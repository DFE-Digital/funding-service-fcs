namespace PaymentManagement.Calculation.Tests.Repositories
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Collections.ObjectModel;
    using System.Data.Entity;
    using System.Linq;
    using System.Linq.Expressions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using PaymentManagement.Calculation.Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.AllocationActuals;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Entities.PaymentSchedule;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Model;
    using PaymentScheduleAllocation = SFA.FCT.CrossDomain.Integration.Entities.PaymentSchedule.Allocation;
    using PaymentScheduleModel = SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Model;

    [TestClass]
    public class DeliverablePaymentRepositoryUnitTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void AddOrUpdateActualValues_UpdatesExistingAndAddsMissingPayments()
        {
            var existing = new DeliverablePayment
            {
                AllocationNumber = "A1",
                VersionNumber = 2,
                DeliverableCode = 10,
                Period = "202501",
                ActualValue = 1,
                ActualVolume = 2
            };
            var context = new TestPolicyContext(existing);
            var repository = new DeliverablePaymentRepository(new TestContextFactory(context));
            var actuals = new ContractAllocationActualsType
            {
                ContractAllocationNumber = "A1",
                ContractReference = new ContractReferenceType { ContractVersionNumber = 2 },
                ActualsSummary = new List<ActualsSummaryType>
                {
                    new ActualsSummaryType { DeliverableCode = 10, Period = "202501", ActualValue = 12, ActualVolume = 13 },
                    new ActualsSummaryType { DeliverableCode = 20, Period = "202502", ActualValue = 22, ActualVolume = 23 }
                }
            };

            repository.AddOrUpdateDeliverablePaymentsWithActualValues(actuals, new ConnectionInfo(null, null));

            Assert.AreEqual(12m, existing.ActualValue);
            Assert.AreEqual(13, existing.ActualVolume);
            var added = context.Payments.Single(payment => payment.DeliverableCode == 20);
            Assert.AreEqual("A1", added.AllocationNumber);
            Assert.AreEqual(2, added.VersionNumber);
            Assert.AreEqual("202502", added.Period);
            Assert.AreEqual(22m, added.ActualValue);
            Assert.AreEqual(23, added.ActualVolume);
            Assert.AreEqual(1, context.SaveChangesCount);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetDeliverablePeriodPaymentInfos_ReturnsOnlyMatchingAllocationAndVersion()
        {
            var context = new TestPolicyContext(
                new DeliverablePayment
                {
                    AllocationNumber = "A1",
                    VersionNumber = 2,
                    DeliverableCode = 10,
                    Period = "202501",
                    NetPaymentAmount = 123,
                    PlannedValue = 100,
                    PlannedVolume = 4,
                    ActualValue = 90,
                    ActualVolume = 3
                },
                new DeliverablePayment
                {
                    AllocationNumber = "A2",
                    VersionNumber = 2,
                    DeliverableCode = 20,
                    Period = "202502"
                });
            var repository = new DeliverablePaymentRepository(new TestContextFactory(context));

            var result = repository.GetDeliverablePeriodPaymentInfos("A1", 2, ConnectionInfo.CreateDefault());

            var payment = result.Single();
            Assert.AreEqual(202501, payment.Period);
            Assert.AreEqual(10, payment.DeliverableCode);
            Assert.AreEqual(123m, payment.NetPaymentAmount);
            Assert.AreEqual(100m, payment.PlannedValue);
            Assert.AreEqual(4, payment.PlannedVolume);
            Assert.AreEqual(90m, payment.ActualValue);
            Assert.AreEqual(3, payment.ActualVolume);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetDeliverablePeriodActualsAndPaymentValues_ReturnsMappedPaymentValues()
        {
            var context = new TestPolicyContext(
                new DeliverablePayment
                {
                    AllocationNumber = "A1",
                    VersionNumber = 2,
                    DeliverableCode = 10,
                    Period = "202501",
                    ActualValue = 90,
                    ActualVolume = 3,
                    NetPaymentAmount = 123,
                    PlannedValue = 100,
                    PlannedVolume = 4,
                    ProfilePaymentAmount = 11,
                    CappedPaymentAmount = 12,
                    BalancingPaymentAmount = 13,
                    ReconciliationPaymentAmount = 14
                });
            var repository = new DeliverablePaymentRepository(new TestContextFactory(context));

            var result = repository.GetDeliverablePeriodActualsAndPaymentValues("A1", 2, ConnectionInfo.CreateDefault());

            var payment = result.Single();
            Assert.AreEqual(202501, payment.Period);
            Assert.AreEqual(10, payment.DeliverableCode);
            Assert.AreEqual(90m, payment.ActualValue);
            Assert.AreEqual(3, payment.ActualVolume);
            Assert.AreEqual(123m, payment.NetPaymentAmount);
            Assert.AreEqual(100m, payment.PlannedValue);
            Assert.AreEqual(4, payment.PlannedVolume);
            Assert.AreEqual(11m, payment.ProfileValue);
            Assert.AreEqual(12m, payment.CappedPaymentAmount);
            Assert.AreEqual(13m, payment.BalancingPaymentAmount);
            Assert.AreEqual(14m, payment.ReconciliationPaymentAmount);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AddOrUpdateCalculatedValues_UpdatesExistingAndAddsMissingPayments()
        {
            var existing = new DeliverablePayment
            {
                AllocationNumber = "A1",
                VersionNumber = 2,
                DeliverableCode = 10,
                Period = "202501"
            };
            var context = new TestPolicyContext(existing);
            var repository = new DeliverablePaymentRepository(new TestContextFactory(context));
            var deliverable = new AllocationDeliverable
            {
                DeliverableCode = 10,
                ScheduledPayments = new List<ScheduledPayment>
                {
                    new ScheduledPayment { Period = "202501", NetPaymentAmount = 11, ProfilePaymentAmount = 12 },
                    new ScheduledPayment { Period = "202502", NetPaymentAmount = 21, ProfilePaymentAmount = 22 }
                }
            };

            repository.AddOrUpdateDeliverablePaymentsWithCalculatedValues("A1", 2, deliverable, new ConnectionInfo(null, null));

            Assert.AreEqual(11m, existing.NetPaymentAmount);
            Assert.AreEqual(12m, existing.ProfilePaymentAmount);
            var added = context.Payments.Single(payment => payment.Period == "202502");
            Assert.AreEqual(10, added.DeliverableCode);
            Assert.AreEqual(21m, added.NetPaymentAmount);
            Assert.AreEqual(22m, added.ProfilePaymentAmount);
            Assert.AreEqual(1, context.SaveChangesCount);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PersistPaymentScheduleAndActuals_AddsPaymentsAndUpdatesExistingActuals()
        {
            var existing = new DeliverablePayment
            {
                AllocationNumber = "A1",
                VersionNumber = 2,
                DeliverableCode = 10,
                Period = "202501"
            };
            var context = new TestPolicyContext(existing);
            var repository = new DeliverablePaymentRepository(new TestContextFactory(context));
            var allocation = new PaymentScheduleAllocation
            {
                AllocationNumber = "A1",
                VersionNumber = 2,
                AllocationDeliverables = new List<AllocationDeliverable>
                {
                    new AllocationDeliverable
                    {
                        DeliverableCode = 10,
                        ScheduledPayments = new List<ScheduledPayment>
                        {
                            new ScheduledPayment { Period = "202501", ActualValue = 100, PlannedValue = 101 },
                            new ScheduledPayment { Period = "202502", ActualValue = 200, PlannedValue = 201 }
                        }
                    }
                }
            };

            repository.PersistPaymentScheduleAndActuals(allocation, new ConnectionInfo(null, null));

            Assert.AreEqual(100m, existing.ActualValue);
            Assert.AreEqual(101m, existing.PlannedValue);
            var added = context.Payments.Single(payment => payment.Period == "202502");
            Assert.AreEqual(200m, added.ActualValue);
            Assert.AreEqual(201m, added.PlannedValue);
            Assert.AreEqual(1, context.SaveChangesCount);
        }

        private sealed class TestContextFactory : IPaymentSchedulePolicyContextFactory
        {
            private readonly IPaymentSchedulePolicyContext _context;

            public TestContextFactory(IPaymentSchedulePolicyContext context)
            {
                _context = context;
            }

            public IPaymentSchedulePolicyContext Create(ConnectionInfo connectionInfo)
            {
                return _context;
            }
        }

        private sealed class TestPolicyContext : IPaymentSchedulePolicyContext
        {
            public TestPolicyContext(params DeliverablePayment[] payments)
            {
                DeliverablePayments = new InMemoryDbSet<DeliverablePayment>(payments);
            }

            public IDbSet<PaymentScheduleModel.Allocation> Allocations { get; set; }
            public IDbSet<DeliverablePayment> DeliverablePayments { get; set; }
            public IDbSet<OrganisationIdentifer> OrganisationIdentifiers { get; set; }
            public IDbSet<PaymentScheduleModel.ProvisionIdentifier> ProvisionIdentifiers { get; set; }
            public IDbSet<PublishedPayableFcrAllocation> PublishedPayableFcrAllocations { get; set; }
            public IDbSet<ProcessedMessage> ProcessedMessages { get; set; }
            public int SaveChangesCount { get; private set; }
            public IEnumerable<DeliverablePayment> Payments => ((InMemoryDbSet<DeliverablePayment>)DeliverablePayments).Data;

            public int SaveChanges()
            {
                SaveChangesCount++;
                return 1;
            }

            public void UpdateEntry<TEntity>(TEntity entityInDb, TEntity entity) where TEntity : class
            {
                throw new NotImplementedException();
            }

            public void Dispose()
            {
            }
        }

        private sealed class InMemoryDbSet<TEntity> : DbSet<TEntity>, IQueryable<TEntity> where TEntity : class
        {
            private readonly ObservableCollection<TEntity> _data;
            private readonly IQueryable<TEntity> _query;

            public InMemoryDbSet(IEnumerable<TEntity> items)
            {
                _data = new ObservableCollection<TEntity>(items);
                _query = _data.AsQueryable();
            }

            public ObservableCollection<TEntity> Data => _data;
            public override ObservableCollection<TEntity> Local => _data;
            public override TEntity Add(TEntity entity) { _data.Add(entity); return entity; }
            public override TEntity Attach(TEntity entity) { _data.Add(entity); return entity; }
            public override TEntity Remove(TEntity entity) { _data.Remove(entity); return entity; }
            public override TEntity Create() { return Activator.CreateInstance<TEntity>(); }
            public override TDerivedEntity Create<TDerivedEntity>() { return Activator.CreateInstance<TDerivedEntity>(); }
            Type IQueryable.ElementType => _query.ElementType;
            Expression IQueryable.Expression => _query.Expression;
            IQueryProvider IQueryable.Provider => _query.Provider;
            IEnumerator<TEntity> IEnumerable<TEntity>.GetEnumerator() { return _data.GetEnumerator(); }
            IEnumerator IEnumerable.GetEnumerator() { return _data.GetEnumerator(); }
        }
    }
}
