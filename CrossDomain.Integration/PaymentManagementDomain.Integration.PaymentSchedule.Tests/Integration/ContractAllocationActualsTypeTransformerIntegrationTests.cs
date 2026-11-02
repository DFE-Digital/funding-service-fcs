namespace SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.Tests.Integration
{
    using System;
    using System.Linq;
    using BusinessLogic;
    using BusinessLogic.Services;
    using CrossDomain.Integration.Entities.PaymentSchedule;
    using CrossDomain.Integration.Events;
    using Framework.Logging.Interfaces;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using PaymentManagementDomain.PaymentSchedule.DataStore;
    using PaymentManagementDomain.PaymentSchedule.DataStore.Repositories;
    using Services;
    using UnitTests.Common;

    [TestClass]
    public class ContractAllocationActualsTypeTransformerIntegrationTests
    {
        [TestMethod, TestCategory("IntegrationTestNightlyBuild")]
        public void ContractAllocationActualsTypeTransformer_ShouldProduceAScheduleThatCanBeSaved()
        {
            // arrange
            const string allocationNumber = "NCSP-197";
            const int versionNumber = 1;
            AllocationActualsVerified contractAllocationActualType = TestResource.FromJson<AllocationActualsVerified>(
               "SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.Tests",
               @"Resources.AllocationActualsVerified_NoCalcNoPay.json");
            
            Allocation schedule = ContractAllocationActualsTypeTransformer.ToPaymentScheduleAllocation(contractAllocationActualType.AllocationActuals);
            var deliverablePayments = PaymentScheduleAllocationToDeliverablePaymentTransformer.ToDeliverablePayments(schedule);
            using (var context = new PaymentSchedulePolicyContext())
            {
                var deliverablePaymentsFromDb = context.DeliverablePayments.Where(dp => dp.AllocationNumber == allocationNumber && dp.VersionNumber == versionNumber).ToList();
                deliverablePaymentsFromDb.ForEach(dp => context.DeliverablePayments.Remove(dp));

                context.SaveChanges();
            }

            using (var context = new PaymentSchedulePolicyContext())
            {
                IPaymentScheduleService paymentScheduleService = new PaymentScheduleService(new AllocationRepository(context), new ProvisionIdentifierRepository(context), new OrganisationIdentifierRepository(context), new DeliverablePaymentRepository(context), Mock.Of<ILogger>());

                // act
                paymentScheduleService.SavePaymentSchedule(schedule, deliverablePayments, ProcessingMode.ActualsReceived, DateTime.UtcNow, DateTime.UtcNow.AddMonths(12));
            }

            // assert
            using (var context = new PaymentSchedulePolicyContext())
            {
                var deliverablePaymentsFromDb = context.DeliverablePayments.Where(dp => dp.AllocationNumber == allocationNumber && dp.VersionNumber == versionNumber).ToList();

                Assert.AreEqual(14, deliverablePaymentsFromDb.Count, "There aren't the right number of deliverable payments");

                var deliverablePayment =
                    deliverablePaymentsFromDb.Single(dp => dp.DeliverableCode == 5 && dp.Period == "201706");

                Assert.AreEqual(78.5m, deliverablePayment.ActualValue, "The Actual Value is not correct");
            }
        }
    }
}
