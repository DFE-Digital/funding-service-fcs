import { __decorate, __metadata } from "tslib";
import { Injectable } from '@angular/core';
import 'rxjs/add/operator/map';
import { HttpClient } from "@angular/common/http";
let CfsImportService = class CfsImportService {
    constructor(http) {
        this.http = http;
    }
    getCfsImportInfos(pageNumber) {
        console.log("getting CfsImportInfos - + pageNumber " + pageNumber);
        return this.http.get(`../../cfs-import/infos?pageNumber=` + pageNumber);
    }
};
CfsImportService = __decorate([
    Injectable(),
    __metadata("design:paramtypes", [HttpClient])
], CfsImportService);
export { CfsImportService };
//# sourceMappingURL=cfs-import-service.js.map