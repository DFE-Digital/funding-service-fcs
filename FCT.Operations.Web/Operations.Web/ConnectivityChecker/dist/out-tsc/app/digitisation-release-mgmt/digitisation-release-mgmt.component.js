import { __decorate, __metadata } from "tslib";
import { Component } from '@angular/core';
import { DigiReleaseMgmtService } from '../services/digi-release-mgmt-service';
import { ApprenticeshipLevyService } from '../services/apprenticeship-levy.service'; //webJobService authorisation
import { HttpClient } from '@angular/common/http';
import { FormBuilder, Validators } from '@angular/forms';
let DigitisationReleaseMgmtComponent = class DigitisationReleaseMgmtComponent {
    constructor(releaseService, webJobService, http, fb) {
        this.releaseService = releaseService;
        this.webJobService = webJobService;
        this.http = http;
        this.fb = fb;
        this.releases = [];
        this.editing = false;
        this.editingReleaseId = null;
        this.editingReleaseName = '';
        this.isProcessing = false;
        this.isAuthorized = false;
        this.successMessage = '';
    }
    ngOnInit() {
        this.webJobService.getIsAuthorized().subscribe((authorized) => {
            this.isAuthorized = authorized;
        });
        this.releaseForm = this.fb.group({
            releaseName: ['', [Validators.required, Validators.maxLength(100)]],
            versionNumber: [{ value: '', disabled: true }],
            description: ['', [Validators.required, Validators.maxLength(500)]]
        });
        this.fetchReleases();
    }
    onSubmit() {
        if (this.releaseForm.invalid)
            return;
        const release = {
            ReleaseName: this.releaseForm.get('releaseName')?.value,
            Description: this.releaseForm.get('description')?.value
        };
        const confirmation = window.confirm(`
      Are you sure you want to submit?
        Release Name: ${this.releaseForm.value.releaseName}
        Version: ${this.releaseForm.get('versionNumber')?.value}
        Description: ${this.releaseForm.value.description}
      `);
        if (!confirmation)
            return;
        if (this.editing) {
            this.releaseService.updateRelease(this.editingReleaseId, release).subscribe(() => {
                this.showSuccessMessage("Successfully Updated");
                this.resetForm();
            });
        }
        else {
            this.releaseService.createRelease(release).subscribe(() => {
                this.showSuccessMessage("Successfully Created");
                this.resetForm();
            });
        }
    }
    editRelease(release) {
        this.releaseForm.setValue({
            releaseName: release.ReleaseName,
            versionNumber: release.Version,
            description: release.Description
        });
        this.editing = true;
        this.editingReleaseId = release.ReleaseId;
        this.editingReleaseName = release.ReleaseName;
    }
    fetchReleases() {
        this.releaseService.getReleases().subscribe((data) => {
            this.releases = data;
            if (!this.editing) {
                this.prefillVersion();
                this.updateButtonStates();
            }
        }, (error) => {
            console.error('Error fetching releases:', error);
        });
    }
    prefillVersion() {
        this.releaseService.getNextReleaseID().subscribe((nextReleaseID) => {
            this.releaseForm.patchValue({
                versionNumber: nextReleaseID
            });
        });
    }
    resetForm() {
        this.releaseForm.reset();
        this.editing = false;
        this.editingReleaseId = null;
        this.editingReleaseName = '';
        this.fetchReleases();
    }
    updateButtonStates() {
        this.releases.forEach((release, index) => {
            if (index === 0) {
                release.isButtonEnabled = true;
                release.buttonLabel = release.DeploymentStatus === 'Deployed' || release.DeploymentStatus === 'Redeployed'
                    ? 'Redeploy'
                    : 'Deploy';
            }
            else {
                release.isButtonEnabled = false;
                release.buttonLabel = 'Deploy';
            }
        });
    }
    deployRelease(release) {
        const action = release.DeploymentStatus === 'Deployed' || release.DeploymentStatus === 'Redeployed'
            ? 'Redeploy'
            : 'Deploy';
        const confirmMessage = `Are you sure you want to ${action.toLowerCase()} release ${release.Version}?`;
        if (!window.confirm(confirmMessage))
            return;
        this.releaseService.deployRelease(release.ReleaseId).subscribe({
            next: async () => {
                this.releases = await this.releaseService.getReleases().toPromise();
                this.showSuccessMessage(`${action} successful.`);
                this.updateButtonStates();
            },
            error: (err) => {
                console.error('Deployment failed', err);
            }
        });
    }
    showSuccessMessage(message) {
        this.successMessage = message;
        setTimeout(() => {
            this.successMessage = null;
        }, 4000);
    }
    getDescText(description, expanded) {
        const maxChars = 120;
        if (expanded || description.length <= maxChars) {
            return description;
        }
        return description.substring(0, maxChars);
    }
    isTruncated(text) {
        const maxChars = 120;
        return text.length > maxChars;
    }
    toggleExpand(release) {
        release.isExpanded = !release.isExpanded;
    }
};
DigitisationReleaseMgmtComponent = __decorate([
    Component({
        selector: 'digitisation-release-mgmt',
        templateUrl: './digitisation-release-mgmt.component.html',
        styleUrls: ['./digitisation-release-mgmt.component.css']
    }),
    __metadata("design:paramtypes", [DigiReleaseMgmtService, ApprenticeshipLevyService,
        HttpClient, FormBuilder])
], DigitisationReleaseMgmtComponent);
export { DigitisationReleaseMgmtComponent };
//# sourceMappingURL=digitisation-release-mgmt.component.js.map