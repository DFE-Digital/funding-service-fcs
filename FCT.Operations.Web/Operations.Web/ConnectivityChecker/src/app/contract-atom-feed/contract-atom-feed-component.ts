import { Component, OnInit } from '@angular/core';
import { ContractAtomFeedService } from '../services/contract-atom-feed-service';

class ContractInfo {

    constructor(
        public Id: string,
        public ContractNumber: string,
        public Version: string,
        public SubVersion: string,
        public ItemTypeString: string,
        public CreatedDateString: string
    ) { }
}

@Component({
    selector: 'contract-atom-feed',
    templateUrl: './contract-atom-feed.component.html'
})
export class ContractAtomFeedComponent implements OnInit {

    public contracts: Array<ContractInfo>;
    public loading: boolean = false;
    public hasSearchBeenClicked: boolean = false;
    public contractNumber : string;

    constructor(private contractAtomFeedService: ContractAtomFeedService) { }

    ngOnInit() {
        console.log("contract atom feed component");
    }

    onSearch(contractNumber) {
        if (this.isOkToSearch(contractNumber)) {
            this.loading = true;
            this.hasSearchBeenClicked = true;
            this.contractAtomFeedService.getContracts(contractNumber).subscribe((contracts: ContractInfo[]) => {
                this.contracts = contracts;
                this.loading = false;
            });
        }

        console.log(contractNumber);
    }

    isOkToSearch(contractNumber) {
        return contractNumber != null && contractNumber.length > 3
    }

    getXmlForContractId(event: Event, contract: ContractInfo){
        console.log("id: " + contract.Id);
        let header = 'data:text/csv;charset=utf-8,'
        var link = document.createElement("a");
        this.contractAtomFeedService.getXml(contract.Id).subscribe((xml: string) => {
            link.setAttribute('href', encodeURI(header + xml));
            
            let fileName =  `${`${contract.ContractNumber}_${contract.Version}_${contract.SubVersion}`}.xml`;
            link.setAttribute('download',  fileName);
            link.click();
        });

        event.preventDefault();
    }
}