import { __decorate, __metadata } from "tslib";
import { Component } from '@angular/core';
import { MonthEndService } from '../services/month-end-service';
class ClosedCollection {
    constructor(CollectionType, CollectionReturnCode, ClosedTime, TotalRowCount, RetrievedRowCount, CreatedDate) {
        this.CollectionType = CollectionType;
        this.CollectionReturnCode = CollectionReturnCode;
        this.ClosedTime = ClosedTime;
        this.TotalRowCount = TotalRowCount;
        this.RetrievedRowCount = RetrievedRowCount;
        this.CreatedDate = CreatedDate;
    }
}
class ClosedCollectionResult {
    constructor(ClosedCollections, TotalRowsInTable) {
        this.ClosedCollections = ClosedCollections;
        this.TotalRowsInTable = TotalRowsInTable;
    }
}
let MonthEndComponent = class MonthEndComponent {
    constructor(monthEndService) {
        this.monthEndService = monthEndService;
        this.loading = false;
        this.pageNumber = 1;
        this.showFirstPage = false;
        this.showNextPage = false;
    }
    ngOnInit() {
        console.log("closed collection component");
        this.loadPage();
    }
    nextPage(event) {
        console.log("calling nextPage");
        this.pageNumber++;
        this.loadPage();
        event.preventDefault();
    }
    firstPage(event) {
        console.log("calling firstPage");
        this.pageNumber = 1;
        this.loadPage();
        event.preventDefault();
    }
    previousPage(event) {
        console.log("calling previousPage");
        this.pageNumber -= 1;
        this.loadPage();
        event.preventDefault();
    }
    loadPage() {
        this.loading = true;
        this.monthEndService.getClosedCollections(this.pageNumber).subscribe((closedCollectionResult) => {
            this.closedCollectionResult = closedCollectionResult;
            this.showFirstPage = this.pageNumber != 1;
            let totalNumPages = Math.ceil(closedCollectionResult.TotalRowsInTable / 10);
            this.showNextPage = (totalNumPages - this.pageNumber) > 0;
            this.loading = false;
        });
    }
};
MonthEndComponent = __decorate([
    Component({
        selector: 'app-month-end',
        templateUrl: './month-end.component.html',
        styleUrls: ['./month-end.component.css']
    }),
    __metadata("design:paramtypes", [MonthEndService])
], MonthEndComponent);
export { MonthEndComponent };
//# sourceMappingURL=month-end.component.js.map