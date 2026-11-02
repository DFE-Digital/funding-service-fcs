namespace ContractCreateDomain.Tests.ValidationTests.Deliverable
{
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules.Deliverable;

    /// <summary>
    /// Rule DBR-017
    /// </summary>
    [TestClass]
    public class DeliverableTypeValueandVolumeUnitCostRequiredRuleTests : ContractRequestValidationBase
    {
        private ValueAndVolumeDeliverableUnitCostRequiredRule _validator;

        [TestInitialize]
        public void Startup()
        {
            _validator = new ValueAndVolumeDeliverableUnitCostRequiredRule(DeliverableMetaData);

            //Convert FSC Data to Volume Types.
            foreach (var fscSettings in DeliverableMetaData[Contract.GetAllocations().First().fundingStreamPeriodCode].DeliverableStructureList)
            {
                fscSettings.Settings.First(s => s.SettingCode.Contains("planningunit")).SettingValue = "Volume and Value";
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Ensure_AValidValueAndVolumeTypeDeliverable_WithAUnitCost_PassesValidation()
        {
            foreach (var deliverable in Contract.GetDeliverables())
            {
                deliverable.unitCost = 123;
            }
            Assert.IsFalse(_validator.GetFailuresForItem(Contract).Any());
        }


        [TestMethod, TestCategory("UnitTest")]
        public void Ensure_AnInvalidValueAndVolumeTypeDeliverable_WithoutAUnitCost_FailsValidation()
        {
            foreach (var deliverable in Contract.GetDeliverables())
            {
                deliverable.unitCost = null;
            }
            Assert.IsTrue(_validator.GetFailuresForItem(Contract).Any());
        }
    }
}