"use strict";
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
exports.LyricsController = void 0;
const vscode_1 = require("vscode");
const spotify_config_1 = require("../config/spotify-config");
const info_1 = require("../info/info");
const request_1 = require("../request/request");
const store_1 = require("../store/store");
const cheerio = require("cheerio");
class TextContentProvider {
    constructor() {
        this.htmlContent = '';
        this._onDidChange = new vscode_1.EventEmitter();
    }
    get onDidChange() {
        return this._onDidChange.event;
    }
    provideTextDocumentContent(_uri) {
        return this.htmlContent;
    }
    update(uri) {
        this._onDidChange.fire(uri);
    }
}
class LyricsController {
    constructor() {
        this.registration = vscode_1.workspace.registerTextDocumentContentProvider('vscode-spotify', LyricsController.lyricsContentProvider);
        this.previewUri = vscode_1.Uri.parse('vscode-spotify://authority/vscode-spotify');
    }
    findLyrics() {
        return __awaiter(this, void 0, void 0, function* () {
            vscode_1.window.withProgress({ location: vscode_1.ProgressLocation.Window, title: 'Searching for lyrics. This might take a while.' }, () => this._findLyrics());
        });
    }
    _findLyrics() {
        return __awaiter(this, void 0, void 0, function* () {
            const state = store_1.getState();
            const { artist, name } = state.track;
            try {
                const url = `${spotify_config_1.getLyricsServerUrl()}?artist=${encodeURIComponent(artist)}&title=${encodeURIComponent(name)}`;
                const result = yield request_1.xhr({
                    url
                });
                const { songs } = JSON.parse(result.responseText);
                if (!songs || !songs.length) {
                    yield this._previewLyrics(`Song lyrics for ${artist} - ${name} not found.\nYou can add it on https://genius.com/ .`);
                    return;
                }
                let song = songs[0];
                if (song.similarity !== 1) {
                    const pick = yield vscode_1.window.showQuickPick(Array.from(songs.map((s) => {
                        return {
                            label: `${s.artist} - ${s.title}`,
                            song: s
                        };
                    })), {
                        ignoreFocusOut: true,
                        placeHolder: 'Select one of the songs that we think might be your song.'
                    });
                    if (!pick) {
                        return;
                    }
                    song = pick.song;
                }
                const geniusUrl = `https://genius.com${song.geniusPath}`;
                try {
                    const fetchRes = yield request_1.xhr({
                        url: geniusUrl
                    });
                    const $ = cheerio.load(fetchRes.responseText);
                    const lyrics = $('.lyrics').text().trim();
                    yield this._previewLyrics(`${artist} - ${name}\n\n${lyrics}`);
                }
                catch (e) {
                    if (e.status === 403) {
                        // probably captcha. Open in browser
                        yield vscode_1.env.openExternal(vscode_1.Uri.parse(geniusUrl));
                        yield this._previewLyrics(`Song lyrics for ${artist} - ${name} not found.\nYou can add it on https://genius.com/ .`);
                    }
                    if (e.status === 404) {
                        yield this._previewLyrics(`Song lyrics for ${artist} - ${name} not found.\nYou can add it on https://genius.com/ .`);
                    }
                    if (e.status === 500) {
                        yield this._previewLyrics(`Error: ${e.responseText}`);
                    }
                }
            }
            catch (e) {
                if (e.status === 404) {
                    yield this._previewLyrics(`Song lyrics for ${artist} - ${name} not found.\nYou can add it on https://genius.com/ .`);
                }
                if (e.status === 500) {
                    yield this._previewLyrics(`Error: ${e.responseText}`);
                }
            }
        });
    }
    _previewLyrics(lyrics) {
        return __awaiter(this, void 0, void 0, function* () {
            LyricsController.lyricsContentProvider.htmlContent = lyrics;
            LyricsController.lyricsContentProvider.update(this.previewUri);
            try {
                const document = yield vscode_1.workspace.openTextDocument(this.previewUri);
                yield vscode_1.window.showTextDocument(document, spotify_config_1.openPanelLyrics(), true);
            }
            catch (_ignored) {
                info_1.showInformationMessage('Failed to show lyrics' + _ignored);
            }
        });
    }
}
exports.LyricsController = LyricsController;
LyricsController.lyricsContentProvider = new TextContentProvider();
//# sourceMappingURL=lyrics.js.map