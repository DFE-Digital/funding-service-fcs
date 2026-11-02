import { Component, OnInit } from '@angular/core';
import { CfsImportService } from '../services/cfs-import-service';

class CfsImportInfo {
}

class CfsImportInfoResult {
    
  constructor(
      public CfsImportInfos: Array<CfsImportInfo>,
      public TotalRowsInTable: number  
      ) { }
}

@Component({
  selector: 'app-cfs-import',
  templateUrl: './cfs-import.component.html',
  styleUrls: ['./cfs-import.component.css']
})
export class CfsImportComponent implements OnInit {

  public cfsImportInfoResult: CfsImportInfoResult;
  public loading : boolean = false;
  public pageNumber : number = 1;
  public showFirstPage : boolean = false;
  public showNextPage : boolean = false;

  constructor(private cfsImportService: CfsImportService) { }

  ngOnInit() {
    console.log("CfsImportcomponent");
    this.loadPage();
  }

  nextPage(event: Event){
    console.log("CfsImportcomponent calling nextPage");
    this.pageNumber++;
    this.loadPage();
    event.preventDefault();
  }

  firstPage(event: Event){
    console.log("CfsImportcomponent calling firstPage");
    this.pageNumber = 1;
    this.loadPage();
    event.preventDefault();
  }

  previousPage(event: Event){
    console.log("CfsImportcomponent calling previousPage");
    this.pageNumber -= 1;
    this.loadPage();
    event.preventDefault();
  }

  loadPage(){
    this.loading = true;
    this.cfsImportService.getCfsImportInfos(this.pageNumber).subscribe((cfsImportInfoResult: CfsImportInfoResult) => {
      this.cfsImportInfoResult = cfsImportInfoResult;
      this.showFirstPage = this.pageNumber != 1;
      let totalNumPages : number = Math.ceil(cfsImportInfoResult.TotalRowsInTable/10);
      this.showNextPage = (totalNumPages - this.pageNumber) > 0;
      this.loading = false;
  });
  console.log("CfsImportcomponent in loadPage");
  }
}
