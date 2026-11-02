import { Component, OnInit } from '@angular/core';
import { FormGroup, FormControl, FormBuilder, Validators } from '@angular/forms';
import { ConnectivityCheckService } from './services/connectivity-check-service';
import { NotificationsService } from './services/notifications-service';
import { CheckResult } from './check.result';
import { OverallResult } from './overall.result';
import { timer, Observable } from 'rxjs';
import 'rxjs/add/operator/switchMap';

class Notification {
    
    constructor(
        public NotificationName: string,
        public Description: string,
        public NotificationType: string) { }

    public isError() : boolean {
        let errorAlertTypes: Array<string> = ["Fatal", "Error"];
        
        return errorAlertTypes.includes(this.NotificationType);
    }
}

@Component({
    selector: 'connectivity-page',
    templateUrl: './connectivity.component.html',
    providers: [ConnectivityCheckService]
})
export class ConnectivityComponent implements OnInit {
    
    public checkResults: Array<CheckResult>;
    public notifications : Array<Notification>;
    public dateLastRefreshed: Date;

    constructor(private connectivityCheckService: ConnectivityCheckService, private notificationsService: NotificationsService) { }
         
    ngOnInit() {
        console.log("connectivity component");

        this.checkConnectivity();

        this.checkNotifications();
    }

    private checkNotifications() {
        this.pollService(this.getNotifications.bind(this)).subscribe((notifications : Notification[]) => {
            this.notifications = notifications.map(n => {
                return new Notification(n.NotificationName, n.Description, n.NotificationType);
            });
        });
    }

    private checkConnectivity() {
        this.pollService(this.getConnectivityCheckNames.bind(this)).subscribe((checkNames: string[]) => {
            this.checkResults = checkNames.map(n => {
                return new CheckResult(n, null, null, null);
            });

             this.checkResults.forEach(initialCheckResult => {
                this.connectivityCheckService.getCheckServiceResult(initialCheckResult.ServiceName).subscribe((checkResult: CheckResult) => {
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

    private pollService(methodToPoll: any): Observable<object> {
        const waitTimeFiveMins = 300000; // this is milliseconds
     
        const initialDelay = 0; // do not delay before making the first check
        return timer(initialDelay, waitTimeFiveMins)
            .switchMap(() => methodToPoll()          
            );
    }

    private getConnectivityCheckNames() : Observable<object>{
        return this.connectivityCheckService.getCheckServiceNames();
    }

    private getNotifications() : Observable<object>{
        return this.notificationsService.getNotifications();
    }
}