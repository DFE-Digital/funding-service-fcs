import { Component, OnInit } from '@angular/core';
import { OrganisationService } from '../services/organisation-service';
import { ProviderAgreementService } from '../services/provider-agreemement-service';
import { Subject, timer } from 'rxjs';
import { Observable } from 'rxjs/Observable';
import { distinctUntilChanged, debounceTime, switchMap } from 'rxjs/operators';

class OrganisationInfo {

  constructor(
    public Ukprn: string,
    public TradingName: string) { }
}

class EngagementEventInfo {
  constructor(
    public EventId: string,
    public ProviderId: string,
    public CreatedDate: string,
    public ProcessingState: string,
    public ContractNumber: string) { }
}

@Component({
  selector: 'app-provider-agreement',
  templateUrl: './provider-agreement.component.html',
  styleUrls: ['./provider-agreement.component.css']
})
export class ProviderAgreementComponent implements OnInit {

  public txtUkprn: string; // bind this to input with ngModel
  public txtUkprnChanged: Subject<string> = new Subject<string>();
  public tradingName: String = null;
  public ukprnIsBad: boolean;
  public isCreated: boolean = false;
  public EngagementEventInfos: Array<EngagementEventInfo>;
  public loading : boolean = false;
  public dateLastRefreshed: Date;
  public isAuthorized : boolean = false;

  constructor(
    private organisationService: OrganisationService,
    private providerAgreementService: ProviderAgreementService
  ) {
    try {
      this.txtUkprnChanged
        .pipe(debounceTime(1000), // wait 1 sec after the last event before emitting last event
        distinctUntilChanged()) // only emit if value is different from previous value
        .subscribe(model => {
          this.txtUkprn = model;
          this.tradingName = null;
          // Call your function which calls API or do anything you would like do after a lag of 1 sec
          this.organisationService.getOrg(this.txtUkprn)
            .subscribe((org: OrganisationInfo) => {
              this.tradingName = org.TradingName
            });
        });  
    } catch (e) {
      console.log("error caught" + e);
      }

  }

  ngOnInit() {
    this.StartPolling();    
    this.providerAgreementService.getIsAuthorized().subscribe((authorized: boolean) => {
      this.isAuthorized = authorized;
    });    
  }

  onUkprnChange(ukprn: string) {
    this.txtUkprnChanged.next(ukprn);
  }

  addAgreement(ukprn: string) {
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
  
  StartPolling(){
    console.log("StartPolling started");
    this.loading = true;
    this.pollService(this.getEventRows()).subscribe((engagementEventInfos: EngagementEventInfo[]) => {
        this.EngagementEventInfos = engagementEventInfos;
        this.loading = false;
        this.dateLastRefreshed = new Date();
    }); 
  }

  getEngagementEventRows(){
    console.log("getEngagementEventRows started");
    this.loading = true;
    this.providerAgreementService.getEngagementEventRows().subscribe((engagementEventInfos: EngagementEventInfo[]) => {
        this.EngagementEventInfos = engagementEventInfos;
        this.loading = false;
        this.dateLastRefreshed = new Date();
    }); 
  }

  private getEventRows() : Observable<object>{
    return this.providerAgreementService.getEngagementEventRows();
  } 

  private pollService(methodToPoll: Observable<any>): Observable<object> {
    const waitTimeThirtySeconds = 30000; // this is milliseconds
    const initialDelay = 0; // do not delay before making the first check

    return timer(initialDelay, waitTimeThirtySeconds)
    .pipe(switchMap(() => methodToPoll));
  }
}