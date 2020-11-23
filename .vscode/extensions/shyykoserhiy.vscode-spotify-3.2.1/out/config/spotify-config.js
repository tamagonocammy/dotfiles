"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.setLastUsedPort = exports.getLastUsedPort = exports.registerGlobalState = exports.getTrackInfoClickBehaviour = exports.getEnableLogs = exports.getForceWebApiImplementation = exports.getTrackInfoFormat = exports.openPanelLyrics = exports.getSpotifyApiUrl = exports.getAuthServerUrl = exports.getLyricsServerUrl = exports.getStatusCheckInterval = exports.getButtonPriority = exports.isButtonToBeShown = exports.isWebApiSpotifyClient = exports.getConfig = void 0;
const os = require("os");
const vscode_1 = require("vscode");
const consts_1 = require("../consts/consts");
const store_1 = require("../store/store");
function getConfig() {
    return vscode_1.workspace.getConfiguration('spotify');
}
exports.getConfig = getConfig;
function isWebApiSpotifyClient() {
    const platform = os.platform();
    return (platform !== 'darwin' && platform !== 'linux') || getForceWebApiImplementation();
}
exports.isWebApiSpotifyClient = isWebApiSpotifyClient;
function isButtonToBeShown(buttonId) {
    const shouldShow = getConfig().get(`show${buttonId[0].toUpperCase()}${buttonId.slice(1)}`, false);
    const { loginState } = store_1.getState();
    if (buttonId === `${consts_1.BUTTON_ID_SIGN_IN}Button`) {
        return shouldShow && !loginState;
    }
    else if (buttonId === `${consts_1.BUTTON_ID_SIGN_OUT}Button`) {
        return shouldShow && !!loginState;
    }
    return shouldShow;
}
exports.isButtonToBeShown = isButtonToBeShown;
function getButtonPriority(buttonId) {
    const config = getConfig();
    return config.get('priorityBase', 0) + config.get(`${buttonId}Priority`, 0);
}
exports.getButtonPriority = getButtonPriority;
function getStatusCheckInterval() {
    const isWebApiClient = isWebApiSpotifyClient();
    let interval = getConfig().get('statusCheckInterval', 5000);
    if (isWebApiClient) {
        interval = Math.max(interval, 5000);
    }
    return interval;
}
exports.getStatusCheckInterval = getStatusCheckInterval;
function getLyricsServerUrl() {
    return getConfig().get('lyricsServerUrl', '');
}
exports.getLyricsServerUrl = getLyricsServerUrl;
function getAuthServerUrl() {
    return getConfig().get('authServerUrl', '');
}
exports.getAuthServerUrl = getAuthServerUrl;
function getSpotifyApiUrl() {
    return getConfig().get('spotifyApiUrl', '');
}
exports.getSpotifyApiUrl = getSpotifyApiUrl;
function openPanelLyrics() {
    return getConfig().get('openPanelLyrics', 1);
}
exports.openPanelLyrics = openPanelLyrics;
function getTrackInfoFormat() {
    return getConfig().get('trackInfoFormat', '');
}
exports.getTrackInfoFormat = getTrackInfoFormat;
function getForceWebApiImplementation() {
    return getConfig().get('forceWebApiImplementation', false);
}
exports.getForceWebApiImplementation = getForceWebApiImplementation;
function getEnableLogs() {
    return getConfig().get('enableLogs', false);
}
exports.getEnableLogs = getEnableLogs;
function getTrackInfoClickBehaviour() {
    return getConfig().get('trackInfoClickBehaviour', 'focus_song');
}
exports.getTrackInfoClickBehaviour = getTrackInfoClickBehaviour;
let globalState;
function registerGlobalState(memento) {
    globalState = memento;
}
exports.registerGlobalState = registerGlobalState;
const LAST_USED_PORT = 'lastUsedPort';
function getLastUsedPort() {
    return globalState.get(LAST_USED_PORT);
}
exports.getLastUsedPort = getLastUsedPort;
function setLastUsedPort(port) {
    globalState.update(LAST_USED_PORT, port);
}
exports.setLastUsedPort = setLastUsedPort;
//# sourceMappingURL=spotify-config.js.map