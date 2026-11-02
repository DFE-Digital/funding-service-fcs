import { Injectable } from '@angular/core';
import 'rxjs/add/operator/map';
import { HttpClient } from "@angular/common/http";

@Injectable()
export class OrganisationService {
  constructor (
    private http: HttpClient
  ) {}

  getOrg(ukprn: string) {
    return this.http.get('../../fcs-organisation/' + ukprn); 
  }
}