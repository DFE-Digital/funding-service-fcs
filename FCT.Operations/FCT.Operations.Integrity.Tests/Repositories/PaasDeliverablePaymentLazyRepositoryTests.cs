namespace FCT.Operations.Integrity.Tests.Repositories
{
    using System.Collections.Generic;
    using System.Linq;
    using ContractManagement.DataStore;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.Framework.Logging.NullObjects;
    using SFA.FCT.Operations.Integrity.DTOs;
    using SFA.FCT.Operations.Integrity.IntegrityCheckers;
    using SFA.FCT.Operations.Integrity.Repositories;
    using SFA.FCT.Operations.Integrity.Services;

    [TestClass]
    public class PaasDeliverablePaymentLazyRepositoryTests
    {
        private static PaasDeliverablePaymentLazyRepository _paasDeliverablePaymentLazyRepository;

        [TestInitialize]
        public void TestInitialize()
        {
            if (_paasDeliverablePaymentLazyRepository == null)
            {
                _paasDeliverablePaymentLazyRepository = new PaasDeliverablePaymentLazyRepository(new ContractManagementDbContext().Database.Connection, Mock.Of<ILogger>());
            }
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void PaasDeliverablePaymentLazyRepository_ShouldGetDeliverablePayments()
        {
            using (var context = new ContractManagementDbContext())
            {
                PaasDeliverablePaymentLazyRepository repository = new PaasDeliverablePaymentLazyRepository(context.Database.Connection, new LoggerNullObject());

                IReadOnlyCollection<DeliverablePaymentWithFsp> deliverablePayments = repository.GetDeliverablePayments();

                var notPaidExternallyDps = deliverablePayments.Where(dp => dp.PaymentMethod != 2).ToList();

                Assert.IsNotNull(deliverablePayments);
                Assert.IsTrue(deliverablePayments.Count > 0);
            }
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void AnitaPaasExtract_ShouldGetDeliverablePayments()
        {
            using (var context = new ContractManagementDbContext())
            {
                AnitaPaasExtract anitaPaasExtract = new AnitaPaasExtract(new PaasDeliverablePaymentLazyRepository(context.Database.Connection, new LoggerNullObject()));

                IntegrityCheckResult integrityCheckResult = anitaPaasExtract.CheckValues();

                Assert.IsNotNull(integrityCheckResult.IssuesCsv);
            }
        }

        [TestMethod, TestCategory("DataDependent")]
        public void PaasDeliverablePaymentLazyRepository_SumActualValuesForAllocation_ShouldGetAggregateActualValueForAllocation()
        {
            decimal allocationActualValue = _paasDeliverablePaymentLazyRepository.SumActualValuesForAllocation("16AP-4692", 3);

            Assert.AreEqual(53543.32M, allocationActualValue);
        }

        [TestMethod, TestCategory("DataDependent")]
        public void PaasDeliverablePaymentLazyRepository_SumActualValuesForAllocation_ShouldGetZeroAggregateActualValueForAllocationWithoutActuals()
        {
            decimal allocationActualValue = _paasDeliverablePaymentLazyRepository.SumActualValuesForAllocation("16NL-1485", 8);

            Assert.AreEqual(0M, allocationActualValue);
        }

        [TestMethod, TestCategory("DataDependent")]
        public void PaasDeliverablePaymentLazyRepository_SumActualValuesForAllocation_ShouldGetZeroAggregateActualValueForNonExistentAllocation()
        {
            decimal allocationActualValue = _paasDeliverablePaymentLazyRepository.SumActualValuesForAllocation("NOT-EXIST", 1);

            Assert.AreEqual(0M, allocationActualValue);
        }

        [TestMethod, TestCategory("DataDependent")]
        public void PaasDeliverablePaymentLazyRepository_SumActualValuesForPeriod_ShouldGetAggregateActualValueForAllocationAndPeriod()
        {
            decimal periodActualValue = _paasDeliverablePaymentLazyRepository.SumActualValuesForPeriod("NCSC-1019", 4, "201712");

            Assert.AreEqual(180210.00M, periodActualValue);
        }

        [TestMethod, TestCategory("DataDependent")]
        public void PaasDeliverablePaymentLazyRepository_SumActualValuesForPeriod_ShouldGetZeroAggregateActualValueForAllocationAndPeriodWithoutActuals()
        {
            decimal periodActualValue = _paasDeliverablePaymentLazyRepository.SumActualValuesForPeriod("NCSC-1019", 4, "201803");

            Assert.AreEqual(0M, periodActualValue);
        }

        [TestMethod, TestCategory("DataDependent")]
        public void PaasDeliverablePaymentLazyRepository_SumActualValuesForPeriod_ShouldGetZeroAggregateActualValueForNonExistentAllocation()
        {
            decimal periodActualValue = _paasDeliverablePaymentLazyRepository.SumActualValuesForPeriod("NOT-EXIST", 1, "201712");

            Assert.AreEqual(0M, periodActualValue);
        }

        [TestMethod, TestCategory("DataDependent")]
        public void PaasDeliverablePaymentLazyRepository_SumReconcilationPaymentAmountsForPeriod_ShouldGetAggregateReconciliationValueForAllocationAndPeriod()
        {
            decimal periodReconciliationValue = _paasDeliverablePaymentLazyRepository.SumReconcilationPaymentAmountsForPeriod("NCSC-1019", 4, "201712");

            Assert.AreEqual(183690.00M, periodReconciliationValue);
        }

        [TestMethod, TestCategory("DataDependent")]
        public void PaasDeliverablePaymentLazyRepository_SumReconcilationPaymentAmountsForPeriod_ShouldGetZeroAggregateReconciliationValueForAllocationAndPeriodWithoutValue()
        {
            decimal periodReconciliationValue = _paasDeliverablePaymentLazyRepository.SumReconcilationPaymentAmountsForPeriod("NCSC-1019", 4, "201803");

            Assert.AreEqual(0M, periodReconciliationValue);
        }

        [TestMethod, TestCategory("DataDependent")]
        public void PaasDeliverablePaymentLazyRepository_SumReconcilationPaymentAmountsForPeriod_ShouldGetZeroAggregateReconciliationValueForNonExistentAllocation()
        {
            decimal periodActualValue = _paasDeliverablePaymentLazyRepository.SumReconcilationPaymentAmountsForPeriod("NOT-EXIST", 1, "201712");

            Assert.AreEqual(0M, periodActualValue);
        }

        [TestMethod, TestCategory("DataDependent")]
        public void PaasDeliverablePaymentLazyRepository_SumNetPaymentAmountsForPeriod_ShouldGetAggregateNetValueForAllocationAndPeriod()
        {
            decimal periodReconciliationValue = _paasDeliverablePaymentLazyRepository.SumNetPaymentAmountsForPeriod("NCSC-1019", 4, "201712");

            Assert.AreEqual(183690.00M, periodReconciliationValue);
        }

        [TestMethod, TestCategory("DataDependent")]
        public void PaasDeliverablePaymentLazyRepository_SumNetPaymentAmountsForPeriod_ShouldGetZeroAggregateNetValueForAllocationAndPeriodWithoutValue()
        {
            decimal periodReconciliationValue = _paasDeliverablePaymentLazyRepository.SumNetPaymentAmountsForPeriod("NCSC-1019", 4, "201803");

            Assert.AreEqual(0M, periodReconciliationValue);
        }

        [TestMethod, TestCategory("DataDependent")]
        public void PaasDeliverablePaymentLazyRepository_SumNetPaymentAmountsForPeriod_ShouldGetZeroAggregateNetValueForNonExistentAllocation()
        {
            decimal periodActualValue = _paasDeliverablePaymentLazyRepository.SumNetPaymentAmountsForPeriod("NOT-EXIST", 1, "201712");

            Assert.AreEqual(0M, periodActualValue);
        }

        [TestMethod, TestCategory("DataDependent")]
        public void PaasDeliverablePaymentLazyRepository_GetDeliverablePaymentsForFsps()
        {
            var payments =
                _paasDeliverablePaymentLazyRepository.GetDeliverablePaymentsForFsps(new List<string> { "AEB-TOL1819" });

            Assert.AreEqual(2316, payments.Count);
        }
    }
}
