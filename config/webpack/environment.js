const { environment } = require('@rails/webpacker')

const webpack = require('webpack')
environment.plugins.prepend('Provide',
  new webpack.ProvidePlugin({
    $: 'packs/jquery.min',
    jQuery: 'packs/jquery.min'
  })
)

module.exports = environment
