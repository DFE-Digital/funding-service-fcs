import { __decorate, __metadata } from "tslib";
import { Component } from '@angular/core';
import { PaymentBatchFeedService } from '../services/payment-batch-feed-service';
class PaymentBatchFeedInfo {
    constructor(Id, FundingStreamPeriod, PaymentPeriod, CensusEndDate, CreatedDate) {
        this.Id = Id;
        this.FundingStreamPeriod = FundingStreamPeriod;
        this.PaymentPeriod = PaymentPeriod;
        this.CensusEndDate = CensusEndDate;
        this.CreatedDate = CreatedDate;
    }
}
let PaymentBatchFeedComponent = class PaymentBatchFeedComponent {
    constructor(paymentBatchFeedService) {
        this.paymentBatchFeedService = paymentBatchFeedService;
        this.loading = false;
        this.hasSearchBeenClicked = false;
    }
    ngOnInit() {
        console.log("payment batch feed component");
    }
    onSearch(fundingStreamPeriod) {
        if (this.isOkToSearch(fundingStreamPeriod)) {
            this.loading = true;
            this.hasSearchBeenClicked = true;
            this.paymentBatchFeedService.getItems(fundingStreamPeriod).subscribe((items) => {
                this.items = items;
                this.loading = false;
                this.items.sort((a, b) => new Date(b.CreatedDate).getTime() - new Date(a.CreatedDate).getTime());
            });
        }
        console.log(fundingStreamPeriod);
    }
    isOkToSearch(fundingStreamPeriod) {
        return fundingStreamPeriod != null && fundingStreamPeriod.length >= 3;
    }
    getXmlForContractId(event, item) {
        console.log("id: " + item.Id);
        let header = 'data:text/csv;charset=utf-8,';
        var link = document.createElement("a");
        this.paymentBatchFeedService.getXml(item.Id).subscribe((xml) => {
            link.setAttribute('href', encodeURI(header + xml));
            let fileName = `${`${item.FundingStreamPeriod}_${item.PaymentPeriod}`}.xml`;
            link.setAttribute('download', fileName);
            link.click();
        });
        event.preventDefault();
    }
};
PaymentBatchFeedComponent = __decorate([
    Component({
        selector: 'app-payment-batch-feed',
        templateUrl: './payment-batch-feed.component.html'
        //styleUrls: ['./payment-batch-feed.component.css']
    }),
    __metadata("design:paramtypes", [PaymentBatchFeedService])
], PaymentBatchFeedComponent);
export { PaymentBatchFeedComponent };
//# sourceMappingURL=payment-batch-feed.component.js.map