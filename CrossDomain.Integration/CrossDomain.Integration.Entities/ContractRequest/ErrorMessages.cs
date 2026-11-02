namespace SFA.FCT.ContractRequestDomain.Common
{
    public class ErrorMessages
    {
        public const string ReplaceString = "<Data Item>";

        // File Level Validation Error Messages. 
        public const string FundingTypeCodeInvalidMessage = "Funding type specified is not a valid funding type.";
        public const string PeriodTypeCodeInvalidMessage = "Period type specified is not a valid Period type.";
        public const string PeriodInvalidMessage = "Period specified is not a valid Period.";
        public const string FileTypeInvalidMessage = "File type is not as expected. Expected file type is .xlsx";
        public const string FileNameInvalidMessage = "File name is not as expected";
        public const string FileStructureInvalidMessage = "File structure is not as expected. File structure expected as per 'Bulk Import File Specification'";
        public const string TypeCombinationInvalidMessage = "The combination of Funding Type, Period Type and Period is not a valid combination";
        public const string FileNameFundingTypeInvalidMessage = "Funding type code in file name should match the funding type code in the 'Control Sheet' tab";
        public const string FileNamePeriodTypeInvalidMessage = "Period type code in file name should match the Period type code in the 'Control Sheet' tab";
        public const string FileNamePeriodInvalidMessage = "Period in file name should match the Period code in the 'Control Sheet' tab";
        public const string NoContractsDataMessage = "The file must contain at least 1 Contract entry";
        public const string ContractingActivityHasClosedForFundingTypePeriod = "Contracting activity has closed for this Funding Type Period";

        // CABR-013
        private const string CABR013CommonErrorMessage = "2 Contract Allocations cannot have the same Tender Award Reference within the Bulk Import file or the CRM system.";
        public const string TenderAwardRefMustBeUniqueAmongstFilesEsfAllocations = CABR013CommonErrorMessage;
        public const string TenderAwardReferenceMustBeUnique = CABR013CommonErrorMessage;
        public const string TenderAwardReferenceMustBeUniqueOrUnchanged = CABR013CommonErrorMessage;

        public const string ContractNumberMustBeSpecified = "A contract number must be specified when creating a Revised New contract";
        public const string ContractNumberMustExistInTheSystem = "A contract number must exist when creating a Revised New contract";
        public const string ContractNumberAndMasterMustBeSpecified = "A contract number and master contract number must be specified when creating a Revised New contract";
        public const string NoPreviousNonWithdrawnContractsAllowedForRevisedNewIntent = "Cannot create a 'Revised New' contract where all existing versions of a contract do not have a status of 'Withdrawn'";

        public const string ExistingContractDoesntExistForGivenNaturalKey = "Cannot create Contract Amendment or Revised New Contract as an existing contract for this given UKPRN cannot be found matching this Contract Number, Period and Funding Type.";

        // UDC-006
        public const string MustSpecifyDeliverableDetailsUpdateRule = "Cannot update the Deliverable without the Contract Allocation Number, Funding Stream Code and Deliverable Code for each Deliverable Period in the Contract Allocation.";

        // UDC-008
        public const string MustSpecifyDeliverableDetailsDeleteRule = "Cannot delete the Deliverable without the Contract Allocation Number, Funding Stream Code and Deliverable Code for each Deliverable Period in the Contract Allocation.";
        
        // UDC-017
        public const string ContractAllocationMustHaveRelatedContractRule = "Cannot update a draft Contract without an entry on the Contract tab for the Contract Allocation with a CRM Intent of 'Update Draft'.";

        // UDC-017b
        public const string ContractAllocationMustHaveRelatedContractBRule = "Cannot update a draft Contract without an entry on the Contract tab for the Contract Allocation with a CRM Intent of 'Update Draft Amendment'.";

        // UDC-018
        public const string DeliverableMustHaveRelatedContractRule = "Cannot update a draft Contract without an entry on the Contract Allocation tab for the Deliverable with a CRM Intent of 'Update Draft'.";

        // UDC-018b
        public const string DeliverableMustHaveRelatedContractBRule = "Cannot update a draft Contract without an entry on the Contract Allocation tab for the Deliverable with a CRM Intent of 'Update Draft Amendment'.";

        // Message Level Validation Error Messages. 
        public const string EndDateBeforeStartDateErrorMessage = "An end date cannot be before the start date.";
        public const string MandatoryItemMissingErrorMessage = "<Data Item> is a mandatory field and therefore can not be null as specified in 'Bulk Import File Specification'";
        public const string DataTypeInvalidErrorMessage = "<Data Item> is not as per expected data type as specified in 'Bulk Import File Specification'";
        public const string DataLengthInvalidErrorMessage = "<Data Item> is not as per expected length as specified in 'Bulk Import File Specification'";
        public const string ConditionalMandatoryItemMissingErrorMessage = "<Data Item> is a mandatory field for the funding type and therefore can not be null as specified in the 'Bulk Import File Specification'.";
        public const string UnexpectedConditionalItemErrorMessage = "<Data Item> is not expected for the funding stream and therefore should be null as specified in the 'Bulk Import File Specification'.";

        public const string CRMIntentInvalidErrorMessage = "CRM intent is not a valid value";
        public const string UkprnIsNotValid = "UKPRN is not a valid organisation";
        public const string UkprnIsNotActiveSoCannotCreate = "UKPRN is not an active organisation therefore a new Contract cannot be created for the UKPRN";
        public const string CrmIntentIsNotConsistent = "The CRM Intent must be New or New Amendment across the contract";
        public const string ContractTypeIsNotValidForContract = "Contract Type is not a valid contract";
        public const string AContractAlreadyExistsForTheUKPRNandPeriod = "A Contract already exists for the given UKPRN, Period and dates specified";
        public const string ANewContractMustHaveAmendmentNotSet = "A new contract variation must have an amendment type specified";
        public const string AContractNumberCannotBeSetForANewContract = "A contract number cannot be specified when creating a new contract";
        public const string AContractAmendmentMustHaveAnAmendmentType = "A contract amendment must have an amendment type specified";
        public const string StartAndEndDateCannotBeTheSameForTheContract = "Start and end date cannot be the same for the Contract";
        public const string CannotHaveMultipleRecordsForTheSameUkprn = "Multiple contracts exist for the given UKPRN within the file";
        public const string CannotHaveMultipleRecordsForTheSameUkprnForNewOrNewAmendmentIntentContracts = "Multiple contracts with an intent of 'New' or 'New Amendment' exist for the given UKPRN within the file";
        public const string NoDeleteOnApprovedContract = "Cannot delete a Contract Allocation/ Deliverable if there is already an existing Approved Contract ";
        public const string AnUpdateDraftAmendmentMustHaveAnAmendmentType = "An Update Draft Amendment must have an amendment type";
        public const string UpdateDraftContractMustNotHaveAnAmendmentType = "An Update Draft Contract must not have an amendment type";
        public const string ARevisedNewContractMustHaveAmendmentNotSet = "Amendent Type must be blank when creating a 'Revised New' contract";
        public const string DeliveryOrgPresentThenAllMustBeSpecified = "If Delivery Organisations are applicable, they must be specified against all Contract Allocations and Deliverables for the Contract";

        // Master Contract Error Messages.
        public const string MandatoryEntitiesNotFound = "A Master Contract must contain 'Master Contract', 'Contract', 'Contract Allocation' and Deliverables'  details in order to be created";
        public const string MasterContractAlreadyExists = "A Master Contract already exists for the given UKPRN and Period";
        public const string MasterContractNewCrmIntentError = "A Master Contract number cannot be specified when creating a new Master Contract";
        public const string MasterContractNewAmendmentCrmIntentError = "A valid Master Contract number must be specified if the CRM Intent is 'New Amendment'";
        public const string MasterContractAmendmentCrmIntentError = "A Master Contract number must be specified if the CRM Intent is 'Amendment'";
        public const string MasterContractAlreadyHasChildContractWithDraftStatusError = "This Master Contract cannot have more than one associated Contract in a draft status at the same time";

        // Allocation Error Messages.
        public const string AllocationStartAndEndDatesMatchError = "Start and end date cannot be the same for the Contract Allocation";
        public const string AllocationStartAndEndDatesNotSupplied = "Start and End date for the Contract Allocation must be specified for ESF, EOP and EOF funding types";
        public const string AllocationDuplicateFieldsError = "2 Contract Allocations cannot have the same Tender Spec Reference, Lot Reference and Tender Award Reference";
        public const string InvalidFundingStreamCode = "Funding Stream Period is not valid for the Funding Type Period";
        public const string AllocationEndDateAfterContractEndDate = "Contract Allocation end date cannot be after the Contract end date.";
        public const string AllocationEndDateBeforeContractStartDate = "Contract Allocation end date cannot be before the Contract start date.";
        public const string AllocationStartDateAfterContractEndDate = "Contract Allocation start date cannot be after the Contract end date.";
        public const string AllocationStartDateBeforeContractStartDate = "Contract Allocation start date cannot be before the Contract start date.";
        public const string PeriodTypeNotValidForFundingStreamCodeRule = "Period type specified is not valid for the specified funding stream";
        public const string PeriodNotValidForFundingStreamCodeRule = "Period specified is not valid for the specified funding stream";
        public const string ContractCannotHaveMoreThenOneAllocationPerFundingStream = "A Contract cannot have more than 1 Contract Allocation for the same Funding Stream Code (and for the same Delivery Organisation if specified)";
        public const string LepMustBeValid = "LEP must be a valid LEP";
        public const string UoPMustBeValid = "UoP must be valid for the Funding Stream Period";
        public const string NewAllocationMustNotHaveAllocationNumber = "A Contract Allocation number cannot be specified when creating a new Contract Allocation";
        public const string AllEsfMandatoryDataMustBePupulated = "All ESF specific mandatory data must be populated";
        public const string RegionTypeMustBeValid = "Region Type must be a valid Region Type";
        public const string DeliveryOrganisationCannotBeChangedOrRemovedOnApprovedContractAllocation = "Delivery Organisation cannot be changed or removed on an approved contract allocation";
        public const string AllocationDeliveryOrganisationPresentThenAllMustBeSpecified = "If Delivery Organisations are applicable, they must be specified against all Contract Allocations for the Contract";
        public const string InvalidDeliveryOrganisationUkprn = "An invalid UKPRN has been specified for the Delivery Organisation";

        public const string InvestmentPriorityMustBeValid = "Investment Prioirty must be a valid Investment Priority";
        public const string AllocationSpecificationTitleInvalid = "Specification Title must be a valid specification title";

        // Deliverable Error Messages
        public const string DeliverableNotValidForFundingStreamPeriod = "Deliverable is not a valid deliverable for the Funding Stream Period";
        public const string DeliverableTypeValueWithSpecifiedUnitcost = "Deliverables defined as Value only should not have a Unit Cost against a deliverable period";
        public const string DeliverableTypeValueWithSpecifiedVolumes = "Deliverables defined as Value only should not have Volumes populated for deliverable periods";
        public const string DeliverableTypeVolumeOnlyWithSpecifiedValues = "Deliverables defined as Volume only should not have Values populated for deliverable periods";
        public const string DeliverableTypeVolumeOnlyWithSpecifiedUnitCost = "Deliverables defined as Volume only should not have Values populated for deliverable periods";
        public const string DeliverableAllowProfileErrorMessage = "Deliverable is not a profile Deliverable";
        public const string DeliverableTypeValueAndVolumeRequiredUnitCost = "Deliverables defined as Value and Volume must have a Unit Cost specified";
        public const string DeliverableTypeValueAndVolumeRequiredVolume = "Deliverables defined as Value and Volume must have a Volume specified";
        public const string DeliverableTypeValueAndVolumeNoValue = "Value does not equal Unit Cost x Volume";
        public const string DeliverableUnitCostsDoNotMatch = "Deliverable Unit Cost must be the same for each deliverable period for the same deliverable for the same funding stream code";
        public const string DeliverableMultiplesRecordsForTheSamePeriod = "Cannot have multiple records for the same Deliverable Period for the same Deliverable for the same Contract Allocation";
        public const string DeliverableYearAndPeriodCombinationInvalid = "Year and Period combination for the Deliverable must fall within the Contract Allocation start and end dates";
        public const string DeliverablePeriodRecordMissing = "A Deliverable must contain a period record for each month of the Contract Allocation in the Deliverable tab";
        public const string DeliverablePeriodCrmIntentsDoNotMatch = "CRM intent must be the same for each deliverable period for the same deliverable for the same Contract Allocation";
        public const string DeliverablePeriodDeliverableDescriptionsDoNotMatch = "Deliverable Description must be the same for each deliverable period for the same deliverable for the same UKPRN, Funding Stream and Contract Allocation number";
        public const string DeliverableMoreThanOnceForAContractAllocation =  "A Deliverable can only appear once against a Contract Allocation";

        // Levy validation
        public const string ADraftOrApprovedContractAlreadyExistsForTheUkprn =
            "A provider can only have one DAS Levy contract in Draft or Approved status";

        // RSR-003b
        public const string VolumeMustBeAWholeNumber = "Volume must be a whole number";
    }
}