import { __decorate, __metadata } from "tslib";
import { Injectable } from '@angular/core';
import 'rxjs/add/operator/map';
import { HttpClient } from "@angular/common/http";
let ConnectivityCheckService = class ConnectivityCheckService {
    constructor(http) {
        this.http = http;
    }
    getChecks() {
        return this.http.get(`../../availability`);
    }
    getCheckServiceNames() {
        return this.http.get(`../../availability/services`);
    }
    getCheckServiceResult(serviceName) {
        return this.http.get(`../../availability/services/` + serviceName);
    }
};
ConnectivityCheckService = __decorate([
    Injectable(),
    __metadata("design:paramtypes", [HttpClient])
], ConnectivityCheckService);
export { ConnectivityCheckService };
//# sourceMappingURL=connectivity-check-service.js.map