import { __decorate, __metadata } from "tslib";
import { Injectable } from '@angular/core';
import 'rxjs/add/operator/map';
import { HttpClient } from "@angular/common/http";
let IntegrityCheckService = class IntegrityCheckService {
    constructor(http) {
        this.http = http;
    }
    startIntegrityCheck(integrityCheckName) {
        return this.http.post('../../integrity-checker', integrityCheckName);
    }
    startAllIntegrityChecks() {
        return this.http.post('../../integrity-checker/all', '');
    }
};
IntegrityCheckService = __decorate([
    Injectable(),
    __metadata("design:paramtypes", [HttpClient])
], IntegrityCheckService);
export { IntegrityCheckService };
//# sourceMappingURL=integrity-check-service.js.map