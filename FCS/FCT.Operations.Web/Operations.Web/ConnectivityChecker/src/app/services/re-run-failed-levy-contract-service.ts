import {Injectable} from '@angular/core';
import { HttpClient, HttpHeaders, HttpResponse } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({ providedIn: 'root' })
export class ReRunFailedLevyContractService {
  private header = new HttpHeaders({ 'content-type': 'application/json' });
  constructor(private http: HttpClient) {}
  ngOnInit() { }

  getFailedQueueCollections() {
    console.log("getting failed queue collections");
    return this.http.get(`../../replayFailedMessage/fetchmessagesfromqueue/`);
  }

  rerunFailedQueueCollections(items: object):Observable<any>  {    
    
    console.log("getting failed queue collections");

    //return this.http.get(`../../replayFailedMessage/rerunselectedfailedmessages/`,data);
    console.log("result count : ",items);
    return this.http.post(`../../replayFailedMessage/rerunselectedfailedmessages/`,JSON.stringify(items),{ headers: this.header });
  } 
}

