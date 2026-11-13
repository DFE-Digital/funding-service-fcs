import { __decorate, __metadata } from "tslib";
import { Injectable } from '@angular/core';
import { catchError } from 'rxjs/operators';
import { ErrorHandlingService } from '../error-handlers/error-handling-service.service';
let ErrorInterceptor = class ErrorInterceptor {
    constructor(errorHandlingService) {
        this.errorHandlingService = errorHandlingService;
    }
    intercept(req, next) {
        return next.handle(req).pipe(catchError((error) => {
            return this.errorHandlingService.handleError(error);
        }));
    }
};
ErrorInterceptor = __decorate([
    Injectable(),
    __metadata("design:paramtypes", [ErrorHandlingService])
], ErrorInterceptor);
export { ErrorInterceptor };
//# sourceMappingURL=ErrorInterceptor.js.map