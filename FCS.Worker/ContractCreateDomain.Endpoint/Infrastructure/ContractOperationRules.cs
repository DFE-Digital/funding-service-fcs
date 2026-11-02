namespace ContractCreateDomain.Endpoint.Infrastructure
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using ContractManagement.DataStore.Dtos;
    using ContractManagement.DataStore.Model;
    using SFA.FCT.ContractCreateDomain.BusinessLogic;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.DTOs;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules.Deliverable;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules.UDC;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence.Entities;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;

    public class ContractOperationRules : IContractOperationRules
    {

        public IEnumerable<IRule<contractRequestType>> GetNewAmendmentContractRules(
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
            bool hasSiblingContractWithDraftStatus)
        {
            List<FundingConfigurationDataType> fundingConfigData = fundingConfigReferenceData.ToList();

            var rules = new List<IRule<contractRequestType>>
            {
                new MasterContractNewAmendmentRule(isNewAmendmentAllowed),
                new MandatoryEntitiesRule(),
                new InvalidUkprnRule(),
                new NewIntentWithInactiveOrganisationRule(),
                new ContractTypeValidationRule(contractTypesReferenceData),
                new ExistingContractRule(multipleOverlappingContractsAllowedForFundingType),
                new NewIntentConsistentRule(),
                new StartAndEndDatesMustNotBeTheSameContractRule(),
                new NewIntententAmendmentTypeNullRule(),
                new NewContractsMustNotHaveContractNumbersRule(),
                new AllocationPeriodTypeValidForFundingStreamCodeRule(fundingConfigData),
                new AllocationPeriodValidForFundingStreamCodeRule(fundingConfigData),
                new AllocationOnlyOnePerFundingStreamRule(allowUseOfDeliveryOrgs),
                new AllocationValidLepCodeRule(localEnterprisePartnershipsReferenceData),
                new AllocationValidUoPCodeRule(unitsOfProcurementReferenceData),
                new AllocationValidRegionTypeRule(regionTypeReferenceData),
                new AllocationMandatoryESFDataPopulatedRule(),
                new AllocationEndDateAfterContractEndDateRule(),
                new AllocationEndDateBeforeContractStartDateRule(),
                new AllocationStartDateBeforeContractStartDateRule(),
                new AllocationStartDateAfterContractEndDateRule(),
                new AllocationStartAndEndDatesMustNotBeTheSameRule(),
                new AllocationValidSpecificationTitleRule(specificationTitlesData),
                new AllocationValidInvestmentPriorityRule(investmentPriorityReferenceData),
                new StartAndEndDatesMandatoryRule(),
                new NewIntentContractAllocationNumberNullRule(),
                new InvalidFundingStreamPeriodCodeRule(ftpFspLookupData),
                new DeliverableAllowProfileRule(profileFspDeliverables),
                new DeliverableMultipleRecordsPerPeriodRule(),
                new DeliverableNotValidForFundingStreamPeriodRule(fscDeliverableStructureData),
                new DeliverablePeriodForEachMonthRule(),
                new DeliverablesCannotBeDuplicatedWithinAnAllocationRule(),
                new DeliverableUnitCostMustBeTheSameForEachPeriodRule(fscDeliverableStructureData),
                new DeliverableYearAndPeriodCombinationRule(),
                new ValueDeliverableNoUnitCostRule(fscDeliverableStructureData),
                new ValueDeliverableNoVolumesRule(fscDeliverableStructureData),
                new AllocationTenderAwardReferenceMustBeUniqueAndValidForFundingStreamRule(matchingTenderAwardReferenceItems),
                new ValueAndVolumeDeliverableVolumeRequiredRule(fscDeliverableStructureData),
                new ValueAndVolumeDeliverableUnitCostRequiredRule(fscDeliverableStructureData),
                new ValueAndVolumeDeliverableNoValueRule(fscDeliverableStructureData),
                new InvalidDeliveryOrganisationUkprnRule(),
                new ContractStartAndEndDateMandatoryRule(),
                new ContractTypeMandatoryRule(),
                new AllocationFundingStreamPeriodMandatoryRule(),
                new ContractTypeForFundingTypeFundingPeriodRule(getFundingTypeFundingPeriodContractTypes),
                new AllowNewAmendmentRule(isNewAmendmentAllowed),
                new SiblingContractWithDraftStatusRule(hasSiblingContractWithDraftStatus)
            };

            // add the conditional mandatory field rules
            rules.AddRange(ConditionalRuleExtractor.CreateConditionalRules(contractRequestType));
            return rules;
        }

        public IEnumerable<IRule<contractRequestType>> GetCreateContractRules(
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
            Func<FundingTypeFundingPeriodDto, bool> isNewAmendmentAllowed)
        {
            var rules = contractRequestType.IsLevyContract() ?
                    GetLevyCreateContractRules() :
                    GetStandardCreateContractRules(
                        fundingConfigReferenceData,
                        contractTypesReferenceData,
                        localEnterprisePartnershipsReferenceData,
                        unitsOfProcurementReferenceData,
                        investmentPriorityReferenceData,
                        regionTypeReferenceData,
                        specificationTitlesData,
                        fscDeliverableStructureData,
                        matchingTenderAwardReferenceItems,
                        multipleOverlappingContractsAllowedForFundingType,
                        ftpFspLookupData,
                        profileFspDeliverables,
                        contractRequestType,
                        allowUseOfDeliveryOrgs,
                        getFundingTypeFundingPeriodContractTypes,
                        isNewAmendmentAllowed);

            return rules;
        }

        private IEnumerable<IRule<contractRequestType>> GetStandardCreateContractRules(
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
            Func<FundingTypeFundingPeriodDto, bool> isNewAmendmentAllowed)
        {
            List<FundingConfigurationDataType> fundingConfigData = fundingConfigReferenceData.ToList();

            var rules = new List<IRule<contractRequestType>>
            {
                new MasterContractNewAmendmentRule(isNewAmendmentAllowed),
                new MasterContractNewIntentRule(),
                new ExistingMasterContractRule(multipleOverlappingContractsAllowedForFundingType),
                new MandatoryEntitiesRule(),
                new InvalidUkprnRule(),
                new NewIntentWithInactiveOrganisationRule(),
                new ContractTypeValidationRule(contractTypesReferenceData),
                new ExistingContractRule(multipleOverlappingContractsAllowedForFundingType),
                new NewIntentConsistentRule(),
                new StartAndEndDatesMustNotBeTheSameContractRule(),
                new NewIntententAmendmentTypeNullRule(),
                new NewContractsMustNotHaveContractNumbersRule(),
                new AllocationPeriodTypeValidForFundingStreamCodeRule(fundingConfigData),
                new AllocationPeriodValidForFundingStreamCodeRule(fundingConfigData),
                new AllocationOnlyOnePerFundingStreamRule(allowUseOfDeliveryOrgs),
                new AllocationValidLepCodeRule(localEnterprisePartnershipsReferenceData),
                new AllocationValidUoPCodeRule(unitsOfProcurementReferenceData),
                new AllocationValidRegionTypeRule(regionTypeReferenceData),
                new AllocationMandatoryESFDataPopulatedRule(),
                new AllocationEndDateAfterContractEndDateRule(),
                new AllocationEndDateBeforeContractStartDateRule(),
                new AllocationStartDateBeforeContractStartDateRule(),
                new AllocationStartDateAfterContractEndDateRule(),
                new AllocationStartAndEndDatesMustNotBeTheSameRule(),
                new AllocationValidSpecificationTitleRule(specificationTitlesData),
                new AllocationValidInvestmentPriorityRule(investmentPriorityReferenceData),
                new StartAndEndDatesMandatoryRule(),
                new NewIntentContractAllocationNumberNullRule(),
                new InvalidFundingStreamPeriodCodeRule(ftpFspLookupData),
                new DeliverableAllowProfileRule(profileFspDeliverables),
                new DeliverableMultipleRecordsPerPeriodRule(),
                new DeliverableNotValidForFundingStreamPeriodRule(fscDeliverableStructureData),
                new DeliverablePeriodForEachMonthRule(),
                new DeliverablesCannotBeDuplicatedWithinAnAllocationRule(),
                new DeliverableUnitCostMustBeTheSameForEachPeriodRule(fscDeliverableStructureData),
                new DeliverableYearAndPeriodCombinationRule(),
                new ValueDeliverableNoUnitCostRule(fscDeliverableStructureData),
                new ValueDeliverableNoVolumesRule(fscDeliverableStructureData),
                new AllocationTenderAwardReferenceMustBeUniqueAndValidForFundingStreamRule(matchingTenderAwardReferenceItems),
                new ValueAndVolumeDeliverableVolumeRequiredRule(fscDeliverableStructureData),
                new ValueAndVolumeDeliverableUnitCostRequiredRule(fscDeliverableStructureData),
                new ValueAndVolumeDeliverableNoValueRule(fscDeliverableStructureData),
                new InvalidDeliveryOrganisationUkprnRule(),
                new ContractStartAndEndDateMandatoryRule(),
                new ContractTypeMandatoryRule(),
                new AllocationFundingStreamPeriodMandatoryRule(),
                new ContractTypeForFundingTypeFundingPeriodRule(getFundingTypeFundingPeriodContractTypes)
            };

            // add the conditional mandatory field rules
            rules.AddRange(ConditionalRuleExtractor.CreateConditionalRules(contractRequestType));
            return rules;
        }

        private static IEnumerable<IRule<contractRequestType>> GetLevyCreateContractRules()
        {
            return new List<IRule<contractRequestType>>
            {
                new InvalidUkprnRule(),
                new ExistingDraftOrApprovedContractRule()
                // TODO Check if required here
            };
        }

        public IEnumerable<IRule<contractRequestType>> GetCreateContractRevisedNewRules(
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
           bool hasSiblingContractWithDraftStatus)
        {
            List<FundingConfigurationDataType> fundingConfigData = fundingConfigReferenceData.ToList();

            var rules = new List<IRule<contractRequestType>>
            {
                new NoExistingContractRule(),
                new InvalidUkprnRule(),
                new ContractTypeValidationRule(contractTypesReferenceData),
                new NewIntentConsistentRule(),
                new StartAndEndDatesMustNotBeTheSameContractRule(),
                new RevisedNewContractsMustHaveContractNumberRule(),
                new RevisedNewContractsAmendmentTypeMustBeNullRule(),
                new RevisedNewContractNumberMustExistRule(),
                new RevisedNewNoNonWithdrawnContractsAllowed(),
                new AllocationPeriodTypeValidForFundingStreamCodeRule(fundingConfigData),
                new AllocationPeriodValidForFundingStreamCodeRule(fundingConfigData),
                new AllocationOnlyOnePerFundingStreamRule(allowUseOfDeliveryOrgs),
                new AllocationValidLepCodeRule(localEnterprisePartnershipsReferenceData),
                new AllocationValidUoPCodeRule(unitsOfProcurementReferenceData),
                new AllocationEndDateAfterContractEndDateRule(),
                new AllocationEndDateBeforeContractStartDateRule(),
                new AllocationStartDateBeforeContractStartDateRule(),
                new AllocationStartDateAfterContractEndDateRule(),
                new AllocationStartAndEndDatesMustNotBeTheSameRule(),
                new StartAndEndDatesMandatoryRule(),
                new AllocationTenderAwardReferenceMustBeUniqueAndValidForFundingStreamRule(matchingTenderAwardReferenceItems),
                new DeliverableNotValidForFundingStreamPeriodRule(fscDeliverableStructureData),
                new DeliverablesCannotBeDuplicatedWithinAnAllocationRule(),
                new DeliverablePeriodForEachMonthRule(),
                new DeliverableYearAndPeriodCombinationRule(),
                new DeliverableMultipleRecordsPerPeriodRule(),
                new ValueDeliverableNoUnitCostRule(fscDeliverableStructureData),
                new ValueDeliverableNoVolumesRule(fscDeliverableStructureData),
                new DeliverableAllowProfileRule(profileFspDeliverables),
                new DeliverableUnitCostMustBeTheSameForEachPeriodRule(fscDeliverableStructureData),
                new ValueAndVolumeDeliverableVolumeRequiredRule(fscDeliverableStructureData),
                new ValueAndVolumeDeliverableUnitCostRequiredRule(fscDeliverableStructureData),
                new ValueAndVolumeDeliverableNoValueRule(fscDeliverableStructureData),
                new MustHaveMatchingContractInFctRule(),
                new ContractAllocationMustHaveActiveUkprnRule(),
                new DeliverableMustHaveActiveUkprnRule(),
                new NewIntentContractAllocationNumberNullRule(),
                new InvalidFundingStreamPeriodCodeRule(ftpFspLookupData),
                new InvalidDeliveryOrganisationUkprnRule(),
                new ContractStartAndEndDateMandatoryRule(),
                new ContractTypeMandatoryRule(),
                new AllocationFundingStreamPeriodMandatoryRule(),
                new ContractTypeForFundingTypeFundingPeriodRule(getFundingTypeFundingPeriodContractTypes),
                new SiblingContractWithDraftStatusRule(hasSiblingContractWithDraftStatus)
            };

            // add the conditional mandatory field rules
            rules.AddRange(ConditionalRuleExtractor.CreateConditionalRules(contractRequestType));
            return rules;
        }

        public IEnumerable<IRule<contractRequestType>> GetUpdateDraftContractFirstLevelRules(
            contractRequestType contractRequest,
            Dictionary<string, FSCDeliverableStructureDefinitionResponse> fscDeliverableStructureData,
            IReadOnlyCollection<FundingStreamPeriodLegalDeliverable> profileFspDeliverables,
            Func<IReadOnlyCollection<FundingTypeFundingPeriodContractTypeDto>> getFundingTypeFundingPeriodContractTypes)
        {
            var rules = new List<IRule<contractRequestType>>
            {
                new MustSpecifyContractAllocationNumberDeleteRule(),
                new MustSpecifyContractAllocationNumberUpdateRule(),
                new MustSpecifyContractNumberRule(),
                new MustSpecifyMasterContractNumberRule(),
                new NewIntentContractAllocationNumberNullRule(),
                new DeliverableMultipleRecordsPerPeriodRule(),
                new ValueDeliverableNoUnitCostRule(fscDeliverableStructureData),
                new ValueDeliverableNoVolumesRule(fscDeliverableStructureData),
                new ValueAndVolumeDeliverableVolumeRequiredRule(fscDeliverableStructureData),
                new ValueAndVolumeDeliverableUnitCostRequiredRule(fscDeliverableStructureData),
                new ValueAndVolumeDeliverableNoValueRule(fscDeliverableStructureData),
                new DeliverableUnitCostMustBeTheSameForEachPeriodRule(fscDeliverableStructureData),
                new InvalidDeliveryOrganisationUkprnRule(),
                new DeliverableAllowProfileRule(profileFspDeliverables),
                new ContractTypeForFundingTypeFundingPeriodRule(getFundingTypeFundingPeriodContractTypes)
            };

            rules.AddRange(ConditionalRuleExtractor.CreateConditionalRules(contractRequest));
            return rules;
        }

        public IEnumerable<IRule<contractRequestType>> GetUpdateDraftContractSecondLevelRules(
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
            bool allowUseOfDeliveryOrgs)
        {
            var fundingConfig = validFundingConfig.ToList();
            var lepCodes = validLepCodes.ToList();
            var uopCodes = validUopCodes.ToList();

            return new List<IRule<contractRequestType>>
            {
                new ContractMustBeInCorrectStateRule(),
                new MustHaveMatchingContractInFctRule(),
                new MustHaveMatchingContractAllocationInFctRule(),
                new MustHaveMatchingMasterContractInFctRule(),
                new MustHaveMatchingDeliverableInFctRule(),
                new ContractAllocationMustHaveActiveUkprnRule(),
                new DeliverableMustHaveActiveUkprnRule(),
                new ContractMustHaveAtLeastOneAllocationRule(),
                new ContractAllocationMustHaveAtLeastOneDeliverableRule(),
                new AllocationStartAndEndDatesMustNotBeTheSameRule(),
                new ContractTypeValidationRule(validContractTypes),
                new InvalidUkprnRule(),
                new StartAndEndDatesMustNotBeTheSameContractRule(),
                 new AllocationOnlyOnePerFundingStreamRule(allowUseOfDeliveryOrgs),
                new AllocationPeriodTypeValidForFundingStreamCodeRule(fundingConfig),
                new AllocationPeriodValidForFundingStreamCodeRule(fundingConfig),
                new StartAndEndDatesMandatoryRule(),
                new AllocationValidLepCodeRule(lepCodes),
                new AllocationValidInvestmentPriorityRule(investmentPriorityReferenceData),
                new AllocationValidUoPCodeRule(uopCodes),
                new AllocationValidRegionTypeRule(regionTypeReferenceData),
                new AllocationMandatoryESFDataPopulatedRule(),
                new AllocationEndDateAfterContractEndDateRule(),
                new AllocationEndDateBeforeContractStartDateRule(),
                new AllocationStartDateBeforeContractStartDateRule(),
                new AllocationStartDateAfterContractEndDateRule(),
                new AllocationValidSpecificationTitleRule(specificationTitlesData),
                new InvalidFundingStreamPeriodCodeRule(ftpFspLookupData),
                new DeliverableNotValidForFundingStreamPeriodRule(deliverableStructures),
                //new DeliverableMultipleRecordsPerPeriodRule(),
                new DeliverableYearAndPeriodCombinationRule(),
                new DeliverablePeriodForEachMonthRule(),
                new DeliverablesCannotBeDuplicatedWithinAnAllocationRule(),
                new UpdateDraftContractCannotRunAgainstContractWithAmendmentTypeRule(),
                // this rule could be moved to 1st level rules if UDC saga refactored to use Amendment saga and AmendmentType presence check is added to 1st level lookup data
                new UpdateDraftContractMustNotHaveAnAmendmentTypeRule(),
                new AllocationTenderAwardReferenceMustBeUniqueOrUnchanged(matchingTenderAwardReferenceItems),
                new AllocationDeliveryOrganisationPresentThenAllMustBeSpecifiedRule()
            };
        }

        public IEnumerable<IRule<contractRequestType>> GetContractAmendmentFirstLevelRules(
            contractRequestType contractRequest,
            Dictionary<string, FSCDeliverableStructureDefinitionResponse> fscDeliverableStructureData,
            IReadOnlyCollection<FundingStreamPeriodLegalDeliverable> profileFspDeliverables,
            Func<IReadOnlyCollection<FundingTypeFundingPeriodContractTypeDto>> getFundingTypeFundingPeriodContractTypes,
            bool hasSiblingContractWithDraftStatus)
        {
            var rules = new List<IRule<contractRequestType>>
            {
                new NoExistingContractRule(),
                new MustSpecifyContractAllocationNumberDeleteRule(),
                new MustSpecifyContractAllocationNumberUpdateRule(),
                new MustSpecifyContractNumberRule(),
                new MustSpecifyMasterContractNumberRule(),
                new NewIntentContractAllocationNumberNullRule(),
                new ContractAmendmentCannotHaveExistingDraftContractRule(),
                new ContractAmendmentMustHaveExistingApprovedOrWithdrawnContractRule(),
                new AmendmentIntentMustHasNonNullAmendmentTypeRule(),
                new DeliverableNotValidForFundingStreamPeriodRule(fscDeliverableStructureData),
                new DeliverableAllowProfileRule(profileFspDeliverables),
                new DeliverableYearAndPeriodCombinationRule(),
                new ValueDeliverableNoUnitCostRule(fscDeliverableStructureData),
                new ValueDeliverableNoVolumesRule(fscDeliverableStructureData),
                new ValueAndVolumeDeliverableVolumeRequiredRule(fscDeliverableStructureData),
                new ValueAndVolumeDeliverableUnitCostRequiredRule(fscDeliverableStructureData),
                new ValueAndVolumeDeliverableNoValueRule(fscDeliverableStructureData),
                new DeliverableUnitCostMustBeTheSameForEachPeriodRule(fscDeliverableStructureData),
                new InvalidDeliveryOrganisationUkprnRule(),
                new ContractTypeForFundingTypeFundingPeriodRule(getFundingTypeFundingPeriodContractTypes),
                new SiblingContractWithDraftStatusRule(hasSiblingContractWithDraftStatus)
            };

            rules.AddRange(ConditionalRuleExtractor.CreateConditionalRules(contractRequest));
            return rules;
        }

        public IEnumerable<IRule<contractRequestType>> GetContractAmendmentSecondLevelRules(
            IEnumerable<FundingConfigurationDataType> fundingConfigReferenceData,
            IEnumerable<string> contractTypesReferenceData,
            IEnumerable<string> localEnterprisePartnershipsReferenceData,
            IEnumerable<UnitOfProcurement> unitsOfProcurementReferenceData,
            IEnumerable<string> regionTypeReferenceData,
            IEnumerable<string> validSpecificationTitles,
            IEnumerable<string> investmentPriorityReferenceData,
            Dictionary<string, FSCDeliverableStructureDefinitionResponse> fscDeliverableStructureData,
            IReadOnlyCollection<MatchingTenderAwardReferenceItem> matchingTenderAwardReferenceItems,
            IReadOnlyCollection<FundingTypePeriodFundingStreamPeriod> ftpFspLookupData,
            contractRequestType contractRequestType,
            IReadOnlyCollection<ContractIdentityInfo> lastApprovedContractIdentityInfos,
            bool allowUseOfDeliveryOrgs)
        {
            List<FundingConfigurationDataType> fundingConfigData = fundingConfigReferenceData.ToList();

            var rules = new List<IRule<contractRequestType>>
            {
                new MasterContractAmendmentRule(),
                new InvalidUkprnRule(),
                new ContractTypeValidationRule(contractTypesReferenceData),
                new StartAndEndDatesMustNotBeTheSameContractRule(),
                new AllocationPeriodTypeValidForFundingStreamCodeRule(fundingConfigData),
                new AllocationPeriodValidForFundingStreamCodeRule(fundingConfigData),
                new AllocationOnlyOnePerFundingStreamRule(allowUseOfDeliveryOrgs),
                new AllocationValidLepCodeRule(localEnterprisePartnershipsReferenceData),
                new AllocationValidInvestmentPriorityRule(investmentPriorityReferenceData),
                new AllocationValidUoPCodeRule(unitsOfProcurementReferenceData),
                new AllocationValidRegionTypeRule(regionTypeReferenceData),
                new AllocationMandatoryESFDataPopulatedRule(),
                new AllocationEndDateAfterContractEndDateRule(),
                new AllocationEndDateBeforeContractStartDateRule(),
                new AllocationStartDateBeforeContractStartDateRule(),
                new AllocationStartDateAfterContractEndDateRule(),
                new AllocationStartAndEndDatesMustNotBeTheSameRule(),
                new AllocationValidSpecificationTitleRule(validSpecificationTitles),
                new StartAndEndDatesMandatoryRule(),
                new InvalidFundingStreamPeriodCodeRule(ftpFspLookupData),
                new DeliverablesCannotBeDuplicatedWithinAnAllocationRule(),
                new DeliverablePeriodForEachMonthRule(),
                new DeliverableMultipleRecordsPerPeriodRule(),
                new MustHaveMatchingContractInFctRule(),
                new MustHaveMatchingContractAllocationInFctRule(),
                new MustHaveMatchingMasterContractInFctRule(),
                new MustHaveMatchingDeliverableInFctRule(),
                new ContractAllocationMustHaveActiveUkprnRule(),
                new DeliverableMustHaveActiveUkprnRule(),
                new AllocationTenderAwardReferenceMustBeUniqueOrUnchanged(matchingTenderAwardReferenceItems),
                new AllocationDeliveryOrganisationCannotBeChangedOnApprovedVersionRule(lastApprovedContractIdentityInfos),
                new AllocationDeliveryOrganisationPresentThenAllMustBeSpecifiedRule()
            };

            rules.AddRange(ConditionalRuleExtractor.CreateConditionalRules(contractRequestType));
            return rules;
        }

        public IEnumerable<IRule<contractRequestType>> GetUpdateDraftContractAmendmentFirstLevelRules(
            contractRequestType contractRequest,
            Dictionary<string, FSCDeliverableStructureDefinitionResponse> fscDeliverableStructureData,
            IReadOnlyCollection<FundingStreamPeriodLegalDeliverable> profileFspDeliverables,
            Func<IReadOnlyCollection<FundingTypeFundingPeriodContractTypeDto>> getFundingTypeFundingPeriodContractTypes)
        {
            var rules = new List<IRule<contractRequestType>>
            {
                new MustSpecifyContractAllocationNumberDeleteRule(),
                new MustSpecifyContractAllocationNumberUpdateRule(),
                new MustSpecifyContractNumberRule(),
                new MustSpecifyMasterContractNumberRule(),
                new NewIntentContractAllocationNumberNullRule(),
                new ContractAmendmentMustHaveExistingApprovedOrWithdrawnContractRule(),
                new UpdateDraftAmendmentCannotRunAgainstContractWithoutAmendmentTypeRule(),
                new DeliverableNotValidForFundingStreamPeriodRule(fscDeliverableStructureData),
                new DeliverableAllowProfileRule(profileFspDeliverables),
                new DeliverableYearAndPeriodCombinationRule(),
                new ValueDeliverableNoUnitCostRule(fscDeliverableStructureData),
                new ValueDeliverableNoVolumesRule(fscDeliverableStructureData),
                new UpdateDraftAmendmentMustHaveAnAmendmentTypeRule(),
                new UpdateDraftAmendmentCannotDeleteApprovedAllocationRule(),
                new UpdateDraftAmendmentCannotDeleteApprovedDeliverableRule(),
                new ValueAndVolumeDeliverableVolumeRequiredRule(fscDeliverableStructureData),
                new ValueAndVolumeDeliverableUnitCostRequiredRule(fscDeliverableStructureData),
                new ValueAndVolumeDeliverableNoValueRule(fscDeliverableStructureData),
                new DeliverableUnitCostMustBeTheSameForEachPeriodRule(fscDeliverableStructureData),
                new InvalidDeliveryOrganisationUkprnRule(),
                new ContractTypeForFundingTypeFundingPeriodRule(getFundingTypeFundingPeriodContractTypes)
            };

            rules.AddRange(ConditionalRuleExtractor.CreateConditionalRules(contractRequest));
            return rules;
        }

        public IEnumerable<IRule<contractRequestType>> GetUpdateDraftContractAmendmentSecondLevelRules(
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
            bool allowUseOfDeliveryOrgs)
        {
            List<FundingConfigurationDataType> fundingConfigData = fundingConfigReferenceData.ToList();

            var rules = new List<IRule<contractRequestType>>
            {
                new MasterContractAmendmentRule(),
                new ContractMustBeInCorrectStateRule(),
                new InvalidUkprnRule(),
                new ContractTypeValidationRule(contractTypesReferenceData),
                new StartAndEndDatesMustNotBeTheSameContractRule(),
                new AllocationPeriodTypeValidForFundingStreamCodeRule(fundingConfigData),
                new AllocationPeriodValidForFundingStreamCodeRule(fundingConfigData),
                new AllocationOnlyOnePerFundingStreamRule(allowUseOfDeliveryOrgs),
                new AllocationValidLepCodeRule(localEnterprisePartnershipsReferenceData),
                new AllocationValidInvestmentPriorityRule(investmentPriorityReferenceData),
                new AllocationValidUoPCodeRule(unitsOfProcurementReferenceData),
                new AllocationValidRegionTypeRule(regionTypeReferenceData),
                new AllocationMandatoryESFDataPopulatedRule(),
                new AllocationEndDateAfterContractEndDateRule(),
                new AllocationEndDateBeforeContractStartDateRule(),
                new AllocationStartDateBeforeContractStartDateRule(),
                new AllocationStartDateAfterContractEndDateRule(),
                new AllocationStartAndEndDatesMustNotBeTheSameRule(),
                new AllocationValidSpecificationTitleRule(specificationTitlesData),
                new StartAndEndDatesMandatoryRule(),
                new InvalidFundingStreamPeriodCodeRule(ftpFspLookupData),
                new DeliverablesCannotBeDuplicatedWithinAnAllocationRule(),
                new DeliverablePeriodForEachMonthRule(),
                new DeliverableMultipleRecordsPerPeriodRule(),
                new MustHaveMatchingContractInFctRule(),
                new MustHaveMatchingContractAllocationInFctRule(),
                new MustHaveMatchingMasterContractInFctRule(),
                new MustHaveMatchingDeliverableInFctRule(),
                new ContractAllocationMustHaveActiveUkprnRule(),
                new DeliverableMustHaveActiveUkprnRule(),
                new AllocationTenderAwardReferenceMustBeUniqueOrUnchanged(matchingTenderAwardReferenceItems),
                new AllocationDeliveryOrganisationCannotBeChangedOnApprovedVersionRule(lastApprovedContractIdentityInfos),
                new AllocationDeliveryOrganisationPresentThenAllMustBeSpecifiedRule()
            };

            rules.AddRange(ConditionalRuleExtractor.CreateConditionalRules(contractRequestType));
            return rules;
        }
    }
}
