import { __decorate, __metadata } from "tslib";
import { Component, ChangeDetectorRef, ViewChild, ElementRef } from '@angular/core';
import { HttpResponse } from '@angular/common/http';
import { ApprenticeshipLevyService } from '../services/apprenticeship-levy.service';
import { UntypedFormBuilder, Validators } from '@angular/forms';
import { FileUploadService } from '../services/file-upload.service';
import { ApplevyVariationService } from '../services/applevy-variation.service';
import * as XLSX from 'xlsx';
import { ErrorHandlingService } from '../error-handlers/error-handling-service.service';
import Swal from 'sweetalert2';
import { ReleaseService } from '../services/release-service';
import { ReleasePopupComponent } from '../release-popup/release-popup.component';
let ApprenticeshipLevyComponent = class ApprenticeshipLevyComponent {
    constructor(webJobService, changeDetectorRef, fb, uploadService, applevyService, errorHandlingService, releaseService) {
        this.webJobService = webJobService;
        this.changeDetectorRef = changeDetectorRef;
        this.fb = fb;
        this.uploadService = uploadService;
        this.applevyService = applevyService;
        this.errorHandlingService = errorHandlingService;
        this.releaseService = releaseService;
        this.containerName = 'fcs-document-template';
        this.approvedTotal = 0;
        this.modifiedTotal = 0;
        this.underTerminationTotal = 0;
        this.kbFile = null;
        this.mandatoryHeaders = ['Contract No', 'Contract Status', 'Sub Status'];
        this.totalHeaders = ['Contract No', 'Contract Status', 'Sub Status', 'Letter Bespoke Required', 'T&C Bespoke Required'];
        this.options = ['Upload Templates', 'Upload Providers'];
        this.submitted = false;
        this.invalidFileType = false;
        this.selectedType = "";
        this.valMessage = [];
        this.totalMessage = [];
        this.errorMessage = [];
        this.message = [];
        this.files = [];
        this.isEnabled = false;
        this.isAuthorized = false;
        this.uploadFileSizeLimit = 2;
        this.isSuccess = -1;
        this.items = [];
        this.isProcessing = false;
        this.progressPercentage = 0;
        this.isValidationSuccess = false;
        this.isFileSelected = false;
        this.isUploading = false;
        this.isWebJobEnabled = false;
        // Pagination properties
        this.currentPage = 1;
        this.itemsPerPage = 7;
        this.totalPages = 1;
        this.paginatedFiles = [];
        this.form = this.fb.group({
            dropdown: [''],
            uploaddocumntfiles: [{ value: '', disabled: true }, [Validators.required, this.fileTypeValidator]],
            useExistingTemplates: [false]
        });
    }
    ngOnInit() {
        this.checkWebJobStatus();
        this.webJobService.getIsAuthorized().subscribe((authorized) => {
            this.isAuthorized = authorized;
        });
        this.getFiles();
        // Global error handling for uncaught errors
        window.onerror = (message, source, lineno, colno, error) => {
            this.errorHandlingService.handleClientError(error);
            return true;
        };
    }
    selectDocumentFiles(event) {
        this.clearMessages();
        const input = event.target;
        console.log('File input select document Files event:', input);
        const pFileList = input.files;
        if (pFileList) {
            const invalidFiles = Array.from(pFileList).filter(file => {
                console.log('Checking file:', file.name);
                return !file.name.includes('LEVY') || !file.name.endsWith('.docx');
            });
            if (invalidFiles.length > 0) {
                this.handleValidationError(['Only .docx files containing "LEVY" in the name are allowed.']);
                this.selectedFiles = null;
            }
            else {
                this.selectedFiles = pFileList;
            }
        }
        this.isSuccess = -1;
    }
    onFileChange(event) {
        this.clearMessages();
        const input = event.target;
        console.log('File input onfilechange event:', input);
        const pFileList = input.files;
        this.selectedFiles = pFileList;
        this.isFileSelected = !!pFileList && pFileList.length > 0;
        this.isValidationSuccess = false;
    }
    clearMessages() {
        this.valMessage = [];
        this.message = [];
        this.totalMessage = [];
        this.errorMessage = [];
        this.isSuccess = -1;
        this.form.get('uploaddocumntfiles').setErrors(null);
    }
    clearCount() {
        this.approvedTotal = 0;
        this.modifiedTotal = 0;
        this.underTerminationTotal = 0;
    }
    getContainer() {
        if (this.selectedType === 'Upload Templates') {
            return 'fcs-document-template';
        }
        else if (this.selectedType === 'Upload Providers') {
            return 'fcs-document-provider';
        }
        else {
            return '';
        }
    }
    resetMessagesAndCounts() {
        this.valMessage = [];
        this.message = [];
        this.totalMessage = [];
        this.errorMessage = [];
        this.isSuccess = -1;
        this.clearCount();
    }
    isFileNameValid(name) {
        return name.startsWith("AppLevy provider variation template");
    }
    isFileTypeValid(name) {
        return name.endsWith('.xlsx');
    }
    isFileSizeValid(size) {
        const maxSizeInBytes = this.uploadFileSizeLimit * 1024 * 1024; // 2 MB
        return size <= maxSizeInBytes;
    }
    handleValidationError(messages) {
        this.uploadStatus = { status: false, msg: messages.join(' ') };
        this.valMessage.push(...messages);
        this.form.get('uploaddocumntfiles').setErrors({ invalid: true });
    }
    validateFiles() {
        this.clearMessages();
        if (this.selectedFiles) {
            const pFileList = this.selectedFiles;
            let validationErrors = [];
            this.isProcessing = true;
            this.progressPercentage = 0;
            if (this.selectedType === 'Upload Providers') {
                this.validateFile(pFileList, validationErrors);
            }
            if (validationErrors.length > 0) {
                this.handleValidationError(validationErrors);
                this.isValidationSuccess = false;
            }
            else {
                this.isValidationSuccess = true;
            }
            this.isProcessing = false;
        }
    }
    validateFile(pFileList, validationErrors) {
        if (pFileList) {
            this.kbFile = pFileList[0];
            this.resetMessagesAndCounts();
            let stepsCompleted = 0;
            const totalSteps = 3; // Adjust based on the number of validation steps
            if (!this.isFileNameValid(this.kbFile.name)) {
                validationErrors.push('Please upload correct file name');
            }
            this.updateProgress(++stepsCompleted, totalSteps);
            if (!this.isFileTypeValid(this.kbFile.name)) {
                validationErrors.push('Please upload MS Excel document only with .xlsx format');
            }
            this.updateProgress(++stepsCompleted, totalSteps);
            if (!this.isFileSizeValid(this.kbFile.size)) {
                validationErrors.push('File size exceeds the limit.');
            }
            this.updateProgress(++stepsCompleted, totalSteps);
            if (validationErrors.length > 0) {
                this.handleValidationError(validationErrors);
                return;
            }
            this.readAndValidateFileContent(this.kbFile);
        }
    }
    updateProgress(stepsCompleted, totalSteps) {
        this.progressPercentage = Math.round((stepsCompleted / totalSteps) * 100);
    }
    readAndValidateFileContent(file) {
        const reader = new FileReader();
        reader.readAsArrayBuffer(file);
        reader.onload = () => {
            const binaryStr = reader.result;
            const wb = XLSX.read(binaryStr, { type: 'binary' });
            const wsname = wb.SheetNames[0];
            const ws = wb.Sheets[wsname];
            const headers = this.extractHeaders(ws);
            let validationErrors = [];
            if (!this.areHeadersValid(headers)) {
                validationErrors.push('Mandatory headers are missing or unnecessary headers are present');
            }
            const data = XLSX.utils.sheet_to_json(ws);
            this.items = this.bindDataToProviderCollection(data);
            const blankEntriesRow = this.findBlankEntriesRows(data);
            if (blankEntriesRow) {
                validationErrors.push('We have found blank details against the entries in row(s) ' + blankEntriesRow + ' please verify and reupload the document.');
            }
            // Additional validation check for statuses
            const validSubStatuses = ['Approved', 'Modified', 'UnderTermination'];
            const invalidRows = data.filter(row => row['Contract Status'] !== 'Approved' || !validSubStatuses.includes(row['Sub Status']));
            if (invalidRows.length > 0) {
                validationErrors.push('Invalid Contract Status or Sub Status found. Contract Status must be "Approved" and Sub Status must be one of "Approved", "Modified", or "UnderTermination".');
            }
            if (validationErrors.length > 0) {
                this.handleValidationError(validationErrors);
                return;
            }
            this.applevyService.getFiles(this.containerName).subscribe(files => {
                const mandatoryFiles = ['T&C_LEVY_2017-05-01.docx', 'T&C_LEVY_2017-05-01_UT.docx'];
                const docxExists = {
                    'LEVY1799_Amendment.docx': files.some(file => file.Name === 'LEVY1799_Amendment.docx'),
                    'LEVY1799_Amendment_Modified.docx': files.some(file => file.Name === 'LEVY1799_Amendment_Modified.docx'),
                    'LEVY1799_Amendment_UnderTerm.docx': files.some(file => file.Name === 'LEVY1799_Amendment_UnderTerm.docx'),
                    'T&C_LEVY_2017-05-01_UT.docx': files.some(file => file.Name === 'T&C_LEVY_2017-05-01_UT.docx'),
                    'T&C_LEVY_2017-05-01.docx': files.some(file => file.Name === 'T&C_LEVY_2017-05-01.docx'),
                };
                if (mandatoryFiles.some(file => !docxExists[file])) {
                    validationErrors.push('Mandatory files are missing: T&C_LEVY_2017-05-01.docx and/or T&C_LEVY_2017-05-01_UT.docx');
                }
                if (data.some(row => row['Contract Status'] === 'Approved' && row['Sub Status'] === 'Approved') && !docxExists['LEVY1799_Amendment.docx']) {
                    validationErrors.push('The required .docx file "LEVY1799_Amendment.docx" does not exist.');
                }
                if (data.some(row => row['Contract Status'] === 'Approved' && row['Sub Status'] === 'Modified') && !docxExists['LEVY1799_Amendment_Modified.docx']) {
                    validationErrors.push('The required .docx file "LEVY1799_Amendment_Modified.docx" does not exist.');
                }
                if (data.some(row => row['Contract Status'] === 'Approved' && row['Sub Status'] === 'UnderTermination') && !docxExists['LEVY1799_Amendment_UnderTerm.docx']) {
                    validationErrors.push('The required .docx file "LEVY1799_Amendment_UnderTerm.docx" does not exist.');
                }
                // Check for concatenated file names
                const missingFiles = [];
                data.forEach(row => {
                    const contractNumber = row['Contract No'];
                    let baseFileName = '';
                    if (row['Contract Status'] === 'Approved' && row['Sub Status'] === 'Approved') {
                        baseFileName = `LEVY1799_Amendment_${contractNumber}`;
                    }
                    else if (row['Contract Status'] === 'Approved' && row['Sub Status'] === 'Modified') {
                        baseFileName = `LEVY1799_Amendment_Modified_${contractNumber}`;
                    }
                    else if (row['Contract Status'] === 'Approved' && row['Sub Status'] === 'UnderTermination') {
                        baseFileName = `LEVY1799_Amendment_UnderTerm_${contractNumber}`;
                    }
                    if (row['Letter Bespoke Required'] === 'Y' && !files.some(file => file.Name === `${baseFileName}.docx`)) {
                        missingFiles.push(`${baseFileName}.docx`);
                    }
                    if (row['T&C Bespoke Required'] === 'Y') {
                        const tcFileName = `T&C_LEVY_2017-05-01${row['Sub Status'] === 'UnderTermination' ? '_UT' : ''}_${contractNumber}.docx`;
                        if (!files.some(file => file.Name === tcFileName)) {
                            missingFiles.push(tcFileName);
                        }
                    }
                });
                if (missingFiles.length > 0) {
                    validationErrors.push('The following bespoke files are missing: ' + missingFiles.join(', '));
                }
                if (validationErrors.length > 0) {
                    this.handleValidationError(validationErrors);
                }
                else {
                    this.processDataEntries(data);
                }
            }, error => {
                console.error('Error retrieving files:', error);
                this.handleValidationError(['Error checking for the required .docx files.']);
            });
        };
    }
    extractHeaders(ws) {
        const headers = [];
        const columnCount = XLSX.utils.decode_range(ws['!ref'] || '').e.c + 1;
        for (let i = 0; i < columnCount; ++i) {
            headers[i] = ws[`${XLSX.utils.encode_col(i)}1`].v;
        }
        return headers;
    }
    areHeadersValid(headers) {
        for (const headerVal of headers) {
            if (!this.totalHeaders.map(x => x.toLocaleLowerCase()).includes(headerVal.toLocaleLowerCase())) {
                return false;
            }
        }
        return true;
    }
    bindDataToProviderCollection(data) {
        return data.map((row) => ({
            contractNumber: row['Contract No'],
            contractStatus: row['Contract Status'],
            contractSubStatus: row['Sub Status'],
            isletterBespoke: row['Letter Bespoke Required'],
            isTnCBespoke: row['T&C Bespoke Required']
        }));
    }
    findBlankEntriesRows(data) {
        let blankEntriesRow = '';
        let rowCount = 1;
        for (const row of data) {
            if (!this.mandatoryHeaderKeyCheck(row)) {
                blankEntriesRow += rowCount + ', ';
            }
            rowCount++;
        }
        return blankEntriesRow;
    }
    processDataEntries(data) {
        let rowCount = 0;
        let crmData = [];
        let invalidContracts = [];
        let missingInCrmContracts = [];
        this.applevyService.getLatestContractInformationByFundingTypeAndFundingPeriod('LEVY', 'LEVY1799').subscribe(crmContracts => {
            crmData = crmContracts;
            for (const row of data) {
                const contractNumber = parseInt(row['Contract No'].split('-').pop(), 10);
                if (contractNumber < 5000) {
                    invalidContracts.push(row);
                    continue;
                }
                if (row["Sub Status"] == "Approved")
                    this.approvedTotal++;
                if (row["Sub Status"] == "Modified")
                    this.modifiedTotal++;
                if (row["Sub Status"] == "UnderTermination")
                    this.underTerminationTotal++;
                rowCount++;
            }
            const mismatchedContracts = data.filter(excelRow => {
                const contractNumber = parseInt(excelRow['Contract No'].split('-').pop(), 10);
                if (contractNumber < 5000)
                    return false;
                const crmContract = crmData.find(crmRow => crmRow.ContractNumber === excelRow['Contract No']);
                return crmContract && crmContract.ContractSubStatus !== excelRow['Sub Status'];
            });
            missingInCrmContracts = data.filter(excelRow => {
                const contractNumber = parseInt(excelRow['Contract No'].split('-').pop(), 10);
                if (contractNumber < 5000)
                    return false;
                const crmContract = crmData.find(crmRow => crmRow.ContractNumber === excelRow['Contract No']);
                return !crmContract;
            });
            if (invalidContracts.length > 0) {
                this.valMessage.push(`Contracts with invalid numbers (less than 5000):`);
                invalidContracts.forEach(contract => {
                    this.valMessage.push(`Contract Number: ${contract['Contract No']}`);
                });
            }
            // Display mismatched contracts
            if (mismatchedContracts.length > 0) {
                this.valMessage.push(`Mismatched contracts:`);
                mismatchedContracts.forEach(contract => {
                    const crmContract = crmData.find(crmRow => crmRow.ContractNumber === contract['Contract No']);
                    this.valMessage.push(`Contract Number: ${contract['Contract No']}, Excel Sub Status: ${contract['Sub Status']}, CRM Sub Status: ${crmContract.ContractSubStatus}`);
                });
            }
            // Display contracts present in Excel but not in CRM
            if (missingInCrmContracts.length > 0) {
                this.valMessage.push(`Contracts present in Excel but not in CRM:`);
                missingInCrmContracts.forEach(contract => {
                    this.valMessage.push(`Contract Number: ${contract['Contract No']}`);
                });
            }
            // Display total counts only if there are no mismatches, no invalid contracts, and no missing contracts
            if (mismatchedContracts.length === 0 && invalidContracts.length === 0 && missingInCrmContracts.length === 0) {
                if (this.approvedTotal > 0 || this.modifiedTotal > 0 || this.underTerminationTotal > 0) {
                    this.totalMessage.push(`APPLEVY Contract Providers Total: ${rowCount}`);
                    this.totalMessage.push(`Approved-Approved: ${this.approvedTotal}`);
                    this.totalMessage.push(`Approved-Modified: ${this.modifiedTotal}`);
                    this.totalMessage.push(`Approved-UnderTermination: ${this.underTerminationTotal}`);
                }
            }
        }, error => {
            console.error('Error fetching CRM data:', error);
            this.handleValidationError(['Error fetching CRM data.']);
        });
    }
    mandatoryHeaderKeyCheck(row) {
        const rowKeys = Object.keys(row);
        for (const headerVal of this.mandatoryHeaders) {
            if (!rowKeys.map(y => y.toLocaleLowerCase()).includes(headerVal.toLocaleLowerCase())) {
                return false;
            }
            if (!row[headerVal].toString().trim()) {
                return false;
            }
        }
        return true;
    }
    selectCheckBox() {
        this.clearMessages();
        this.selectedFiles = null;
        this.isFileSelected = false;
        this.isValidationSuccess = false;
        this.form.get('uploaddocumntfiles').reset();
        if (this.form.get('useExistingTemplates').value) {
            this.form.get('uploaddocumntfiles').enable();
        }
        else {
            this.form.get('uploaddocumntfiles').disable();
        }
    }
    uploadFiles() {
        if (this.isUploading)
            return;
        this.isUploading = true;
        this.clearMessages();
        if (this.selectedFiles) {
            const containerName = this.getContainer();
            for (let i = 0; i < this.selectedFiles.length; i++) {
                this.upload(this.selectedFiles[i], containerName);
            }
        }
        this.isUploading = false;
    }
    upload(file, containerName) {
        if (file) {
            console.log('Uploading file:', file.name);
            this.uploadService.upload(file, containerName).subscribe({
                next: (event) => {
                    if (event instanceof HttpResponse) {
                        const fileUrl = event.body.FileUrl;
                        const msg = file.name + ": upload successful!";
                        if (file.name.endsWith('.xlsx') || file.name.endsWith('.csv')) {
                            Swal.fire({
                                title: 'Upload Successful!',
                                text: 'Provider upload successful. Do you want to proceed to create a release?',
                                icon: 'success',
                                showCancelButton: true,
                                confirmButtonText: 'Yes, create release',
                                cancelButtonText: 'No, cancel',
                                customClass: {
                                    popup: 'swal2-popup',
                                    title: 'swal2-title',
                                    htmlContainer: 'swal2-content'
                                }
                            }).then((result) => {
                                if (result.isConfirmed) {
                                    this.openReleasePopup(fileUrl);
                                }
                                else {
                                    this.message.push('Release creation cancelled.');
                                }
                            });
                        }
                        else {
                            this.getFiles();
                            this.message.push(msg);
                            this.isSuccess = 1;
                        }
                    }
                },
                error: (err) => {
                    let msg = file.name + ": upload unsuccessful!";
                    if (err.error && err.error.message) {
                        msg += " " + err.error.message;
                    }
                    this.errorMessage.push(msg);
                    this.isSuccess = 0;
                }
            });
        }
    }
    openReleasePopup(fileUrl) {
        console.log('Opening release popup');
        if (this.releasePopup) {
            this.releasePopup.openPopup(fileUrl);
        }
        else {
            console.error('ReleasePopupComponent not found');
        }
    }
    fetchReleases() {
        this.releaseService.getReleases().subscribe(data => {
            console.log('Fetched releases:', data);
            // Handle the fetched release data as needed
        });
    }
    getFiles() {
        this.applevyService.getFiles(this.containerName).subscribe(files => {
            const now = new Date();
            const sevenDaysAgo = new Date(now.setDate(now.getDate() - 360));
            this.files = files.filter(file => file.Name.includes('LEVY') &&
                !file.Name.includes('NONLEVY') &&
                new Date(file.UploadDate) >= sevenDaysAgo);
            console.log('Filtered files:', this.files);
            this.latestUploadDate = this.getLatestUploadDate();
            this.totalPages = Math.ceil(this.files.length / this.itemsPerPage);
            this.updatePaginatedFiles();
        }, error => {
            console.error('Error:', error);
            this.errorMessage.push(error);
        });
    }
    updatePaginatedFiles() {
        const startIndex = (this.currentPage - 1) * this.itemsPerPage;
        const endIndex = startIndex + this.itemsPerPage;
        this.paginatedFiles = this.files.slice(startIndex, endIndex);
    }
    previousPage() {
        if (this.currentPage > 1) {
            this.currentPage--;
            this.updatePaginatedFiles();
        }
    }
    nextPage() {
        if (this.currentPage < this.totalPages) {
            this.currentPage++;
            this.updatePaginatedFiles();
        }
    }
    getLatestUploadDate() {
        return this.files.reduce((latest, file) => {
            return new Date(file.UploadDate) > latest ? new Date(file.UploadDate) : latest;
        }, new Date(0));
    }
    fileTypeValidator(control) {
        const file = control.value;
        if (file) {
            const extension = file.split('.').pop().toLowerCase();
            const allowedExtensions = ['docx', 'doc', 'xlsx', 'csv'];
            if (!allowedExtensions.includes(extension)) {
                return { invalidFileType: true };
            }
        }
        return null;
    }
    fileSizeValidator(files) {
        const maxSizeInBytes = 5 * 1024 * 1024; // 5 MB
        let inValidSize = false;
        Array.from(files).forEach((file) => {
            if (file.size > maxSizeInBytes) {
                const msg = `File Name ${file.name} exceeds the size limit of 5 MB.`;
                this.errorMessage.push(msg);
                inValidSize = true;
            }
        });
        return inValidSize;
    }
    clear() {
        this.selectedFiles = null;
        this.totalMessage = [];
        this.form.get('uploaddocumntfiles').reset();
    }
    onSubmitDocument(event) {
        event.preventDefault();
        this.clearMessages();
        if (this.form.valid) {
            this.submitted = true;
            this.uploadFiles();
        }
        this.form.get('uploaddocumntfiles').reset();
        this.selectedFiles = null;
        this.isValidationSuccess = false;
        this.isFileSelected = false;
    }
    ondropdownChange(event) {
        this.clearMessages();
        this.selectedType = event.target.value;
        this.form.get('uploaddocumntfiles').reset();
        this.selectedFiles = null;
        this.clearCount();
        this.form.get('useExistingTemplates').reset();
        if (this.selectedType === 'Upload Providers') {
            this.form.get('uploaddocumntfiles').disable();
            this.form.get('useExistingTemplates').valueChanges.subscribe(value => {
                if (value) {
                    this.form.get('uploaddocumntfiles').enable();
                }
                else {
                    this.form.get('uploaddocumntfiles').disable();
                }
            });
        }
        else {
            this.form.get('uploaddocumntfiles').enable();
        }
    }
    checkWebJobStatus() {
        this.webJobService.getStatus().subscribe((status) => {
            this.isWebJobEnabled = status;
            this.isEnabled = status;
        }, error => {
            console.error('Error fetching WebJob status', error);
            this.errorMessage.push('Error fetching WebJob status: ' + error.message);
        });
    }
    confirmToggle(event) {
        const checkbox = event.target;
        const originalState = checkbox.checked;
        if (!this.isAuthorized) {
            Swal.fire({
                title: 'Permission Denied',
                text: 'You do not have permission to enable/disable the job.',
                icon: 'error',
                confirmButtonText: 'OK',
                customClass: {
                    popup: 'swal2-popup',
                    title: 'swal2-title',
                    htmlContainer: 'swal2-content'
                }
            });
            checkbox.checked = !originalState;
            return;
        }
        // Temporarily revert the checkbox state to prevent premature toggling
        checkbox.checked = !originalState;
        Swal.fire({
            title: 'Confirm Action',
            text: 'Do you want to enable/disable the job?',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonText: 'Yes, proceed',
            cancelButtonText: 'No, cancel',
            customClass: {
                popup: 'swal2-popup',
                title: 'swal2-title',
                htmlContainer: 'swal2-content'
            }
        }).then((result) => {
            if (result.isConfirmed) {
                this.toggleWebJob(originalState);
            }
            else {
                checkbox.checked = !originalState;
            }
        });
    }
    toggleWebJob(newState) {
        this.isEnabled = newState;
        if (this.isEnabled) {
            this.webJobService.enableWebJob().subscribe(() => {
                console.log('WebJob enabled');
                window.location.reload();
            }, error => {
                console.error('Error enabling WebJob', error);
                this.errorMessage.push('Error enabling WebJob: ' + error.message);
                this.isEnabled = false;
            });
        }
        else {
            this.webJobService.disableWebJob().subscribe(() => {
                console.log('WebJob disabled');
                window.location.reload();
            }, error => {
                console.error('Error disabling WebJob', error);
                this.errorMessage.push('Error disabling WebJob: ' + error.message);
                this.isEnabled = true;
            });
        }
    }
    debounce(func, wait) {
        let timeout;
        return function (...args) {
            clearTimeout(timeout);
            timeout = setTimeout(() => func.apply(this, args), wait);
        };
    }
};
__decorate([
    ViewChild(ReleasePopupComponent),
    __metadata("design:type", ReleasePopupComponent)
], ApprenticeshipLevyComponent.prototype, "releasePopup", void 0);
__decorate([
    ViewChild('uploaderLoader', { static: false }),
    __metadata("design:type", ElementRef)
], ApprenticeshipLevyComponent.prototype, "uploaderLoaderRef", void 0);
ApprenticeshipLevyComponent = __decorate([
    Component({
        selector: 'app-apprenticeship-levy',
        templateUrl: './apprenticeship-levy.component.html',
        styleUrls: ['./apprenticeship-levy.component.css']
    }),
    __metadata("design:paramtypes", [ApprenticeshipLevyService,
        ChangeDetectorRef,
        UntypedFormBuilder,
        FileUploadService,
        ApplevyVariationService,
        ErrorHandlingService,
        ReleaseService])
], ApprenticeshipLevyComponent);
export { ApprenticeshipLevyComponent };
//# sourceMappingURL=apprenticeship-levy.component.js.map