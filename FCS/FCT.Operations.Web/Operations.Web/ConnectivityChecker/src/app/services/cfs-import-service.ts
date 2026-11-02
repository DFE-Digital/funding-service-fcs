import { Injectable } from '@angular/core';
import 'rxjs/add/operator/map';
import { HttpClient } from "@angular/common/http";

@Injectable()
export class CfsImportService {
  constructor (
    private http: HttpClient
  ) {}

  getCfsImportInfos(pageNumber) {
    console.log("getting CfsImportInfos - + pageNumber " + pageNumber);
    return this.http.get(`../../cfs-import/infos?pageNumber=` + pageNumber);
  }
}