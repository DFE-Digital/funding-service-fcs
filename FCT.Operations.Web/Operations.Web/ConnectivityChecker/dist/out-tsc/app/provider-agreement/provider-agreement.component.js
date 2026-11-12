import { __decorate, __metadata } from "tslib";
import { Component } from '@angular/core';
import { OrganisationService } from '../services/organisation-service';
import { ProviderAgreementService } from '../services/provider-agreemement-service';
import { Subject, timer } from 'rxjs';
import { distinctUntilChanged, debounceTime, switchMap } from 'rxjs/operators';
class OrganisationInfo {
    constructor(Ukprn, TradingName) {
        this.Ukprn = Ukprn;
        this.TradingName = TradingName;
    }
}
class EngagementEventInfo {
    constructor(EventId, ProviderId, CreatedDate, ProcessingState, ContractNumber) {
        this.EventId = EventId;
        this.ProviderId = ProviderId;
        this.CreatedDate = CreatedDate;
        this.ProcessingState = ProcessingState;
        this.ContractNumber = ContractNumber;
    }
}
let ProviderAgreementComponent = class ProviderAgreementComponent {
    constructor(organisationService, providerAgreementService) {
        this.organisationService = organisationService;
        this.providerAgreementService = providerAgreementService;
        this.txtUkprnChanged = new Subject();
        this.tradingName = null;
        this.isCreated = false;
        this.loading = false;
        this.isAuthorized = false;
        try {
            this.txtUkprnChanged
                .pipe(debounceTime(1000), // wait 1 sec after the last event before emitting last event
            distinctUntilChanged()) // only emit if value is different from previous value
                .subscribe(model => {
                this.txtUkprn = model;
                this.tradingName = null;
                // Call your function which calls API or do anything you would like do after a lag of 1 sec
                this.organisationService.getOrg(this.txtUkprn)
                    .subscribe((org) => {
                    this.tradingName = org.TradingName;
                });
            });
        }
        catch (e) {
            console.log("error caught" + e);
        }
    }
    ngOnInit() {
        this.StartPolling();
        this.providerAgreementService.getIsAuthorized().subscribe((authorized) => {
            this.isAuthorized = authorized;
        });
    }
    onUkprnChange(ukprn) {
        this.txtUkprnChanged.next(ukprn);
    }
    addAgreement(ukprn) {
        this.providerAgreementService.add(ukprn).subscribe((val) => {
            this.isCreated = true;
            setTimeout(() => {
                this.isCreated = false,
                    this.tradingName = null;
                this.txtUkprn = null;
            }, 2500);
            this.getEngagementEventRows();
        });
    }
    StartPolling() {
        console.log("StartPolling started");
        this.loading = true;
        this.pollService(this.getEventRows()).subscribe((engagementEventInfos) => {
            this.EngagementEventInfos = engagementEventInfos;
            this.loading = false;
            this.dateLastRefreshed = new Date();
        });
    }
    getEngagementEventRows() {
        console.log("getEngagementEventRows started");
        this.loading = true;
        this.providerAgreementService.getEngagementEventRows().subscribe((engagementEventInfos) => {
            this.EngagementEventInfos = engagementEventInfos;
            this.loading = false;
            this.dateLastRefreshed = new Date();
        });
    }
    getEventRows() {
        return this.providerAgreementService.getEngagementEventRows();
    }
    pollService(methodToPoll) {
        const waitTimeThirtySeconds = 30000; // this is milliseconds
        const initialDelay = 0; // do not delay before making the first check
        return timer(initialDelay, waitTimeThirtySeconds)
            .pipe(switchMap(() => methodToPoll));
    }
};
ProviderAgreementComponent = __decorate([
    Component({
        selector: 'app-provider-agreement',
        templateUrl: './provider-agreement.component.html',
        styleUrls: ['./provider-agreement.component.css']
    }),
    __metadata("design:paramtypes", [OrganisationService,
        ProviderAgreementService])
], ProviderAgreementComponent);
export { ProviderAgreementComponent };
//# sourceMappingURL=provider-agreement.component.js.map