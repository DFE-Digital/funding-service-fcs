import { Injectable } from '@angular/core';
import { HttpRequest, HttpHandler, HttpEvent, HttpInterceptor } from '@angular/common/http';
import {SessionService} from '../services/session-service';
import { Observable } from 'rxjs/Observable';
import { Inject, Injector } from '@angular/core';

@Injectable()
export class SessionInterceptor implements HttpInterceptor {
  private sessionService : SessionService;
  private injector: Injector;
  constructor(injector: Injector) {
    this.injector = injector;
  }
  
  intercept(request: HttpRequest<any>, next: HttpHandler): Observable<HttpEvent<any>> {
    this.sessionService = this.injector.get(SessionService);
    request = request.clone({
      setHeaders: {
        Authorization: `session-token ${this.sessionService.getSessionId()}`
      }
    });
    return next.handle(request);
  }
}