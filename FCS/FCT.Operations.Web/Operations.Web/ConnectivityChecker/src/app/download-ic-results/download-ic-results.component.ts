import { Component, OnInit } from '@angular/core';
import { DownloadIcResultsService } from '../services/download-ic-results.service';

class DownloadIntegrityResultCollection {
    
  constructor(
      public CheckerType: string, 
      public StartDate: Date, 
      public FinishDate: Date,      
      public Status: string, 
      public Outcome: string,
      public Link: String     
     
      ) { }
}

class DownloadIntegrityCheckerCollectionResult {
    
  constructor(
      public DownloadIntegrityResultCollections: Array<DownloadIntegrityResultCollection>,
      public TotalRowsInTable: number  
      ) { }
}

@Component({
  selector: 'app-download-ic-results',
  templateUrl: './download-ic-results.component.html',
  styleUrls: ['./download-ic-results.component.css']
})
export class DownloadIcResultsComponent implements OnInit {

  public downloadIntegrityCheckerCollectionResult: DownloadIntegrityCheckerCollectionResult;
  public loading : boolean = false;
  public pageNumber : number = 1;
  public showFirstPage : boolean = false;
  public showNextPage : boolean = false;

  constructor(private downloadIcResultsService: DownloadIcResultsService) { }

  ngOnInit() {
    console.log("closed collection component");
    this.loadPage();
  }

  nextPage(event: Event){
    console.log("calling nextPage");
    this.pageNumber++;
    this.loadPage();
    event.preventDefault();
  }

  firstPage(event: Event){
    console.log("calling firstPage");
    this.pageNumber = 1;
    this.loadPage();
    event.preventDefault();
  }

  previousPage(event: Event){
    console.log("calling previousPage");
    this.pageNumber -= 1;
    this.loadPage();
    event.preventDefault();
  }

  loadPage(){
    this.loading = true;
    this.downloadIcResultsService.getClosedCollections(this.pageNumber).subscribe((downloadIntegrityCheckerCollectionResult: DownloadIntegrityCheckerCollectionResult) => {
      this.downloadIntegrityCheckerCollectionResult = downloadIntegrityCheckerCollectionResult;
      this.showFirstPage = this.pageNumber != 1;
      let totalNumPages : number = Math.ceil(downloadIntegrityCheckerCollectionResult.TotalRowsInTable/10);
      this.showNextPage = (totalNumPages - this.pageNumber) > 0;
      this.loading = false;
  });
  }

  downloadCSV(event: Event, downloadIntegrityCheckerCollectionResult: DownloadIntegrityResultCollection){
    console.log("documentname: " + downloadIntegrityCheckerCollectionResult.Link);
    let header = 'data:text/csv;charset=utf-8,'
    var link = document.createElement("a");
    this.downloadIcResultsService.downloadCSV(downloadIntegrityCheckerCollectionResult.Link).subscribe((responseType: Blob) => {
        link.setAttribute('href', encodeURI(header + responseType));
        
        let fileName =  `${`${downloadIntegrityCheckerCollectionResult.Link}`}`;
        link.setAttribute('download',  fileName);
        link.click();
    });

    event.preventDefault();
}


}
