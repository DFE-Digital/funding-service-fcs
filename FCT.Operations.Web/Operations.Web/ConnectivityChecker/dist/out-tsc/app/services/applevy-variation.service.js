import { __decorate, __metadata } from "tslib";
import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { catchError } from 'rxjs/operators';
import { ErrorHandlingService } from '../error-handlers/error-handling-service.service';
let ApplevyVariationService = class ApplevyVariationService {
    constructor(http, errorHandlingService) {
        this.http = http;
        this.errorHandlingService = errorHandlingService;
        this.header = new HttpHeaders({ 'content-type': 'application/json' });
    }
    triggerVariation(items) {
        return this.http.post(`../../applevy-variation/createapplevyvariation/`, items, { headers: this.header })
            .pipe(catchError(this.errorHandlingService.handleError));
    }
    getFiles(containerName) {
        return this.http.get(`../../applevy-variation/GetFiles/` + containerName)
            .pipe(catchError(this.errorHandlingService.handleError));
    }
    getLatestContractInformationByFundingTypeAndFundingPeriod(fundingType, fundingPeriod) {
        return this.http.get(`../../applevy-variation/GetLatestContractInformationByFundingTypeAndFundingPeriod/${fundingType}/${fundingPeriod}`)
            .pipe(catchError(this.errorHandlingService.handleError));
    }
};
ApplevyVariationService = __decorate([
    Injectable({
        providedIn: 'root'
    }),
    __metadata("design:paramtypes", [HttpClient, ErrorHandlingService])
], ApplevyVariationService);
export { ApplevyVariationService };
//# sourceMappingURL=applevy-variation.service.js.map