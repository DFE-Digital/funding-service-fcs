import { __decorate, __metadata } from "tslib";
import { Component } from '@angular/core';
import { ParkedFundingAllocationsService } from '../services/parked-funding-allocations-service';
class ParkedFundingAllocationsDetail {
}
let ParkedFundingAllocationsComponent = class ParkedFundingAllocationsComponent {
    constructor(parkedFundingAllocationsService) {
        this.parkedFundingAllocationsService = parkedFundingAllocationsService;
        this.loading = false;
    }
    ngOnInit() {
        console.log("parked-funding-allocations component");
        this.loading = true;
        this.parkedFundingAllocationsService.getParkedFundingAllocationDetails().subscribe((detail) => {
            this.Detail = detail;
            this.loading = false;
        });
    }
};
ParkedFundingAllocationsComponent = __decorate([
    Component({
        selector: 'parked-funding-allocations',
        templateUrl: './parked-funding-allocations.html',
        styleUrls: ['./parked-funding-allocations.css']
    }),
    __metadata("design:paramtypes", [ParkedFundingAllocationsService])
], ParkedFundingAllocationsComponent);
export { ParkedFundingAllocationsComponent };
//# sourceMappingURL=parked-funding-allocations.component.js.map