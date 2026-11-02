import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { catchError } from 'rxjs/operators';

@Injectable({
  providedIn: 'root'
})
export class ReleaseService {

  private apiUrl = '../../applevy-variation';

  constructor(private http: HttpClient) { }

  createRelease(release: any): Observable<any> {
    return this.http.post<any>(this.apiUrl+'/createRelease', release).pipe(
      catchError(error => {
        console.error('Error creating release:', error); // Log error
        throw error;
      })
    );
  }

  getReleases(): Observable<any> {
    return this.http.get<any>(this.apiUrl+'/getReleases').pipe(
      catchError(error => {
        console.error('Error fetching releases:', error); // Log error
        throw error;
      })
    );
  }

  getFileContent(fileUrl: string): Observable<any> {
    return this.http.get(fileUrl, { responseType: 'arraybuffer' }).pipe(
      catchError(error => {
        console.error('Error getting fileurl:', error); // Log error
        throw error;
      })
    );
  }
  
}



