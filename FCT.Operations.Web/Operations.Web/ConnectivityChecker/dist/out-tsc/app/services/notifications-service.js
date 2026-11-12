import { __decorate, __metadata } from "tslib";
import { Injectable } from '@angular/core';
import 'rxjs/add/operator/map';
import { HttpClient } from "@angular/common/http";
let NotificationsService = class NotificationsService {
    constructor(http) {
        this.http = http;
    }
    getNotifications() {
        console.log("getNotifications");
        return this.http.get(`../../fcs-notifications`);
    }
};
NotificationsService = __decorate([
    Injectable(),
    __metadata("design:paramtypes", [HttpClient])
], NotificationsService);
export { NotificationsService };
//# sourceMappingURL=notifications-service.js.map