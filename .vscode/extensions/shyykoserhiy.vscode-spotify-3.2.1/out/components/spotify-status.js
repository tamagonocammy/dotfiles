"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.SpotifyStatus = void 0;
const vscode_1 = require("vscode");
const spotify_config_1 = require("../config/spotify-config");
const store_1 = require("../store/store");
const spotify_controls_1 = require("./spotify-controls");
class SpotifyStatus {
    constructor() {
        this.loginState = null;
        store_1.getStore().subscribe(() => {
            this.render();
        });
    }
    /**
     * Updates spotify status bar inside vscode
     */
    render() {
        const state = store_1.getState();
        // Create as needed
        if (!this._statusBarItem) {
            this._statusBarItem = vscode_1.window.createStatusBarItem(vscode_1.StatusBarAlignment.Left, spotify_config_1.getButtonPriority('trackInfo'));
            this._statusBarItem.show();
        }
        if (!this._spotifyControls) {
            this._spotifyControls = new spotify_controls_1.SpotifyControls();
            this._spotifyControls.showVisible();
        }
        if (this.loginState !== state.loginState) {
            this.loginState = state.loginState;
            this._spotifyControls.showHideAuthButtons();
        }
        if (state.isRunning) {
            const { state: playing, volume, isRepeating, isShuffling } = state.playerState;
            const text = this.formattedTrackInfo(state.track);
            let toRedraw = false;
            if (text !== this._statusBarItem.text) { // we need this guard to prevent flickering
                this._statusBarItem.text = text;
                toRedraw = true;
            }
            if (this._spotifyControls.updateDynamicButtons(playing === 'playing', volume === 0, isRepeating, isShuffling)) {
                toRedraw = true;
            }
            if (toRedraw) {
                this._statusBarItem.show();
                this._spotifyControls.showVisible();
            }
            const trackInfoClickBehaviour = spotify_config_1.getTrackInfoClickBehaviour();
            if (trackInfoClickBehaviour === 'none') {
                this._statusBarItem.command = undefined;
            }
            else {
                this._statusBarItem.command = 'spotify.trackInfoClick';
            }
        }
        else {
            this._statusBarItem.text = '';
            this._statusBarItem.hide();
            this._spotifyControls.hideAll();
        }
    }
    /**
     * Disposes status bar items(if exist)
     */
    dispose() {
        if (this._statusBarItem) {
            this._statusBarItem.dispose();
        }
        if (this._spotifyControls) {
            this._spotifyControls.dispose();
        }
    }
    formattedTrackInfo(track) {
        const { album, artist, name } = track;
        const keywordsMap = {
            albumName: album,
            artistName: artist,
            trackName: name
        };
        return spotify_config_1.getTrackInfoFormat().replace(/albumName|artistName|trackName/gi, matched => keywordsMap[matched]);
    }
}
exports.SpotifyStatus = SpotifyStatus;
//# sourceMappingURL=spotify-status.js.map