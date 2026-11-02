namespace ContractCreateDomain.Endpoint.Infrastructure
{
    using System;
    using System.Collections.Generic;
    using ContractManagement.DataStore.Dtos;
    using ContractManagement.DataStore.Model;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.DTOs;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence.Entities;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;

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
            contractRequestType contractRequestType,
            bool allowUseOfDeliveryOrgs,
            Func<IReadOnlyCollection<FundingTypeFundingPeriodContractTypeDto>> getFundingTypeFundingPeriodContractTypes,
            Func<FundingTypeFundingPeriodDto, bool> isNewAmendmentAllowed,
            bool hasSiblingContractWithDraftStatus);

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
             contractRequestType contractRequestType,
             bool allowUseOfDeliveryOrgs,
             Func<IReadOnlyCollection<FundingTypeFundingPeriodContractTypeDto>> getFundingTypeFundingPeriodContractTypes,
             Func<FundingTypeFundingPeriodDto, bool> isNewAmendmentAllowed);

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
           contractRequestType contractRequestType,
           bool allowUseOfDeliveryOrgs,
           Func<IReadOnlyCollection<FundingTypeFundingPeriodContractTypeDto>> getFundingTypeFundingPeriodContractTypes,
           bool hasSiblingContractWithDraftStatus);

        IEnumerable<IRule<contractRequestType>> GetUpdateDraftContractFirstLevelRules(
            contractRequestType contractRequest,
            Dictionary<string, FSCDeliverableStructureDefinitionResponse> fscDeliverableStructureData,
            IReadOnlyCollection<FundingStreamPeriodLegalDeliverable> profileFspDeliverables,
            Func<IReadOnlyCollection<FundingTypeFundingPeriodContractTypeDto>> getFundingTypeFundingPeriodContractTypes);

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
            contractRequestType contractRequestType,
            bool allowUseOfDeliveryOrgs);

        IEnumerable<IRule<contractRequestType>> GetContractAmendmentFirstLevelRules(
            contractRequestType contractRequest,
            Dictionary<string, FSCDeliverableStructureDefinitionResponse> fscDeliverableStructureData,
            IReadOnlyCollection<FundingStreamPeriodLegalDeliverable> profileFspDeliverables,
            Func<IReadOnlyCollection<FundingTypeFundingPeriodContractTypeDto>> getFundingTypeFundingPeriodContractTypes, 
            bool hasSiblingContractWithDraftStatus);

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
            IReadOnlyCollection<ContractIdentityInfo> lastApprovedContractIdentityInfos,
            bool allowUseOfDeliveryOrgs);

        IEnumerable<IRule<contractRequestType>> GetUpdateDraftContractAmendmentFirstLevelRules(
            contractRequestType contractRequest,
            Dictionary<string, FSCDeliverableStructureDefinitionResponse> fscDeliverableStructureData,
            IReadOnlyCollection<FundingStreamPeriodLegalDeliverable> profileFspDeliverables,
            Func<IReadOnlyCollection<FundingTypeFundingPeriodContractTypeDto>> getFundingTypeFundingPeriodContractTypes);

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
           IReadOnlyCollection<ContractIdentityInfo> lastApprovedContractIdentityInfos,
           bool allowUseOfDeliveryOrgs);
    }
}
