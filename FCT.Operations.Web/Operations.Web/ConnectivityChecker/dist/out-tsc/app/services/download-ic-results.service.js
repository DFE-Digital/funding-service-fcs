import { __decorate, __metadata } from "tslib";
import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
let DownloadIcResultsService = class DownloadIcResultsService {
    constructor(http) {
        this.http = http;
    }
    getClosedCollections(pageNumber) {
        console.log("getting closed collections");
        return this.http.get(`../../intcheck-download/download-int-collections?pageNumber=` + pageNumber);
    }
    downloadCSV(documentName) {
        return this.http.get('../../intcheck-download/download-document?documentName=' + documentName, { responseType: 'text' });
    }
};
DownloadIcResultsService = __decorate([
    Injectable({ providedIn: 'root' }),
    __metadata("design:paramtypes", [HttpClient])
], DownloadIcResultsService);
export { DownloadIcResultsService };
//# sourceMappingURL=download-ic-results.service.js.map