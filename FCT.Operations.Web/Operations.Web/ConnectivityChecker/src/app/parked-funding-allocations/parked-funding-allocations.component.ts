import { Component, OnInit } from '@angular/core';
import { ParkedFundingAllocationsService } from '../services/parked-funding-allocations-service';

class ParkedFundingAllocationsDetail {
}

@Component({
  selector: 'parked-funding-allocations',
  templateUrl: './parked-funding-allocations.html',
  styleUrls: ['./parked-funding-allocations.css']
})
export class ParkedFundingAllocationsComponent implements OnInit {

  public Detail: ParkedFundingAllocationsDetail;
  public loading : boolean = false;

  constructor(private parkedFundingAllocationsService: ParkedFundingAllocationsService) { }

  ngOnInit() {
    console.log("parked-funding-allocations component");
    this.loading = true;
    this.parkedFundingAllocationsService.getParkedFundingAllocationDetails().subscribe((detail: ParkedFundingAllocationsDetail) => {
        this.Detail = detail;
        this.loading = false;
    });
  }
}
