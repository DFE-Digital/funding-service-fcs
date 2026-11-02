namespace AllocationDeliveryDomain.Endpoint.Tests.PaymentInstructionValidation
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using AllocationDeliveryDomain.Endpoint.PaymentInstructionValidation.Repositories;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    [TestClass]
    public class PaymentInstructionAuditRepositoryTests
    {
        private const string TestOrgId = "ORG9999999";
        private const string TestFspCode = "TestFsp1799";

        [TestInitialize]
        public void Setup()
        {
            CleanUp();
        }

        [TestCleanup]
        public void CleanUp()
        {
            using (var context = new MonitoringDeliverablesDbContext())
            {
                var testRecords =
                    context.PaymentInstructionAudits.Where(
                        pia => pia.FundingStreamPeriodCode == TestFspCode && pia.OrganisationId == TestOrgId);

                if (testRecords.Any())
                {
                    context.PaymentInstructionAudits.RemoveRange(testRecords);
                    context.SaveChanges();
                }
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PaymentInstructionAuditRepoitory_CreatePaymentInstructionAudits_SuccessfullyAddsSingleRecord()
        {
            using (var context = new MonitoringDeliverablesDbContext())
            {
                // arrange
                IEnumerable<PaymentInstructionAudit> recordsToAdd = new List<PaymentInstructionAudit>
                {
                    CreateTestAuditRecordForDeliverableCode(1)
                };
                
                PaymentInstructionAuditRepository repository = new PaymentInstructionAuditRepository();

                // act
                repository.CreatePaymentInstructionAudits(recordsToAdd, new ConnectionInfo(null, context.Database.Connection));

                // assert
                var actualRecords =
                    context.PaymentInstructionAudits.Where(
                        pia => pia.FundingStreamPeriodCode == TestFspCode && pia.OrganisationId == TestOrgId);

                Assert.AreEqual(1, actualRecords.Count());
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PaymentInstructionAuditRepoitory_CreatePaymentInstructionAudits_SuccessfullyAddsMultipleRecords()
        {
            using (var context = new MonitoringDeliverablesDbContext())
            {
                // arrange
                IEnumerable<PaymentInstructionAudit> recordsToAdd = new List<PaymentInstructionAudit>
                {
                    CreateTestAuditRecordForDeliverableCode(1),
                    CreateTestAuditRecordForDeliverableCode(2),
                    CreateTestAuditRecordForDeliverableCode(3),
                    CreateTestAuditRecordForDeliverableCode(4),
                    CreateTestAuditRecordForDeliverableCode(5),
                    CreateTestAuditRecordForDeliverableCode(6)
                };

                PaymentInstructionAuditRepository repository = new PaymentInstructionAuditRepository();

                // act
                repository.CreatePaymentInstructionAudits(recordsToAdd, new ConnectionInfo(null, context.Database.Connection));

                // assert
                var actualRecords =
                    context.PaymentInstructionAudits.Where(
                        pia => pia.FundingStreamPeriodCode == TestFspCode && pia.OrganisationId == TestOrgId);

                Assert.AreEqual(6, actualRecords.Count());
            }
        }

        private PaymentInstructionAudit CreateTestAuditRecordForDeliverableCode(int deliverabeCode)
        {
            return new PaymentInstructionAudit
            {
                CollectionReturnPeriod = 1,
                OrganisationId = TestOrgId,
                FundingStreamPeriodCode = TestFspCode,
                DeliverableCode = deliverabeCode,
                Period = "201706",
                ContractAllocationNumber = "TEST-1234",
                Ukprn = "90001234",
                ContractNumber = "TEST-4321",
                ContractVersion = 1,
                ContractSubVersion = 0,
                AllocationStartDate = new DateTime(2017, 6, 1),
                CollectionReturnCode = "TEST",
                CollectionType = "TEST",
                PaymentValue = 1000 + deliverabeCode
            };
        }
    }
}