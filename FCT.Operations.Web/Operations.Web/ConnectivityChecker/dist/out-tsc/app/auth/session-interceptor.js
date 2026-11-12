import { __decorate, __metadata } from "tslib";
import { Injectable } from '@angular/core';
import { SessionService } from '../services/session-service';
import { Injector } from '@angular/core';
let SessionInterceptor = class SessionInterceptor {
    constructor(injector) {
        this.injector = injector;
    }
    intercept(request, next) {
        this.sessionService = this.injector.get(SessionService);
        request = request.clone({
            setHeaders: {
                Authorization: `session-token ${this.sessionService.getSessionId()}`
            }
        });
        return next.handle(request);
    }
};
SessionInterceptor = __decorate([
    Injectable(),
    __metadata("design:paramtypes", [Injector])
], SessionInterceptor);
export { SessionInterceptor };
//# sourceMappingURL=session-interceptor.js.map