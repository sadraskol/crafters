'use strict';
const webpack = require('webpack');
const path = require('path');

module.exports = {
  resolve: {
    modules: [
      path.join(__dirname, 'src'),
      'bower_components',
      'node_modules'
    ],
    extensions: [ '.purs', '.js']
  },

  entry: './src/App.js',

  devtool: 'eval',

  devServer: {
    contentBase: './dist',
    port: 4008,
    stats: 'errors-only'
  },

  output: {
    path: __dirname + '/dist',
    pathinfo: true,
    filename: 'bundle.js'
  },

  module: {
    loaders: [
      {
        test: /\.purs$/,
        loader: 'purs-loader',
        exclude: /node_modules/,
        query: {
          psc: 'psa',
          bundle: false,
          src: [
            'bower_components/purescript-*/src/**/*.purs',
            'src/**/*.purs'
          ]
        }
      }
    ]
  },

  plugins: [
     new webpack.LoaderOptionsPlugin({
       debug: true
     })
   ]
};
