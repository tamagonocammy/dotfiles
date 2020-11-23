"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.createCancelablePromise = exports.NOT_RUNNING_REASON = exports.CANCELED_REASON = void 0;
exports.CANCELED_REASON = 'canceled';
exports.NOT_RUNNING_REASON = 'not_running';
function createCancelablePromise(executor) {
    let cancel = null;
    const promise = new Promise((resolve, reject) => {
        cancel = () => {
            reject(exports.CANCELED_REASON);
        };
        executor(resolve, reject);
    });
    return { promise, cancel };
}
exports.createCancelablePromise = createCancelablePromise;
//# sourceMappingURL=utils.js.map