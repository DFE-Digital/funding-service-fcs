import { Injectable } from '@angular/core';
import 'rxjs/add/operator/map';
import { HttpClient } from "@angular/common/http";

@Injectable()
export class ParkedFundingAllocationsService {
  constructor (
    private http: HttpClient
  ) {}

  getParkedFundingAllocationDetails() {
    console.log("getting Parked FundingAllocations detail");
    return this.http.get(`../../parked-funding-allocations/detail`);
  }
}