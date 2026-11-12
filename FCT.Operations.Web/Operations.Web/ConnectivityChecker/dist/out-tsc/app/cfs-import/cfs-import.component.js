import { __decorate, __metadata } from "tslib";
import { Component } from '@angular/core';
import { CfsImportService } from '../services/cfs-import-service';
class CfsImportInfo {
}
class CfsImportInfoResult {
    constructor(CfsImportInfos, TotalRowsInTable) {
        this.CfsImportInfos = CfsImportInfos;
        this.TotalRowsInTable = TotalRowsInTable;
    }
}
let CfsImportComponent = class CfsImportComponent {
    constructor(cfsImportService) {
        this.cfsImportService = cfsImportService;
        this.loading = false;
        this.pageNumber = 1;
        this.showFirstPage = false;
        this.showNextPage = false;
    }
    ngOnInit() {
        console.log("CfsImportcomponent");
        this.loadPage();
    }
    nextPage(event) {
        console.log("CfsImportcomponent calling nextPage");
        this.pageNumber++;
        this.loadPage();
        event.preventDefault();
    }
    firstPage(event) {
        console.log("CfsImportcomponent calling firstPage");
        this.pageNumber = 1;
        this.loadPage();
        event.preventDefault();
    }
    previousPage(event) {
        console.log("CfsImportcomponent calling previousPage");
        this.pageNumber -= 1;
        this.loadPage();
        event.preventDefault();
    }
    loadPage() {
        this.loading = true;
        this.cfsImportService.getCfsImportInfos(this.pageNumber).subscribe((cfsImportInfoResult) => {
            this.cfsImportInfoResult = cfsImportInfoResult;
            this.showFirstPage = this.pageNumber != 1;
            let totalNumPages = Math.ceil(cfsImportInfoResult.TotalRowsInTable / 10);
            this.showNextPage = (totalNumPages - this.pageNumber) > 0;
            this.loading = false;
        });
        console.log("CfsImportcomponent in loadPage");
    }
};
CfsImportComponent = __decorate([
    Component({
        selector: 'app-cfs-import',
        templateUrl: './cfs-import.component.html',
        styleUrls: ['./cfs-import.component.css']
    }),
    __metadata("design:paramtypes", [CfsImportService])
], CfsImportComponent);
export { CfsImportComponent };
//# sourceMappingURL=cfs-import.component.js.map