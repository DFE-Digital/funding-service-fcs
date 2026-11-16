import { __decorate, __metadata } from "tslib";
import { Injectable } from '@angular/core';
import 'rxjs/add/operator/map';
import { HttpClient } from "@angular/common/http";
let LevyContractService = class LevyContractService {
    constructor(http) {
        this.http = http;
    }
    getNonAmendableContracts() {
        console.log("getting non amendable Levy contracts");
        return this.http.get(`../../fcs-levy-contracts/not-amendable`);
    }
};
LevyContractService = __decorate([
    Injectable(),
    __metadata("design:paramtypes", [HttpClient])
], LevyContractService);
export { LevyContractService };
//# sourceMappingURL=levy-contract-service.js.map