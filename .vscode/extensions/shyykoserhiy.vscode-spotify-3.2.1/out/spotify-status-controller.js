"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.SpotifyStatusController = void 0;
const autobind_decorator_1 = require("autobind-decorator");
const actions_1 = require("./actions/actions");
const spotify_config_1 = require("./config/spotify-config");
const spotify_client_1 = require("./spotify/spotify-client");
const utils_1 = require("./spotify/utils");
class SpotifyStatusController {
    constructor() {
        this.clearState = (reason) => {
            // canceling of the promise only happens when method queryStatus is triggered.
            if (reason !== utils_1.CANCELED_REASON) {
                this._retryCount++;
                if (this._retryCount >= this._maxRetryCount) {
                    actions_1.actionsCreator.updateStateAction({
                        playerState: {
                            position: 0, volume: 0, state: 'paused', isRepeating: false,
                            isShuffling: false
                        },
                        track: { album: '', artist: '', name: '' },
                        isRunning: false
                    });
                    this._retryCount = 0;
                }
                setTimeout(this.queryStatus, spotify_config_1.getStatusCheckInterval());
            }
        };
        this._retryCount = 0;
        this._maxRetryCount = 5;
        this.queryStatus();
    }
    /**
     * Retrieves status of spotify and passes it to spotifyStatus;
     */
    queryStatus() {
        this._cancelPreviousPoll();
        const { promise, cancel } = spotify_client_1.SpoifyClientSingleton.getSpotifyClient(this.queryStatus).pollStatus(status => {
            actions_1.actionsCreator.updateStateAction(status);
            this._retryCount = 0;
        }, spotify_config_1.getStatusCheckInterval);
        this._cancelCb = cancel;
        promise.catch(this.clearState);
    }
    dispose() {
        this._cancelPreviousPoll();
    }
    _cancelPreviousPoll() {
        if (this._cancelCb) {
            this._cancelCb();
        }
    }
}
__decorate([
    autobind_decorator_1.default
], SpotifyStatusController.prototype, "queryStatus", null);
exports.SpotifyStatusController = SpotifyStatusController;
//# sourceMappingURL=spotify-status-controller.js.map