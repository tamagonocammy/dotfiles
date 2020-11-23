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
exports.LinuxSpotifyClient = void 0;
const child_process_1 = require("child_process");
const info_1 = require("../info/info");
const os_agnostic_spotify_client_1 = require("./os-agnostic-spotify-client");
const utils_1 = require("./utils");
const SP_DEST = 'org.mpris.MediaPlayer2.spotify';
const SP_PATH = '/org/mpris/MediaPlayer2';
const SP_MEMB = 'org.mpris.MediaPlayer2.Player';
const DB_P_GET = 'org.freedesktop.DBus.Properties.Get';
const createCommandString = (command) => `dbus-send  --print-reply --dest=${SP_DEST} ${SP_PATH} ${SP_MEMB}.${command}`;
const playPauseDebianCmd = createCommandString('PlayPause');
const pauseDebianCmd = createCommandString('Pause');
const playNextTrackDebianCmd = createCommandString('Next');
const playPreviousTrackDebianCmd = createCommandString('Previous');
const getPlaybackStatus = `dbus-send --print-reply --dest=${SP_DEST} ${SP_PATH} ${DB_P_GET} string:${SP_MEMB} string:PlaybackStatus`;
// @see https://gist.github.com/wandernauta/6800547
/**
 * Example response
trackid|spotify:track:4SQ0ytpTP8v1Rx8FWR22cv
length|354000000
artUrl|https://open.spotify.com/image/e51e7bc95101b3990d86ca58b18a6eb6ba057db3
album|In My Body
albumArtist|SYML
artist|SYML
autoRating|0.52
discNumber|1
title|The War
trackNumber|6
url|https://open.spotify.com/track/4SQ0ytpTP8v1Rx8FWR22cv
 */
const getMetadataCommand = `dbus-send                                                                   \
--print-reply                                                                 \\
--dest=${SP_DEST}                                                             \\
${SP_PATH}                                                                    \\
org.freedesktop.DBus.Properties.Get                                         \\
string:"${SP_MEMB}" string:'Metadata'                                         \\
| grep -Ev "^method"                                                          \\
| grep -Eo '("(.*)")|(\\b[0-9][a-zA-Z0-9.]*\\b)'                                 \\
| sed -E '2~2 a|'                                                              \\
| tr -d '\\n'                                                                  \\
| sed -E 's/\\|/\\n/g'                                                           \\
| sed -E 's/(xesam:)|(mpris:)//'                                              \\
| sed -E 's/^"//'                                                         \\
| sed -E 's/"$//'                                                          \\
| sed -E 's/"+/|/'                                                           \\
| sed -E 's/ +/ /g'
`;
const terminalCommand = (cmd) => 
/**
 * This is a wrapper for executing terminal commands
 * by using NodeJs' built in "child process" library.
 * This function initially returns a Promise.
 *
 * @param {string} cmd This is the command to execute
 * @return {string} the standard output of the executed command on successful execution
 * @return {boolean} returns false if the executed command is unsuccessful
 *
 */
new Promise((resolve, _reject) => {
    child_process_1.exec(cmd, (e, stdout, stderr) => {
        if (e) {
            return resolve('');
        }
        if (stderr) {
            return resolve('');
        }
        resolve(stdout);
    });
});
class LinuxSpotifyClient extends os_agnostic_spotify_client_1.OsAgnosticSpotifyClient {
    constructor(_queryStatusFunc) {
        super();
        this.currentOnVolume = 0;
        this._queryStatusFunc = () => {
            // spotify with dbfus doesn't return correct state right after next/prev/pause/play
            // command executtion. we need to wait
            setTimeout(_queryStatusFunc, /*magic number*/ 600);
        };
    }
    get queryStatusFunc() {
        return this._queryStatusFunc;
    }
    pollStatus(cb, getInterval) {
        let canceled = false;
        const p = utils_1.createCancelablePromise((_, reject) => {
            const _poll = () => {
                if (canceled) {
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
    play() {
        terminalCommand(playPauseDebianCmd);
    }
    pause() {
        terminalCommand(pauseDebianCmd);
    }
    playPause() {
        return __awaiter(this, void 0, void 0, function* () {
            yield terminalCommand(playPauseDebianCmd);
            this._queryStatusFunc();
        });
    }
    next() {
        return __awaiter(this, void 0, void 0, function* () {
            yield terminalCommand(playNextTrackDebianCmd);
            this._queryStatusFunc();
        });
    }
    previous() {
        return __awaiter(this, void 0, void 0, function* () {
            yield terminalCommand(playPreviousTrackDebianCmd);
            this._queryStatusFunc();
        });
    }
    /**
     *  This function checks to see which "Sinked Input #"
     *  is actually running spotify.
     *
     *  @param s The sting that might be contain the Sinked Input #
     *  we are looking for.
     *  @return This function was intended to be used with map in order
     *  to remap an Array where there should only be one element after we "findSpotify"
     */
    findSpotify(s) {
        const foundSpotifySink = s.match(/(Spotify)/i);
        return (foundSpotifySink !== null) ? ((foundSpotifySink.length > 1) ? true : false) : false;
    }
    getCurrentVolume() {
        return __awaiter(this, void 0, void 0, function* () {
            try {
                const d = yield terminalCommand('pactl list sink-inputs');
                const sinkedArr = d.split('Sinked Input #');
                const a = sinkedArr ? sinkedArr.filter(this.findSpotify) : [];
                if (a.length > 0) {
                    const currentVol = a[0].match(/(\d{1,3})%/i);
                    if (currentVol !== null) {
                        const sinkNum = a[0].match(/Sink Input #(\d{1,3})/);
                        if (currentVol.length > 1) {
                            if (parseInt(currentVol[1]) >= 0 && sinkNum !== null) {
                                return { sinkNum: sinkNum[1], volume: parseInt(currentVol[1]) };
                            }
                        }
                    }
                }
            }
            catch (ignored) {
                info_1.log(ignored);
            }
            return { sinkNum: null, volume: 0 };
        });
    }
    muteVolume(currentVol) {
        return __awaiter(this, void 0, void 0, function* () {
            const v = currentVol || (yield this.getCurrentVolume());
            if (v.sinkNum && v.volume !== 0) {
                this.currentOnVolume = v.volume;
                this._setVolume(v.sinkNum, 0);
            }
        });
    }
    unmuteVolume(currentVol) {
        return __awaiter(this, void 0, void 0, function* () {
            const v = currentVol || (yield this.getCurrentVolume());
            if (v.sinkNum && v.volume === 0) {
                this._setVolume(v.sinkNum, this.currentOnVolume || 100);
            }
        });
    }
    muteUnmuteVolume() {
        return __awaiter(this, void 0, void 0, function* () {
            const v = yield this.getCurrentVolume();
            if (v.sinkNum) {
                if (v.volume === 0) {
                    this.unmuteVolume(v);
                }
                else {
                    this.muteVolume(v);
                }
            }
        });
    }
    volumeUp() {
        terminalCommand('pactl list sink-inputs')
            .then((d) => {
            const sinkedArr = d.split('Sinked Input #');
            return (sinkedArr !== null) ? sinkedArr.filter(this.findSpotify) : [];
        })
            .then((a) => {
            if (a.length > 0) {
                const sinkNum = a[0].match(/Sink Input #(\d{1,3})/);
                if (sinkNum !== null) {
                    terminalCommand(`pactl set-sink-input-volume ${sinkNum[1]} +5%)`);
                }
            }
        })
            .catch(info_1.log);
    }
    volumeDown() {
        terminalCommand('pactl list sink-inputs')
            .then((d) => {
            const sinkedArr = d.split('Sinked Input #');
            return (sinkedArr !== null) ? sinkedArr.filter(this.findSpotify) : [];
        })
            .then((a) => {
            if (a.length > 0) {
                const sinkNum = a[0].match(/Sink Input #(\d{1,3})/);
                if (sinkNum !== null) {
                    terminalCommand(`pactl set-sink-input-volume ${sinkNum[1]} -5%`);
                }
            }
        })
            .catch(info_1.log);
    }
    getStatus() {
        return __awaiter(this, void 0, void 0, function* () {
            try {
                const playbackStatus = yield terminalCommand(getPlaybackStatus);
                const metadata = yield terminalCommand(getMetadataCommand);
                if (!playbackStatus || !metadata) {
                    return Promise.reject(`Spotify isn't running`);
                }
                const state = playbackStatus.indexOf('Playing') ? 'playing' : 'paused';
                const result = {
                    playerState: {
                        state,
                        volume: 100,
                        position: 0,
                        isRepeating: false,
                        isShuffling: false // dbus doesn't return real value for this
                    },
                    track: {
                        album: (/album\|(.+)/g.exec(metadata) || [])[1],
                        artist: (/artist\|(.+)/g.exec(metadata) || [])[1],
                        name: (/title\|(.+)/g.exec(metadata) || [])[1]
                    },
                    isRunning: true
                };
                return result;
            }
            catch (ignored) {
                info_1.log(ignored);
            }
            return Promise.reject(`Spotify isn't running`);
        });
    }
    _setVolume(sinkNum, volume) {
        terminalCommand(`pactl set-sink-input-volume ${sinkNum} ${volume}%`);
    }
}
exports.LinuxSpotifyClient = LinuxSpotifyClient;
//# sourceMappingURL=linux-spotify-client.js.map