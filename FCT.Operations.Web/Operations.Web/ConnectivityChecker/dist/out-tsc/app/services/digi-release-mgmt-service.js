import { __decorate, __metadata } from "tslib";
import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { catchError } from 'rxjs/operators';
let DigiReleaseMgmtService = class DigiReleaseMgmtService {
    constructor(http) {
        this.http = http;
        this.apiUrl = '../../config-dig-release-management';
    }
    createRelease(release) {
        return this.http.post(this.apiUrl + '/createRelease', release).pipe(catchError(error => {
            console.error('Error creating release:', error); // Log error
            throw error;
        }));
    }
    getReleases() {
        return this.http.get(this.apiUrl).pipe(catchError(error => {
            console.error('Error fetching releases:', error); // Log error
            throw error;
        }));
    }
    updateRelease(id, release) {
        return this.http.put(`${this.apiUrl}/updateRelease/${id}`, release).pipe(catchError(error => {
            console.error('Error updating release:', error); // Log error
            throw error;
        }));
    }
    getNextReleaseID() {
        return this.http.get(this.apiUrl + '/nextVersion').pipe(catchError(error => {
            console.error('Error getting fileurl:', error); // Log error
            throw error;
        }));
    }
    deployRelease(id) {
        return this.http.post(`${this.apiUrl}/deployRelease/${id}`, {}).pipe(catchError(error => {
            console.error('Error updating release:', error); // Log error
            throw error;
        }));
    }
};
DigiReleaseMgmtService = __decorate([
    Injectable({
        providedIn: 'root'
    }),
    __metadata("design:paramtypes", [HttpClient])
], DigiReleaseMgmtService);
export { DigiReleaseMgmtService };
//# sourceMappingURL=digi-release-mgmt-service.js.map