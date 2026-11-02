namespace PMD.PaymentSchedule.DataStore.Tests.RepositoryTests
{
    using System;
    using System.Linq;
    using System.Threading.Tasks;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using MoreLinq;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Repositories;

    [TestClass]
    public class DeliverablePaymentCommandRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public async Task DeliverablePaymentCommandRepository_ShouldAddPeriod()
        {
            // arrange
            const string allocationNumber = "Test A";
            const int version = 1;
            const int deliverableCode = 1;
            const string period = "201807";

            using (var context = new PaymentSchedulePolicyContext())
            {
                context.DeliverablePayments.Where(dp => dp.AllocationNumber == allocationNumber)
                    .ForEach(dp => context.DeliverablePayments.Remove(dp));

                context.SaveChanges();
            }


            using (var context = new PaymentSchedulePolicyContext())
            {
                DeliverablePaymentCommandRepository repository = new DeliverablePaymentCommandRepository();

                // act
                await repository.AddDeliverablePeriodIfNotPresent(allocationNumber,
                    version, deliverableCode, period,
                    new ConnectionInfo(transaction: null, connection: context.Database.Connection));
            }

            using (var context = new PaymentSchedulePolicyContext())
            {
                var matchingRow =
                    context.DeliverablePayments.FirstOrDefault(dp => dp.AllocationNumber == allocationNumber);

                // assert
                Assert.IsNotNull(matchingRow);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task
            DeliverablePaymentCommandRepository_AddDeliverablePeriodIfNotPresent_ShouldNotThrowExceptionIfAlreadyPresent()
        {
            // arrange
            const string allocationNumber = "Test A";
            const int version = 1;
            const int deliverableCode = 1;
            const string period = "201807";

            using (var context = new PaymentSchedulePolicyContext())
            {
                context.DeliverablePayments.Where(dp => dp.AllocationNumber == allocationNumber)
                    .ForEach(dp => context.DeliverablePayments.Remove(dp));

                context.SaveChanges();
            }


            using (var context = new PaymentSchedulePolicyContext())
            {
                DeliverablePaymentCommandRepository repository = new DeliverablePaymentCommandRepository();

                await repository.AddDeliverablePeriodIfNotPresent(allocationNumber,
                    version, deliverableCode, period,
                    new ConnectionInfo(transaction: null, connection: context.Database.Connection));
            }

            try
            {
                using (var context = new PaymentSchedulePolicyContext())
                {
                    DeliverablePaymentCommandRepository repository = new DeliverablePaymentCommandRepository();

                    // act
                    await repository.AddDeliverablePeriodIfNotPresent(allocationNumber,
                        version, deliverableCode, period,
                        new ConnectionInfo(transaction: null, connection: context.Database.Connection));
                }
            }
            catch (Exception)
            {
                Assert.Fail("An exception has been thrown");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task DeliverablePaymentCommandRepository_ShouldAddPeriodWithADefaultPeriodTypeOfCalendarMonth()
        {
            // arrange
            const string allocationNumber = "Test A";
            const int version = 1;
            const int deliverableCode = 1;
            const string period = "201807";

            using (var context = new PaymentSchedulePolicyContext())
            {
                context.DeliverablePayments.Where(dp => dp.AllocationNumber == allocationNumber)
                    .ForEach(dp => context.DeliverablePayments.Remove(dp));

                context.SaveChanges();
            }


            using (var context = new PaymentSchedulePolicyContext())
            {
                DeliverablePaymentCommandRepository repository = new DeliverablePaymentCommandRepository();

                // act
                await repository.AddDeliverablePeriodIfNotPresent(allocationNumber,
                    version, deliverableCode, period,
                    new ConnectionInfo(transaction: null, connection: context.Database.Connection));
            }

            using (var context = new PaymentSchedulePolicyContext())
            {
                var matchingRow = context.DeliverablePayments.FirstOrDefault(dp => dp.AllocationNumber == allocationNumber);

                // assert
                Assert.IsNotNull(matchingRow, "The deliverable payment row is not present");
                Assert.AreEqual(SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Model.PeriodTypeCode.CM,
                    matchingRow.PeriodTypeCode, "The period type code is not present");
            }
        }
    }
}
