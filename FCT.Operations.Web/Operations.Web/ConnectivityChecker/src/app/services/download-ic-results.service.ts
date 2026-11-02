import {Injectable} from '@angular/core';
import { HttpClient, HttpResponse } from '@angular/common/http';


@Injectable({ providedIn: 'root' })
export class DownloadIcResultsService {
  constructor(private http: HttpClient) {}


  getClosedCollections(pageNumber) {
    console.log("getting closed collections");
    return this.http.get(`../../intcheck-download/download-int-collections?pageNumber=` + pageNumber);
  }
  
  
  downloadCSV(documentName): any{		
		return this.http.get('../../intcheck-download/download-document?documentName='+ documentName, {responseType: 'text'});
   }

}
