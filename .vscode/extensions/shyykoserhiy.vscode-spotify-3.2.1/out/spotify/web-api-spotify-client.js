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
exports.WebApiSpotifyClient = void 0;
const actions_1 = require("../actions/actions");
const info_1 = require("../info/info");
const store_1 = require("../store/store");
const utils_1 = require("../utils/utils");
const utils_2 = require("./utils");
class WebApiSpotifyClient {
    constructor(_queryStatusFunc) {
        this.prevVolume = 0;
        this._queryStatusFunc = () => {
            info_1.log('SCHEDULED QUERY STATUS');
            setTimeout(_queryStatusFunc, /*magic number for 'rapid' update. 1 second should? be enough*/ 1000);
        };
    }
    get queryStatusFunc() {
        return this._queryStatusFunc;
    }
    next(api) {
        return __awaiter(this, void 0, void 0, function* () {
            yield api.player.next.post();
            this._queryStatusFunc();
        });
    }
    previous(api) {
        return __awaiter(this, void 0, void 0, function* () {
            yield api.player.previous.post();
            this._queryStatusFunc();
        });
    }
    play(api) {
        return __awaiter(this, void 0, void 0, function* () {
            yield api.player.play.put({});
            this._queryStatusFunc();
        });
    }
    pause(api) {
        return __awaiter(this, void 0, void 0, function* () {
            yield api.player.pause.put();
            this._queryStatusFunc();
        });
    }
    playPause() {
        const { playerState } = store_1.getState();
        if (playerState.state === 'playing') {
            this.pause();
        }
        else {
            this.play();
        }
    }
    pollStatus(_cb, getInterval) {
        let canceled = false;
        const p = utils_2.createCancelablePromise((_, reject) => {
            const _poll = () => __awaiter(this, void 0, void 0, function* () {
                if (canceled) {
                    return;
                }
                const api = actions_1.getSpotifyWebApi();
                try {
                    if (api) {
                        info_1.log('GETTING STATUS');
                        const player = yield api.player.get();
                        if (!player) {
                            reject(utils_2.NOT_RUNNING_REASON);
                            return;
                        }
                        info_1.log('GOT STATUS', JSON.stringify(player));
                        if (!canceled) {
                            _cb({
                                isRunning: player.device.is_active,
                                playerState: {
                                    // fixme more than two states
                                    isRepeating: player.repeat_state !== 'off',
                                    isShuffling: player.shuffle_state,
                                    position: player.progress_ms,
                                    state: player.is_playing ? 'playing' : 'paused',
                                    volume: player.device.volume_percent
                                },
                                track: {
                                    album: player.item.album.name,
                                    artist: utils_1.artistsToArtist(player.item.artists),
                                    name: player.item.name
                                },
                                context: player.context ? {
                                    uri: player.context.uri,
                                    trackNumber: player.item.track_number
                                } : void 0
                            });
                        }
                    }
                }
                catch (_e) {
                    reject(_e);
                    return;
                }
                setTimeout(_poll, getInterval());
            });
            _poll();
        });
        p.promise = p.promise.catch(err => {
            canceled = true;
            throw err;
        });
        return p;
    }
    muteVolume(api) {
        return __awaiter(this, void 0, void 0, function* () {
            this.prevVolume = store_1.getState().playerState.volume;
            if (this.prevVolume !== 0) {
                yield api.player.volume.put(0);
                this._queryStatusFunc();
            }
        });
    }
    unmuteVolume(api) {
        return __awaiter(this, void 0, void 0, function* () {
            if (this.prevVolume) {
                yield api.player.volume.put(this.prevVolume);
                this._queryStatusFunc();
            }
        });
    }
    muteUnmuteVolume() {
        const volume = store_1.getState().playerState.volume;
        if (volume === 0) {
            this.unmuteVolume();
        }
        else {
            this.muteVolume();
        }
    }
    volumeUp(api) {
        return __awaiter(this, void 0, void 0, function* () {
            const volume = store_1.getState().playerState.volume || 0;
            yield api.player.volume.put(Math.min(volume + 20, 100));
            this._queryStatusFunc();
        });
    }
    volumeDown(api) {
        return __awaiter(this, void 0, void 0, function* () {
            const volume = store_1.getState().playerState.volume || 0;
            yield api.player.volume.put(Math.max(volume - 20, 0));
            this._queryStatusFunc();
        });
    }
    toggleRepeating(api) {
        return __awaiter(this, void 0, void 0, function* () {
            const { playerState } = store_1.getState();
            // fixme more than two states
            yield api.player.repeat.put((!playerState.isRepeating) ? 'context' : 'off');
            this._queryStatusFunc();
        });
    }
    toggleShuffling(api) {
        return __awaiter(this, void 0, void 0, function* () {
            const { playerState } = store_1.getState();
            yield api.player.shuffle.put(!playerState.isShuffling);
            this._queryStatusFunc();
        });
    }
}
__decorate([
    actions_1.withErrorAsync(),
    actions_1.withApi()
], WebApiSpotifyClient.prototype, "next", null);
__decorate([
    actions_1.withErrorAsync(),
    actions_1.withApi()
], WebApiSpotifyClient.prototype, "previous", null);
__decorate([
    actions_1.withErrorAsync(),
    actions_1.withApi()
], WebApiSpotifyClient.prototype, "play", null);
__decorate([
    actions_1.withErrorAsync(),
    actions_1.withApi()
], WebApiSpotifyClient.prototype, "pause", null);
__decorate([
    actions_1.withErrorAsync(),
    actions_1.withApi()
], WebApiSpotifyClient.prototype, "muteVolume", null);
__decorate([
    actions_1.withErrorAsync(),
    actions_1.withApi()
], WebApiSpotifyClient.prototype, "unmuteVolume", null);
__decorate([
    actions_1.withErrorAsync(),
    actions_1.withApi()
], WebApiSpotifyClient.prototype, "volumeUp", null);
__decorate([
    actions_1.withErrorAsync(),
    actions_1.withApi()
], WebApiSpotifyClient.prototype, "volumeDown", null);
__decorate([
    actions_1.withErrorAsync(),
    actions_1.withApi()
], WebApiSpotifyClient.prototype, "toggleRepeating", null);
__decorate([
    actions_1.withErrorAsync(),
    actions_1.withApi()
], WebApiSpotifyClient.prototype, "toggleShuffling", null);
exports.WebApiSpotifyClient = WebApiSpotifyClient;
//# sourceMappingURL=web-api-spotify-client.js.map