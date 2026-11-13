import { __decorate, __metadata } from "tslib";
import { Component } from '@angular/core';
import { CleanContractDataService } from '../services/clean-contract-data.service';
let CleanContractDataComponent = class CleanContractDataComponent {
    constructor(cleanContractDataService) {
        this.cleanContractDataService = cleanContractDataService;
        this.fundingID = '';
        this.processedFundingIDs = [];
        this.statusMessage = '';
        this.statusClass = '';
    }
    prepareFundingIDList() {
        this.processedFundingIDs = this.fundingID
            .split(/[\n,]+/)
            .map(fID => fID.trim())
            .filter(fID => fID.length > 0);
        const confirmation = window.confirm(`
      Are you sure you want to submit?
      Funding IDs:\n\n${this.processedFundingIDs.join(', ')}
    `);
        if (confirmation) {
            this.submitFundingIDList();
        }
    }
    submitFundingIDList() {
        this.cleanContractDataService.cleanContractData(this.processedFundingIDs).subscribe({
            next: (apiResponse) => {
                this.statusMessage = 'Funding ID List submitted successfully. ' + apiResponse;
                this.statusClass = 'Success';
                this.fundingID = '';
                this.processedFundingIDs = [];
            },
            error: (apiResponse) => {
                this.statusMessage = 'Failed to submit Funding ID List. ' + apiResponse;
                this.statusClass = 'Error';
            }
        });
    }
};
CleanContractDataComponent = __decorate([
    Component({
        selector: 'app-clean-contract-data',
        templateUrl: './clean-contract-data.component.html',
        styleUrl: './clean-contract-data.component.css',
        standalone: false
    }),
    __metadata("design:paramtypes", [CleanContractDataService])
], CleanContractDataComponent);
export { CleanContractDataComponent };
//# sourceMappingURL=clean-contract-data.component.js.map