import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
 
@Injectable({
  providedIn: 'root'
})
export class ApprenticeshipLevyService {
  private apiUrl = '../../fcs-levy-contracts';

  constructor(private http: HttpClient) { }

  getStatus(): Observable<boolean> {
    return this.http.get<boolean>(`${this.apiUrl}/webjobstatus`);
  }

  enableWebJob(): Observable<any> {
    return this.http.post(`${this.apiUrl}/enablewebjob`, {});
  }

  disableWebJob(): Observable<any> {
    return this.http.post(`${this.apiUrl}/disablewebjob`, {});
  }
  
  getIsAuthorized() {
    console.log("Getting is-authorized");
  return this.http.get(`../../dasevents/is-authorized`);
}
}