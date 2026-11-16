import { __decorate, __metadata } from "tslib";
import { Injectable } from '@angular/core';
import 'rxjs/add/operator/map';
import { HttpClient } from "@angular/common/http";
let ProviderAgreementService = class ProviderAgreementService {
    constructor(http) {
        this.http = http;
    }
    add(ukprn) {
        console.log("Add EngagementEvent");
        return this.http.post('../../dasevents/initiatepublication/', { "Ukprn": ukprn });
    }
    getEngagementEventRows() {
        console.log("Getting EngagementEventRows");
        return this.http.get(`../../dasevents/recent`);
    }
    getIsAuthorized() {
        console.log("Getting is-authorized");
        return this.http.get(`../../dasevents/is-authorized`);
    }
};
ProviderAgreementService = __decorate([
    Injectable(),
    __metadata("design:paramtypes", [HttpClient])
], ProviderAgreementService);
export { ProviderAgreementService };
//# sourceMappingURL=provider-agreemement-service.js.map