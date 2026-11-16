import { __decorate, __metadata } from "tslib";
import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
let StorageService = class StorageService {
    constructor(http) {
        this.http = http;
    }
    copyDocuments(sourceContainer) {
        return this.http.post('../../applevy-variation/copyDocuments', { sourceContainer });
    }
};
StorageService = __decorate([
    Injectable({
        providedIn: 'root'
    }),
    __metadata("design:paramtypes", [HttpClient])
], StorageService);
export { StorageService };
//# sourceMappingURL=storage.service.js.map