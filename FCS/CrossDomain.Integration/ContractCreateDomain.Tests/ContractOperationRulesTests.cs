namespace ContractCreateDomain.Tests
{
    using System.Collections.Generic;
    using System.Linq;
    using Castle.MicroKernel.Lifestyle;
    using ContractManagement.DataStore.Model;
    using ContractManagement.DataStore.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules.UDC;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules.Deliverable;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence.Entities;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using SFA.FCT.Framework.Logging;
    using Castle.Windsor;

    [TestClass]
    public class ContractOperationRulesTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void GetRules_ReturnsUpdateDraftContractFirstLevelRules()
        {
            // Act
            var rules =
                (List<IRule<contractRequestType>>)
                new ContractOperationRules(new Mock<IFundingTypeFundingPeriodQueryRepository>().Object,
                        Mock.Of<IFundingTypeFundingPeriodContractTypeQueryRepository>())
                    .GetUpdateDraftContractFirstLevelRules(new contractRequestType(), null, null);
            Assert.IsTrue(rules.OfType<MustSpecifyContractAllocationNumberDeleteRule>().Any(),
                "GetUpdateDraftContractFirstLevelRules should return MustSpecifyContractAllocationNumberDeleteRule.");
            Assert.IsTrue(rules.OfType<MustSpecifyContractAllocationNumberUpdateRule>().Any(),
                "GetUpdateDraftContractFirstLevelRules should return MustSpecifyContractAllocationNumberUpdateRule.");
            Assert.IsTrue(rules.OfType<MustSpecifyContractNumberRule>().Any(),
                "GetUpdateDraftContractFirstLevelRules should return MustSpecifyContractNumberRule.");
            Assert.IsTrue(rules.OfType<MustSpecifyMasterContractNumberRule>().Any(),
                "GetUpdateDraftContractFirstLevelRules should return MustSpecifyMasterContractNumberRule.");
            Assert.IsTrue(rules.OfType<ConditionalMandatoryFieldsRule>().Any(),
                "GetUpdateDraftContractFirstLevelRules should return ConditionalMandatoryFieldsRule.");
            Assert.IsTrue(rules.OfType<NewIntentContractAllocationNumberNullRule>().Any(),
                "GetUpdateDraftContractFirstLevelRules should return NewIntentContractAllocationNumberNullRule.");
            Assert.IsTrue(rules.OfType<DeliverableMultipleRecordsPerPeriodRule>().Any(),
                "GetUpdateDraftContractFirstLevelRules should return DeliverableMultipleRecordsPerPeriodRule.");
            Assert.IsTrue(rules.OfType<ValueAndVolumeDeliverableVolumeRequiredRule>().Any(),
                "GetUpdateDraftContractFirstLevelRules should return ValueAndVolumeDeliverableVolumeRequiredRule.");
            Assert.IsTrue(rules.OfType<ValueAndVolumeDeliverableUnitCostRequiredRule>().Any(),
                "GetUpdateDraftContractFirstLevelRules should return ValueAndVolumeDeliverableUnitCostRequiredRule.");
            Assert.IsTrue(rules.OfType<ValueAndVolumeDeliverableNoValueRule>().Any(),
                "GetUpdateDraftContractFirstLevelRules should return ValueAndVolumeDeliverableNoValueRule.");
            Assert.IsTrue(rules.OfType<DeliverableUnitCostMustBeTheSameForEachPeriodRule>().Any(),
                "GetUpdateDraftContractFirstLevelRules should return DeliverableUnitCostMustBeTheSameForEachPeriodRule.");
            Assert.IsTrue(rules.OfType<ValueDeliverableNoUnitCostRule>().Any(),
                "GetUpdateDraftContractFirstLevelRules should return ValueDeliverableNoUnitCostRule.");
            Assert.IsTrue(rules.OfType<ValueDeliverableNoVolumesRule>().Any(),
                "GetUpdateDraftContractFirstLevelRules should return ValueDeliverableNoVolumesRule.");
            Assert.IsTrue(rules.OfType<DeliverableAllowProfileRule>().Any(),
                "GetUpdateDraftContractFirstLevelRules should return DeliverableAllowProfileRule.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetContractAmendmentFirstLevelRules_ReturnsContractAmendmentFirstLevelRules()
        {
            var rules =
                new ContractOperationRules(new Mock<IFundingTypeFundingPeriodQueryRepository>().Object,
                        Mock.Of<IFundingTypeFundingPeriodContractTypeQueryRepository>())
                    .GetContractAmendmentFirstLevelRules(new contractRequestType(),
                        new Dictionary<string, FSCDeliverableStructureDefinitionResponse>(),
                        new List<FundingStreamPeriodLegalDeliverable>()).ToList();

            Assert.IsTrue(rules.OfType<MustSpecifyContractAllocationNumberDeleteRule>().Any(),
                "GetContractAmendmentFirstLevelRules should return MustSpecifyContractAllocationNumberDeleteRule.");
            Assert.IsTrue(rules.OfType<MustSpecifyContractAllocationNumberUpdateRule>().Any(),
                "GetContractAmendmentFirstLevelRules should return MustSpecifyContractAllocationNumberUpdateRule.");
            Assert.IsTrue(rules.OfType<MustSpecifyContractNumberRule>().Any(),
                "GetContractAmendmentFirstLevelRules should return MustSpecifyContractNumberRule.");
            Assert.IsTrue(rules.OfType<MustSpecifyMasterContractNumberRule>().Any(),
                "GetContractAmendmentFirstLevelRules should return MustSpecifyMasterContractNumberRule.");
            Assert.IsTrue(rules.OfType<ConditionalMandatoryFieldsRule>().Any(),
                "GetContractAmendmentFirstLevelRules should return ConditionalMandatoryFieldsRule.");
            Assert.IsTrue(rules.OfType<NewIntentContractAllocationNumberNullRule>().Any(),
                "GetContractAmendmentFirstLevelRules should return NewIntentContractAllocationNumberNullRule.");
            Assert.IsTrue(rules.OfType<DeliverableNotValidForFundingStreamPeriodRule>().Any(),
                "GetContractAmendmentFirstLevelRules should return DeliverableNotValidForFundingStreamPeriodRule.");
            Assert.IsTrue(rules.OfType<DeliverableAllowProfileRule>().Any(),
                "GetContractAmendmentFirstLevelRules should return DeliverableAllowProfileRule.");
            Assert.IsTrue(rules.OfType<DeliverableYearAndPeriodCombinationRule>().Any(),
                "GetContractAmendmentSecondLevelRules should return DeliverableYearAndPeriodCombinationRule.");
            Assert.IsTrue(rules.OfType<ValueDeliverableNoUnitCostRule>().Any(),
                "GetContractAmendmentFirstLevelRules should return ValueDeliverableNoUnitCostRule.");
            Assert.IsTrue(rules.OfType<ValueDeliverableNoVolumesRule>().Any(),
                "GetContractAmendmentFirstLevelRules should return ValueDeliverableNoVolumesRule.");
            Assert.IsTrue(rules.OfType<NoExistingContractRule>().Any(),
                "GetContractAmendmentFirstLevelRules should return NoExistingContractRule.");
            Assert.IsTrue(rules.OfType<ValueAndVolumeDeliverableVolumeRequiredRule>().Any(),
                "GetContractAmendmentFirstLevelRules should return ValueAndVolumeDeliverableVolumeRequiredRule.");
            Assert.IsTrue(rules.OfType<ValueAndVolumeDeliverableUnitCostRequiredRule>().Any(),
                "GetContractAmendmentFirstLevelRules should return ValueAndVolumeDeliverableUnitCostRequiredRule.");
            Assert.IsTrue(rules.OfType<ValueAndVolumeDeliverableNoValueRule>().Any(),
                "GetContractAmendmentFirstLevelRules should return ValueAndVolumeDeliverableNoValueRule.");
            Assert.IsTrue(rules.OfType<DeliverableUnitCostMustBeTheSameForEachPeriodRule>().Any(),
                "GetContractAmendmentFirstLevelRules should return DeliverableUnitCostMustBeTheSameForEachPeriodRule.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetContractAmendmentSecondLevelRules_ReturnsContractAmendmentSecondLevelRules()
        {
            var rules = new ContractOperationRules(new Mock<IFundingTypeFundingPeriodQueryRepository>().Object,
                Mock.Of<IFundingTypeFundingPeriodContractTypeQueryRepository>()).GetContractAmendmentSecondLevelRules(
                new List<FundingConfigurationDataType>(),
                new List<string>(),
                new List<string>(),
                new List<UnitOfProcurement>(),
                new List<string>(),
                new List<string>(),
                new List<string>(),
                new Dictionary<string, FSCDeliverableStructureDefinitionResponse>(),
                new List<MatchingTenderAwardReferenceItem>(),
                new List<FundingTypePeriodFundingStreamPeriod>(),
                new contractRequestType
                {
                    contract = new contractType
                    {
                        fundingTypeCode = "MAIN",
                        period = new periodType
                        {
                            period = "1718",
                            periodType1 = new periodTypeType()
                        },
                        contracts = new List<contractType>()
                        {
                            new contractType
                            {
                                fundingTypeCode = "MAIN",
                                period = new periodType
                                {
                                    period = "1718",
                                    periodType1 = new periodTypeType()
                                }
                            }
                        }
                    }
                },
                new List<ContractIdentityInfo>()).ToList();

            Assert.IsTrue(rules.OfType<MasterContractAmendmentRule>().Any(),
                "GetContractAmendmentSecondLevelRules should return MasterContractAmendmentRule.");
            Assert.IsTrue(rules.OfType<AllocationValidInvestmentPriorityRule>().Any(),
                "GetContractAmendmentSecondLevelRules should return AllocationValidInvestmentPriorityRule.");
            Assert.IsTrue(rules.OfType<InvalidUkprnRule>().Any(),
                "GetContractAmendmentSecondLevelRules should return InvalidUkprnRule.");
            Assert.IsTrue(rules.OfType<ContractTypeValidationRule>().Any(),
                "GetContractAmendmentSecondLevelRules should return ContractTypeValidationRule.");
            Assert.IsTrue(rules.OfType<StartAndEndDatesMustNotBeTheSameContractRule>().Any(),
                "GetContractAmendmentSecondLevelRules should return StartAndEndDatesMustNotBeTheSameContractRule.");
            Assert.IsTrue(rules.OfType<AllocationPeriodTypeValidForFundingStreamCodeRule>().Any(),
                "GetContractAmendmentSecondLevelRules should return AllocationPeriodTypeValidForFundingStreamCodeRule.");
            Assert.IsTrue(rules.OfType<AllocationPeriodValidForFundingStreamCodeRule>().Any(),
                "GetContractAmendmentSecondLevelRules should return AllocationPeriodValidForFundingStreamCodeRule.");
            Assert.IsTrue(rules.OfType<AllocationOnlyOnePerFundingStreamRule>().Any(),
                "GetContractAmendmentSecondLevelRules should return AllocationOnlyOnePerFundingStreamRule.");
            Assert.IsTrue(rules.OfType<AllocationValidLepCodeRule>().Any(),
                "GetContractAmendmentSecondLevelRules should return AllocationValidLepCodeRule.");
            Assert.IsTrue(rules.OfType<AllocationMandatoryESFDataPopulatedRule>().Any(),
                "GetContractAmendmentSecondLevelRules should return AllocationMandatoryESFDataPopulatedRule.");
            Assert.IsTrue(rules.OfType<AllocationValidRegionTypeRule>().Any(),
                "GetContractAmendmentSecondLevelRules should return AllocationValidRegionTypeRule.");
            Assert.IsTrue(rules.OfType<AllocationValidUoPCodeRule>().Any(),
                "GetContractAmendmentSecondLevelRules should return AllocationValidUoPCodeRule.");
            Assert.IsTrue(rules.OfType<AllocationEndDateAfterContractEndDateRule>().Any(),
                "GetContractAmendmentSecondLevelRules should return AllocationEndDateAfterContractEndDateRule.");
            Assert.IsTrue(rules.OfType<AllocationEndDateBeforeContractStartDateRule>().Any(),
                "GetContractAmendmentSecondLevelRules should return AllocationEndDateBeforeContractStartDateRule.");
            Assert.IsTrue(rules.OfType<AllocationStartDateBeforeContractStartDateRule>().Any(),
                "GetContractAmendmentSecondLevelRules should return AllocationStartDateBeforeContractStartDateRule.");
            Assert.IsTrue(rules.OfType<AllocationStartDateAfterContractEndDateRule>().Any(),
                "GetContractAmendmentSecondLevelRules should return AllocationStartDateAfterContractEndDateRule.");
            Assert.IsTrue(rules.OfType<AllocationStartAndEndDatesMustNotBeTheSameRule>().Any(),
                "GetContractAmendmentSecondLevelRules should return AllocationStartAndEndDatesMustNotBeTheSameRule.");
            Assert.IsTrue(rules.OfType<AllocationValidSpecificationTitleRule>().Any(),
                "GetContractAmendmentSecondLevelRules should return AllocationValidSpecificationTitleRule");
            Assert.IsTrue(rules.OfType<StartAndEndDatesMandatoryRule>().Any(),
                "GetContractAmendmentSecondLevelRules should return StartAndEndDatesMandatoryRule.");
            Assert.IsTrue(rules.OfType<InvalidFundingStreamPeriodCodeRule>().Any(),
                "GetContractAmendmentSecondLevelRules should return InvalidFundingStreamPeriodCodeRule.");
            Assert.IsTrue(rules.OfType<DeliverablesCannotBeDuplicatedWithinAnAllocationRule>().Any(),
                "GetContractAmendmentSecondLevelRules should return DeliverablesCannotBeDuplicatedWithinAnAllocationRule.");
            Assert.IsTrue(rules.OfType<DeliverablePeriodForEachMonthRule>().Any(),
                "GetContractAmendmentSecondLevelRules should return DeliverablePeriodForEachMonthRule.");
            Assert.IsTrue(rules.OfType<DeliverableMultipleRecordsPerPeriodRule>().Any(),
                "GetContractAmendmentSecondLevelRules should return DeliverableMultipleRecordsPerPeriodRule.");
            Assert.IsTrue(rules.OfType<MustHaveMatchingContractInFctRule>().Any(),
                "GetContractAmendmentSecondLevelRules should return MustHaveMatchingContractInFctRule.");
            Assert.IsTrue(rules.OfType<MustHaveMatchingContractAllocationInFctRule>().Any(),
                "GetContractAmendmentSecondLevelRules should return MustHaveMatchingContractAllocationInFctRule.");
            Assert.IsTrue(rules.OfType<MustHaveMatchingMasterContractInFctRule>().Any(),
                "GetContractAmendmentSecondLevelRules should return MustHaveMatchingMasterContractInFctRule.");
            Assert.IsTrue(rules.OfType<MustHaveMatchingDeliverableInFctRule>().Any(),
                "GetContractAmendmentSecondLevelRules should return MustHaveMatchingDeliverableInFctRule.");
            Assert.IsTrue(rules.OfType<ContractAllocationMustHaveActiveUkprnRule>().Any(),
                "GetContractAmendmentSecondLevelRules should return ContractAllocationMustHaveActiveUkprnRule.");
            Assert.IsTrue(rules.OfType<DeliverableMustHaveActiveUkprnRule>().Any(),
                "GetContractAmendmentSecondLevelRules should return DeliverableMustHaveActiveUkprnRule.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetUpdateDraftContractAmendmentFirstLevelRules_ReturnsContractAmendmentFirstLevelRules()
        {
            var rules =
                new ContractOperationRules(new Mock<IFundingTypeFundingPeriodQueryRepository>().Object,
                        Mock.Of<IFundingTypeFundingPeriodContractTypeQueryRepository>())
                    .GetUpdateDraftContractAmendmentFirstLevelRules(new contractRequestType(),
                        new Dictionary<string, FSCDeliverableStructureDefinitionResponse>(),
                        new List<FundingStreamPeriodLegalDeliverable>()).ToList();

            Assert.IsTrue(rules.OfType<MustSpecifyContractAllocationNumberDeleteRule>().Any(),
                "GetUpdateDraftContractAmendmentFirstLevelRules should return MustSpecifyContractAllocationNumberDeleteRule.");
            Assert.IsTrue(rules.OfType<MustSpecifyContractAllocationNumberUpdateRule>().Any(),
                "GetUpdateDraftContractAmendmentFirstLevelRules should return MustSpecifyContractAllocationNumberUpdateRule.");
            Assert.IsTrue(rules.OfType<MustSpecifyContractNumberRule>().Any(),
                "GetUpdateDraftContractAmendmentFirstLevelRules should return MustSpecifyContractNumberRule.");
            Assert.IsTrue(rules.OfType<MustSpecifyMasterContractNumberRule>().Any(),
                "GetUpdateDraftContractAmendmentFirstLevelRules should return MustSpecifyMasterContractNumberRule.");
            Assert.IsTrue(rules.OfType<ConditionalMandatoryFieldsRule>().Any(),
                "GetUpdateDraftContractAmendmentFirstLevelRules should return ConditionalMandatoryFieldsRule.");
            Assert.IsTrue(rules.OfType<NewIntentContractAllocationNumberNullRule>().Any(),
                "GetUpdateDraftContractAmendmentFirstLevelRules should return NewIntentContractAllocationNumberNullRule.");
            Assert.IsTrue(rules.OfType<ContractAmendmentMustHaveExistingApprovedOrWithdrawnContractRule>().Any(),
                $"GetUpdateDraftContractAmendmentFirstLevelRules should return {nameof(ContractAmendmentMustHaveExistingApprovedOrWithdrawnContractRule)}.");
            Assert.IsTrue(rules.OfType<UpdateDraftAmendmentCannotRunAgainstContractWithoutAmendmentTypeRule>().Any(),
                "GetUpdateDraftContractAmendmentFirstLevelRules should return UpdateDraftAmendmentCannotRunAgainstContractWithoutAmendmentTypeRule.");
            Assert.IsTrue(rules.OfType<DeliverableNotValidForFundingStreamPeriodRule>().Any(),
                "GetUpdateDraftContractAmendmentFirstLevelRules should return DeliverableNotValidForFundingStreamPeriodRule.");
            Assert.IsTrue(rules.OfType<DeliverableAllowProfileRule>().Any(),
                "GetUpdateDraftContractAmendmentFirstLevelRules should return DeliverableAllowProfileRule.");
            Assert.IsTrue(rules.OfType<DeliverableYearAndPeriodCombinationRule>().Any(),
                "GetUpdateDraftContractAmendmentFirstLevelRules should return DeliverableYearAndPeriodCombinationRule.");
            Assert.IsTrue(rules.OfType<ValueDeliverableNoUnitCostRule>().Any(),
                "GetUpdateDraftContractAmendmentFirstLevelRules should return ValueDeliverableNoUnitCostRule.");
            Assert.IsTrue(rules.OfType<ValueDeliverableNoVolumesRule>().Any(),
                "GetUpdateDraftContractAmendmentFirstLevelRules should return ValueDeliverableNoVolumesRule.");
            Assert.IsTrue(rules.OfType<UpdateDraftAmendmentMustHaveAnAmendmentTypeRule>().Any(),
                "GetUpdateDraftContractAmendmentFirstLevelRules should return UpdateDraftContractAmendmentMustHaveAnAmendmentTypeRule.");
            Assert.IsTrue(rules.OfType<UpdateDraftAmendmentCannotDeleteApprovedAllocationRule>().Any(),
                "GetUpdateDraftContractAmendmentFirstLevelRules should return UpdateDraftAmendmentCannotDeleteApprovedAllocationRule.");
            Assert.IsTrue(rules.OfType<UpdateDraftAmendmentCannotDeleteApprovedDeliverableRule>().Any(),
                "GetUpdateDraftContractAmendmentFirstLevelRules should return UpdateDraftAmendmentCannotDeleteApprovedDeliverableRule.");
            Assert.IsTrue(rules.OfType<ValueAndVolumeDeliverableVolumeRequiredRule>().Any(),
                "GetUpdateDraftContractAmendmentFirstLevelRules should return ValueAndVolumeDeliverableVolumeRequiredRule.");
            Assert.IsTrue(rules.OfType<ValueAndVolumeDeliverableUnitCostRequiredRule>().Any(),
                "GetUpdateDraftContractAmendmentFirstLevelRules should return ValueAndVolumeDeliverableUnitCostRequiredRule.");
            Assert.IsTrue(rules.OfType<ValueAndVolumeDeliverableNoValueRule>().Any(),
                "GetUpdateDraftContractAmendmentFirstLevelRules should return ValueAndVolumeDeliverableNoValueRule.");
            Assert.IsTrue(rules.OfType<DeliverableUnitCostMustBeTheSameForEachPeriodRule>().Any(),
                "GetUpdateDraftContractAmendmentFirstLevelRules should return DeliverableUnitCostMustBeTheSameForEachPeriodRule.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractOperationsRules_GetCreateContractRules_ShouldReturnRulesWhenChannelIsFundingTypeIsNotDas()
        {
            // act
            ContractOperationRules rulesFactory = new ContractOperationRules(
                new Mock<IFundingTypeFundingPeriodQueryRepository>().Object,
                Mock.Of<IFundingTypeFundingPeriodContractTypeQueryRepository>());
            IEnumerable<IRule<contractRequestType>> rules = rulesFactory.GetCreateContractRules(
                new List<FundingConfigurationDataType>(),
                new List<string>(),
                new List<string>(),
                new List<UnitOfProcurement>(),
                new List<string>(),
                new List<string>(),
                new List<string>(),
                new Dictionary<string, FSCDeliverableStructureDefinitionResponse>(),
                new List<MatchingTenderAwardReferenceItem>(),
                false,
                new List<FundingTypePeriodFundingStreamPeriod>(),
                new List<FundingStreamPeriodLegalDeliverable>(),
                new contractRequestType
                {
                    contract = new contractType
                    {
                        fundingTypeCode = "MAIN",
                        period = new periodType
                        {
                            period = "1718",
                            periodType1 = new periodTypeType()
                        },
                        contracts = new List<contractType>()
                        {
                            new contractType
                            {
                                fundingTypeCode = "MAIN",
                                period = new periodType
                                {
                                    period = "1718",
                                    periodType1 = new periodTypeType()
                                }
                            }
                        }
                    }
                });

            // assert
            Assert.IsNotNull(rules, "Returned rule collection was null.");
            Assert.IsTrue(rules.Any(), "Returned rule collection was empty.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractOperationsRules_GetCreateContractRules_ShouldReturnEmptyRuleSetWhenFundingTypeIsDas()
        {
            // act
            ContractOperationRules rulesFactory = new ContractOperationRules(
                new Mock<IFundingTypeFundingPeriodQueryRepository>().Object,
                Mock.Of<IFundingTypeFundingPeriodContractTypeQueryRepository>());
            IEnumerable<IRule<contractRequestType>> rules = rulesFactory.GetCreateContractRules(
                new List<FundingConfigurationDataType>(),
                new List<string>(),
                new List<string>(),
                new List<UnitOfProcurement>(),
                new List<string>(),
                new List<string>(),
                new List<string>(),
                new Dictionary<string, FSCDeliverableStructureDefinitionResponse>(),
                new List<MatchingTenderAwardReferenceItem>(),
                false,
                new List<FundingTypePeriodFundingStreamPeriod>(),
                new List<FundingStreamPeriodLegalDeliverable>(),
                new contractRequestType
                {
                    contract = new contractType
                    {
                        fundingTypeCode = "LEVY"
                    }
                });

            // assert
            Assert.IsNotNull(rules, "Returned rule collection was null.");
            Assert.IsTrue(rules.Any(), "Returned rule collection was empty.");
        }


        [TestMethod, TestCategory("UnitTest")]
        public void ContractOperationsRules_ShouldResolve()
        {
           using (IWindsorContainer container = new WindsorContainer().Install(new ContractCreateDomain.Endpoint.WindsorInstallerForSagas(new LoggerFactory())))
           {
                container.BeginScope();
                
                var rules = container.Resolve<ContractCreateDomain.Endpoint.Infrastructure.IContractOperationRules>();

                Assert.IsNotNull(rules, "Could not resolve");
            }
        }
    }
}