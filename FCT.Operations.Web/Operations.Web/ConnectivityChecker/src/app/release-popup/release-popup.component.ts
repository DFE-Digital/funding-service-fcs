import { Component, OnInit, Output, EventEmitter } from '@angular/core';
import { UntypedFormBuilder, UntypedFormGroup, Validators } from '@angular/forms';
import { ReleaseService } from '../services/release-service';
import Swal from 'sweetalert2';

@Component({
  selector: 'app-release-popup',
  templateUrl: './release-popup.component.html',
  styleUrls: ['./release-popup.component.css']
})
export class ReleasePopupComponent implements OnInit {

  releaseForm: UntypedFormGroup;
  showPopup = false;
  fileUrl: string; 
  @Output() releaseCreated = new EventEmitter<void>();

  constructor(private fb: UntypedFormBuilder, private releaseService: ReleaseService) { }

  ngOnInit(): void {
    this.releaseForm = this.fb.group({
      releaseName: ['', Validators.required],
      versionNumber: ['', Validators.required],
      description: ['', Validators.required],
      fileUrl: [''], 
      status: ['Not started']     });
  }

  onSubmitRelease(): void {
    if (this.releaseForm.valid) {
      console.log('Form Values:', this.releaseForm.value); 
      this.releaseService.createRelease(this.releaseForm.value).subscribe(
        (response) => {
          console.log(response);
          Swal.fire({
            title: 'Success!',
            text: response,
            icon: 'success',
            confirmButtonText: 'OK'
          });
          this.releaseCreated.emit();
          this.closePopup();
        },
        error => {
          console.error('Error creating release:', error);
          Swal.fire({
            title: 'Error!',
            text: 'An error occurred while creating the release.',
            icon: 'error',
            confirmButtonText: 'OK'
          });
        }
      );
    }
  }

  openPopup(fileUrl: string): void {
    this.showPopup = true;
    this.fileUrl = fileUrl; 
    this.releaseForm.patchValue({ fileUrl: this.fileUrl });
  }

  closePopup(): void {
    this.showPopup = false;
  }

}