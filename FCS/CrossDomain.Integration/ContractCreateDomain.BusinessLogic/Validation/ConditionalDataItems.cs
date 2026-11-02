namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation
{
    using System.Collections.Generic;
    using CrossDomain.Integration.Entities.ContractRequest;
    using CrossDomain.Integration.Entities;

    public static class ConditionalDataItems
    {
        // Master Level
        public const string FundingTypeCode = "fundingTypeCode";
        public const string FundingStreamCode = "fundingStreamCode";

        // Common
        private const string CrmIntent = "CRMIntent";

        // CRM IntentTypes
        private const string New = "New";
        private const string UpdateDraft = "Update Draft";
        private const string DeleteDraft = "Delete Draft";
        private const string Amendment = "Amendment";

        // Contract Level
        private const string ContractNumber = "contractNumber";

        // Allocation Level
        private const string AllocationNumber = "contractAllocationNumber";
        private const string TenderSpecificationReference = "tenderSpecificationReference";
        private const string TenderAwardReference = "tenderAwardReference";
        private const string ActivityDescription = "activityDescription";
        private const string InvestmentPriority = "investmentPriority";
        private const string SpecificationTitle = "specificationTitle";
        private const string AgreementNumber = "agreementNumber";
        private const string RegionType = "regionType";
        private const string AllocationDescription = "description";
        private const string LePCode = "LEPCode";
        private const string UoPCode = "UoPCode";


        // Non Constatnts
        private static readonly List<object> EuropeFundingTypes = new List<object> { FundingTypes.ESF };

        public static List<ConditionalDataItem> ConditionalArguments { get; } = new List<ConditionalDataItem>
        {
            new ConditionalDataItem(propertyName: ContractNumber, conditionalSwitchItem: CrmIntent,
                matchedValues: new List<object> {UpdateDraft, DeleteDraft, Amendment}, shouldBeNull: false,
                errorLevel: errorInfoTypeLevel.MasterContract),

            new ConditionalDataItem(propertyName: ContractNumber, conditionalSwitchItem: CrmIntent,
                matchedValues: new List<object> {New}, shouldBeNull: true, errorLevel: errorInfoTypeLevel.Contract),

            new ConditionalDataItem(propertyName: TenderSpecificationReference, conditionalSwitchItem: FundingTypeCode,
                matchedValues: EuropeFundingTypes, shouldBeNull: false, errorLevel: errorInfoTypeLevel.Allocation),

            new ConditionalDataItem(propertyName: TenderAwardReference, conditionalSwitchItem: FundingTypeCode,
                matchedValues: EuropeFundingTypes, shouldBeNull: false, errorLevel: errorInfoTypeLevel.Allocation),

            new ConditionalDataItem(propertyName: ActivityDescription, conditionalSwitchItem: FundingTypeCode,
                matchedValues: EuropeFundingTypes, shouldBeNull: false, errorLevel: errorInfoTypeLevel.Allocation),

            new ConditionalDataItem(propertyName: InvestmentPriority, conditionalSwitchItem: FundingTypeCode,
                matchedValues: EuropeFundingTypes, shouldBeNull: false, errorLevel: errorInfoTypeLevel.Allocation),

            new ConditionalDataItem(propertyName: RegionType, conditionalSwitchItem: FundingTypeCode,
                matchedValues: EuropeFundingTypes, shouldBeNull: false, errorLevel: errorInfoTypeLevel.Allocation),

            new ConditionalDataItem(propertyName: AllocationDescription, conditionalSwitchItem: FundingTypeCode,
                matchedValues: EuropeFundingTypes, shouldBeNull: false, errorLevel: errorInfoTypeLevel.Allocation),

            new ConditionalDataItem(propertyName: SpecificationTitle, conditionalSwitchItem: FundingTypeCode,
                matchedValues: EuropeFundingTypes, shouldBeNull: false, errorLevel: errorInfoTypeLevel.Allocation),

            new ConditionalDataItem(propertyName: AgreementNumber, conditionalSwitchItem: FundingTypeCode,
                matchedValues: EuropeFundingTypes, shouldBeNull: false, errorLevel: errorInfoTypeLevel.Allocation),

            new ConditionalDataItem(propertyName: LePCode, conditionalSwitchItem: FundingTypeCode,
                matchedValues: EuropeFundingTypes, shouldBeNull: false, errorLevel: errorInfoTypeLevel.Allocation),

            new ConditionalDataItem(propertyName: AllocationNumber, conditionalSwitchItem: CrmIntent,
                matchedValues: new List<object> {UpdateDraft, DeleteDraft, Amendment}, shouldBeNull: false,
                errorLevel: errorInfoTypeLevel.Allocation)
        };
    }
}