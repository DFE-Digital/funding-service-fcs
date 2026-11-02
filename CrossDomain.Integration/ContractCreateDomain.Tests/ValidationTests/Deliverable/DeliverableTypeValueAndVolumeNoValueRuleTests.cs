namespace ContractCreateDomain.Tests.ValidationTests.Deliverable
{
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules.Deliverable;
    using MoreLinq;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
    using System;
    using FluentAssertions;

    /// <summary>
    /// Rule DBR-018
    /// </summary>
    [TestClass]
    public class DeliverableTypeValueAndVolumeNoValueRuleTests : ContractRequestValidationBase
    {
        private ValueAndVolumeDeliverableNoValueRule _validator;

        [TestInitialize]
        public void Startup()
        {
            _validator = new ValueAndVolumeDeliverableNoValueRule(DeliverableMetaData);

            //Convert FSC Data to Volume Types.
            foreach (var fscSettings in DeliverableMetaData[Contract.GetAllocations().First().fundingStreamPeriodCode].DeliverableStructureList)
            {
                fscSettings.Settings.First(s => s.SettingCode.Contains("planningunit")).SettingValue = "Volume and Value";
            }

            Contract.GetDeliverables().ForEach(cd => cd.unitCost = 10);
            Contract.GetDeliverablePeriods().ForEach(cdp => SetContractDeliverablePeriod(cdp));
        }

        private void SetContractDeliverablePeriod(contractDeliverablePeriodType cdp)
        {
            cdp.plannedValue = null;
            cdp.plannedVolume = 10;
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Ensure_AValidValueAndVolumeTypeDeliverable_WithoutAValue_PassesValidation()
        {
            // Act/Assert
            Assert.IsFalse(_validator.GetFailuresForItem(Contract).Any());
        }
        
        [TestMethod, TestCategory("UnitTest")]
        public void Ensure_AnInvalidValueAndVolumeTypeDeliverable_WithAnInvalidPlannedValue_FailsValidation()
        {
            // Arrange
            var firstDeliverablePeriod =Contract.GetDeliverablePeriods().First();
            firstDeliverablePeriod.plannedValue = 123;

            // Act
            var failedCorrelationIds = _validator.GetFailuresForItem(Contract);


            // Assert
            Assert.IsTrue(failedCorrelationIds.Count() == 1);
            Assert.AreEqual(firstDeliverablePeriod.correlationId, failedCorrelationIds.First());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Ensure_AnInvalidValueAndVolumeTypeDeliverable_WithAValidPlannedValue_PassesValidation()
        {
            // Arrange
            var firstDeliverablePeriod = Contract.GetDeliverablePeriods().First();
            firstDeliverablePeriod.plannedValue = 100;

            // Act/Assert
            Assert.IsFalse(_validator.GetFailuresForItem(Contract).Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ShouldPassDbr_018Check_WhenFundingTypeIsSB()
        {
            // Arrange
            Contract.contract.fundingTypeCode = "SB";
            var firstDeliverablePeriod = Contract.GetDeliverablePeriods().First();
            firstDeliverablePeriod.plannedValue = 123;

            // Act/Assert
            _validator.GetFailuresForItem(Contract).Any().Should().BeFalse();
        }
    }
}
