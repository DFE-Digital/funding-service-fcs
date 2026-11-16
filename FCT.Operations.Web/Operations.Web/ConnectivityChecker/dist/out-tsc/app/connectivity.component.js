import { __decorate, __metadata } from "tslib";
import { Component } from '@angular/core';
import { ConnectivityCheckService } from './services/connectivity-check-service';
import { NotificationsService } from './services/notifications-service';
import { CheckResult } from './check.result';
import { timer } from 'rxjs';
import 'rxjs/add/operator/switchMap';
class Notification {
    constructor(NotificationName, Description, NotificationType) {
        this.NotificationName = NotificationName;
        this.Description = Description;
        this.NotificationType = NotificationType;
    }
    isError() {
        let errorAlertTypes = ["Fatal", "Error"];
        return errorAlertTypes.includes(this.NotificationType);
    }
}
let ConnectivityComponent = class ConnectivityComponent {
    constructor(connectivityCheckService, notificationsService) {
        this.connectivityCheckService = connectivityCheckService;
        this.notificationsService = notificationsService;
    }
    ngOnInit() {
        console.log("connectivity component");
        this.checkConnectivity();
        this.checkNotifications();
    }
    checkNotifications() {
        this.pollService(this.getNotifications.bind(this)).subscribe((notifications) => {
            this.notifications = notifications.map(n => {
                return new Notification(n.NotificationName, n.Description, n.NotificationType);
            });
        });
    }
    checkConnectivity() {
        this.pollService(this.getConnectivityCheckNames.bind(this)).subscribe((checkNames) => {
            this.checkResults = checkNames.map(n => {
                return new CheckResult(n, null, null, null);
            });
            this.checkResults.forEach(initialCheckResult => {
                this.connectivityCheckService.getCheckServiceResult(initialCheckResult.ServiceName).subscribe((checkResult) => {
                    initialCheckResult.Details = checkResult.Details;
                    initialCheckResult.IsAvailable = checkResult.IsAvailable;
                    initialCheckResult.ServiceName = checkResult.ServiceName;
                    initialCheckResult.SupplementaryInfo = checkResult.SupplementaryInfo;
                    initialCheckResult.DataIsFresh();
                });
            });
            this.dateLastRefreshed = new Date();
        });
    }
    pollService(methodToPoll) {
        const waitTimeFiveMins = 300000; // this is milliseconds
        const initialDelay = 0; // do not delay before making the first check
        return timer(initialDelay, waitTimeFiveMins)
            .switchMap(() => methodToPoll());
    }
    getConnectivityCheckNames() {
        return this.connectivityCheckService.getCheckServiceNames();
    }
    getNotifications() {
        return this.notificationsService.getNotifications();
    }
};
ConnectivityComponent = __decorate([
    Component({
        selector: 'connectivity-page',
        templateUrl: './connectivity.component.html',
        providers: [ConnectivityCheckService]
    }),
    __metadata("design:paramtypes", [ConnectivityCheckService, NotificationsService])
], ConnectivityComponent);
export { ConnectivityComponent };
//# sourceMappingURL=connectivity.component.js.map