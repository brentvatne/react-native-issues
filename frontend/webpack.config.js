module.exports = {
  cache: true,
  entry: './index',
  output: {
    filename: 'dist/bundle.js'
  },
  module: {
    loaders: [
      { test: /\.js$/, exclude: /node_modules/, loader: "babel-loader"}
    ]
  }
};
