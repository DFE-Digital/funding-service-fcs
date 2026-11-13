import { __decorate, __metadata } from "tslib";
import { Injectable } from '@angular/core';
import 'rxjs/add/operator/map';
import { HttpClient } from "@angular/common/http";
let ContractAtomFeedService = class ContractAtomFeedService {
    constructor(http) {
        this.http = http;
    }
    getContracts(contractNumber) {
        console.log("getting contracts");
        return this.http.get(`../../fcs-contract-atom-info?contractNumber=` + contractNumber);
    }
    getXml(id) {
        console.log("getting contracts");
        return this.http.get(`../../fcs-contract-atom-info/` + id);
    }
};
ContractAtomFeedService = __decorate([
    Injectable(),
    __metadata("design:paramtypes", [HttpClient])
], ContractAtomFeedService);
export { ContractAtomFeedService };
//# sourceMappingURL=contract-atom-feed-service.js.map