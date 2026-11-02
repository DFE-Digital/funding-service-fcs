import { Injectable } from '@angular/core';
import { HttpClient, HttpRequest, HttpEvent } from '@angular/common/http';
import { Observable } from 'rxjs';
import { catchError } from 'rxjs/operators';
import { environment } from '../../environments/environment';
import { ErrorHandlingService } from '../error-handlers/error-handling-service.service';

@Injectable({
  providedIn: 'root'
})
export class FileUploadService {
  
  constructor(private http: HttpClient, private errorHandlingService: ErrorHandlingService) {}

  upload(file: File, containerName: string): Observable<HttpEvent<any>> {
    const formData: FormData = new FormData();
    formData.append('file', file);  
    formData.append('containerName', containerName);

    const req = new HttpRequest('POST', `../../applevy-variation/UploadDocumentFun`, formData, {
      responseType: 'json'
    });

    return this.http.request(req).pipe(
      catchError(this.errorHandlingService.handleError)
    );
  }
}