import { Injectable } from '@angular/core';
import 'rxjs/add/operator/map';
import { HttpClient } from "@angular/common/http";

@Injectable()
export class ContractAtomFeedService {
  constructor (
    private http: HttpClient
  ) {}

  getContracts(contractNumber) {
    console.log("getting contracts");
    return this.http.get(`../../fcs-contract-atom-info?contractNumber=` + contractNumber);
  }

  getXml(id) {
    console.log("getting contracts");
    return this.http.get(`../../fcs-contract-atom-info/` + id);
  }
}