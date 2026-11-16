import { __decorate, __metadata } from "tslib";
import { Component, Output, EventEmitter } from '@angular/core';
import { UntypedFormBuilder, Validators } from '@angular/forms';
import { ReleaseService } from '../services/release-service';
import Swal from 'sweetalert2';
let ReleasePopupComponent = class ReleasePopupComponent {
    constructor(fb, releaseService) {
        this.fb = fb;
        this.releaseService = releaseService;
        this.showPopup = false;
        this.releaseCreated = new EventEmitter();
    }
    ngOnInit() {
        this.releaseForm = this.fb.group({
            releaseName: ['', Validators.required],
            versionNumber: ['', Validators.required],
            description: ['', Validators.required],
            fileUrl: [''],
            status: ['Not started']
        });
    }
    onSubmitRelease() {
        if (this.releaseForm.valid) {
            console.log('Form Values:', this.releaseForm.value);
            this.releaseService.createRelease(this.releaseForm.value).subscribe((response) => {
                console.log(response);
                Swal.fire({
                    title: 'Success!',
                    text: response,
                    icon: 'success',
                    confirmButtonText: 'OK'
                });
                this.releaseCreated.emit();
                this.closePopup();
            }, error => {
                console.error('Error creating release:', error);
                Swal.fire({
                    title: 'Error!',
                    text: 'An error occurred while creating the release.',
                    icon: 'error',
                    confirmButtonText: 'OK'
                });
            });
        }
    }
    openPopup(fileUrl) {
        this.showPopup = true;
        this.fileUrl = fileUrl;
        this.releaseForm.patchValue({ fileUrl: this.fileUrl });
    }
    closePopup() {
        this.showPopup = false;
    }
};
__decorate([
    Output(),
    __metadata("design:type", Object)
], ReleasePopupComponent.prototype, "releaseCreated", void 0);
ReleasePopupComponent = __decorate([
    Component({
        selector: 'app-release-popup',
        templateUrl: './release-popup.component.html',
        styleUrls: ['./release-popup.component.css']
    }),
    __metadata("design:paramtypes", [UntypedFormBuilder, ReleaseService])
], ReleasePopupComponent);
export { ReleasePopupComponent };
//# sourceMappingURL=release-popup.component.js.map