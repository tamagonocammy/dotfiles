"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.isMuted = exports.getState = exports.getStore = void 0;
const immutable_1 = require("immutable");
const redux_1 = require("redux");
const redux_persist_1 = require("redux-persist");
const root_reducer_1 = require("../reducers/root-reducer");
const state_1 = require("../state/state");
const vscode_storage_1 = require("./storage/vscode-storage");
let store;
function getStore(memento) {
    if (!store) {
        const notToPersistList = ['selectedTrack', 'selectedPlaylist'];
        const persistConfig = {
            key: 'root',
            storage: memento ? vscode_storage_1.createVscodeStorage(memento) : vscode_storage_1.createDummyStorage(),
            transforms: [{
                    out: (val, key) => {
                        if (~notToPersistList.indexOf(key)) {
                            return null;
                        }
                        if (key === 'tracks') {
                            return immutable_1.Map(val);
                        }
                        return val;
                    },
                    in: (val, key) => {
                        if (~notToPersistList.indexOf(key)) {
                            return null;
                        }
                        return val;
                    }
                }]
        };
        const persistedReducer = redux_persist_1.persistReducer(persistConfig, root_reducer_1.default);
        store = redux_1.createStore(persistedReducer, state_1.DEFAULT_STATE);
        redux_persist_1.persistStore(store);
    }
    return store;
}
exports.getStore = getStore;
function getState() {
    return getStore().getState();
}
exports.getState = getState;
/**
 * True if on last state of Spotify it was muted(volume was equal 0)
 */
function isMuted() {
    const state = getState();
    return state && state.playerState.volume === 0;
}
exports.isMuted = isMuted;
//# sourceMappingURL=store.js.map