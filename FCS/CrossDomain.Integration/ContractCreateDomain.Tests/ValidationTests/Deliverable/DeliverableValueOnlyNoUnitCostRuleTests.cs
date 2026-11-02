namespace ContractCreateDomain.Tests.Integration_Tests
{
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules.Deliverable;
    using ValidationTests;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;

    /// <summary>
    /// DBR-014
    /// </summary>
    [TestClass]
    public class DeliverableValueOnlyNoUnitCostRuleTests : ContractRequestValidationBase
    {
        private ValueDeliverableNoUnitCostRule _validator;

        [TestInitialize]
        public void Startup()
        {
            _validator = new ValueDeliverableNoUnitCostRule(DeliverableMetaData);

            //Convert FSC Data to Value Only Types.
            foreach (var fscSettings in DeliverableMetaData[Contract.GetAllocations().First().fundingStreamPeriodCode].DeliverableStructureList)
            {
                fscSettings.Settings.First(s => s.SettingCode.Contains("planningunit")).SettingValue = "Value";
            }

            Contract.GetDeliverables().ToList().ForEach(cd => cd.unitCost = null);
            Contract.GetDeliverablePeriods().ToList().ForEach(cdp => SetContractDeliverablePeriod(cdp));
        }

        private void SetContractDeliverablePeriod(contractDeliverablePeriodType cdp)
        {
            cdp.plannedValue = 100;
            cdp.plannedVolume = null;
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Ensure_AValueOnlyTypeDeliverable_WithoutAUnitCost_PassesValidation()
        {
            // Act/Assert
            Assert.IsFalse(_validator.GetFailuresForItem(Contract).Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Ensure_AValueOnlyTypeDeliverable_WithAUnitCost_FailsValidation()
        {
            // Arrange
            var firstDeliverable = Contract.GetDeliverables().First();
            firstDeliverable.unitCost = 123;

            // Act
            var failedCorrelationIds = _validator.GetFailuresForItem(Contract);

            // Assert
            Assert.IsTrue(failedCorrelationIds.Count() == 1);
            Assert.AreEqual(firstDeliverable.correlationId, failedCorrelationIds.First());
        }
      
    }
}