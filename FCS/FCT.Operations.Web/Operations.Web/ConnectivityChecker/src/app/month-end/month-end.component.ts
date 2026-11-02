import { Component, OnInit } from '@angular/core';
import { MonthEndService } from '../services/month-end-service';

class ClosedCollection {
    
  constructor(
      public CollectionType: string,
      public CollectionReturnCode: string,
      public ClosedTime: Date,
      public TotalRowCount: Number,
      public RetrievedRowCount: Number,
      public CreatedDate: Date
      ) { }
}

class ClosedCollectionResult {
    
  constructor(
      public ClosedCollections: Array<ClosedCollection>,
      public TotalRowsInTable: number  
      ) { }
}

@Component({
  selector: 'app-month-end',
  templateUrl: './month-end.component.html',
  styleUrls: ['./month-end.component.css']
})
export class MonthEndComponent implements OnInit {

  public closedCollectionResult: ClosedCollectionResult;
  public loading : boolean = false;
  public pageNumber : number = 1;
  public showFirstPage : boolean = false;
  public showNextPage : boolean = false;

  constructor(private monthEndService: MonthEndService) { }

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
    this.monthEndService.getClosedCollections(this.pageNumber).subscribe((closedCollectionResult: ClosedCollectionResult) => {
      this.closedCollectionResult = closedCollectionResult;
      this.showFirstPage = this.pageNumber != 1;
      let totalNumPages : number = Math.ceil(closedCollectionResult.TotalRowsInTable/10);
      this.showNextPage = (totalNumPages - this.pageNumber) > 0;
      this.loading = false;
  });
  }
}
