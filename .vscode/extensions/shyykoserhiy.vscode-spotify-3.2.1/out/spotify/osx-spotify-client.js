"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.OsxSpotifyClient = void 0;
const spotify = require("spotify-node-applescript");
const vscode_1 = require("vscode");
const store_1 = require("../store/store");
const utils_1 = require("./utils");
class OsxSpotifyClient {
    constructor(queryStatusFunc) {
        this._queryStatusFunc = queryStatusFunc;
    }
    get queryStatusFunc() {
        return this._queryStatusFunc;
    }
    next() {
        spotify.next(this._queryStatusFunc);
    }
    previous() {
        spotify.previous(this._queryStatusFunc);
    }
    play() {
        spotify.play(this._queryStatusFunc);
    }
    pause() {
        spotify.pause(this._queryStatusFunc);
    }
    playPause() {
        spotify.playPause(this._queryStatusFunc);
    }
    muteVolume() {
        spotify.muteVolume(this._queryStatusFunc);
    }
    unmuteVolume() {
        spotify.unmuteVolume(this._queryStatusFunc);
    }
    muteUnmuteVolume() {
        if (store_1.isMuted()) {
            spotify.unmuteVolume(this._queryStatusFunc);
        }
        else {
            spotify.muteVolume(this._queryStatusFunc);
        }
    }
    volumeUp() {
        spotify.volumeUp(this._queryStatusFunc);
    }
    volumeDown() {
        spotify.volumeDown(this._queryStatusFunc);
    }
    toggleRepeating() {
        spotify.toggleRepeating(this._queryStatusFunc);
    }
    toggleShuffling() {
        spotify.toggleShuffling(this._queryStatusFunc);
    }
    pollStatus(cb, getInterval) {
        let canceled = false;
        const p = utils_1.createCancelablePromise((_, reject) => {
            const _poll = () => {
                if (canceled) {
                    return;
                }
                if (!vscode_1.window.state.focused) {
                    setTimeout(_poll, getInterval());
                    return;
                }
                this.getStatus().then(status => {
                    cb(status);
                    setTimeout(_poll, getInterval());
                }).catch(reject);
            };
            _poll();
        });
        p.promise = p.promise.catch(err => {
            canceled = true;
            throw err;
        });
        return p;
    }
    getStatus() {
        return this._promiseIsRunning().then(isRunning => {
            if (!isRunning) {
                return Promise.reject('Spotify isn\'t running');
            }
            return Promise.all([
                this._promiseGetState(),
                this._promiseGetTrack(),
                this._promiseIsRepeating(),
                this._promiseIsShuffling()
            ]).then(values => {
                const spState = values[0];
                const state = {
                    playerState: Object.assign(spState, {
                        isRepeating: values[2],
                        isShuffling: values[3]
                    }),
                    track: values[1],
                    isRunning: true
                };
                return state;
            });
        });
    }
    _promiseIsRunning() {
        return new Promise((resolve, reject) => {
            spotify.isRunning((err, isRunning) => {
                if (err) {
                    reject(err);
                }
                else {
                    resolve(isRunning);
                }
            });
        });
    }
    _promiseGetState() {
        return new Promise((resolve, reject) => {
            spotify.getState((err, state) => {
                if (err) {
                    reject(err);
                }
                else {
                    resolve(state);
                }
            });
        });
    }
    _promiseGetTrack() {
        return new Promise((resolve, reject) => {
            spotify.getTrack((err, track) => {
                if (err) {
                    reject(err);
                }
                else {
                    resolve(track);
                }
            });
        });
    }
    _promiseIsRepeating() {
        return new Promise((resolve, reject) => {
            spotify.isRepeating((err, repeating) => {
                if (err) {
                    reject(err);
                }
                else {
                    resolve(repeating);
                }
            });
        });
    }
    _promiseIsShuffling() {
        return new Promise((resolve, reject) => {
            spotify.isShuffling((err, shuffling) => {
                if (err) {
                    reject(err);
                }
                else {
                    resolve(shuffling);
                }
            });
        });
    }
}
exports.OsxSpotifyClient = OsxSpotifyClient;
//# sourceMappingURL=osx-spotify-client.js.map