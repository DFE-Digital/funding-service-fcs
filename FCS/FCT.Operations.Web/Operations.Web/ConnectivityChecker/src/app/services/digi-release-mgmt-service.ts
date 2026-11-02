import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { catchError } from 'rxjs/operators';

@Injectable({
  providedIn: 'root'
})
export class DigiReleaseMgmtService {

  private apiUrl = '../../config-dig-release-management';

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
    return this.http.get<any>(this.apiUrl).pipe(
      catchError(error => {
        console.error('Error fetching releases:', error); // Log error
        throw error;
      })
    );
  }

  updateRelease(id: number, release:any): Observable<any>{
    return this.http.put(`${this.apiUrl}/updateRelease/${id}`, release).pipe(
      catchError(error => {
        console.error('Error updating release:', error); // Log error
        throw error;
      })
    );
  }

  getNextReleaseID(): Observable<number>{
    return this.http.get<number>(this.apiUrl+'/nextVersion').pipe(
      catchError(error => {
        console.error('Error getting fileurl:', error); // Log error
        throw error;
      })
    );
  }

  deployRelease(id:number): Observable<any>{
    return this.http.post(`${this.apiUrl}/deployRelease/${id}`,{}).pipe(
      catchError(error => {
        console.error('Error updating release:', error); // Log error
        throw error;
      })
    );
  }
}



