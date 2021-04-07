class DataUploader
  def self.call(data, upload)
    resp = Faraday.post("http://localhost:5000/predict", { data: data }.to_json, "Content-Type" => "application/json")

    # fetching the payload & stats/attacks objects from it
    response_body = JSON.parse(resp.body)
    statistics = response_body['statistics']
    attacks = response_body['attacks']

    # creating stats record with the mapped values from the payload
    Statistic.create!(
      upload: upload,
      total_records: statistics['total_records'].to_i,
      total_attacks: statistics['total_attacks'].to_i,
      total_ddos: statistics['total_ddos'].to_i,
      total_dos: statistics['total_dos'].to_i,
      total_theft: statistics['total_theft'].to_i,
      total_reconnaissance: statistics['total_reconnaissance'].to_i,
    )

    # To use bulk insert in one query for all attacks, we need the data in this format: [{..attack_attrs}, {..attack_attrs}]
    # So here we map the array from the payload to contain array of hashes
    attacks.map! do |attack|
      {
        upload_id: upload.id,
        source_ip: attack['saddr'],
        source_port: attack['sport'],
        destination_ip: attack['daddr'],
        destination_port: attack['dport'],
        duration: attack['dur'],
        sequence_id: attack['pkSeqID'],
        attack_type: attack['attack_type'].downcase,
        created_at: Time.now,
        updated_at: Time.now,
        started_at: Time.at(attack['stime'].to_i),
        ended_at: Time.at(attack['ltime'].to_i),
      }
    end

    # insert all attacks in a single query
    Attack.insert_all!(attacks)

    # This updates the upload status to be processed
    upload.update!(status: :processed, finished_at: Time.now)

  rescue => error
    # catch any error and update the upload to be failed!
    upload.update!(status: :failed)
    raise error.to_s
  end
end
