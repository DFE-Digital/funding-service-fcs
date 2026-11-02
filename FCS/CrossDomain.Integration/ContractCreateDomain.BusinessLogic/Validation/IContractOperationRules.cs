namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation
{
    using System.Collections.Generic;
    using ContractManagement.DataStore.Model;
    using CrossDomain.Integration.Entities.ContractRequest;
    using CrossDomain.Integration.Entities;
    using Implementation.Persistence.Entities;

    public interface IContractOperationRules
    {
        IEnumerable<IRule<contractRequestType>> GetNewAmendmentContractRules(
            IEnumerable<FundingConfigurationDataType> fundingConfigReferenceData,
            IEnumerable<string> contractTypesReferenceData,
            IEnumerable<string> localEnterprisePartnershipsReferenceData,
            IEnumerable<UnitOfProcurement> unitsOfProcurementReferenceData,
            IEnumerable<string> investmentPriorityReferenceData,
            IEnumerable<string> regionTypeReferenceData,
            IEnumerable<string> specificationTitlesData,
            Dictionary<string, FSCDeliverableStructureDefinitionResponse> fscDeliverableStructureData,
            IReadOnlyCollection<MatchingTenderAwardReferenceItem> matchingTenderAwardReferenceItems,
            bool multipleOverlappingContractsAllowedForFundingType,
            IReadOnlyCollection<FundingTypePeriodFundingStreamPeriod> ftpFspLookupData,
            IReadOnlyCollection<FundingStreamPeriodLegalDeliverable> profileFspDeliverables,
            contractRequestType contractRequestType);
  
       IEnumerable<IRule<contractRequestType>> GetCreateContractRules(
            IEnumerable<FundingConfigurationDataType> fundingConfigReferenceData,
            IEnumerable<string> contractTypesReferenceData,
            IEnumerable<string> localEnterprisePartnershipsReferenceData,
            IEnumerable<UnitOfProcurement> unitsOfProcurementReferenceData,
            IEnumerable<string> investmentPriorityReferenceData,
            IEnumerable<string> regionTypeReferenceData,
            IEnumerable<string> specificationTitlesData,
            Dictionary<string, FSCDeliverableStructureDefinitionResponse> fscDeliverableStructureData,
            IReadOnlyCollection<MatchingTenderAwardReferenceItem> matchingTenderAwardReferenceItems,
            bool multipleOverlappingContractsAllowedForFundingType,
            IReadOnlyCollection<FundingTypePeriodFundingStreamPeriod> ftpFspLookupData,
            IReadOnlyCollection<FundingStreamPeriodLegalDeliverable> profileFspDeliverables,
            contractRequestType contractRequestType);

        IEnumerable<IRule<contractRequestType>> GetCreateContractRevisedNewRules(
           IEnumerable<FundingConfigurationDataType> fundingConfigReferenceData,
           IEnumerable<string> contractTypesReferenceData,
           IEnumerable<string> localEnterprisePartnershipsReferenceData,
           IEnumerable<UnitOfProcurement> unitsOfProcurementReferenceData,
           IEnumerable<string> investmentPriorityReferenceData,
           IEnumerable<string> regionTypeReferenceData,
           IEnumerable<string> specificationTitlesData,
           Dictionary<string, FSCDeliverableStructureDefinitionResponse> fscDeliverableStructureData,
            IReadOnlyCollection<MatchingTenderAwardReferenceItem> matchingTenderAwardReferenceItems,
           bool multipleOverlappingContractsAllowedForFundingType,
           IReadOnlyCollection<FundingTypePeriodFundingStreamPeriod> ftpFspLookupData,
           IReadOnlyCollection<FundingStreamPeriodLegalDeliverable> profileFspDeliverables,
           contractRequestType contractRequestType);

        IEnumerable<IRule<contractRequestType>> GetUpdateDraftContractFirstLevelRules(
            contractRequestType contractRequest,
            Dictionary<string, FSCDeliverableStructureDefinitionResponse> fscDeliverableStructureData,
            IReadOnlyCollection<FundingStreamPeriodLegalDeliverable> profileFspDeliverables);

        IEnumerable<IRule<contractRequestType>> GetUpdateDraftContractSecondLevelRules(
            IEnumerable<FundingConfigurationDataType> validFundingConfig,
            IEnumerable<string> validContractTypes,
            IEnumerable<string> validLepCodes,
            IEnumerable<UnitOfProcurement> validUopCodes,
            IEnumerable<string> regionTypeReferenceData,
            IEnumerable<string> specificationTitlesData,
            IEnumerable<string> investmentPriorityReferenceData,
            IDictionary<string, FSCDeliverableStructureDefinitionResponse> deliverableStructures,
            IReadOnlyCollection<MatchingTenderAwardReferenceItem> matchingTenderAwardReferenceItems,
            IReadOnlyCollection<FundingTypePeriodFundingStreamPeriod> ftpFspLookupData,
            contractRequestType contractRequestType);

        IEnumerable<IRule<contractRequestType>> GetContractAmendmentFirstLevelRules(
            contractRequestType contractRequest,
            Dictionary<string, FSCDeliverableStructureDefinitionResponse> fscDeliverableStructureData,
            IReadOnlyCollection<FundingStreamPeriodLegalDeliverable> profileFspDeliverables);

        IEnumerable<IRule<contractRequestType>> GetContractAmendmentSecondLevelRules(
            IEnumerable<FundingConfigurationDataType> fundingConfigReferenceData,
            IEnumerable<string> contractTypesReferenceData,
            IEnumerable<string> localEnterprisePartnershipsReferenceData,
            IEnumerable<UnitOfProcurement> unitsOfProcurementReferenceData,
            IEnumerable<string> regionTypeReferenceData,
            IEnumerable<string> specificationTitlesData,
            IEnumerable<string> investmentPriorityReferenceData,
            Dictionary<string, FSCDeliverableStructureDefinitionResponse> fscDeliverableStructureData,
            IReadOnlyCollection<MatchingTenderAwardReferenceItem> matchingTenderAwardReferenceItems,
            IReadOnlyCollection<FundingTypePeriodFundingStreamPeriod> ftpFspLookupData,
            contractRequestType contractRequestType,
            IReadOnlyCollection<ContractIdentityInfo> lastApprovedContractIdentityInfos);

        IEnumerable<IRule<contractRequestType>> GetUpdateDraftContractAmendmentFirstLevelRules(
            contractRequestType contractRequest,
            Dictionary<string, FSCDeliverableStructureDefinitionResponse> fscDeliverableStructureData,
            IReadOnlyCollection<FundingStreamPeriodLegalDeliverable> profileFspDeliverables);

        IEnumerable<IRule<contractRequestType>> GetUpdateDraftContractAmendmentSecondLevelRules(
           IEnumerable<FundingConfigurationDataType> fundingConfigReferenceData,
           IEnumerable<string> contractTypesReferenceData,
           IEnumerable<string> localEnterprisePartnershipsReferenceData,
           IEnumerable<UnitOfProcurement> unitsOfProcurementReferenceData,
           IEnumerable<string> regionTypeReferenceData,
           IEnumerable<string> specificationTitlesData,
           IEnumerable<string> investmentPriorityReferenceData,
           Dictionary<string, FSCDeliverableStructureDefinitionResponse> fscDeliverableStructureData,
           IReadOnlyCollection<MatchingTenderAwardReferenceItem> matchingTenderAwardReferenceItems,
           IReadOnlyCollection<FundingTypePeriodFundingStreamPeriod> ftpFspLookupData,
           contractRequestType contractRequestType,
           IReadOnlyCollection<ContractIdentityInfo> lastApprovedContractIdentityInfos);
    }
}