import { __decorate, __metadata } from "tslib";
import { Component } from '@angular/core';
import { LevyContractService } from '../services/levy-contract-service';
class Contract {
    constructor(ContractNumber, MasterContractNumber, Ukprn, ContractVersionNumber, SubVersionNumber, ContractStatus, ContractSubStatus) {
        this.ContractNumber = ContractNumber;
        this.MasterContractNumber = MasterContractNumber;
        this.Ukprn = Ukprn;
        this.ContractVersionNumber = ContractVersionNumber;
        this.SubVersionNumber = SubVersionNumber;
        this.ContractStatus = ContractStatus;
        this.ContractSubStatus = ContractSubStatus;
    }
}
let LevyAmendmentComponent = class LevyAmendmentComponent {
    constructor(levyContractService) {
        this.levyContractService = levyContractService;
        this.loading = false;
    }
    ngOnInit() {
        console.log("levy component");
        this.loading = true;
        this.levyContractService.getNonAmendableContracts().subscribe((contracts) => {
            this.contracts = contracts;
            this.loading = false;
        });
    }
    createCsv(event) {
        console.log("create csv");
        let header = 'data:text/csv;charset=utf-8,';
        var link = document.createElement("a");
        let csv = this.createCsvFromContracts(this.contracts);
        link.setAttribute('href', encodeURI(header + csv));
        link.setAttribute('download', "file.csv");
        link.click();
        event.preventDefault();
    }
    createCsvFromContracts(contracts) {
        let columnDelimiter = ',';
        let lineDelimiter = '\n';
        let columnHeadings = 'Contract, Master Contract, Ukprn, Version, Sub Version, Status, Substatus';
        let dataRows = Array.prototype.map.call(this.contracts, contract => {
            return contract.ContractNumber + columnDelimiter +
                contract.MasterContractNumber + columnDelimiter +
                contract.Ukprn + columnDelimiter +
                contract.ContractVersionNumber + columnDelimiter +
                contract.SubVersionNumber + columnDelimiter +
                contract.ContractStatus + columnDelimiter +
                contract.ContractSubStatus + lineDelimiter;
        });
        return columnHeadings + lineDelimiter + dataRows.join("");
    }
};
LevyAmendmentComponent = __decorate([
    Component({
        selector: 'app-levy-amendment',
        templateUrl: './levy-amendment.component.html',
        styleUrls: ['./levy-amendment.component.css']
    }),
    __metadata("design:paramtypes", [LevyContractService])
], LevyAmendmentComponent);
export { LevyAmendmentComponent };
//# sourceMappingURL=levy-amendment.component.js.map