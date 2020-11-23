"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.update = void 0;
const common_1 = require("../actions/common");
const info_1 = require("../info/info");
const state_1 = require("../state/state");
function update(obj, propertyUpdate) {
    return Object.assign({}, obj, propertyUpdate);
}
exports.update = update;
function default_1(state, action) {
    info_1.log('root-reducer', action.type, JSON.stringify(action));
    if (action.type === common_1.UPDATE_STATE_ACTION) {
        return update(state, action.state);
    }
    if (action.type === common_1.SIGN_IN_ACTION) {
        return update(state, {
            loginState: update(state.loginState, { accessToken: action.accessToken, refreshToken: action.refreshToken })
        });
    }
    if (action.type === common_1.SIGN_OUT_ACTION) {
        return state_1.DEFAULT_STATE;
    }
    if (action.type === common_1.PLAYLISTS_LOAD_ACTION) {
        return update(state, {
            playlists: (action.playlists && action.playlists.length) ? action.playlists : [state_1.DUMMY_PLAYLIST]
        });
    }
    if (action.type === common_1.SELECT_PLAYLIST_ACTION) {
        return update(state, {
            selectedPlaylist: action.playlist
        });
    }
    if (action.type === common_1.SELECT_TRACK_ACTION) {
        return update(state, {
            selectedTrack: action.track
        });
    }
    if (action.type === common_1.TRACKS_LOAD_ACTION) {
        return update(state, {
            tracks: state.tracks.set(action.playlist.id, action.tracks)
        });
    }
    return state;
}
exports.default = default_1;
//# sourceMappingURL=root-reducer.js.map