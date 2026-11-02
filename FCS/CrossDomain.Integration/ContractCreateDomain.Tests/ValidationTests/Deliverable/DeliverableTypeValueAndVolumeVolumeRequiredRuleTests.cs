namespace ContractCreateDomain.Tests.ValidationTests.Deliverable
{
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules.Deliverable;

    /// <summary>
    /// Rule DBR-016
    /// </summary>
    [TestClass]
    public class DeliverableTypeValueAndVolumeVolumeRequiredRuleTests : ContractRequestValidationBase
    {
        private ValueAndVolumeDeliverableVolumeRequiredRule _validator;

        [TestInitialize]
        public void Startup()
        {
            _validator = new ValueAndVolumeDeliverableVolumeRequiredRule(DeliverableMetaData);

            //Convert FSC Data to Volume Types.
            foreach (var fscSettings in DeliverableMetaData[Contract.GetAllocations().First().fundingStreamPeriodCode].DeliverableStructureList)
            {
                fscSettings.Settings.First(s => s.SettingCode.Contains("planningunit")).SettingValue = "Volume and Value";
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Ensure_AValueAndVolumeTypeDeliverable_WithAPlannedVolume_PassesValidation()
        {
            // Arrange
            foreach (var deliverable in Contract.GetDeliverables())
            {
                deliverable.contractDeliverablePeriods.ForEach(cd => cd.plannedVolume = 123);
            }         

            // Act/Assert
            Assert.IsFalse(_validator.GetFailuresForItem(Contract).Any());
        }
        
        [TestMethod, TestCategory("UnitTest")]
        public void Ensure_AnValueAndVolumeTypeDeliverable_WithoutAPlannedVolume_FailsValidation()
        {
            // Arrange
            var deliverables = Contract.GetDeliverables();
            deliverables.First().contractDeliverablePeriods.First().plannedVolume = null;

            // Act/Assert
            Assert.IsTrue(_validator.GetFailuresForItem(Contract).Any());
        }
    }
}
