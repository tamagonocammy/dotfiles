"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.activate = void 0;
const vscode_1 = require("vscode");
const commands_1 = require("./commands");
const spotify_status_1 = require("./components/spotify-status");
const tree_playlists_1 = require("./components/tree-playlists");
const tree_track_1 = require("./components/tree-track");
const spotify_config_1 = require("./config/spotify-config");
const spotify_status_controller_1 = require("./spotify-status-controller");
const spotify_client_1 = require("./spotify/spotify-client");
const store_1 = require("./store/store");
// This method is called when your extension is activated. Activation is
// controlled by the activation events defined in package.json.
function activate(context) {
    // This line of code will only be executed once when your extension is activated.
    spotify_config_1.registerGlobalState(context.globalState);
    store_1.getStore(context.globalState);
    const spotifyStatus = new spotify_status_1.SpotifyStatus();
    const controller = new spotify_status_controller_1.SpotifyStatusController();
    const playlistTreeView = vscode_1.window.createTreeView('vscode-spotify-playlists', { treeDataProvider: new tree_playlists_1.TreePlaylistProvider() });
    const treeTrackProvider = new tree_track_1.TreeTrackProvider();
    const trackTreeView = vscode_1.window.createTreeView('vscode-spotify-tracks', { treeDataProvider: treeTrackProvider });
    treeTrackProvider.bindView(trackTreeView);
    // Add to a list of disposables which are disposed when this extension is deactivated.
    context.subscriptions.push(tree_playlists_1.connectPlaylistTreeView(playlistTreeView));
    context.subscriptions.push(tree_track_1.connectTrackTreeView(trackTreeView));
    context.subscriptions.push(controller);
    context.subscriptions.push(spotifyStatus);
    context.subscriptions.push(playlistTreeView);
    context.subscriptions.push(commands_1.createCommands(spotify_client_1.SpoifyClientSingleton.spotifyClient));
}
exports.activate = activate;
//# sourceMappingURL=extension.js.map