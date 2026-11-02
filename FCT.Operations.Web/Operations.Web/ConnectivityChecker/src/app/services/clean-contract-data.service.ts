import { Injectable } from "@angular/core";
import { HttpClient } from "@angular/common/http";
import { Observable } from "rxjs";

@Injectable({
    providedIn: 'root'
})

export class CleanContractDataService {
    private apiUrl = '../../contractcleanup';

    constructor(private http: HttpClient) { }

    cleanContractData(fundingIDs: string[]): Observable<any> {
        return this.http.post(this.apiUrl + '/cfsdata', fundingIDs);
    }
}