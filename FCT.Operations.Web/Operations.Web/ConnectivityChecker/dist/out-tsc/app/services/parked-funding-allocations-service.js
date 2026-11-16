import { __decorate, __metadata } from "tslib";
import { Injectable } from '@angular/core';
import 'rxjs/add/operator/map';
import { HttpClient } from "@angular/common/http";
let ParkedFundingAllocationsService = class ParkedFundingAllocationsService {
    constructor(http) {
        this.http = http;
    }
    getParkedFundingAllocationDetails() {
        console.log("getting Parked FundingAllocations detail");
        return this.http.get(`../../parked-funding-allocations/detail`);
    }
};
ParkedFundingAllocationsService = __decorate([
    Injectable(),
    __metadata("design:paramtypes", [HttpClient])
], ParkedFundingAllocationsService);
export { ParkedFundingAllocationsService };
//# sourceMappingURL=parked-funding-allocations-service.js.map