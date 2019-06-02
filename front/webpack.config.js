'use strict';
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const webpack = require('webpack');
const path = require('path');

module.exports = {
  entry: {
    'app': ['./js/src/App.js', './css/app.scss'],
  },
  output: {
    path: `${__dirname}/../priv/static`,
    pathinfo: true,
    filename: 'js/[name].js'
  },

  devtool: 'source-map',

  resolve: {
    modules: [
      path.join(__dirname, 'js', 'src'),
      'bower_components',
      'node_modules'
    ],
    extensions: [ '.purs', '.js' ]
  },

  module: {
    rules: [{
        test: /\.js$/,
        exclude: /node_modules/,
        use: [{
          loader: 'babel-loader'
        }]
      }, {
        test: /\.purs$/,
        loader: 'purs-loader',
        exclude: /node_modules/,
        query: {
          psc: 'psa',
          bundle: false,
          src: [
            'bower_components/purescript-*/src/**/*.purs',
            'js/src/**/*.purs'
          ]
        }
      }, {
        test: /\.css$/,
        use: [
          { loader: MiniCssExtractPlugin.loader },
          { loader: 'css-loader' },
          { loader: 'postcss-loader', options: {plugins: [require('autoprefixer')]} }
        ]
      }, {
        test: /\.scss$/,
        use: [
          { loader: MiniCssExtractPlugin.loader },
          { loader: 'css-loader' },
          { loader: 'postcss-loader', options: {plugins: [require('autoprefixer')]} },
          { loader: 'sass-loader' }
        ]
      }
    ]
  },

  mode: process.env.NODE_ENV || 'production',

  plugins: [
    new MiniCssExtractPlugin({ filename: 'css/[name].css' })
  ],

  optimization: {
    concatenateModules: true
  }
};
