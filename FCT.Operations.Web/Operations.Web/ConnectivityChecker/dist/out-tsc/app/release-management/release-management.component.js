import { __decorate, __metadata } from "tslib";
import { Component } from '@angular/core';
import { ReleaseService } from '../services/release-service';
import { StorageService } from '../services/storage.service';
import { ApprenticeshipLevyService } from '../services/apprenticeship-levy.service';
import { HttpClient } from '@angular/common/http';
import Swal from 'sweetalert2';
let ReleaseManagementComponent = class ReleaseManagementComponent {
    constructor(releaseService, storageService, webJobService, http) {
        this.releaseService = releaseService;
        this.storageService = storageService;
        this.webJobService = webJobService;
        this.http = http;
        this.releases = [];
        this.isProcessing = false;
        this.isAuthorized = false;
    }
    ngOnInit() {
        this.webJobService.getIsAuthorized().subscribe((authorized) => {
            this.isAuthorized = authorized;
        });
        this.fetchReleases();
    }
    fetchReleases() {
        this.releaseService.getReleases().subscribe((data) => {
            this.releases = data;
            this.updateButtonStates();
        }, (error) => {
            console.error('Error fetching releases:', error);
        });
    }
    updateButtonStates() {
        this.releases.forEach((release, index) => {
            if (index === 0 && release.Status === 'Not Started') {
                release.isButtonEnabled = true;
            }
            else {
                release.isButtonEnabled = false;
            }
        });
    }
    deployRelease(release) {
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
                    this.storageService.copyDocuments(sourceContainer).subscribe(() => {
                        this.http.post('../../applevy-variation/deploy', { fileUrl: release.FileUrl, rowKey: release.RowKey, environment: release.Environment }).subscribe(() => {
                            Swal.fire({
                                title: 'Success!',
                                text: 'Release deployed successfully.',
                                icon: 'success',
                                confirmButtonText: 'OK'
                            });
                            release.Status = 'Deployed';
                            this.updateButtonStates();
                        }, (error) => {
                            console.error('Error deploying release:', error);
                        });
                    }, (error) => {
                        this.isProcessing = false;
                        console.error('Error copying documents:', error);
                        Swal.fire({
                            title: 'Error!',
                            text: 'An error occurred while copying documents.',
                            icon: 'error',
                            confirmButtonText: 'OK'
                        });
                    });
                }
                else if (result.dismiss === Swal.DismissReason.cancel) {
                    Swal.fire({
                        title: 'Cancelled',
                        text: 'Deployment has been cancelled.',
                        icon: 'error',
                        confirmButtonText: 'OK'
                    });
                }
            });
        }
        else {
            Swal.fire({
                title: 'Error!',
                text: 'File URL is missing.',
                icon: 'error',
                confirmButtonText: 'OK'
            });
        }
    }
};
ReleaseManagementComponent = __decorate([
    Component({
        selector: 'app-release-management',
        templateUrl: './release-management.component.html',
        styleUrls: ['./release-management.component.css']
    }),
    __metadata("design:paramtypes", [ReleaseService, StorageService, ApprenticeshipLevyService,
        HttpClient])
], ReleaseManagementComponent);
export { ReleaseManagementComponent };
//# sourceMappingURL=release-management.component.js.map