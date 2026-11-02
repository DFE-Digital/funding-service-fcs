import { Component, OnInit } from '@angular/core';
import { PaymentBatchFeedService } from '../services/payment-batch-feed-service';

class PaymentBatchFeedInfo {

  constructor(
    public Id: string,
    public FundingStreamPeriod: string,
    public PaymentPeriod: string,
    public CensusEndDate: string,
    public CreatedDate: string
  ) { }
}

@Component({
  selector: 'app-payment-batch-feed',
  templateUrl: './payment-batch-feed.component.html'
  //styleUrls: ['./payment-batch-feed.component.css']
})
export class PaymentBatchFeedComponent implements OnInit {

  public items: Array<PaymentBatchFeedInfo>;
  public loading: boolean = false;
  public hasSearchBeenClicked: boolean = false;
  public fundingStreamPeriod: string;

  constructor(private paymentBatchFeedService: PaymentBatchFeedService) { }

  ngOnInit() {
    console.log("payment batch feed component");
  }

  onSearch(fundingStreamPeriod) {
    if (this.isOkToSearch(fundingStreamPeriod)) {
      this.loading = true;
      this.hasSearchBeenClicked = true;
      this.paymentBatchFeedService.getItems(fundingStreamPeriod).subscribe((items: PaymentBatchFeedInfo[]) => {
        this.items = items;
        this.loading = false;
        this.items.sort((a,b) => new Date(b.CreatedDate).getTime() - new Date(a.CreatedDate).getTime());
      });
    }

    console.log(fundingStreamPeriod);
  }

  isOkToSearch(fundingStreamPeriod) {
    return fundingStreamPeriod != null && fundingStreamPeriod.length >= 3
  }

  getXmlForContractId(event: Event, item: PaymentBatchFeedInfo) {
    console.log("id: " + item.Id);
    let header = 'data:text/csv;charset=utf-8,'
    var link = document.createElement("a");
    this.paymentBatchFeedService.getXml(item.Id).subscribe((xml: string) => {
      link.setAttribute('href', encodeURI(header + xml));

      let fileName = `${`${item.FundingStreamPeriod}_${item.PaymentPeriod}`}.xml`;
      link.setAttribute('download', fileName);
      link.click();
    });

    event.preventDefault();
  }
}