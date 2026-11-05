namespace ContractCreateDomain.Tests
{
    using System.Collections.Generic;
    using System.Linq;
    using ContractManagement.DataStore.Model;
    using ContractManagement.DataStore.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules.Deliverable;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules.UDC;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence.Entities;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;

    [TestClass]
    public class ContractOperationRulesAllMethodsTests
    {
        private readonly ContractOperationRules sut = new ContractOperationRules(
            Mock.Of<IFundingTypeFundingPeriodQueryRepository>(),
            Mock.Of<IFundingTypeFundingPeriodContractTypeQueryRepository>());

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

        private static contractRequestType CreateRequest()
        {
            var request = new contractRequestType { contract = new contractType() };
            request.contract.contracts.Add(new contractType
            {
                period = new periodType { period = "1", periodType1 = new periodTypeType { periodTypeCode = "AY" } }
            });
            return request;
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
                FtpFsp, ProfileDeliverables, CreateRequest()).ToList();

            AssertValid(rules);
            Assert.IsTrue(rules.OfType<InvalidUkprnRule>().Any());
            Assert.IsTrue(rules.OfType<DeliverablePeriodForEachMonthRule>().Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetCreateContractRules_ForLevyContract_ReturnsLevyRuleSet()
        {
            var request = new contractRequestType { contract = new contractType { fundingTypeCode = "LEVY" } };

            var rules = this.sut.GetCreateContractRules(
                FundingConfig, Strings, Strings, Uops, Strings, Strings, Strings, Structures, TenderAwards, false,
                FtpFsp, ProfileDeliverables, request).ToList();

            Assert.AreEqual(2, rules.Count);
            Assert.IsTrue(rules.OfType<InvalidUkprnRule>().Any());
            Assert.IsTrue(rules.OfType<ExistingDraftOrApprovedContractRule>().Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetCreateContractRevisedNewRules_ReturnsExpectedRules()
        {
            var rules = this.sut.GetCreateContractRevisedNewRules(
                FundingConfig, Strings, Strings, Uops, Strings, Strings, Strings, Structures, TenderAwards, true,
                FtpFsp, ProfileDeliverables, CreateRequest()).ToList();

            AssertValid(rules);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetUpdateDraftContractSecondLevelRules_ReturnsExpectedRules()
        {
            var rules = this.sut.GetUpdateDraftContractSecondLevelRules(
                FundingConfig, Strings, Strings, Uops, Strings, Strings, Strings, Structures, TenderAwards, FtpFsp,
                CreateRequest()).ToList();

            AssertValid(rules);
            Assert.IsTrue(rules.OfType<InvalidFundingStreamPeriodCodeRule>().Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetContractAmendmentFirstLevelRules_IncludesNoExistingContractRule()
        {
            var rules = this.sut.GetContractAmendmentFirstLevelRules(
                CreateRequest(), Structures, ProfileDeliverables).ToList();

            AssertValid(rules);
            Assert.IsTrue(rules.OfType<NoExistingContractRule>().Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetContractAmendmentSecondLevelRules_ReturnsExpectedRules()
        {
            var rules = this.sut.GetContractAmendmentSecondLevelRules(
                FundingConfig, Strings, Strings, Uops, Strings, Strings, Strings, Structures, TenderAwards, FtpFsp,
                CreateRequest(), IdentityInfos).ToList();

            AssertValid(rules);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetUpdateDraftContractAmendmentFirstLevelRules_IncludesAmendmentTypeRule()
        {
            var rules = this.sut.GetUpdateDraftContractAmendmentFirstLevelRules(
                CreateRequest(), Structures, ProfileDeliverables).ToList();

            AssertValid(rules);
            Assert.IsTrue(rules.OfType<UpdateDraftAmendmentCannotRunAgainstContractWithoutAmendmentTypeRule>().Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetUpdateDraftContractAmendmentSecondLevelRules_ReturnsExpectedRules()
        {
            var rules = this.sut.GetUpdateDraftContractAmendmentSecondLevelRules(
                FundingConfig, Strings, Strings, Uops, Strings, Strings, Strings, Structures, TenderAwards, FtpFsp,
                CreateRequest(), IdentityInfos).ToList();

            AssertValid(rules);
        }
    }
}
