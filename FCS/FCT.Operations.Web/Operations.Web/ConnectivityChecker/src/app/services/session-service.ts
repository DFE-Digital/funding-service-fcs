import { Injectable } from '@angular/core';
import { HttpClient } from "@angular/common/http";
import 'rxjs/add/operator/map';
import 'rxjs/Rx';
import {Observable} from 'rxjs';


@Injectable()
export class SessionService {
  private sessionKey: string = 'session_key';
  private sessionId: string = "";
  constructor (
    private http: HttpClient 
  ) {
  }

  login(authenticationToken: string) : Observable<any>  {
      let body = JSON.stringify({ 'foo': authenticationToken });
      let headers = new Headers({ 'Accept': 'application/json' });
     // let options = new RequestOptions({ headers: headers });

      return this.http.post('../../session', authenticationToken); // ...and calling .json() on the response to return data
      //.catch((error:any) => Observable.throw(error.json().error || 'Server error')); //...errors if any;
    //.map((res:Response) => res.json());
  }

  addSessionId(sessionId : string){
    localStorage.setItem(this.sessionKey, sessionId)
  }

  getSessionId() :string{
    return localStorage.getItem(this.sessionKey)
  }

  isLoggedIn(): boolean{
    return localStorage.getItem(this.sessionKey) != null;
  }
}