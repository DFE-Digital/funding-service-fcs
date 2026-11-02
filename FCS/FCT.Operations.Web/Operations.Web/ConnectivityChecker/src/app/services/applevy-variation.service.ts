import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable } from 'rxjs';
import { catchError } from 'rxjs/operators';
import { ProviderCollection } from '../apprenticeship-levy/Model/ProviderCollection';
import { ErrorHandlingService } from '../error-handlers/error-handling-service.service';

@Injectable({
  providedIn: 'root'
})
export class ApplevyVariationService {
  private header = new HttpHeaders({ 'content-type': 'application/json' });

  constructor(private http: HttpClient, private errorHandlingService: ErrorHandlingService) { }

  triggerVariation(items: ProviderCollection[]): Observable<any> {
    return this.http.post(`../../applevy-variation/createapplevyvariation/`, items, { headers: this.header })
      .pipe(
        catchError(this.errorHandlingService.handleError)
      );
  }

  getFiles(containerName: string): Observable<any> {
    return this.http.get(`../../applevy-variation/GetFiles/` + containerName)
      .pipe(
        catchError(this.errorHandlingService.handleError)
      );
  }

  
 getLatestContractInformationByFundingTypeAndFundingPeriod(fundingType: string, fundingPeriod: string): Observable<any> {
      return this.http.get(`../../applevy-variation/GetLatestContractInformationByFundingTypeAndFundingPeriod/${fundingType}/${fundingPeriod}`)
        .pipe(
          catchError(this.errorHandlingService.handleError)
        );
    }
  
}

