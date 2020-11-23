"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.TreePlaylistProvider = exports.connectPlaylistTreeView = void 0;
const path = require("path");
const vscode = require("vscode");
const actions_1 = require("../actions/actions");
const store_1 = require("../store/store");
exports.connectPlaylistTreeView = (view) => vscode.Disposable.from(view.onDidChangeSelection(e => {
    actions_1.actionsCreator.selectPlaylistAction(e.selection[0]);
    actions_1.actionsCreator.loadTracksIfNotLoaded(e.selection[0]);
}), view.onDidChangeVisibility(e => {
    if (e.visible) {
        const state = store_1.getState();
        if (!state.playlists.length) {
            actions_1.actionsCreator.loadPlaylists();
        }
        if (state.selectedPlaylist) {
            const p = state.playlists.find(pl => pl.id === state.selectedPlaylist.id);
            if (p && !view.selection.indexOf(p)) {
                view.reveal(p, { focus: true, select: true });
            }
        }
    }
}));
class TreePlaylistProvider {
    constructor() {
        this.onDidChangeTreeDataEmitter = new vscode.EventEmitter();
        this.onDidChangeTreeData = this.onDidChangeTreeDataEmitter.event;
        this.playlists = [];
        store_1.getStore().subscribe(() => {
            const { playlists } = store_1.getState();
            if (this.playlists !== playlists) {
                this.playlists = playlists;
                this.refresh();
            }
        });
    }
    getParent(_p) {
        return void 0; // all playlists are in root
    }
    refresh() {
        this.onDidChangeTreeDataEmitter.fire(void 0);
    }
    getTreeItem(p) {
        return new PlaylistTreeItem(p, vscode.TreeItemCollapsibleState.None);
    }
    getChildren(element) {
        if (element) {
            return Promise.resolve([]);
        }
        if (!this.playlists) {
            return Promise.resolve([]);
        }
        return new Promise(resolve => {
            resolve(this.playlists);
        });
    }
}
exports.TreePlaylistProvider = TreePlaylistProvider;
class PlaylistTreeItem extends vscode.TreeItem {
    constructor(playlist, collapsibleState, command) {
        super(playlist.name, collapsibleState);
        this.playlist = playlist;
        this.collapsibleState = collapsibleState;
        this.command = command;
        this.iconPath = {
            light: path.join(__filename, '..', '..', '..', 'resources', 'light', 'playlist.svg'),
            dark: path.join(__filename, '..', '..', '..', 'resources', 'dark', 'playlist.svg')
        };
        this.contextValue = 'playlist';
    }
    // @ts-ignore
    get tooltip() {
        return `${this.playlist.id}:${this.label}`;
    }
}
//# sourceMappingURL=tree-playlists.js.map