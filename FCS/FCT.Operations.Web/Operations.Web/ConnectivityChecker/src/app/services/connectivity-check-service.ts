import { Injectable } from '@angular/core';
import 'rxjs/add/operator/map';
import { HttpClient } from "@angular/common/http";
import { CheckResult } from '../check.result';

@Injectable()
export class ConnectivityCheckService {
  constructor (
    private http: HttpClient
  ) {}

  getChecks() {
    return this.http.get(`../../availability`);
  }

  getCheckServiceNames() {
    return this.http.get(`../../availability/services`);
  }

  getCheckServiceResult(serviceName: string) {
    return this.http.get<CheckResult>(`../../availability/services/` + serviceName);
  }
}