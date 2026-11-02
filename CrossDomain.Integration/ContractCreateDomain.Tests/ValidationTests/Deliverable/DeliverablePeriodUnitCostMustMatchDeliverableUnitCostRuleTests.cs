namespace ContractCreateDomain.Tests.ValidationTests.Deliverable
{
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules.Deliverable;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;

    /// <summary>
    /// Rule DBR-010
    /// </summary>
    [TestClass]
    public class DeliverablePeriodUnitCostMustMatchDeliverableUnitCostRuleTests : ContractRequestValidationBase
    {
        private DeliverableUnitCostMustBeTheSameForEachPeriodRule _validator;

        [TestInitialize]
        public void Startup()
        {
            _validator = new DeliverableUnitCostMustBeTheSameForEachPeriodRule(DeliverableMetaData);

            foreach (var fscSettings in DeliverableMetaData[Contract.GetAllocations().First().fundingStreamPeriodCode].DeliverableStructureList)
            {
                fscSettings.Settings.First(s => s.SettingCode.Contains("planningunit")).SettingValue = "Value";
            }

            foreach (var fscSettings in DeliverableMetaData[EsfContract.GetAllocations().First().fundingStreamPeriodCode].DeliverableStructureList)
            {
                fscSettings.Settings.First(s => s.SettingCode.Contains("planningunit")).SettingValue = "Volume and Value";
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DeliverableUnitCostMustBeTheSameForEachPeriodRule_GetFailuresForItem_VolumeDeliverableWithConsistentUnitCostDeliverablePassesValidation()
        {
            List<string> errorList = _validator.GetFailuresForItem(EsfContract).ToList();

            Assert.IsFalse(errorList.Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DeliverableUnitCostMustBeTheSameForEachPeriodRule_GetFailuresForItem_VolumeDeliverableWithMultipleInconsistentUnitCostDeliverableFailsValidation()
        {
            IEnumerable<contractDeliverable> allDeliverables = EsfContract.GetDeliverables();
            List<string> expectedErrorDeliverableCorrelationIds = allDeliverables.Select(d => d.correlationId).ToList();

            allDeliverables.First().contractDeliverablePeriods[3].unitCost = 321m;
            allDeliverables.Skip(1).First().contractDeliverablePeriods[2].unitCost = 20m;
            allDeliverables.Skip(2).First().contractDeliverablePeriods[10].unitCost = 30m;
            allDeliverables.Skip(3).First().contractDeliverablePeriods[0].unitCost = 100m;

            List<string> errorList = _validator.GetFailuresForItem(EsfContract).ToList();

            Assert.IsTrue(errorList.Any());
            CollectionAssert.AreEquivalent(expectedErrorDeliverableCorrelationIds, errorList.ToList());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DeliverableUnitCostMustBeTheSameForEachPeriodRule_GetFailuresForItem_VolumeDeliverableWithSingleInconsistentUnitCostDeliverableFailsValidation()
        {
            var allocation = EsfContract.GetAllocations().First();
            var deliverable = allocation.contractDeliverables.First();

            var expectedErrorDeliverableCorrelationId = deliverable.correlationId;

            deliverable.contractDeliverablePeriods.ForEach(dp => dp.unitCost = 50m);

            deliverable.contractDeliverablePeriods.Skip(5).First().unitCost = 60m;

            List<string> errorList = _validator.GetFailuresForItem(EsfContract).ToList();

            Assert.IsNotNull(errorList);
            Assert.AreEqual(1, errorList.Count());
            Assert.AreEqual(expectedErrorDeliverableCorrelationId, errorList.First());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DeliverableUnitCostMustBeTheSameForEachPeriodRule_GetFailuresForItem_ValueDeliverableNullUnitCostPassesValidation()
        {
            // arrange 
            var contractDeliverables = Contract.GetDeliverables();

            foreach (contractDeliverable contractDeliverable in contractDeliverables)
            {
                foreach (contractDeliverablePeriodType contractDeliverablePeriod in contractDeliverable.contractDeliverablePeriods)
                {
                    contractDeliverablePeriod.unitCost = null;
                }
            }

            // act
            IEnumerable<string> errorList = _validator.GetFailuresForItem(Contract);

            // assert
            Assert.IsFalse(errorList.Any(), "Validation failed");
        }
    }
}