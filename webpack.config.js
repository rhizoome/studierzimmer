const path = require('path');

module.exports = {
    entry: './src/main.ts',
    output: {
        filename: 'main.js',
        path: path.resolve(__dirname, 'dist'),
        library: 'Studierzimmer',
        libraryTarget: 'var',
    },
    resolve: {
        extensions: ['.ts', '.js'],
    },
    module: {
        rules: [
            {
                test: /\.ts$/,
                use: 'ts-loader',
                exclude: /node_modules/,
            },
            {
                test: /\.json$/,
                type: 'json', // Use built-in JSON loader
            },
        ],
    },
    devtool: 'source-map',
    mode: 'development',
};
