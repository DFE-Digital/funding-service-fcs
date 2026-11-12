import { __decorate, __metadata } from "tslib";
import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { catchError } from 'rxjs/operators';
let ReleaseService = class ReleaseService {
    constructor(http) {
        this.http = http;
        this.apiUrl = '../../applevy-variation';
    }
    createRelease(release) {
        return this.http.post(this.apiUrl + '/createRelease', release).pipe(catchError(error => {
            console.error('Error creating release:', error); // Log error
            throw error;
        }));
    }
    getReleases() {
        return this.http.get(this.apiUrl + '/getReleases').pipe(catchError(error => {
            console.error('Error fetching releases:', error); // Log error
            throw error;
        }));
    }
    getFileContent(fileUrl) {
        return this.http.get(fileUrl, { responseType: 'arraybuffer' }).pipe(catchError(error => {
            console.error('Error getting fileurl:', error); // Log error
            throw error;
        }));
    }
};
ReleaseService = __decorate([
    Injectable({
        providedIn: 'root'
    }),
    __metadata("design:paramtypes", [HttpClient])
], ReleaseService);
export { ReleaseService };
//# sourceMappingURL=release-service.js.map