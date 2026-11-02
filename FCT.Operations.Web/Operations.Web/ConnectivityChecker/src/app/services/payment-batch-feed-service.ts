import { Injectable } from '@angular/core';
import 'rxjs/add/operator/map';
import { HttpClient } from "@angular/common/http";

@Injectable()
export class PaymentBatchFeedService {
  constructor (
    private http: HttpClient
  ) {}

  getItems(fundingStreamPeriod) {
    console.log("getting items");
    return this.http.get(`../../fcs-payment-batch-feed-info?fundingStreamPeriod=` + fundingStreamPeriod);
  }

  getXml(id) {
    console.log("getting contracts");
    return this.http.get(`../../fcs-payment-batch-feed-info/` + id);
  }
}