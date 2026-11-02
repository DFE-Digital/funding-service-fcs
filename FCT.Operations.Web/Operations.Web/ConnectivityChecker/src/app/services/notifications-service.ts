import { Injectable } from '@angular/core';
import 'rxjs/add/operator/map';
import { HttpClient } from "@angular/common/http";

@Injectable()
export class NotificationsService {
  constructor (
    private http: HttpClient
  ) {}

  getNotifications() {
    console.log("getNotifications");
    return this.http.get(`../../fcs-notifications`);
  }
}
