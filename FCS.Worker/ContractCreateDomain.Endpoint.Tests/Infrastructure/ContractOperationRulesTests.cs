namespace ContractCreateDomain.Endpoint.Tests.Infrastructure
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using ContractManagement.DataStore.Dtos;
    using ContractManagement.DataStore.Model;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractCreateDomain.BusinessLogic;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.DTOs;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules.Deliverable;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules.UDC;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence.Entities;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
    using ContractOperationRules = Endpoint.Infrastructure.ContractOperationRules;

    [TestClass]
    public class ContractOperationRulesTests
    {
        private readonly ContractOperationRules sut = new ContractOperationRules();

        private static IEnumerable<FundingConfigurationDataType> FundingConfig => new List<FundingConfigurationDataType>();

        private static IEnumerable<string> Strings => new List<string>();

        private static IEnumerable<UnitOfProcurement> Uops => new List<UnitOfProcurement>();

        private static Dictionary<string, FSCDeliverableStructureDefinitionResponse> Structures =>
            new Dictionary<string, FSCDeliverableStructureDefinitionResponse>();

        private static IReadOnlyCollection<MatchingTenderAwardReferenceItem> TenderAwards =>
            new List<MatchingTenderAwardReferenceItem>();

        private static IReadOnlyCollection<FundingTypePeriodFundingStreamPeriod> FtpFsp =>
            new List<FundingTypePeriodFundingStreamPeriod>();

        private static IReadOnlyCollection<FundingStreamPeriodLegalDeliverable> ProfileDeliverables =>
            new List<FundingStreamPeriodLegalDeliverable>();

        private static IReadOnlyCollection<ContractIdentityInfo> IdentityInfos => new List<ContractIdentityInfo>();

        private static Func<IReadOnlyCollection<FundingTypeFundingPeriodContractTypeDto>> ContractTypesFunc =>
            () => new List<FundingTypeFundingPeriodContractTypeDto>();

        private static void AssertContains<T>(IEnumerable<IRule<contractRequestType>> rules)
        {
            Assert.IsTrue(rules.OfType<T>().Any(), $"Expected rule {typeof(T).Name}.");
        }

        private static void AssertValid(List<IRule<contractRequestType>> rules)
        {
            Assert.IsTrue(rules.Count > 0);
            Assert.IsFalse(rules.Any(r => r == null));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetNewAmendmentContractRules_ReturnsExpectedRules()
        {
            var rules = this.sut.GetNewAmendmentContractRules(
                FundingConfig, Strings, Strings, Uops, Strings, Strings, Strings, Structures, TenderAwards, true,
                FtpFsp, ProfileDeliverables, new contractRequestType(), true, ContractTypesFunc, dto => true, false).ToList();

            AssertValid(rules);
            AssertContains<MasterContractNewAmendmentRule>(rules);
            AssertContains<AllowNewAmendmentRule>(rules);
            AssertContains<SiblingContractWithDraftStatusRule>(rules);
            AssertContains<DeliverablePeriodForEachMonthRule>(rules);
            AssertContains<ContractTypeForFundingTypeFundingPeriodRule>(rules);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetCreateContractRules_ForStandardContract_ReturnsFullRuleSet()
        {
            var request = new contractRequestType { contract = new contractType { fundingTypeCode = "ESF" } };

            var rules = this.sut.GetCreateContractRules(
                FundingConfig, Strings, Strings, Uops, Strings, Strings, Strings, Structures, TenderAwards, false,
                FtpFsp, ProfileDeliverables, request, false, ContractTypesFunc, dto => true).ToList();

            AssertValid(rules);
            Assert.IsTrue(rules.Count > 2);
            AssertContains<InvalidUkprnRule>(rules);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetCreateContractRules_ForLevyContract_ReturnsLevyRuleSet()
        {
            var request = new contractRequestType { contract = new contractType { fundingTypeCode = "LEVY" } };

            var rules = this.sut.GetCreateContractRules(
                FundingConfig, Strings, Strings, Uops, Strings, Strings, Strings, Structures, TenderAwards, false,
                FtpFsp, ProfileDeliverables, request, false, ContractTypesFunc, dto => true).ToList();

            Assert.AreEqual(2, rules.Count);
            AssertContains<InvalidUkprnRule>(rules);
            AssertContains<ExistingDraftOrApprovedContractRule>(rules);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetCreateContractRevisedNewRules_ReturnsExpectedRules()
        {
            var rules = this.sut.GetCreateContractRevisedNewRules(
                FundingConfig, Strings, Strings, Uops, Strings, Strings, Strings, Structures, TenderAwards, true,
                FtpFsp, ProfileDeliverables, new contractRequestType(), true, ContractTypesFunc, true).ToList();

            AssertValid(rules);
            AssertContains<DeliverableMultipleRecordsPerPeriodRule>(rules);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetUpdateDraftContractFirstLevelRules_ReturnsExpectedRules()
        {
            var rules = this.sut.GetUpdateDraftContractFirstLevelRules(
                new contractRequestType(), Structures, ProfileDeliverables, ContractTypesFunc).ToList();

            AssertValid(rules);
            AssertContains<MustSpecifyContractNumberRule>(rules);
            AssertContains<DeliverableAllowProfileRule>(rules);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetUpdateDraftContractSecondLevelRules_ReturnsExpectedRules()
        {
            var rules = this.sut.GetUpdateDraftContractSecondLevelRules(
                FundingConfig, Strings, Strings, Uops, Strings, Strings, Strings, Structures, TenderAwards, FtpFsp,
                new contractRequestType(), true).ToList();

            AssertValid(rules);
            AssertContains<InvalidFundingStreamPeriodCodeRule>(rules);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetContractAmendmentFirstLevelRules_ReturnsExpectedRules()
        {
            var rules = this.sut.GetContractAmendmentFirstLevelRules(
                new contractRequestType(), Structures, ProfileDeliverables, ContractTypesFunc, true).ToList();

            AssertValid(rules);
            AssertContains<SiblingContractWithDraftStatusRule>(rules);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetContractAmendmentSecondLevelRules_ReturnsExpectedRules()
        {
            var rules = this.sut.GetContractAmendmentSecondLevelRules(
                FundingConfig, Strings, Strings, Uops, Strings, Strings, Strings, Structures, TenderAwards, FtpFsp,
                new contractRequestType(), IdentityInfos, true).ToList();

            AssertValid(rules);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetUpdateDraftContractAmendmentFirstLevelRules_ReturnsExpectedRules()
        {
            var rules = this.sut.GetUpdateDraftContractAmendmentFirstLevelRules(
                new contractRequestType(), Structures, ProfileDeliverables, ContractTypesFunc).ToList();

            AssertValid(rules);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetUpdateDraftContractAmendmentSecondLevelRules_ReturnsExpectedRules()
        {
            var rules = this.sut.GetUpdateDraftContractAmendmentSecondLevelRules(
                FundingConfig, Strings, Strings, Uops, Strings, Strings, Strings, Structures, TenderAwards, FtpFsp,
                new contractRequestType(), IdentityInfos, true).ToList();

            AssertValid(rules);
        }
    }
}
