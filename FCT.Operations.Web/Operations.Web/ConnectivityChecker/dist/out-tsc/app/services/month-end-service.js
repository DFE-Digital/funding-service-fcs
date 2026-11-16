import { __decorate, __metadata } from "tslib";
import { Injectable } from '@angular/core';
import 'rxjs/add/operator/map';
import { HttpClient } from "@angular/common/http";
let MonthEndService = class MonthEndService {
    constructor(http) {
        this.http = http;
    }
    getClosedCollections(pageNumber) {
        console.log("getting closed collections");
        return this.http.get(`../../month-end/closed-collections?pageNumber=` + pageNumber);
    }
};
MonthEndService = __decorate([
    Injectable(),
    __metadata("design:paramtypes", [HttpClient])
], MonthEndService);
export { MonthEndService };
//# sourceMappingURL=month-end-service.js.map