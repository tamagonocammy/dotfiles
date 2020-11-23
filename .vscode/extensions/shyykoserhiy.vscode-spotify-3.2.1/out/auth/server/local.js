"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.createDisposableAuthSever = void 0;
const express = require("express");
const spotify_config_1 = require("../../config/spotify-config");
const info_1 = require("../../info/info");
function createDisposableAuthSever() {
    let server;
    const createServerPromise = new Promise((res, rej) => {
        setTimeout(() => {
            rej('Timeout error. No response for 10 minutes.');
        }, 10 * 60 * 1000 /*10 minutes*/);
        try {
            const app = express();
            app.get('/callback', (request, response) => {
                const { access_token: accessToken, refresh_token: refreshToken, error } = request.query;
                if (!error) {
                    res({ accessToken, refreshToken });
                }
                else {
                    rej(error);
                }
                response.redirect(`${spotify_config_1.getAuthServerUrl()}/?message=${encodeURIComponent('You can now close this tab')}`);
                request.destroy();
            });
            server = app.listen(8350);
        }
        catch (e) {
            rej(e);
        }
    });
    return {
        createServerPromise,
        dispose: () => server && server.close(() => {
            info_1.log('server closed');
        })
    };
}
exports.createDisposableAuthSever = createDisposableAuthSever;
//# sourceMappingURL=local.js.map