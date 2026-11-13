import { __decorate, __metadata } from "tslib";
import { Injectable } from '@angular/core';
import { HttpClient } from "@angular/common/http";
import 'rxjs/add/operator/map';
import 'rxjs/Rx';
let SessionService = class SessionService {
    constructor(http) {
        this.http = http;
        this.sessionKey = 'session_key';
        this.sessionId = "";
    }
    login(authenticationToken) {
        let body = JSON.stringify({ 'foo': authenticationToken });
        let headers = new Headers({ 'Accept': 'application/json' });
        // let options = new RequestOptions({ headers: headers });
        return this.http.post('../../session', authenticationToken); // ...and calling .json() on the response to return data
        //.catch((error:any) => Observable.throw(error.json().error || 'Server error')); //...errors if any;
        //.map((res:Response) => res.json());
    }
    addSessionId(sessionId) {
        localStorage.setItem(this.sessionKey, sessionId);
    }
    getSessionId() {
        return localStorage.getItem(this.sessionKey);
    }
    isLoggedIn() {
        return localStorage.getItem(this.sessionKey) != null;
    }
};
SessionService = __decorate([
    Injectable(),
    __metadata("design:paramtypes", [HttpClient])
], SessionService);
export { SessionService };
//# sourceMappingURL=session-service.js.map