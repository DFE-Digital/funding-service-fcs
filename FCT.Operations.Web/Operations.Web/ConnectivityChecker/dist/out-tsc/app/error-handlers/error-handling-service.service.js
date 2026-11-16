import { __decorate, __metadata } from "tslib";
import { Injectable } from '@angular/core';
import { throwError } from 'rxjs';
let ErrorHandlingService = class ErrorHandlingService {
    constructor() { }
    handleError(error) {
        let errorMessage = 'An unknown error occurred!';
        if (error.error instanceof ErrorEvent) {
            // Client-side or network error
            errorMessage = `Client-side error: ${error.error.message}`;
        }
        else {
            // Backend error
            errorMessage = `Server-side error: Error Code: ${error.status}\nMessage: ${error.message}`;
        }
        console.error(errorMessage);
        return throwError(errorMessage);
    }
    handleClientError(error) {
        console.error('Client-side error:', error);
        // Display user-friendly error message
        //alert('An unexpected error occurred. Please try again.');
    }
};
ErrorHandlingService = __decorate([
    Injectable({
        providedIn: 'root'
    }),
    __metadata("design:paramtypes", [])
], ErrorHandlingService);
export { ErrorHandlingService };
//# sourceMappingURL=error-handling-service.service.js.map