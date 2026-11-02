import { Component, OnInit } from '@angular/core';
import { LevyContractService } from '../services/levy-contract-service';

class Contract {
    
  constructor(
      public ContractNumber: string,
      public MasterContractNumber: string,
      public Ukprn: string,
      public ContractVersionNumber: string,
      public SubVersionNumber: string,
      public ContractStatus: string,
      public ContractSubStatus: string
      ) { }
}

@Component({
  selector: 'app-levy-amendment',
  templateUrl: './levy-amendment.component.html',
  styleUrls: ['./levy-amendment.component.css']
})
export class LevyAmendmentComponent implements OnInit {

  public contracts: Array<Contract>;
  public loading : boolean = false;

  constructor(private levyContractService: LevyContractService) { }

  ngOnInit() {
    console.log("levy component");
    this.loading = true;
    this.levyContractService.getNonAmendableContracts().subscribe((contracts: Contract[]) => {
        this.contracts = contracts;
        this.loading = false;
    });
  }

  createCsv(event: Event){
    console.log("create csv");
    let header = 'data:text/csv;charset=utf-8,'
    var link = document.createElement("a");
    let csv = this.createCsvFromContracts(this.contracts);

    link.setAttribute('href', encodeURI(header + csv));
        link.setAttribute('download', "file.csv");
        link.click();

    event.preventDefault();
  }

  createCsvFromContracts(contracts: Array<Contract>) : string {
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
}
