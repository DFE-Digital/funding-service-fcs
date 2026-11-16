import { __decorate, __metadata } from "tslib";
import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
let ApprenticeshipLevyService = class ApprenticeshipLevyService {
    constructor(http) {
        this.http = http;
        this.apiUrl = '../../fcs-levy-contracts';
    }
    getStatus() {
        return this.http.get(`${this.apiUrl}/webjobstatus`);
    }
    enableWebJob() {
        return this.http.post(`${this.apiUrl}/enablewebjob`, {});
    }
    disableWebJob() {
        return this.http.post(`${this.apiUrl}/disablewebjob`, {});
    }
    getIsAuthorized() {
        console.log("Getting is-authorized");
        return this.http.get(`../../dasevents/is-authorized`);
    }
};
ApprenticeshipLevyService = __decorate([
    Injectable({
        providedIn: 'root'
    }),
    __metadata("design:paramtypes", [HttpClient])
], ApprenticeshipLevyService);
export { ApprenticeshipLevyService };
//# sourceMappingURL=apprenticeship-levy.service.js.map