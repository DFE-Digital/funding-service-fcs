import { Component, OnInit } from '@angular/core';
import { IntegrityCheckService } from '../services/integrity-check-service';
import { SessionService } from '../services/session-service';
import { HttpResponse } from '@angular/common/http';

class IntegrityCheck {
    
    constructor(
        public Name: string,
        public Description: string,        
        ) { }
  }

  class Notification {
    
    constructor(
        public NotificationName: string,
        public IsError: boolean) { }

    public isError() : boolean {
       return this.IsError;
    }
}

@Component({
    selector: 'app-integrity-check',
    templateUrl: './integrity-checks.component.html',
    styleUrls: ['./integrity-checks.component.css']
  })
  export class IntegrityCheckComponent implements OnInit {
      private defaultChk = "Not Set";
      private allChk = "Not Set";
      public notifications : Array<Notification> = new Array<Notification>();

      public integrityChecks : Array<IntegrityCheck> = [
        new IntegrityCheck(this.defaultChk, ""),
        new IntegrityCheck(this.allChk, "ALL (without deliverable payment)"),
        new IntegrityCheck("PAAS_TO_CRM_CHECK_DELIVERABLE_PAYMENT", "PAAS_TO_CRM_CHECK_DELIVERABLE_PAYMENT"),
        // new IntegrityCheck("PAAS_TO_CRM_CHECK_DELIVERABLE_PAYMENT_FULL", "PAAS_TO_CRM_CHECK_DELIVERABLE_PAYMENT_FULL"),
        new IntegrityCheck("ALLOC_LEVEL_ACTUALS_SUMACTUAL_TO_DELIVPAYT_ACTUALS", "ALLOC_LEVEL_ACTUALS_SUMACTUAL_TO_DELIVPAYT_ACTUALS"),        
        new IntegrityCheck("ANITA_PAAS_EXTRACT", "ANITA_PAAS_EXTRACT"),
        new IntegrityCheck("CRM_TO_PAAS_CHECK_SUBNOMINAL_AGGREGATION", "CRM_TO_PAAS_CHECK_SUBNOMINAL_AGGREGATION"),
        new IntegrityCheck("PAAS_TO_CRM_CHECK_SUBNOMINAL_AGGREGATION", "PAAS_TO_CRM_CHECK_SUBNOMINAL_AGGREGATION"),
        new IntegrityCheck("PAYCALC_VS_PAYGEN_CHECK", "PAYCALC_VS_PAYGEN_CHECK"),
        new IntegrityCheck("PAYMENT_INSTRUCTIONS_SUMACTUAL_TO_DELIV_PAYMENTS", "PAYMENT_INSTRUCTIONS_SUMACTUAL_TO_DELIV_PAYMENTS"),      
        /*new IntegrityCheck("PAYMENT_INSTRUCTIONS_SUMACTUAL_TO_DELIV_PAYMENTS_FORCE", "PAYMENT_INSTRUCTIONS_SUMACTUAL_TO_DELIV_PAYMENTS_FORCE"),
        new IntegrityCheck("PERIOD_LEVEL_ACTUALS_SUMACTUAL_TO_DELIVPAYT_ACTUAL", "PERIOD_LEVEL_ACTUALS_SUMACTUAL_TO_DELIVPAYT_ACTUAL"),*/
        new IntegrityCheck("DELIVERABLE_PAYMENT_POSITIVE_CAP_CHECKER", "DELIVERABLE_PAYMENT_POSITIVE_CAP_CHECKER")
    ];
    
    private selectedIntegrityCheckName : string = null;

    ngOnInit() {
        console.log("IntegrityCheckComponent");
      }

    constructor(private integrityCheckService: IntegrityCheckService, private sessionService: SessionService) { }

    onStartIntegrityCheck(){
        this.AddNotification("Waiting for Integrity Check to start", false);
        if (this.selectedIntegrityCheckName == this.allChk){
            this.integrityCheckService.startAllIntegrityChecks()
            .subscribe(() => this.goodResponse(),
            (res) => this.errorResponse(res));
        }
        else{
            this.integrityCheckService.startIntegrityCheck(this.selectedIntegrityCheckName).subscribe(() => this.goodResponse(),
            (res) => this.errorResponse(res) );
        }
        this.selectedIntegrityCheckName = null;
    }

    onIntegrityCheckChange(name: any){
        this.selectedIntegrityCheckName = name;
        console.log("change - " + name);
    }

    isValid(){
        return this.selectedIntegrityCheckName != null;
    }

    isLoggedIn(){
        return this.sessionService.isLoggedIn();
    }

    private goodResponse(){
        console.log("good");
        this.AddNotification("Integrity Check Started", false);
    }

    private errorResponse(res: any){
        if(res.status == 202) {
            this.AddNotification("Integrity Check Started", false);
        }
        else if (res.status == 401){
            this.AddNotification("Please login", true);
        }
        setTimeout(function() {
            this.ClearNotifications();
            this.selectedIntegrityCheckName = null;
        }.bind(this), 10000);
    }

    private AddNotification(name: string, isError: boolean){
        this.ClearNotifications();
        this.notifications.push(new Notification(name, isError));
    }

    private ClearNotifications(){
        this.notifications = new Array<Notification>();
    }
  }  