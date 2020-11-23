"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.DEFAULT_STATE = exports.DUMMY_PLAYLIST = void 0;
const immutable_1 = require("immutable");
exports.DUMMY_PLAYLIST = {
    collaborative: false,
    /* eslint-disable @typescript-eslint/naming-convention */
    external_urls: {
        spotify: ''
    },
    href: '',
    id: 'No Playlists',
    images: [{
            height: 100,
            url: 'none',
            width: 100
        }],
    name: 'It seems that you don\'t have any playlists. To refresh use spotify.loadPlaylists command.',
    owner: {
        /* eslint-disable @typescript-eslint/naming-convention */
        display_name: '',
        /* eslint-disable @typescript-eslint/naming-convention */
        external_urls: {
            spotify: ''
        },
        href: '',
        id: '',
        type: '',
        uri: ''
    },
    primary_color: null,
    public: false,
    snapshot_id: '',
    tracks: {
        href: '',
        total: 0
    },
    type: '',
    uri: ''
};
exports.DEFAULT_STATE = {
    playerState: {
        position: 0,
        volume: 0,
        state: 'paused',
        isRepeating: false,
        isShuffling: false
    },
    track: {
        album: '',
        artist: '',
        name: ''
    },
    isRunning: false,
    loginState: null,
    context: void 0,
    playlists: [],
    selectedPlaylist: void 0,
    tracks: immutable_1.Map(),
    selectedTrack: null
};
//# sourceMappingURL=state.js.map