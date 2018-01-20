'use strict';
const ExtractTextPlugin = require('extract-text-webpack-plugin');
const webpack = require('webpack');
const path = require('path');

const cssLoader = ExtractTextPlugin.extract({
  fallback: 'style-loader',
  use: [
    { loader: 'css-loader' },
    { loader: 'postcss-loader', options: {plugins: [require('autoprefixer')]} }
  ],
});

const sassLoader = ExtractTextPlugin.extract({
  fallback: 'style-loader',
  use: [
    { loader: 'css-loader' },
    { loader: 'postcss-loader', options: {plugins: [require('autoprefixer')]} },
    { loader: 'sass-loader' }
  ],
});

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
    loaders: [{
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
        use: cssLoader
      }, {
        test: /\.scss$/,
        use: sassLoader
      }
    ]
  },

  plugins: [
    new webpack.DefinePlugin({
      'process.env': {
        'NODE_ENV': JSON.stringify(process.env.NODE_ENV)
      }
    }),
    new ExtractTextPlugin({ filename: 'css/[name].css', allChunks: true }),
    new webpack.optimize.ModuleConcatenationPlugin(),
    new webpack.optimize.UglifyJsPlugin({ output: { comments: false } })
  ]
};
