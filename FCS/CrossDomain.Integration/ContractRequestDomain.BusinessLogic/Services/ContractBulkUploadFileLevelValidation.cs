using SFA.FCT.ContractRequestDomain.BusinessLogic.Validation;

namespace SFA.FCT.ContractRequestDomain.BusinessLogic.Services
{
    using System;
    using System.Collections.Generic;
    using System.Globalization;
    using System.IO;
    using System.Linq;
    using Common;
    using CrossDomain.Integration.Common;
    using CrossDomain.Integration.Entities.Data;
    using CrossDomain.Integration.Entities.ExcelUpload;
    using CrossDomain.Integration.OverrideDate.DataStore.Services;
    using DataStore.Repositories;
    using Framework.Logging.Interfaces;
    using Interfaces;
    using Validation.UDC;
    
    public class ContractBulkUploadFileLevelValidation : IContractBulkUploadFileLevelValidation
    {
        private const string FileFormatType = ".xlsx";
        private  List<errorInfo> _errors = new List<errorInfo>();
        private readonly IFundingTypeFundingPeriodRepository _fundingTypeFundingPeriodRepository;
        private readonly IFundingAllocationReleaseRepository _fundingAllocationReleaseRepository;
        private readonly IDateProvider _dateProvider;
        private readonly ILogger _logger;

        public ContractBulkUploadFileLevelValidation(IFundingTypeFundingPeriodRepository fundingTypeFundingPeriodRepository, IDateProvider dateProvider, IFundingAllocationReleaseRepository fundingAllocationReleaseRepository, ILogger logger)
        {
            _fundingTypeFundingPeriodRepository = fundingTypeFundingPeriodRepository;
            _dateProvider = dateProvider;
            _fundingAllocationReleaseRepository = fundingAllocationReleaseRepository;
            _logger = logger;
        }

        public  List<errorInfo> Errors
        {
            get { return _errors; }
            set { _errors  = value; }
        }

        public bool Validate(dataLoadResults dataLoadResults, ConnectionInfo connectionInfo)
        {
            return ValidateFile(dataLoadResults, connectionInfo);
        }

        public bool ValidateFile(dataLoadResults file, ConnectionInfo connectionInfo)
        {
            if (file.error != null)
            {
                return false;
            }

            // FSR_004_ValidateFileStructure(file);
            ContractBulkUpload validationFile = new ContractBulkUpload(file);

            FSR_001_ValidateFileType(file.fileName);

            FSR_002_ValidateFileName(file.fileName, validationFile.ControlSheet.row.First());

            FSR_005a_ValidateFileNameFundingType(file.fileName, validationFile.ControlSheet.row.First());

            FSR_005b_ValidateFileNamePeriodType(file.fileName, validationFile.ControlSheet.row.First());

            FSR_005c_ValidateFileNamePeriod(file.fileName, validationFile.ControlSheet.row.First());

            FSR_006_ValidateFundingType(validationFile.ControlSheet, file.ReferenceData.FundingConfiguration);

            FSR_007_ValidatePeriodTypeCode(validationFile.ControlSheet, file.ReferenceData.FundingConfiguration);

            FSR_008_ValidatePeriod(validationFile.ControlSheet, file.ReferenceData.FundingConfiguration);

            FSR_009_ValidateTypeCombination(validationFile.ControlSheet, file.ReferenceData.FundingConfiguration);

            FSR_011_ValidateFundingTypePeriodIsNotClosed(validationFile.ControlSheet, connectionInfo);
            FSR_012_ValidateFundingAllocationInProgress(validationFile.ControlSheet, connectionInfo);

            ValidateContractDataExists(validationFile.ContractSheet);

            // CABR-013
            _errors.AddRange(new TenderAwardRefMustBeUniqueAmongstFilesEsfAllocations().GetFailureForItem(file));

            // UDC-006
            _errors.AddRange(new MustSpecifyDeliverableDetailsUpdateRule().GetFailureForItem(file));

            // UDC-008
            _errors.AddRange(new MustSpecifyDeliverableDetailsDeleteRule().GetFailureForItem(file));
            
            // UDC-017
            _errors.AddRange(new ContractAllocationMustHaveRelatedContractRule().GetFailureForItem(file));

            // UDC-017b
            _errors.AddRange(new ContractAllocationMustHaveRelatedContractBRule().GetFailureForItem(file));

            // UDC-018
            _errors.AddRange(new DeliverableMustHaveRelatedContractRule().GetFailureForItem(file));

            // UDC-018b
            _errors.AddRange(new DeliverableMustHaveRelatedContractBRule().GetFailureForItem(file));

            file.error = _errors.ToArray();
            System.Diagnostics.Trace.TraceInformation("File Level Validation passed = " + !Errors.Any());
            return !_errors.Any();
        }

        /// <summary>
        /// Validates that the combination of Funding Type, Period Type and Period are all compatible with each other.
        /// </summary>
        /// <param name="controlSheet"></param>
        /// <param name="referenceData"></param>
        /// <returns></returns>
        public bool FSR_009_ValidateTypeCombination(sheetType controlSheet, FundingConfigurationType referenceData)
        {
            string fundingTypeCode = controlSheet.row.First().cell.First(c => c.columnName.Equals(ContractBulkUpload.ControlSheetFundingTypeCode)).Value;
            string periodTypeCode = controlSheet.row.First().cell.First(c => c.columnName.Equals(ContractBulkUpload.ControlSheetPeriodTypeCode)).Value;
            string period = controlSheet.row.First().cell.First(c => c.columnName.Equals(ContractBulkUpload.ControlSheetPeriod)).Value;

            if (!referenceData.FundingConfigurationList.Any(f => f.FundingTypeCode == fundingTypeCode && f.PeriodTypeCode == periodTypeCode && f.Period == period))
            {
                _errors.Add(new errorInfo { Value = ErrorMessages.TypeCombinationInvalidMessage });
                return false;
            }

            return true;
        }

        /// <summary>
        /// Validates the structure of the input file.
        /// The file should contain a Control Sheet, a Contract Sheet, a Contract Allocations Sheet and a Deliverables Sheet.
        /// </summary>
        /// <param name="file"></param>
        /// <returns></returns>
        public bool FSR_004_ValidateFileStructure(dataLoadResults file)
        {
            ContractBulkUpload validate = new ContractBulkUpload(file);
            if (validate.ControlSheet == null || validate.ContractSheet == null
                 || validate.ContractAllocationSheet == null || validate.ContractDeliverableSheet == null)
            {
                _errors.Add(new errorInfo { Value = ErrorMessages.FileStructureInvalidMessage });
                return false;
            }

            return true;
        }

        /// <summary>
        /// Validates the file type is valid.
        /// Only .xlsx format files are allowed.
        /// </summary>
        /// <param name="filename"></param>
        /// <returns></returns>
        public bool FSR_001_ValidateFileType(string filename)
        {
            if (Path.GetExtension(filename) != FileFormatType)
            {
                _errors.Add(new errorInfo { Value = ErrorMessages.FileTypeInvalidMessage });
                return false;
            }

            return true;
        }

        /// <summary>
        /// Checks that the specified file name is valid.
        /// Format of Bulk Import file name is Funding Type Code 'space' Period Type Code 'space' Period 'space' ddmmyyyyhhmmss 'space' freeformat_description_without_spaces e.g. MAIN AY 1516 12012015202601 file_1a.xlsx
        /// </summary>
        /// <param name="filename">Filename specified</param>
        /// <param name="controlSheet">The control sheet element taken from the xml</param>
        /// <returns></returns>
        public bool FSR_002_ValidateFileName(string filename, rowType controlSheet)
        {
            bool error = false;
            filename = filename.Replace(FileFormatType, string.Empty);
            filename = filename.TrimEnd(' ');
            var filenameSections = filename.Split(' ');
            if (filenameSections.Count() != 5)
            {
                error = true;
            }
            else
            {
                DateTime validDate;
                if (!DateTime.TryParseExact(filenameSections[3], "ddMMyyyyHHmmss", CultureInfo.InvariantCulture, DateTimeStyles.None, out validDate))
                {
                    error = true;
                }
            }

            if (error)
            {
                // create error and add to list.
                _errors.Add(new errorInfo { Value = ErrorMessages.FileNameInvalidMessage });
                return false;
            }

            return true;
        }

        /// <summary>
        /// Checks that the specified file name funding type is valid.
        /// The Funding type in the file name matches the funding type in the control sheet.
        /// </summary>
        /// <param name="filename">Filename specified</param>
        /// <param name="controlSheet">The control sheet element taken from the xml</param>
        /// <returns></returns>
        public bool FSR_005a_ValidateFileNameFundingType(string filename, rowType controlSheet)
        {
            string fundingTypeCode = controlSheet.GetCellValue(ContractBulkUpload.ControlSheetFundingTypeCode);

            var filenameSections = filename.Split(' ');
            if (filenameSections.Count() < 5 || filenameSections[0] != fundingTypeCode)
            {
                // create error and add to list.
                _errors.Add(new errorInfo { Value = ErrorMessages.FileNameFundingTypeInvalidMessage });
                return false;
            }

            return true;
        }

        /// <summary>
        /// Checks that the specified file name period type is valid.
        /// The period type in the file name matches the period type in the control sheet.
        /// </summary>
        /// <param name="filename">Filename specified</param>
        /// <param name="controlSheet">The control sheet element taken from the xml</param>
        /// <returns></returns>
        public bool FSR_005b_ValidateFileNamePeriodType(string filename, rowType controlSheet)
        {
            string periodTypeCode = controlSheet.GetCellValue(ContractBulkUpload.ControlSheetPeriodTypeCode);
            var filenameSections = filename.Split(' ');
            if (filenameSections.Count() < 5 || filenameSections[1] != periodTypeCode)
            {
                // create error and add to list.
                _errors.Add(new errorInfo { Value = ErrorMessages.FileNamePeriodTypeInvalidMessage });
                return false;
            }

            return true;
        }

        /// <summary>
        /// Checks that the specified file name period is valid.
        /// The period in the file name matches the period in the control sheet.
        /// </summary>
        /// <param name="filename">Filename specified</param>
        /// <param name="controlSheet">The control sheet element taken from the xml</param>
        /// <returns></returns>
        public bool FSR_005c_ValidateFileNamePeriod(string filename, rowType controlSheet)
        {
            string period = controlSheet.GetCellValue(ContractBulkUpload.ControlSheetPeriod);
            var filenameSections = filename.Split(' ');
            if (filenameSections.Count() < 5 || filenameSections[2] != period)
            {
                // create error and add to list.
                _errors.Add(new errorInfo { Value = ErrorMessages.FileNamePeriodInvalidMessage });
                return false;
            }

            return true;
        }

        /// <summary>
        /// Checks that the Funding Type being used in the control sheet is a valid funding type.
        /// </summary>
        /// <param name="controlSheet">The control sheet element taken from the xml</param>
        /// <param name="referenceData">The collection of valid reference data from the xml.</param>
        /// <returns></returns>
        public bool FSR_006_ValidateFundingType(sheetType controlSheet, FundingConfigurationType referenceData)
        {
            string controlType = controlSheet.row.First().GetCellValue(ContractBulkUpload.ControlSheetFundingTypeCode);
            if (!referenceData.FundingConfigurationList.Any(f => f.FundingTypeCode.Equals(controlType)))
            {
                _errors.Add(new errorInfo { Value = ErrorMessages.FundingTypeCodeInvalidMessage, sheet = controlSheet.name, row = controlSheet.row.First().rowNumber });
                return false;
            }

            return true;
        }

        /// <summary>
        /// Checks that the period type specified is valid.
        /// </summary>
        /// <param name="controlSheet">The control sheet element taken from the xml</param>
        /// <param name="referenceData">The collection of valid reference data from the xml.</param>
        /// <returns></returns>
        public bool FSR_007_ValidatePeriodTypeCode(sheetType controlSheet, FundingConfigurationType referenceData)
        {
            string controlType = controlSheet.row.First().GetCellValue(ContractBulkUpload.ControlSheetPeriodTypeCode);
            if (!referenceData.FundingConfigurationList.Any(p => p.PeriodTypeCode.Equals(controlType)))
            {
                _errors.Add(new errorInfo { Value = ErrorMessages.PeriodTypeCodeInvalidMessage, sheet = controlSheet.name, row = controlSheet.row.First().rowNumber });
                return false;
            }

            return true;
        }

        /// <summary>
        /// Checks that the period specified is valid.
        /// </summary>
        /// <param name="controlSheet">The control sheet element taken from the xml</param>
        /// <param name="referenceData">The collection of valid reference data from the xml.</param>
        /// <returns></returns>
        public bool FSR_008_ValidatePeriod(sheetType controlSheet, FundingConfigurationType referenceData)
        {
            const int rowNumber = 0;
            string controlType = controlSheet.row[rowNumber].GetCellValue(ContractBulkUpload.ControlSheetPeriod);
            if (!referenceData.FundingConfigurationList.Any(p => p.Period.Equals(controlType)))
            {
                _errors.Add(new errorInfo { Value = ErrorMessages.PeriodInvalidMessage, sheet = controlSheet.name, row = controlSheet.row[rowNumber].rowNumber });
                return false;
            }

            return true;
        }

        /// <summary>
        /// Checks that there is at least one row containing contract data.
        /// </summary>
        /// <param name="contractsSheet">The contract sheet.</param>
        /// <returns></returns>
        public bool ValidateContractDataExists(sheetType contractsSheet)
        {
            if (contractsSheet.row == null || !contractsSheet.row.Any())
            {
                _errors.Add(new errorInfo { Value = ErrorMessages.NoContractsDataMessage });
                return false;
            }

            return true;
        }

        public void FSR_011_ValidateFundingTypePeriodIsNotClosed(sheetType controlSheet, ConnectionInfo connectionInfo)
        {
            rowType firstRow = controlSheet.row[0];

            string fundingType = firstRow.GetCellValue(ContractBulkUpload.ControlSheetFundingTypeCode);
            string periodType = firstRow.GetCellValue(ContractBulkUpload.ControlSheetPeriodTypeCode);
            string period = firstRow.GetCellValue(ContractBulkUpload.ControlSheetPeriod);
            string fundingPeriodName = $"{periodType}{period}";

            DateTime? activityCloseDate = _fundingTypeFundingPeriodRepository
                .GetActivityCloseDate(fundingType, fundingPeriodName);

            if (_dateProvider.GetDate(connectionInfo).Date > activityCloseDate)
            {
                _errors.Add(new errorInfo { Value = ErrorMessages.ContractingActivityHasClosedForFundingTypePeriod});
            }
        }

        public void FSR_012_ValidateFundingAllocationInProgress(sheetType controlSheet, ConnectionInfo connectionInfo)
        {
            rowType firstRow = controlSheet.row[0];

            string fundingType = firstRow.GetCellValue(ContractBulkUpload.ControlSheetFundingTypeCode);
            string periodType = firstRow.GetCellValue(ContractBulkUpload.ControlSheetPeriodTypeCode);
            string period = firstRow.GetCellValue(ContractBulkUpload.ControlSheetPeriod);
            string fundingPeriodName = $"{periodType}{period}";

            bool isFundingAllocationReleaseInProgress = _fundingAllocationReleaseRepository.IsReleaseInProgress(fundingTypeCode: fundingType,
                fundingPeriod: fundingPeriodName, connectionInfo: connectionInfo);


            _logger.LogInformation(1, $"FSR_012_ValidateFundingAllocationInProgress:{fundingType}, fundingPeriod: {fundingPeriodName}, isFundingAllocationReleaseInProgress: {isFundingAllocationReleaseInProgress}");

            if (isFundingAllocationReleaseInProgress)
            {
                _errors.Add(new errorInfo { Value = "Release of funding allocations from Contract Control is in progress for the same Funding Type Period" });
            }
        }
    }
}