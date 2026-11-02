namespace ContractCreateDomain.Tests.ValidationTests.Deliverable
{
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules.Deliverable;

    /// <summary>
    /// DBR-013
    /// </summary>
    [TestClass]
    public class DeliverableTypeValueNoVolumesRuleTests : ContractRequestValidationBase
    {
        private ValueDeliverableNoVolumesRule _validator;

        [TestInitialize]
        public void Startup()
        {
            _validator = new ValueDeliverableNoVolumesRule(DeliverableMetaData);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void EnsureADeliverableTypeValueWithVolumeSpecifiedFailsForNonEsf()
        {
            // in the non-esf contract, deliverable 1 is value-only, there are no other deliverables

            Contract.GetDeliverablePeriods().ToList().ForEach(x => x.plannedVolume = 123);

            var valueOnlyDeliverables = Contract.GetDeliverables().Where(d => d.deliverable.deliverableCode == 1);
            var expectedCorrelationIds = valueOnlyDeliverables.Select(d => d.correlationId).ToList();

            var failedCorrelationIds = _validator.GetFailuresForItem(Contract).ToList();

            Assert.IsNotNull(failedCorrelationIds);
            CollectionAssert.AreEquivalent(expectedCorrelationIds, failedCorrelationIds);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void EnsureNonEsfAllocationsWithValueOnlyDeliverableWithVolumeSpecifiedReturnsCorrelationIds()
        {
            // in the non-esf contract, deliverable 1 is value-only, there are no other deliverables
            var deliverablePeriods = Contract.GetDeliverablePeriods().ToList();
            deliverablePeriods.ForEach(dp => dp.plannedVolume = null);
            var allocation = Contract.GetAllocations().First();
            var deliverable = allocation.contractDeliverables.First(d => d.deliverable.deliverableCode == 1);

            var expectedErrorDeliverableCorrelationId = deliverable.correlationId;

            deliverable.contractDeliverablePeriods.Skip(7).First().plannedVolume = 69;

            var errorList = _validator.GetFailuresForItem(Contract);

            Assert.IsNotNull(errorList);
            Assert.AreEqual(1, errorList.Count());
            Assert.AreEqual(expectedErrorDeliverableCorrelationId, errorList.First());
        }

        //TODO: we need a non-esf contract that contains deliverables other than value-only to test they don't fail validation when a plannedVolume is populated

        [TestMethod, TestCategory("UnitTest")]
        public void EnsureADeliverableTypeValueWithVolumeSpecifiedFailsForEsf()
        {
            // in the esf contract, deliverable 1 is volume-&-value, and deliverable 2 is value-only

            // set planned volume for all dp's (for those attached to value-only & volume-&-value deliverables)
            EsfContract.GetDeliverablePeriods().ToList().ForEach(x => x.plannedVolume = 123);

            var valueOnlyDeliverables = EsfContract.GetDeliverables().Where(d => d.deliverable.deliverableCode == 2);
            // we expect only the value-only deliverables to fail
            var expectedCorrelationIds = valueOnlyDeliverables.Select(d => d.correlationId).ToList();

            var failedCorrelationIds = _validator.GetFailuresForItem(EsfContract).ToList();

            Assert.IsNotNull(failedCorrelationIds);
            CollectionAssert.AreEquivalent(expectedCorrelationIds, failedCorrelationIds);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void EnsureEsfAllocationsWithValueOnlyDeliverableWithVolumeSpecifiedReturnsCorrelationIds()
        {
            // in the esf contract, deliverable 1 is value and volume, and deliverable 2 is volume only

            var allocation = EsfContract.GetAllocations().First();
            var deliverable = allocation.contractDeliverables.First(d => d.deliverable.deliverableCode == 2);

            var expectedErrorDeliverableCorrelationId = deliverable.correlationId;

            deliverable.contractDeliverablePeriods.Skip(7).First().plannedVolume = 69;

            var errorList = _validator.GetFailuresForItem(EsfContract);

            Assert.IsNotNull(errorList);
            Assert.AreEqual(1, errorList.Count());
            Assert.AreEqual(expectedErrorDeliverableCorrelationId, errorList.First());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void EnsureAValidDeliverableTypeValueWithNoVolumesSpecifiedValidatesCorrectly()
        {
            var deliverablePeriods = Contract.GetDeliverablePeriods();
            deliverablePeriods.ToList().ForEach(dp => dp.plannedVolume = null);

            Assert.IsFalse(_validator.GetFailuresForItem(Contract).Any());
        }
    }
}