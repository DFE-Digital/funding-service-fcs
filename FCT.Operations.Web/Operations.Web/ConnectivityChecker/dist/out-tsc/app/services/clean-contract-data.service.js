import { __decorate, __metadata } from "tslib";
import { Injectable } from "@angular/core";
import { HttpClient } from "@angular/common/http";
let CleanContractDataService = class CleanContractDataService {
    constructor(http) {
        this.http = http;
        this.apiUrl = '../../contractcleanup';
    }
    cleanContractData(fundingIDs) {
        return this.http.post(this.apiUrl + '/cfsdata', fundingIDs);
    }
};
CleanContractDataService = __decorate([
    Injectable({
        providedIn: 'root'
    }),
    __metadata("design:paramtypes", [HttpClient])
], CleanContractDataService);
export { CleanContractDataService };
//# sourceMappingURL=clean-contract-data.service.js.map