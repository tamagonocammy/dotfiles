"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.SpoifyClientSingleton = void 0;
const os = require("os");
const linux_spotify_client_1 = require("./linux-spotify-client");
const osx_spotify_client_1 = require("./osx-spotify-client");
const spotify_config_1 = require("../config/spotify-config");
const web_api_spotify_client_1 = require("./web-api-spotify-client");
class SpoifyClientSingleton {
    static getSpotifyClient(queryStatus) {
        if (this.spotifyClient) {
            return this.spotifyClient;
        }
        const platform = os.platform();
        if (spotify_config_1.isWebApiSpotifyClient()) {
            this.spotifyClient = new web_api_spotify_client_1.WebApiSpotifyClient(queryStatus);
            return this.spotifyClient;
        }
        if (platform === 'darwin') {
            this.spotifyClient = new osx_spotify_client_1.OsxSpotifyClient(queryStatus);
        }
        if (platform === 'linux') {
            this.spotifyClient = new linux_spotify_client_1.LinuxSpotifyClient(queryStatus);
        }
        return this.spotifyClient;
    }
}
exports.SpoifyClientSingleton = SpoifyClientSingleton;
//# sourceMappingURL=spotify-client.js.map