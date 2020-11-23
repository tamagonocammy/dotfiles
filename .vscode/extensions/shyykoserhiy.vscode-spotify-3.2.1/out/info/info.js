"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.log = exports.showErrorMessage = exports.showWarningMessage = exports.showInformationMessage = void 0;
const moment = require("moment");
const vscode_1 = require("vscode");
const spotify_config_1 = require("../config/spotify-config");
function showInformationMessage(message) {
    vscode_1.window.showInformationMessage(`vscode-spotify: ${message}`);
}
exports.showInformationMessage = showInformationMessage;
function showWarningMessage(message, ...items) {
    return vscode_1.window.showWarningMessage(`vscode-spotify: ${message}`, ...items);
}
exports.showWarningMessage = showWarningMessage;
function showErrorMessage(message) {
    vscode_1.window.showErrorMessage(`vscode-spotify: ${message}`);
}
exports.showErrorMessage = showErrorMessage;
function log(...args) {
    if (spotify_config_1.getEnableLogs()) {
        console.log.apply(console, ['vscode-spotify', moment().format('YYYY/MM/DD HH:MM:mm:ss:SSS'), ...args]);
    }
}
exports.log = log;
//# sourceMappingURL=info.js.map