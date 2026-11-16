import { __decorate, __metadata } from "tslib";
import { Injectable } from '@angular/core';
import { HttpClient, HttpRequest } from '@angular/common/http';
import { catchError } from 'rxjs/operators';
import { ErrorHandlingService } from '../error-handlers/error-handling-service.service';
let FileUploadService = class FileUploadService {
    constructor(http, errorHandlingService) {
        this.http = http;
        this.errorHandlingService = errorHandlingService;
    }
    upload(file, containerName) {
        const formData = new FormData();
        formData.append('file', file);
        formData.append('containerName', containerName);
        const req = new HttpRequest('POST', `../../applevy-variation/UploadDocumentFun`, formData, {
            responseType: 'json'
        });
        return this.http.request(req).pipe(catchError(this.errorHandlingService.handleError));
    }
};
FileUploadService = __decorate([
    Injectable({
        providedIn: 'root'
    }),
    __metadata("design:paramtypes", [HttpClient, ErrorHandlingService])
], FileUploadService);
export { FileUploadService };
//# sourceMappingURL=file-upload.service.js.map