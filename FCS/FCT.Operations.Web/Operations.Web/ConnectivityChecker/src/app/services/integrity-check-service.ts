import { Injectable } from '@angular/core';
import 'rxjs/add/operator/map';
import { HttpClient } from "@angular/common/http";

@Injectable()
export class IntegrityCheckService {
  constructor (
    private http: HttpClient
  ) {}

  startIntegrityCheck(integrityCheckName: string) {
    return this.http.post('../../integrity-checker', integrityCheckName); 
  }

  startAllIntegrityChecks() {
    return this.http.post('../../integrity-checker/all', ''); 
  }
}