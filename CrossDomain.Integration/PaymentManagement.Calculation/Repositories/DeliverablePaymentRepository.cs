namespace PaymentManagement.Calculation.Repositories
{
    using System;
    using Dtos;
    using SFA.FCT.CrossDomain.Integration.Entities.AllocationActuals;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Model;
    using System.Collections.Generic;
    using System.Data.Entity;
    using System.Linq;
    using Optional.Collections;
    using SFA.FCT.CrossDomain.Integration.Entities.PaymentSchedule;
    using Allocation = SFA.FCT.CrossDomain.Integration.Entities.PaymentSchedule.Allocation;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public class DeliverablePaymentRepository : IDeliverablePaymentRepository
    {
        private readonly IPaymentSchedulePolicyContextFactory _contextFactory;

        public DeliverablePaymentRepository()
            : this(new PaymentSchedulePolicyContextFactory())
        {
        }

        public DeliverablePaymentRepository(IPaymentSchedulePolicyContextFactory contextFactory)
        {
            _contextFactory = contextFactory ?? throw new ArgumentNullException(nameof(contextFactory));
        }

        public IReadOnlyCollection<DeliverablePeriodPaymentInfo> GetDeliverablePeriodPaymentInfos(string allocationNumber, int versionNumber, ConnectionInfo connectionInfo)
        {
            using (var context = _contextFactory.Create(connectionInfo))
            {
                return context.DeliverablePayments
                    .Where(dp => dp.AllocationNumber == allocationNumber && dp.VersionNumber == versionNumber)
                    .Select(dp => new
                    {
                        dp.Period,
                        dp.DeliverableCode,
                        dp.NetPaymentAmount,
                        dp.PlannedValue,
                        dp.PlannedVolume,
                        dp.CappedPaymentAmount,
                        dp.ReconciliationPaymentAmount,
                        dp.ProfilePaymentAmount,
                        dp.BalancingPaymentAmount,
                        dp.ActualValue,
                        dp.ActualVolume
                    })
                    .AsEnumerable()
                    .Select(dp => new DeliverablePeriodPaymentInfo(
                        int.Parse(dp.Period),
                        dp.DeliverableCode,
                        dp.NetPaymentAmount,
                        dp.PlannedValue,
                        dp.PlannedVolume,
                        dp.CappedPaymentAmount,
                        dp.ReconciliationPaymentAmount,
                        dp.ActualVolume,
                        dp.ActualValue,
                        dp.BalancingPaymentAmount,
                        dp.ProfilePaymentAmount
                    ))
                    .ToList();
            }
        }

        public void AddOrUpdateDeliverablePaymentsWithActualValues(ContractAllocationActualsType contractAllocationActualsType, ConnectionInfo connectionInfo)
        {
            using (var context = _contextFactory.Create(connectionInfo))
            {
                var allocationNumber = contractAllocationActualsType.ContractAllocationNumber;
                var versionNumber = contractAllocationActualsType.ContractReference.ContractVersionNumber;

                var deliverablePayments = context.DeliverablePayments
                    .Where(dp => dp.AllocationNumber == allocationNumber && dp.VersionNumber == versionNumber).ToList();

                contractAllocationActualsType.ActualsSummary.ForEach(actualsSummary =>
                {
                    deliverablePayments.SingleOrNone(dp =>
                        dp.DeliverableCode == actualsSummary.DeliverableCode && dp.Period == actualsSummary.Period)
                        .Match(
                            some: existingDeliverablePayment =>
                            {
                                existingDeliverablePayment.ActualValue = actualsSummary.ActualValue;
                                existingDeliverablePayment.ActualVolume = actualsSummary.ActualVolume;

                            },
                            none: () =>
                            {
                                context.DeliverablePayments.Add(new DeliverablePayment
                                {
                                    AllocationNumber = allocationNumber,
                                    VersionNumber = versionNumber,
                                    DeliverableCode = actualsSummary.DeliverableCode,
                                    Period = actualsSummary.Period,
                                    ActualVolume = actualsSummary.ActualVolume,
                                    ActualValue = actualsSummary.ActualValue
                                });
                            });
                });

                context.SaveChanges();
            }
        }

        public void AddOrUpdateDeliverablePaymentsWithCalculatedValues(string allocationNumber, int versionNumber, AllocationDeliverable allocationDeliverable,
            ConnectionInfo connectionInfo)
        {
            using (var context = _contextFactory.Create(connectionInfo))
            {
                var deliverablePayments = context.DeliverablePayments
                .Where(dp => dp.AllocationNumber == allocationNumber && dp.VersionNumber == versionNumber).ToList();

                allocationDeliverable.ScheduledPayments.ForEach(sp =>
                {
                    deliverablePayments.SingleOrNone(dp =>
                        dp.DeliverableCode == allocationDeliverable.DeliverableCode && dp.Period == sp.Period)
                        .Match(
                            some: existingDeliverablePayment =>
                            {
                                existingDeliverablePayment.BalancingPaymentAmount = sp.BalancingPaymentAmount;
                                existingDeliverablePayment.CappedPaymentAmount = sp.CappedPaymentAmount;
                                existingDeliverablePayment.NetPaymentAmount = sp.NetPaymentAmount;
                                existingDeliverablePayment.ProfilePaymentAmount = sp.ProfilePaymentAmount;
                                existingDeliverablePayment.ReconciliationPaymentAmount = sp.ReconciliationPaymentAmount;
                            },
                            none: () =>
                            {
                                context.DeliverablePayments.Add(new DeliverablePayment
                                {
                                    AllocationNumber = allocationNumber,
                                    VersionNumber = versionNumber,
                                    Period = sp.Period,
                                    DeliverableCode = allocationDeliverable.DeliverableCode,
                                    BalancingPaymentAmount = sp.BalancingPaymentAmount,
                                    CappedPaymentAmount = sp.CappedPaymentAmount,
                                    NetPaymentAmount = sp.NetPaymentAmount,
                                    ProfilePaymentAmount = sp.ProfilePaymentAmount,
                                    ReconciliationPaymentAmount = sp.ReconciliationPaymentAmount,
                                    PeriodTypeCode = PeriodTypeCode.CM
                                });
                            });
                });

                context.SaveChanges();
            }
        }

        public IReadOnlyCollection<DeliverablePeriodActualAndPaymentInfo> GetDeliverablePeriodActualsAndPaymentValues(string allocationNumber, int versionNumber,
            ConnectionInfo connectionInfo)
        {
            using (var context = _contextFactory.Create(connectionInfo))
            {
                return context.DeliverablePayments
                    .AsNoTracking()
                    .Where(dp => dp.AllocationNumber == allocationNumber && dp.VersionNumber == versionNumber)
                    .Select(dp => new { dp.DeliverableCode, dp.Period, dp.ActualValue, dp.ActualVolume,
                        dp.ProfilePaymentAmount, dp.CappedPaymentAmount, dp.BalancingPaymentAmount, dp.ReconciliationPaymentAmount, dp.NetPaymentAmount,
                        dp.PlannedValue, dp.PlannedVolume
                    })
                    .AsEnumerable()
                    .Select(dp =>
                        new DeliverablePeriodActualAndPaymentInfo(dp.DeliverableCode, int.Parse(dp.Period), dp.ActualVolume,
                            dp.ActualValue, dp.ProfilePaymentAmount, dp.CappedPaymentAmount, dp.BalancingPaymentAmount, dp.ReconciliationPaymentAmount, dp.NetPaymentAmount,
                            dp.PlannedValue, dp.PlannedVolume))
                    .ToList();
            }
        }

        public void PersistPaymentScheduleAndActuals(Allocation paymentSchedule, ConnectionInfo connectionInfo)
        {
            using (var context = _contextFactory.Create(connectionInfo))
            {
                var allocationNumber = paymentSchedule.AllocationNumber;
                var versionNumber = paymentSchedule.VersionNumber;

                var deliverablePayments = context.DeliverablePayments
                    .Where(dp => dp.AllocationNumber == allocationNumber && dp.VersionNumber == versionNumber).ToList();

                paymentSchedule.AllocationDeliverables.ForEach(
                    ad =>
                    {
                        var deliverableCode = ad.DeliverableCode;

                        ad.ScheduledPayments.ForEach(sp =>
                        {
                            deliverablePayments.SingleOrNone(dp => dp.DeliverableCode == deliverableCode && dp.Period == sp.Period)
                            .Match(
                                some: existingDeliverablePayment =>
                                {
                                    existingDeliverablePayment.BalancingPaymentAmount = sp.BalancingPaymentAmount;
                                    existingDeliverablePayment.CappedPaymentAmount = sp.CappedPaymentAmount;
                                    existingDeliverablePayment.NetPaymentAmount = sp.NetPaymentAmount;
                                    existingDeliverablePayment.ProfilePaymentAmount = sp.ProfilePaymentAmount;
                                    existingDeliverablePayment.ReconciliationPaymentAmount = sp.ReconciliationPaymentAmount;
                                    existingDeliverablePayment.PeriodTypeCode = PeriodTypeCode.CM;
                                    existingDeliverablePayment.ActualVolume = sp.ActualVolume;
                                    existingDeliverablePayment.ActualValue = sp.ActualValue;
                                    existingDeliverablePayment.PlannedVolume = sp.PlannedVolume;
                                    existingDeliverablePayment.PlannedValue = sp.PlannedValue;
                                    existingDeliverablePayment.CollectionReturnCode = sp.CollectionReturnCode;
                                },
                                none: () =>
                                {
                                    context.DeliverablePayments.Add(new DeliverablePayment
                                    {
                                        AllocationNumber = allocationNumber,
                                        VersionNumber = versionNumber,
                                        Period = sp.Period,
                                        DeliverableCode = deliverableCode,

                                        BalancingPaymentAmount = sp.BalancingPaymentAmount,
                                        CappedPaymentAmount = sp.CappedPaymentAmount,
                                        NetPaymentAmount = sp.NetPaymentAmount,
                                        ProfilePaymentAmount = sp.ProfilePaymentAmount,
                                        ReconciliationPaymentAmount = sp.ReconciliationPaymentAmount,
                                        PeriodTypeCode = PeriodTypeCode.CM,
                                        ActualVolume = sp.ActualVolume,
                                        ActualValue = sp.ActualValue,
                                        PlannedVolume = sp.PlannedVolume,
                                        PlannedValue = sp.PlannedValue,
                                        CollectionReturnCode = sp.CollectionReturnCode,
                                    });
                                });
                        });
                    });

                context.SaveChanges();
            }
        }
    }
}