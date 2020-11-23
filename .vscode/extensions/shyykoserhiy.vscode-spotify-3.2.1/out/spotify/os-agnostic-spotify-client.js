"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.OsAgnosticSpotifyClient = void 0;
const info_1 = require("../info/info");
const utils_1 = require("./utils");
function notSupported(_ignoredTarget, _ignoredPropertyKey, descriptor) {
    const fn = descriptor.value;
    if (typeof fn !== 'function') {
        throw new Error(`@notSupported can only be applied to method and not to ${typeof fn}`);
    }
    return Object.assign({}, descriptor, {
        value() {
            info_1.showInformationMessage('This functionality is not supported on this platform.');
            return;
        }
    });
}
// tslint:disable:no-empty
class OsAgnosticSpotifyClient {
    get queryStatusFunc() {
        return this.next;
    }
    next() {
    }
    previous() {
    }
    play() {
    }
    pause() {
    }
    playPause() {
    }
    pollStatus(_cb, _getInterval) {
        return utils_1.createCancelablePromise((_resolve, _reject) => { });
    }
    muteVolume() {
    }
    unmuteVolume() {
    }
    muteUnmuteVolume() {
    }
    volumeUp() {
    }
    volumeDown() {
    }
    toggleRepeating() {
    }
    toggleShuffling() {
    }
}
__decorate([
    notSupported
], OsAgnosticSpotifyClient.prototype, "next", null);
__decorate([
    notSupported
], OsAgnosticSpotifyClient.prototype, "previous", null);
__decorate([
    notSupported
], OsAgnosticSpotifyClient.prototype, "play", null);
__decorate([
    notSupported
], OsAgnosticSpotifyClient.prototype, "pause", null);
__decorate([
    notSupported
], OsAgnosticSpotifyClient.prototype, "playPause", null);
__decorate([
    notSupported
], OsAgnosticSpotifyClient.prototype, "pollStatus", null);
__decorate([
    notSupported
], OsAgnosticSpotifyClient.prototype, "muteVolume", null);
__decorate([
    notSupported
], OsAgnosticSpotifyClient.prototype, "unmuteVolume", null);
__decorate([
    notSupported
], OsAgnosticSpotifyClient.prototype, "muteUnmuteVolume", null);
__decorate([
    notSupported
], OsAgnosticSpotifyClient.prototype, "volumeUp", null);
__decorate([
    notSupported
], OsAgnosticSpotifyClient.prototype, "volumeDown", null);
__decorate([
    notSupported
], OsAgnosticSpotifyClient.prototype, "toggleRepeating", null);
__decorate([
    notSupported
], OsAgnosticSpotifyClient.prototype, "toggleShuffling", null);
exports.OsAgnosticSpotifyClient = OsAgnosticSpotifyClient;
//# sourceMappingURL=os-agnostic-spotify-client.js.map