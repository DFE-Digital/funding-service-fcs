import { __decorate, __metadata } from "tslib";
import { Component } from '@angular/core';
import { ContractAtomFeedService } from '../services/contract-atom-feed-service';
class ContractInfo {
    constructor(Id, ContractNumber, Version, SubVersion, ItemTypeString, CreatedDateString) {
        this.Id = Id;
        this.ContractNumber = ContractNumber;
        this.Version = Version;
        this.SubVersion = SubVersion;
        this.ItemTypeString = ItemTypeString;
        this.CreatedDateString = CreatedDateString;
    }
}
let ContractAtomFeedComponent = class ContractAtomFeedComponent {
    constructor(contractAtomFeedService) {
        this.contractAtomFeedService = contractAtomFeedService;
        this.loading = false;
        this.hasSearchBeenClicked = false;
    }
    ngOnInit() {
        console.log("contract atom feed component");
    }
    onSearch(contractNumber) {
        if (this.isOkToSearch(contractNumber)) {
            this.loading = true;
            this.hasSearchBeenClicked = true;
            this.contractAtomFeedService.getContracts(contractNumber).subscribe((contracts) => {
                this.contracts = contracts;
                this.loading = false;
            });
        }
        console.log(contractNumber);
    }
    isOkToSearch(contractNumber) {
        return contractNumber != null && contractNumber.length > 3;
    }
    getXmlForContractId(event, contract) {
        console.log("id: " + contract.Id);
        let header = 'data:text/csv;charset=utf-8,';
        var link = document.createElement("a");
        this.contractAtomFeedService.getXml(contract.Id).subscribe((xml) => {
            link.setAttribute('href', encodeURI(header + xml));
            let fileName = `${`${contract.ContractNumber}_${contract.Version}_${contract.SubVersion}`}.xml`;
            link.setAttribute('download', fileName);
            link.click();
        });
        event.preventDefault();
    }
};
ContractAtomFeedComponent = __decorate([
    Component({
        selector: 'contract-atom-feed',
        templateUrl: './contract-atom-feed.component.html'
    }),
    __metadata("design:paramtypes", [ContractAtomFeedService])
], ContractAtomFeedComponent);
export { ContractAtomFeedComponent };
//# sourceMappingURL=contract-atom-feed-component.js.map