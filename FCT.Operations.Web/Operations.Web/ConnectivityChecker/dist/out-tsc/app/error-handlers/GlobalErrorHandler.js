import { __decorate, __metadata } from "tslib";
import { Injectable, Injector } from '@angular/core';
import { ErrorHandlingService } from '../error-handlers/error-handling-service.service';
let GlobalErrorHandler = class GlobalErrorHandler {
    constructor(injector) {
        this.injector = injector;
    }
    handleError(error) {
        const errorHandlingService = this.injector.get(ErrorHandlingService);
        errorHandlingService.handleClientError(error);
        // Additional global error handling logic
    }
};
GlobalErrorHandler = __decorate([
    Injectable(),
    __metadata("design:paramtypes", [Injector])
], GlobalErrorHandler);
export { GlobalErrorHandler };
//# sourceMappingURL=GlobalErrorHandler.js.map