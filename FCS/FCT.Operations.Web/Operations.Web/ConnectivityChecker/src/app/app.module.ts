import { BrowserModule } from '@angular/platform-browser';
import { NgModule, ErrorHandler } from '@angular/core';

import { AppComponent } from './app.component';
import {HttpClientModule} from '@angular/common/http';
import { RouterModule, Routes } from '@angular/router';
import { ConnectivityComponent } from './connectivity.component';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';

import { SessionService } from './services/session-service';
import { ConnectivityCheckService } from './services/connectivity-check-service';
import { NotificationsService } from './services/notifications-service';
import { LevyContractService } from './services/levy-contract-service';
import { IntegrityCheckService } from './services/integrity-check-service';
import { OrganisationService } from './services/organisation-service';
import { ProviderAgreementService } from './services/provider-agreemement-service';
import { ContractAtomFeedService } from './services/contract-atom-feed-service';
import { PaymentBatchFeedService } from './services/payment-batch-feed-service';
import { MonthEndService } from './services/month-end-service';
import { ParkedFundingAllocationsService } from './services/parked-funding-allocations-service';
import { CfsImportService } from './services/cfs-import-service';
import { DownloadIcResultsService } from './services/download-ic-results.service';
import { ReRunFailedLevyContractService } from './services/re-run-failed-levy-contract-service';
import { ApprenticeshipLevyService } from './services/apprenticeship-levy.service';
import { FileUploadService } from './services/file-upload.service';
import { CleanContractDataService } from './services/clean-contract-data.service';
import { DigiReleaseMgmtService } from './services/digi-release-mgmt-service';

import { NgbModule } from '@ng-bootstrap/ng-bootstrap';
import { HTTP_INTERCEPTORS } from '@angular/common/http';
import { SessionInterceptor } from './auth/session-interceptor';
import { LevyAmendmentComponent } from './levy-amendment/levy-amendment.component';
import { IntegrityCheckComponent } from './integrity-checks/integrity-checks.component';
import { ContractAtomFeedComponent } from './contract-atom-feed/contract-atom-feed-component';
import { MonthEndComponent } from './month-end/month-end.component';
import { ProviderAgreementComponent } from './provider-agreement/provider-agreement.component';
import { ParkedFundingAllocationsComponent } from './parked-funding-allocations/parked-funding-allocations.component';
import { CfsImportComponent } from './cfs-import/cfs-import.component';
import { NavBarComponent } from './nav/navbar.component';
import { DownloadIcResultsComponent } from './download-ic-results/download-ic-results.component';
import { AccessabilityPageComponent } from './accessability-page/accessability-page/accessability-page.component';
import { ReRunFailedLevyContractComponent } from './re-run-failed-levy-contract/re-run-failed-levy-contract.component';
import { ApprenticeshipLevyComponent } from './apprenticeship-levy/apprenticeship-levy.component';
import { PaymentBatchFeedComponent } from './payment-batch-feed/payment-batch-feed.component';
import { GlobalErrorHandler } from './error-handlers/GlobalErrorHandler';
import { ReleaseManagementComponent } from './release-management/release-management.component';
import { ReleasePopupComponent } from './release-popup/release-popup.component';
import { CleanContractDataComponent } from './clean-contract-data/clean-contract-data.component';
import { DigitisationReleaseMgmtComponent } from './digitisation-release-mgmt/digitisation-release-mgmt.component'

const appRoutes: Routes = [
  { path: '', redirectTo: 'connectivity', pathMatch: 'full' },
  { path: 'connectivity', component: ConnectivityComponent },
  { path: 'levyAmendment', component: LevyAmendmentComponent },
  { path: 'integrity-checks', component: IntegrityCheckComponent },
  { path: 'contract-atom-feed', component: ContractAtomFeedComponent },
  { path: 'payment-batch-feed', component: PaymentBatchFeedComponent},
  { path: 'month-end', component: MonthEndComponent },
  { path: 'provider-agreement', component: ProviderAgreementComponent },
  { path: 'parked-funding-allocations', component: ParkedFundingAllocationsComponent },
  { path: 'cfs-import', component: CfsImportComponent },
  { path: 'download-ic-results', component: DownloadIcResultsComponent },
  { path: 'accessability-page', component: AccessabilityPageComponent },
  { path: 're-run-failed-levy-contract', component: ReRunFailedLevyContractComponent },
  { path: 'apprenticeship-levy', component: ApprenticeshipLevyComponent },
  { path: 'release-management', component: ReleaseManagementComponent },
  { path: 'clean-contract-data', component: CleanContractDataComponent},
  { path: 'digi-release-management', component: DigitisationReleaseMgmtComponent}
];

@NgModule({
  declarations: [
    AppComponent,
    ConnectivityComponent,
    LevyAmendmentComponent,
    IntegrityCheckComponent,
    ContractAtomFeedComponent,
    MonthEndComponent,
    ProviderAgreementComponent,
    ParkedFundingAllocationsComponent,
    CfsImportComponent,
    NavBarComponent,
    DownloadIcResultsComponent,
    AccessabilityPageComponent,
    ReRunFailedLevyContractComponent,
    ApprenticeshipLevyComponent,
    PaymentBatchFeedComponent,
    ReleaseManagementComponent,
    ReleasePopupComponent,
    CleanContractDataComponent,
    DigitisationReleaseMgmtComponent
  ],
  imports: [
    BrowserModule,
    HttpClientModule,
    FormsModule,
    ReactiveFormsModule,
    RouterModule.forRoot(
      appRoutes,
      { enableTracing: true, useHash: true } // <-- debugging purposes only
    ),
    NgbModule,
  ],
  providers: [SessionService, ConnectivityCheckService, NotificationsService, LevyContractService, IntegrityCheckService, OrganisationService, ProviderAgreementService, ContractAtomFeedService, PaymentBatchFeedService, CleanContractDataService, MonthEndService, ParkedFundingAllocationsService, CfsImportService,DownloadIcResultsService, ReRunFailedLevyContractService,FileUploadService, DigiReleaseMgmtService,
    {
      provide: HTTP_INTERCEPTORS,
      useClass: SessionInterceptor,
      multi: true
    },
    {
      provide: ErrorHandler,
      useClass: GlobalErrorHandler
    }
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }