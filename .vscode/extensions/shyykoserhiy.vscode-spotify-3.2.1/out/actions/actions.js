"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.actionsCreator = exports.getSpotifyWebApi = exports.withErrorAsync = exports.withApi = void 0;
const api_1 = require("@vscodespotify/spotify-common/lib/spotify/api");
const autobind_decorator_1 = require("autobind-decorator");
const vscode_1 = require("vscode");
const local_1 = require("../auth/server/local");
const spotify_config_1 = require("../config/spotify-config");
const consts_1 = require("../consts/consts");
const info_1 = require("../info/info");
const state_1 = require("../state/state");
const store_1 = require("../store/store");
const utils_1 = require("../utils/utils");
const common_1 = require("./common");
function withApi() {
    return (_target, _key, descriptor) => {
        const originalMethod = descriptor.value;
        descriptor.value = function (...args) {
            const api = exports.getSpotifyWebApi();
            if (api) {
                return originalMethod.apply(this, [...args, api]);
            }
            else {
                (() => __awaiter(this, void 0, void 0, function* () {
                    const signIn = 'Sign in';
                    const result = yield info_1.showWarningMessage('You should be logged in order to use this feature.', signIn);
                    if (result === signIn) {
                        vscode_1.commands.executeCommand(consts_1.SIGN_IN_COMMAND);
                    }
                }))();
            }
        };
        return descriptor;
    };
}
exports.withApi = withApi;
function withErrorAsync() {
    return (_target, _key, descriptor) => {
        const originalMethod = descriptor.value;
        descriptor.value = function (...args) {
            return __awaiter(this, void 0, void 0, function* () {
                try {
                    return yield originalMethod.apply(this, args);
                }
                catch (e) {
                    info_1.showWarningMessage('Failed to perform operation ' + e.message || e);
                }
            });
        };
        return descriptor;
    };
}
exports.withErrorAsync = withErrorAsync;
function actionCreator() {
    return (_target, _key, descriptor) => {
        const originalMethod = descriptor.value;
        descriptor.value = function (...args) {
            const action = originalMethod.apply(this, args);
            if (!action) {
                return;
            }
            store_1.getStore().dispatch(action);
        };
        return descriptor;
    };
}
function asyncActionCreator() {
    return (_target, _key, descriptor) => {
        const originalMethod = descriptor.value;
        descriptor.value = function (...args) {
            return __awaiter(this, void 0, void 0, function* () {
                let action;
                try {
                    action = yield originalMethod.apply(this, args);
                    if (!action) {
                        return;
                    }
                }
                catch (e) {
                    info_1.showWarningMessage('Failed to perform operation ' + e.message || e);
                }
                store_1.getStore().dispatch(action);
            });
        };
        return descriptor;
    };
}
const apiMap = new WeakMap();
exports.getSpotifyWebApi = () => {
    const { loginState } = store_1.getState();
    if (!loginState) {
        info_1.log('getSpotifyWebApi', 'NOT LOGGED IN');
        return null;
    }
    if (!vscode_1.window.state.focused) {
        info_1.log('getSpotifyWebApi', 'NOT FOCUSED');
        return null;
    }
    let api = apiMap.get(loginState);
    if (!api) {
        api = api_1.getApi(spotify_config_1.getAuthServerUrl(), loginState.accessToken, loginState.refreshToken, (token) => {
            exports.actionsCreator._actionSignIn(token, loginState.refreshToken);
        });
        apiMap.set(loginState, api);
    }
    return api;
};
class ActionCreator {
    updateStateAction(state) {
        return {
            type: common_1.UPDATE_STATE_ACTION,
            state
        };
    }
    loadPlaylists(api) {
        return __awaiter(this, void 0, void 0, function* () {
            const playlists = yield api.playlists.getAll();
            return {
                type: common_1.PLAYLISTS_LOAD_ACTION,
                playlists
            };
        });
    }
    selectPlaylistAction(p) {
        return {
            type: common_1.SELECT_PLAYLIST_ACTION,
            playlist: p
        };
    }
    selectTrackAction(track) {
        return {
            type: common_1.SELECT_TRACK_ACTION,
            track
        };
    }
    selectCurrentTrack() {
        const state = store_1.getState();
        if (state.playerState && state.track) {
            let track;
            const currentTrack = state.track;
            const playlist = state.playlists.find(p => {
                const tracks = state.tracks.get(p.id);
                if (tracks) {
                    const foundTrack = tracks.find(t => t.track.name === currentTrack.name
                        && t.track.album.name === currentTrack.album
                        && utils_1.artistsToArtist(t.track.artists) === currentTrack.artist);
                    if (foundTrack) {
                        track = foundTrack;
                        return true;
                    }
                }
                return false;
            });
            if (playlist) {
                this.selectPlaylistAction(playlist);
                this.selectTrackAction(track);
            }
        }
    }
    loadTracksForSelectedPlaylist() {
        this.loadTracks(store_1.getState().selectedPlaylist);
    }
    loadTracksIfNotLoaded(playlist) {
        if (!playlist) {
            return void 0;
        }
        const { tracks } = store_1.getState();
        if (!tracks.has(playlist.id)) {
            this.loadTracks(playlist);
        }
    }
    loadTracks(playlist, api) {
        return __awaiter(this, void 0, void 0, function* () {
            if (!playlist || playlist.id === state_1.DUMMY_PLAYLIST.id) {
                return void 0;
            }
            const tracks = yield api.playlists.tracks.getAll(playlist);
            return {
                type: common_1.TRACKS_LOAD_ACTION,
                playlist,
                tracks
            };
        });
    }
    playTrack(offset, playlist, api) {
        return __awaiter(this, void 0, void 0, function* () {
            yield api.player.play.put({
                offset,
                albumUri: playlist.uri
            });
            return;
        });
    }
    seekTo(time, api) {
        return __awaiter(this, void 0, void 0, function* () {
            const timeS = time || (yield vscode_1.window.showInputBox({ prompt: 'Select time to seek to in format mm:ss or ss' }));
            if (!timeS) {
                return;
            }
            const invalidTimeFormatError = 'Invalid time format. Should be in format mm:ss or ss';
            const timeA = timeS.split(':');
            if (timeA.length > 2) {
                info_1.showErrorMessage(invalidTimeFormatError);
                return;
            }
            let minutes = 0;
            let seconds = 0;
            if (timeA[1]) {
                minutes = parseFloat(timeA[0]);
                seconds = parseFloat(timeA[1]);
            }
            else {
                seconds = parseFloat(timeA[0]);
            }
            if (Number.isNaN(seconds) || Number.isNaN(minutes)) {
                info_1.showErrorMessage(invalidTimeFormatError);
                return;
            }
            const seekTo = Math.round((minutes * 60 + seconds) * 1000);
            yield api.player.seek.put(seekTo);
        });
    }
    actionSignIn() {
        vscode_1.commands.executeCommand('vscode.open', vscode_1.Uri.parse(`${spotify_config_1.getAuthServerUrl()}/login`)).then(() => {
            const { createServerPromise, dispose } = local_1.createDisposableAuthSever();
            createServerPromise.then(({ accessToken, refreshToken }) => {
                this._actionSignIn(accessToken, refreshToken);
            }).catch(e => {
                info_1.showInformationMessage(`Failed to retrieve access token : ${JSON.stringify(e)}`);
            }).then(() => {
                dispose();
            });
        });
    }
    _actionSignIn(accessToken, refreshToken) {
        return {
            accessToken,
            refreshToken,
            type: common_1.SIGN_IN_ACTION
        };
    }
    actionSignOut() {
        return {
            type: common_1.SIGN_OUT_ACTION
        };
    }
}
__decorate([
    autobind_decorator_1.default,
    actionCreator()
], ActionCreator.prototype, "updateStateAction", null);
__decorate([
    autobind_decorator_1.default,
    asyncActionCreator(),
    withApi()
], ActionCreator.prototype, "loadPlaylists", null);
__decorate([
    autobind_decorator_1.default,
    actionCreator()
], ActionCreator.prototype, "selectPlaylistAction", null);
__decorate([
    autobind_decorator_1.default,
    actionCreator()
], ActionCreator.prototype, "selectTrackAction", null);
__decorate([
    autobind_decorator_1.default
], ActionCreator.prototype, "selectCurrentTrack", null);
__decorate([
    autobind_decorator_1.default
], ActionCreator.prototype, "loadTracksForSelectedPlaylist", null);
__decorate([
    autobind_decorator_1.default
], ActionCreator.prototype, "loadTracksIfNotLoaded", null);
__decorate([
    autobind_decorator_1.default,
    asyncActionCreator(),
    withApi()
], ActionCreator.prototype, "loadTracks", null);
__decorate([
    autobind_decorator_1.default,
    withErrorAsync(),
    withApi()
], ActionCreator.prototype, "playTrack", null);
__decorate([
    autobind_decorator_1.default,
    withErrorAsync(),
    withApi()
], ActionCreator.prototype, "seekTo", null);
__decorate([
    autobind_decorator_1.default
], ActionCreator.prototype, "actionSignIn", null);
__decorate([
    autobind_decorator_1.default,
    actionCreator()
], ActionCreator.prototype, "_actionSignIn", null);
__decorate([
    autobind_decorator_1.default,
    actionCreator()
], ActionCreator.prototype, "actionSignOut", null);
exports.actionsCreator = new ActionCreator();
//# sourceMappingURL=actions.js.map