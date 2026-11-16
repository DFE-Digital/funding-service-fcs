import { __decorate, __metadata } from "tslib";
import { Injectable } from '@angular/core';
import 'rxjs/add/operator/map';
import { HttpClient } from "@angular/common/http";
let OrganisationService = class OrganisationService {
    constructor(http) {
        this.http = http;
    }
    getOrg(ukprn) {
        return this.http.get('../../fcs-organisation/' + ukprn);
    }
};
OrganisationService = __decorate([
    Injectable(),
    __metadata("design:paramtypes", [HttpClient])
], OrganisationService);
export { OrganisationService };
//# sourceMappingURL=organisation-service.js.map