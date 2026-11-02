namespace CrossDomain.Integration.Common.Tests.Unit
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;

    [TestClass]
    public class ContractDeliverablePeriodsTypeContractDeliverablePeriodTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ContractDeliverablePeriodsTypeContractDeliverablePeriod_ShouldCalculatePlannedValueWhenVolumePresent()
        {
            // arrange
            contractDeliverablePeriodsTypeContractDeliverablePeriod cdp = new contractDeliverablePeriodsTypeContractDeliverablePeriod();

            cdp.plannedVolume = 2;
            cdp.unitCost = 10;
            cdp.plannedValue = 0;
            
            // act
            cdp.CalculateAndSetPlannedValue();

            // assert
            Assert.AreEqual(20, cdp.plannedValue);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractDeliverablePeriodsTypeContractDeliverablePeriod_ShouldCalculatePlannedValueWhenPlannedValuePresent()
        {
            // arrange
            contractDeliverablePeriodsTypeContractDeliverablePeriod cdp = new contractDeliverablePeriodsTypeContractDeliverablePeriod();

            cdp.plannedVolume = 2;
            cdp.unitCost = 10;
            cdp.plannedValue = 10;

            // act
            cdp.CalculateAndSetPlannedValue();

            // assert
            Assert.AreEqual(10, cdp.plannedValue);
        }
    }
}
