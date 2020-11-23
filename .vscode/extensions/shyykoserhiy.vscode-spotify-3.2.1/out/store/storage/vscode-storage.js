"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.createDummyStorage = exports.createVscodeStorage = void 0;
function createVscodeStorage(memento) {
    return {
        getItem: (key) => new Promise((resolve, _reject) => {
            resolve(memento.get(key));
        }),
        setItem: (key, item) => new Promise((resolve, _reject) => {
            memento.update(key, item).then(resolve);
        }),
        removeItem: (key) => new Promise((resolve, _reject) => {
            memento.update(key, null).then(resolve);
        })
    };
}
exports.createVscodeStorage = createVscodeStorage;
function createDummyStorage() {
    return {
        getItem: (_key) => new Promise((resolve, _reject) => {
            resolve('');
        }),
        setItem: (_key, _item) => new Promise((resolve, _reject) => {
            resolve();
        }),
        removeItem: (_key) => new Promise((resolve, _reject) => {
            resolve();
        })
    };
}
exports.createDummyStorage = createDummyStorage;
//# sourceMappingURL=vscode-storage.js.map