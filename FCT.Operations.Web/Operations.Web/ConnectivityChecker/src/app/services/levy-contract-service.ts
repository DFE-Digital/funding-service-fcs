import { Injectable } from '@angular/core';
import 'rxjs/add/operator/map';
import { HttpClient } from "@angular/common/http";

@Injectable()
export class LevyContractService {
  constructor (
    private http: HttpClient
  ) {}

  getNonAmendableContracts() {
    console.log("getting non amendable Levy contracts");
    return this.http.get(`../../fcs-levy-contracts/not-amendable`);
  }
}