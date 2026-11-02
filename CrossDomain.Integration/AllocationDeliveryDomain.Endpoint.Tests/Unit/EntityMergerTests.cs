namespace AllocationDeliveryDomain.Endpoint.Tests.Unit
{
    using System;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;

    [TestClass]
    public class EntityMergerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void EntityMerger_ShouldMergeAllFieldsExceptTheKeyAndNamedIndex()
        {
            // arrange
            CurrentViewActual currentViewActual = new CurrentViewActual
            {
                ActualValue = 10D,
                ActualVolume = 12L,
                AllocationEndDate = DateTime.MaxValue,
                AllocationStartDate = DateTime.MinValue,
                CollectionReturnCode = "CRC",
                CollectionType = "CT",
                ContractAllocationNumber = "CAN",
                ContractNumber = "CN",
                ContractSubVersion = Int32.MaxValue,
                ContractVersion = Int32.MinValue,
                DeliverableCode = 1,
                FundingStreamPeriodCode = "FSPC",
                Id = 123,
                LastModifiedDate = DateTime.Now,
                OrganisationId = "12345",
                Period = "082015",
                PeriodTypeCode = "AY",
                Ukprn = "12345678",
                UoPCode = null
            };

            CurrentViewActual distinationCurrentViewActual = new CurrentViewActual();

            // act
            EntityMerger<CurrentViewActual>.MergeNonKeyAndNonIndexProperties(currentViewActual, distinationCurrentViewActual, "IX_OrgIdPeriodFSPCUoPDeliverableCode");

            // assert
            Assert.AreEqual(currentViewActual.ActualValue, distinationCurrentViewActual.ActualValue);
            Assert.AreEqual(currentViewActual.ActualVolume, distinationCurrentViewActual.ActualVolume);
            Assert.AreEqual(currentViewActual.AllocationEndDate, distinationCurrentViewActual.AllocationEndDate);
            Assert.AreEqual(currentViewActual.AllocationStartDate, distinationCurrentViewActual.AllocationStartDate);
            Assert.AreEqual(currentViewActual.CollectionReturnCode, distinationCurrentViewActual.CollectionReturnCode);
            Assert.AreEqual(currentViewActual.CollectionType, distinationCurrentViewActual.CollectionType);
            Assert.AreEqual(currentViewActual.ContractNumber, distinationCurrentViewActual.ContractNumber);
            Assert.AreEqual(currentViewActual.ContractSubVersion, distinationCurrentViewActual.ContractSubVersion);
            Assert.AreEqual(currentViewActual.Ukprn, distinationCurrentViewActual.Ukprn);

            Assert.AreNotEqual(currentViewActual.OrganisationId, distinationCurrentViewActual.OrganisationId, "An index property has been updated");
        }
    }
}
