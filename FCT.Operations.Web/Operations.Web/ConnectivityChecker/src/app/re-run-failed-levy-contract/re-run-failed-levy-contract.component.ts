import { Component, OnInit } from '@angular/core';
import { ReRunFailedLevyContractService } from '../services/re-run-failed-levy-contract-service';
class ErrorMessage {
 
  constructor(
      public MessageId: string, 
      public MessageBody: string,  
      public CompleteDate: Date, 
      public selected: boolean
      ) { 
       
      }
     
}

class ErrorQueueContract {
  
  constructor(
      public QueueName: string ,
      public lstContract: Array<ErrorMessage>
       
      ) { }
}
@Component({
  selector: 'app-re-run-failed-levy-contract',
  templateUrl: './re-run-failed-levy-contract.component.html',
  styleUrls: ['./re-run-failed-levy-contract.component.css']
})
export class ReRunFailedLevyContractComponent implements OnInit {
  public responseContracts: ErrorQueueContract;
  public responseErrorMessages : Set<ErrorMessage> = new Set<ErrorMessage>();
  selectedMessages: boolean[] = []; 
  selectedIds: Set<string> = new Set<string>();
  public errorQueueContract: ErrorQueueContract;
  public errorMessage: ErrorMessage;;
  
  public loading : boolean = false;
  public pageNumber : number = 1;
  public showFirstPage : boolean = false;
  public showNextPage : boolean = false;
   constructor(private reRunFailedLevyContractService: ReRunFailedLevyContractService) { }
 
   ngOnInit(): void {
    
    this.loadPage();
  }

  loadPage(){
    this.loading = true;
    this.reRunFailedLevyContractService.getFailedQueueCollections().subscribe((errorQueueContract: ErrorQueueContract) => {
      this.errorQueueContract = errorQueueContract;       
      this.showFirstPage = this.pageNumber != 1;
      this.loading = false;
      this.data = this.data;
      
      this.selectedMessages = new Array(this.errorQueueContract.lstContract.length).fill(false);
  });
  }
  // Sample data for the table
  data = [
    { id: 1, MessageId: '78572501-8666-4fd6-94d9-b5ee8fc97449', MessageBody: '{"ContractNumber":"APPLEVY-768","MasterContractNumber":"ESFA-768"}', CompleteDate: '04/03/2024 19:15', selected: false },
    { id: 2, MessageId: '180323cc-5ca8-44d2-bf1c-32246027e9e3', MessageBody: '{"ContractNumber":"APPLEVY-618","MasterContractNumber":"ESFA-568"}', CompleteDate: '04/03/2024 19:17', selected: false },
    { id: 3, MessageId: '2e36e0b8-7da0-4e68-a8d8-16894dce0b98', MessageBody: '{"ContractNumber":"APPLEVY-868","MasterContractNumber":"ESFA-903"}', CompleteDate: '05/03/2024 11:17', selected: false },
    { id: 4, MessageId: '7e36e0b8-7da0-4e68-a8d8-16894dce0b10', MessageBody: '{"ContractNumber":"APPLEVY-768","MasterContractNumber":"ESFA-901"}', CompleteDate: '05/03/2024 16:11', selected: false },
    { id: 5, MessageId: '6e36e0b8-7da0-4e68-a8d8-16894dce0b22', MessageBody: '{"ContractNumber":"APPLEVY-261","MasterContractNumber":"ESFA-904"}', CompleteDate: '05/03/2024 15:15', selected: false },
    { id: 6, MessageId: '5e36e0b8-7da0-4e68-a8d8-16894dce0b33', MessageBody: '{"ContractNumber":"APPLEVY-823","MasterContractNumber":"ESFA-905"}', CompleteDate: '05/03/2024 14:14', selected: false },
    { id: 7, MessageId: '4e36e0b8-7da0-4e68-a8d8-16894dce0b44', MessageBody: '{"ContractNumber":"APPLEVY-268","MasterContractNumber":"ESFA-906"}', CompleteDate: '05/03/2024 12:12', selected: false },
    { id: 8, MessageId: '3e36e0b8-7da0-4e68-a8d8-16894dce0b55', MessageBody: '{"ContractNumber":"APPLEVY-367","MasterContractNumber":"ESFA-907"}', CompleteDate: '05/03/2024 11:17', selected: false },
    { id: 9, MessageId: '2e36e0b8-7da0-4e68-a8d8-16894dce0b66', MessageBody: '{"ContractNumber":"APPLEVY-465","MasterContractNumber":"ESFA-908"}', CompleteDate: '05/03/2024 10:23', selected: false }
  ];
      
    
      // Check if all rows are selected
      checkIfAllSelected() {
        this.selectAll = this.data.every(item => item.selected);
        this.updateSearchButtonState();
  
      } 
   
    // Header checkbox state
    selectAll: boolean = false;

    // Toggle all checkboxes
    toggleAll(event: any) {       
      if (event.target.checked) {
        this.errorQueueContract.lstContract.forEach(item => this.selectedIds.add(item.MessageId));
      } else {
        this.selectedIds.clear();
      }
      
      this.updateSearchButtonState();
       const checked = event.target.checked;
       this.selectedMessages.fill(checked);
       if (event.target.checked) {
        this.errorQueueContract.lstContract.forEach(item => this.selectedIds.add(item.MessageId));
      } else {
        this.selectedIds.clear();
      }
//      this.data.forEach(item => item.selected = this.selectAll);
      this.errorQueueContract.lstContract.forEach(item => item.selected = this.selectAll);
      if (event.target.checked) {
        this.errorQueueContract.lstContract.forEach(item => this.responseErrorMessages.add(item));
        this.errorQueueContract.lstContract.forEach(item => this.selectedIds.add(item.MessageId));
      } else {
        this.responseErrorMessages.clear();        
        this.selectedIds.clear();
      }
      
      this.updateSearchButtonState();

    }

    toggleSelection1(row: any, event: any) {
      const checked = event.target.checked;
      const index = this.errorQueueContract.lstContract.indexOf(row);
       
      this.selectedMessages[index] = checked;
    }

    toggleSelection(id: string) {
      if (this.selectedIds.has(id)) {
        this.selectedIds.delete(id);
      } else {
        this.selectedIds.add(id);
      }
    }

    onButtonClick() {
       //const selectedRows = this.errorQueueContract.lstContract.filter((row, index) => this.selectedMessages[index]);
       this.loading = true; 
       this.isSearchButtonEnabled = false;
      const selectedArray = Array.from(this.selectedIds);

      const selectedIdsObject = { ids: selectedArray };
      var dataa = this.errorQueueContract.lstContract.filter(item => this.selectedIds.has(item.MessageId));
      console.log('Submitted IDs:', dataa);
       this.processSelectedItems(dataa);
    }
  
    processSelectedItems(selectedIds: any) {
      console.log('Selected Items:', selectedIds);
      const dataObject = { items: selectedIds }; // Create an object containing the list of selected items
     
       
      this.loading = true;
        this.reRunFailedLevyContractService.rerunFailedQueueCollections(dataObject.items).subscribe(response => {
          console.log('Submitted IDs:', response);
          this.loading = false;
          // Trigger data refresh after successful submit
          this.loadPage();
        }, error => {
          console.error('Error:', error);
          this.loading = false; // Hide loading spinner if there's an error
          this.isSearchButtonEnabled = true;
        });
    }
    onCheckboxChange(event: any, id: string): void {
      if (this.selectedIds.has(id)) {
        this.selectedIds.delete(id);
      } else { 
        this.selectedIds.add(id);
       
      }
      console.log("this.selectedIds 4", this.selectedIds);
    this.updateSearchButtonState();
  
    }
     // Update the state of the search button
  updateSearchButtonState() {
    if(this.selectedIds.size > 0)
      this.isSearchButtonEnabled = true;
    else
    this.isSearchButtonEnabled =false;
  }

  // Search button state
  isSearchButtonEnabled: boolean = false; 
}
