import { Injectable } from '@angular/core';
import 'rxjs/add/operator/map';
import { HttpClient } from "@angular/common/http";

@Injectable()
export class MonthEndService {
  constructor (
    private http: HttpClient
  ) {}

  getClosedCollections(pageNumber) {
    console.log("getting closed collections");
    return this.http.get(`../../month-end/closed-collections?pageNumber=` + pageNumber);
  }
}