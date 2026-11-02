namespace ContractCreateDomain.Tests.ValidationTests.Deliverable
{
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules.Deliverable;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
    using MoreLinq;

    /// <summary>
    /// Rule DBR-007
    /// </summary>
    [TestClass]
    public class DeliverableMultipleRecordsPerPeriodRuleTests : ContractRequestValidationBase
    {
        private DeliverableMultipleRecordsPerPeriodRule _rule;

        [TestInitialize]
        public void Startup()
        {
            _rule = new DeliverableMultipleRecordsPerPeriodRule();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DeliverableMultipleRecordsPerPeriodRule_ShouldEnsureADeliverableWithNoDuplicatedRecordsForTheSamePeriodPassesValidation()
        {
            Assert.IsFalse(_rule.GetFailuresForItem(Contract).Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DeliverableMultipleRecordsPerPeriodRule_ShouldEnsureADeliverableWithDuplicatedRecordsForTheSamePeriodFailsValidation()
        {
            Contract.GetDeliverables().First().contractDeliverablePeriods.Add(Contract.GetDeliverables().First().contractDeliverablePeriods.First());
            Assert.IsTrue(_rule.GetFailuresForItem(Contract).Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DeliverableMultipleRecordsPerPeriodRule_ShouldEnsureADeliverableWithDuplicatedRecordsForTheSamePeriodForEsfContractsFailsValidation()
        {
            Contract.GetAllContracts().ForEach(x => x.fundingTypeCode = "ESF");

            Contract.GetDeliverables().First().contractDeliverablePeriods.Add(Contract.GetDeliverables().First().contractDeliverablePeriods.First());
            Assert.IsTrue(_rule.GetFailuresForItem(Contract).Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DeliverableMultipleRecordsPerPeriodRule_ShouldPassWhenGivenValidEfaContractWithDeliveryOrganisations()
        {
            // arrange
            contractRequestType efaContract = GetUpdateDraftEfaContract();

            // act
            IEnumerable<string> failures = _rule.GetFailuresForItem(efaContract);

            // assert
            Assert.IsFalse(failures.Any());
        }
    }
}
