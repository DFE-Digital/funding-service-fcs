import { __decorate, __metadata } from "tslib";
import { Component } from '@angular/core';
import { DownloadIcResultsService } from '../services/download-ic-results.service';
class DownloadIntegrityResultCollection {
    constructor(CheckerType, StartDate, FinishDate, Status, Outcome, Link) {
        this.CheckerType = CheckerType;
        this.StartDate = StartDate;
        this.FinishDate = FinishDate;
        this.Status = Status;
        this.Outcome = Outcome;
        this.Link = Link;
    }
}
class DownloadIntegrityCheckerCollectionResult {
    constructor(DownloadIntegrityResultCollections, TotalRowsInTable) {
        this.DownloadIntegrityResultCollections = DownloadIntegrityResultCollections;
        this.TotalRowsInTable = TotalRowsInTable;
    }
}
let DownloadIcResultsComponent = class DownloadIcResultsComponent {
    constructor(downloadIcResultsService) {
        this.downloadIcResultsService = downloadIcResultsService;
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
        this.downloadIcResultsService.getClosedCollections(this.pageNumber).subscribe((downloadIntegrityCheckerCollectionResult) => {
            this.downloadIntegrityCheckerCollectionResult = downloadIntegrityCheckerCollectionResult;
            this.showFirstPage = this.pageNumber != 1;
            let totalNumPages = Math.ceil(downloadIntegrityCheckerCollectionResult.TotalRowsInTable / 10);
            this.showNextPage = (totalNumPages - this.pageNumber) > 0;
            this.loading = false;
        });
    }
    downloadCSV(event, downloadIntegrityCheckerCollectionResult) {
        console.log("documentname: " + downloadIntegrityCheckerCollectionResult.Link);
        let header = 'data:text/csv;charset=utf-8,';
        var link = document.createElement("a");
        this.downloadIcResultsService.downloadCSV(downloadIntegrityCheckerCollectionResult.Link).subscribe((responseType) => {
            link.setAttribute('href', encodeURI(header + responseType));
            let fileName = `${`${downloadIntegrityCheckerCollectionResult.Link}`}`;
            link.setAttribute('download', fileName);
            link.click();
        });
        event.preventDefault();
    }
};
DownloadIcResultsComponent = __decorate([
    Component({
        selector: 'app-download-ic-results',
        templateUrl: './download-ic-results.component.html',
        styleUrls: ['./download-ic-results.component.css']
    }),
    __metadata("design:paramtypes", [DownloadIcResultsService])
], DownloadIcResultsComponent);
export { DownloadIcResultsComponent };
//# sourceMappingURL=download-ic-results.component.js.map