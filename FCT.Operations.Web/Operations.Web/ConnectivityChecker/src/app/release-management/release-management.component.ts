import { Component, OnInit } from '@angular/core';
import { ReleaseService } from '../services/release-service';
import { StorageService } from '../services/storage.service';
import { ApprenticeshipLevyService } from '../services/apprenticeship-levy.service';
import { HttpClient } from '@angular/common/http';
import * as XLSX from 'xlsx';
import Swal from 'sweetalert2';

@Component({
  selector: 'app-release-management',
  templateUrl: './release-management.component.html',
  styleUrls: ['./release-management.component.css']
})
export class ReleaseManagementComponent implements OnInit {

  releases: any[] = [];
  isProcessing: boolean = false;
  public isAuthorized: boolean = false;

  constructor(private releaseService: ReleaseService, private storageService: StorageService, private webJobService: ApprenticeshipLevyService,
     private http: HttpClient) { }

  ngOnInit(): void {
    this.webJobService.getIsAuthorized().subscribe((authorized: boolean) => {
      this.isAuthorized = authorized;
    });
    this.fetchReleases();
  }

  fetchReleases(): void {
    this.releaseService.getReleases().subscribe(
      (data) => {
        this.releases = data;        
       this.updateButtonStates();

      },
      (error) => {
        console.error('Error fetching releases:', error);
      }
    );
  }   
  
updateButtonStates(): void {   
    this.releases.forEach((release, index) => {
      if (index===0 && release.Status === 'Not Started') {
        release.isButtonEnabled = true;        
      } else {
        release.isButtonEnabled = false;
      }
    });
  }     
  

  deployRelease(release: any): void {
    
    if (release.FileUrl) {
      Swal.fire({
        title: 'Are you sure?',
        text: 'Do you want to proceed with the deployment?',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonText: 'Yes, deploy it!',
        cancelButtonText: 'No, cancel!'
      }).then((result) => {
        if (result.isConfirmed) {
          release.Status = 'In-progress';
          const sourceContainer = 'fcs-document-template';
          this.storageService.copyDocuments(sourceContainer).subscribe(
            () => {     
              
              this.http.post('../../applevy-variation/deploy', { fileUrl: release.FileUrl, rowKey: release.RowKey,environment:release.Environment  }).subscribe(
                () => {
                  Swal.fire({
                    title: 'Success!',
                    text: 'Release deployed successfully.',
                    icon: 'success',
                    confirmButtonText: 'OK'
                  });
                
                  release.Status = 'Deployed';
                  this.updateButtonStates(); 
                },
                (error) => {
                 
                  console.error('Error deploying release:', error);                  
                }
              );
            },
            (error) => {
              this.isProcessing = false; 
              console.error('Error copying documents:', error);
              Swal.fire({
                title: 'Error!',
                text: 'An error occurred while copying documents.',
                icon: 'error',
                confirmButtonText: 'OK'
              });
            }
          );
        } else if (result.dismiss === Swal.DismissReason.cancel) {
          Swal.fire({
            title: 'Cancelled',
            text: 'Deployment has been cancelled.',
            icon: 'error',
            confirmButtonText: 'OK'
          });
        }
      });
    } else {
      Swal.fire({
        title: 'Error!',
        text: 'File URL is missing.',
        icon: 'error',
        confirmButtonText: 'OK'
      });
    }
  }
}
