import { __decorate, __metadata } from "tslib";
import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
let ReRunFailedLevyContractService = class ReRunFailedLevyContractService {
    constructor(http) {
        this.http = http;
        this.header = new HttpHeaders({ 'content-type': 'application/json' });
    }
    ngOnInit() { }
    getFailedQueueCollections() {
        console.log("getting failed queue collections");
        return this.http.get(`../../replayFailedMessage/fetchmessagesfromqueue/`);
    }
    rerunFailedQueueCollections(items) {
        console.log("getting failed queue collections");
        //return this.http.get(`../../replayFailedMessage/rerunselectedfailedmessages/`,data);
        console.log("result count : ", items);
        return this.http.post(`../../replayFailedMessage/rerunselectedfailedmessages/`, JSON.stringify(items), { headers: this.header });
    }
};
ReRunFailedLevyContractService = __decorate([
    Injectable({ providedIn: 'root' }),
    __metadata("design:paramtypes", [HttpClient])
], ReRunFailedLevyContractService);
export { ReRunFailedLevyContractService };
//# sourceMappingURL=re-run-failed-levy-contract-service.js.map