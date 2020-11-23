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
exports.createCommands = void 0;
const vscode_1 = require("vscode");
const actions_1 = require("./actions/actions");
const spotify_config_1 = require("./config/spotify-config");
const lyrics_1 = require("./lyrics/lyrics");
const consts_1 = require("./consts/consts");
function createCommands(sC) {
    const lC = new lyrics_1.LyricsController();
    const lyrics = vscode_1.commands.registerCommand('spotify.lyrics', lC.findLyrics.bind(lC));
    const next = vscode_1.commands.registerCommand('spotify.next', sC.next.bind(sC));
    const previous = vscode_1.commands.registerCommand('spotify.previous', sC.previous.bind(sC));
    const play = vscode_1.commands.registerCommand('spotify.play', sC.play.bind(sC));
    const pause = vscode_1.commands.registerCommand('spotify.pause', sC.pause.bind(sC));
    const playPause = vscode_1.commands.registerCommand('spotify.playPause', sC.playPause.bind(sC));
    const muteVolume = vscode_1.commands.registerCommand('spotify.muteVolume', sC.muteVolume.bind(sC));
    const unmuteVolume = vscode_1.commands.registerCommand('spotify.unmuteVolume', sC.unmuteVolume.bind(sC));
    const muteUnmuteVolume = vscode_1.commands.registerCommand('spotify.muteUnmuteVolume', sC.muteUnmuteVolume.bind(sC));
    const volumeUp = vscode_1.commands.registerCommand('spotify.volumeUp', sC.volumeUp.bind(sC));
    const volumeDown = vscode_1.commands.registerCommand('spotify.volumeDown', sC.volumeDown.bind(sC));
    const toggleRepeating = vscode_1.commands.registerCommand('spotify.toggleRepeating', sC.toggleRepeating.bind(sC));
    const toggleShuffling = vscode_1.commands.registerCommand('spotify.toggleShuffling', sC.toggleShuffling.bind(sC));
    const signIn = vscode_1.commands.registerCommand(consts_1.SIGN_IN_COMMAND, actions_1.actionsCreator.actionSignIn);
    const signOut = vscode_1.commands.registerCommand('spotify.signOut', actions_1.actionsCreator.actionSignOut);
    const loadPlaylists = vscode_1.commands.registerCommand('spotify.loadPlaylists', actions_1.actionsCreator.loadPlaylists);
    const loadTracks = vscode_1.commands.registerCommand('spotify.loadTracks', actions_1.actionsCreator.loadTracksForSelectedPlaylist);
    const trackInfoClick = vscode_1.commands.registerCommand('spotify.trackInfoClick', () => {
        const trackInfoClickBehaviour = spotify_config_1.getTrackInfoClickBehaviour();
        if (trackInfoClickBehaviour === 'focus_song') {
            actions_1.actionsCreator.selectCurrentTrack();
        }
        else if (trackInfoClickBehaviour === 'play_pause') {
            sC.playPause();
        }
    });
    const playTrack = vscode_1.commands.registerCommand('spotify.playTrack', (/*arguments from TrackTreeItem event*/ offset, playlist) => __awaiter(this, void 0, void 0, function* () {
        yield actions_1.actionsCreator.playTrack(offset, playlist);
        sC.queryStatusFunc();
    }));
    const seekTo = vscode_1.commands.registerCommand('spotify.seekTo', (seekToMs) => {
        actions_1.actionsCreator.seekTo(seekToMs);
    });
    return vscode_1.Disposable.from(lyrics, next, previous, play, pause, playPause, muteVolume, unmuteVolume, muteUnmuteVolume, volumeUp, volumeDown, toggleRepeating, toggleShuffling, signIn, signOut, loadPlaylists, loadTracks, trackInfoClick, playTrack, seekTo, lC.registration);
}
exports.createCommands = createCommands;
//# sourceMappingURL=commands.js.map