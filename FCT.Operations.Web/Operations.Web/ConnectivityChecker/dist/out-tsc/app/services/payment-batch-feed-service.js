import { __decorate, __metadata } from "tslib";
import { Injectable } from '@angular/core';
import 'rxjs/add/operator/map';
import { HttpClient } from "@angular/common/http";
let PaymentBatchFeedService = class PaymentBatchFeedService {
    constructor(http) {
        this.http = http;
    }
    getItems(fundingStreamPeriod) {
        console.log("getting items");
        return this.http.get(`../../fcs-payment-batch-feed-info?fundingStreamPeriod=` + fundingStreamPeriod);
    }
    getXml(id) {
        console.log("getting contracts");
        return this.http.get(`../../fcs-payment-batch-feed-info/` + id);
    }
};
PaymentBatchFeedService = __decorate([
    Injectable(),
    __metadata("design:paramtypes", [HttpClient])
], PaymentBatchFeedService);
export { PaymentBatchFeedService };
//# sourceMappingURL=payment-batch-feed-service.js.map