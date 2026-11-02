namespace SFA.FCT.PaymentManagementDomain.BusinessLogic.Test.Integration
{
    using System;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using PaymentSchedule.DataStore;
    using PaymentSchedule.DataStore.Model;

    [TestClass]
    public class UpSertHelperTests
    {
        private readonly PaymentSchedulePolicyContext _paymentSchedulePolicyContext = new PaymentSchedulePolicyContext();

        private Allocation _allocation = new Allocation
        {
            AllocationNumber = "123456",
            VersionNumber = 1,
            ContractNumber = "qwerty",
            ContractVersionNumber = 1,
            AllocationEndDate = DateTime.Today.AddDays(2),
            AllocationStartDate = DateTime.Today,
            FundingStreamPeriodCode = "FF",
            LastModifiedDate = DateTime.Now
        };

        [TestMethod, TestCategory("IntegrationTest")]
        public void UpSertHelper_ShouldUpdateExistingEntity()
        {
            // arrange
            _paymentSchedulePolicyContext.Allocations.Add(_allocation);
            _allocation.AllocationEndDate = DateTime.Today;
            // act

            UpSertHelper.AddOrUpdatePaymentScheduleEntity(_allocation,
                () => _paymentSchedulePolicyContext.Allocations.Find(_allocation.AllocationNumber, _allocation.VersionNumber),
            _paymentSchedulePolicyContext.Allocations,
            ((allocationInDb, allocation) => _paymentSchedulePolicyContext.UpdateEntry(allocationInDb, allocation))            
            );
            _paymentSchedulePolicyContext.SaveChanges();

            // assert
            Assert.AreEqual(_paymentSchedulePolicyContext.Allocations.Find(_allocation.AllocationNumber, _allocation.VersionNumber).AllocationEndDate, DateTime.Today);
        }

        [TestCleanup]
        public void CleanUp()
        {
           Allocation allocationInDb = _paymentSchedulePolicyContext.Allocations.Find(_allocation.AllocationNumber, _allocation.VersionNumber);
           _paymentSchedulePolicyContext.Allocations.Remove(allocationInDb);
            _paymentSchedulePolicyContext.SaveChanges();
        }
    }
}
