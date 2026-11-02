import { Injectable } from '@angular/core';
import 'rxjs/add/operator/map';
import { HttpClient } from "@angular/common/http";

@Injectable()
export class ProviderAgreementService {
  constructor (
    private http: HttpClient
  ) {}

  add(ukprn: string) {
    console.log("Add EngagementEvent");
    return this.http.post('../../dasevents/initiatepublication/', {"Ukprn": ukprn}); 
  }

  getEngagementEventRows() {
    console.log("Getting EngagementEventRows");
    return this.http.get(`../../dasevents/recent`);
  }

  getIsAuthorized() {
      console.log("Getting is-authorized");
    return this.http.get(`../../dasevents/is-authorized`);
  }
}