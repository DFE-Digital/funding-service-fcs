namespace SFA.FCT.PaymentManagementDomain.BusinessLogic.Test.UnitTests
{
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Entities.DeliveryAllocation;
    using CrossDomain.Integration.Entities.PaymentSchedule;
    using global::UnitTests.Common;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Services;

    [TestClass]
    public class PlannedValueCopierTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void PlannedValueCopier_ShouldCopyToAllocationDeliverablesToPaymentSchedule()
        {
            // arrange
            List<contractDeliverableType> contractDeliverableTypes = GetContractDeliverableTypeFromFile();
            Assert.IsNotNull(contractDeliverableTypes);

            List<AllocationDeliverable> allocationDeliverables = GetAllocationDeliverables();
            Assert.IsNotNull(allocationDeliverables);
            Assert.IsTrue(allocationDeliverables.Single(ad => ad.DeliverableCode == 1).ScheduledPayments.All(sp => sp.PlannedValue == 0), "The PlannedValue should all equal zero initially");

            // act
            PlannedValueCopier.CopyDeliveryCommencedValuesToPaymentSchedule(contractDeliverableTypes, allocationDeliverables);

            // assert
            Assert.IsTrue(allocationDeliverables.Single(ad => ad.DeliverableCode == 1).ScheduledPayments.All(sp => sp.PlannedValue == 581.00M), "The PlannedValue should not be zero after");
        }

        private List<contractDeliverableType> GetContractDeliverableTypeFromFile()
        {
            return
                TestResource.FromJson<List<contractDeliverableType>>(
                    "SFA.FCT.PaymentManagementDomain.BusinessLogic.Test", "Resources.AllocationDeliveryCommencedDeliverables.json");
        }

        private List<AllocationDeliverable> GetAllocationDeliverables()
        {
            return
                TestResource.FromJson<List<AllocationDeliverable>>(
                    "SFA.FCT.PaymentManagementDomain.BusinessLogic.Test", "Resources.PaymentScheduleDeliverables.json");
        }
    }
}
