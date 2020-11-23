"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.xhr = exports.configureHttpRequest = void 0;
const httpRequest = require("request-light");
const vscode_1 = require("vscode");
function configureHttpRequest() {
    const httpSettings = vscode_1.workspace.getConfiguration('http');
    httpRequest.configure(httpSettings.get('proxy', ''), httpSettings.get('proxyStrictSSL', false));
}
exports.configureHttpRequest = configureHttpRequest;
function xhr(xhrOptions) {
    configureHttpRequest();
    return httpRequest.xhr(xhrOptions);
}
exports.xhr = xhr;
//# sourceMappingURL=request.js.map