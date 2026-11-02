import { Component } from '@angular/core';
import { CleanContractDataService } from '../services/clean-contract-data.service';

@Component({
    selector: 'app-clean-contract-data',
    templateUrl: './clean-contract-data.component.html',
    styleUrl: './clean-contract-data.component.css',
    standalone: false
})
export class CleanContractDataComponent {
  fundingID: string = '';
  processedFundingIDs: string[] = [];
  statusMessage: string = '';
  statusClass: string = '';

  constructor(private cleanContractDataService: CleanContractDataService) { }

  prepareFundingIDList() {
    this.processedFundingIDs = this.fundingID
      .split(/[\n,]+/)
      .map(fID => fID.trim())
      .filter(fID => fID.length > 0);

    const confirmation = window.confirm(`
      Are you sure you want to submit?
      Funding IDs:\n\n${this.processedFundingIDs.join(', ')}
    `);

    if(confirmation){
      this.submitFundingIDList();
    }
  }

  submitFundingIDList() {
    this.cleanContractDataService.cleanContractData(this.processedFundingIDs).subscribe({
      next: (apiResponse: string) => {
        this.statusMessage = 'Funding ID List submitted successfully. ' + apiResponse;
        this.statusClass = 'Success';

        this.fundingID = '';
        this.processedFundingIDs = [];
      },
      error: (apiResponse: string) => {
        this.statusMessage = 'Failed to submit Funding ID List. '  + apiResponse; 
        this.statusClass = 'Error';
      }
    });
  }
}
