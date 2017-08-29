const path = require('path');

module.exports = {
    entry: ['babel-polyfill', './src/js/Fling.js'],
    output: {
        filename: 'bundle.js',
        path: path.resolve(__dirname, 'src', 'dist'),
        publicPath: '/dist'
    },
    devtool: 'source-map',
    module: {
        rules: [
            {
                test: /\.css$/,
                use: [ 'style-loader', 'css-loader' ]

            },
            {
                test: /\.js$/,
                exclude: /(node_modules|bower_components)/,
                use: {
                    loader: 'babel-loader',
                    options: {
                        presets: ['env']
                    }
                }
            }
        ]
    }
};
