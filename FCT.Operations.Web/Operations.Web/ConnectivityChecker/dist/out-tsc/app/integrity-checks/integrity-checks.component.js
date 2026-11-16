import { __decorate, __metadata } from "tslib";
import { Component } from '@angular/core';
import { IntegrityCheckService } from '../services/integrity-check-service';
import { SessionService } from '../services/session-service';
class IntegrityCheck {
    constructor(Name, Description) {
        this.Name = Name;
        this.Description = Description;
    }
}
class Notification {
    constructor(NotificationName, IsError) {
        this.NotificationName = NotificationName;
        this.IsError = IsError;
    }
    isError() {
        return this.IsError;
    }
}
let IntegrityCheckComponent = class IntegrityCheckComponent {
    constructor(integrityCheckService, sessionService) {
        this.integrityCheckService = integrityCheckService;
        this.sessionService = sessionService;
        this.defaultChk = "Not Set";
        this.allChk = "Not Set";
        this.notifications = new Array();
        this.integrityChecks = [
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
        this.selectedIntegrityCheckName = null;
    }
    ngOnInit() {
        console.log("IntegrityCheckComponent");
    }
    onStartIntegrityCheck() {
        this.AddNotification("Waiting for Integrity Check to start", false);
        if (this.selectedIntegrityCheckName == this.allChk) {
            this.integrityCheckService.startAllIntegrityChecks()
                .subscribe(() => this.goodResponse(), (res) => this.errorResponse(res));
        }
        else {
            this.integrityCheckService.startIntegrityCheck(this.selectedIntegrityCheckName).subscribe(() => this.goodResponse(), (res) => this.errorResponse(res));
        }
        this.selectedIntegrityCheckName = null;
    }
    onIntegrityCheckChange(name) {
        this.selectedIntegrityCheckName = name;
        console.log("change - " + name);
    }
    isValid() {
        return this.selectedIntegrityCheckName != null;
    }
    isLoggedIn() {
        return this.sessionService.isLoggedIn();
    }
    goodResponse() {
        console.log("good");
        this.AddNotification("Integrity Check Started", false);
    }
    errorResponse(res) {
        if (res.status == 202) {
            this.AddNotification("Integrity Check Started", false);
        }
        else if (res.status == 401) {
            this.AddNotification("Please login", true);
        }
        setTimeout(function () {
            this.ClearNotifications();
            this.selectedIntegrityCheckName = null;
        }.bind(this), 10000);
    }
    AddNotification(name, isError) {
        this.ClearNotifications();
        this.notifications.push(new Notification(name, isError));
    }
    ClearNotifications() {
        this.notifications = new Array();
    }
};
IntegrityCheckComponent = __decorate([
    Component({
        selector: 'app-integrity-check',
        templateUrl: './integrity-checks.component.html',
        styleUrls: ['./integrity-checks.component.css']
    }),
    __metadata("design:paramtypes", [IntegrityCheckService, SessionService])
], IntegrityCheckComponent);
export { IntegrityCheckComponent };
//# sourceMappingURL=integrity-checks.component.js.map