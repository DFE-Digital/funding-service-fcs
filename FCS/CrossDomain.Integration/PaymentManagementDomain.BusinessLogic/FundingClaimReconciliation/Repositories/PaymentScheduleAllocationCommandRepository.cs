namespace SFA.FCT.PaymentManagementDomain.BusinessLogic.FundingClaimReconciliation.Repositories
{
    using System;
    using System.Linq;
    using CrossDomain.Integration.Entities.Data;
    using DataStore = PaymentSchedule.DataStore;
    using Model = PaymentSchedule.DataStore.Model;
    using PaymentSchedule = CrossDomain.Integration.Entities.PaymentSchedule;

    public class PaymentScheduleAllocationCommandRepository : IPaymentScheduleAllocationCommandRepository
    {
        public void UpdateDeliverablePaymentsForAllocation(PaymentSchedule.Allocation allocation, DateTime allocationStartDate, DateTime allocationEndDate,
            ConnectionInfo connectionInfo)
        {
            using (var context = new DataStore.PaymentSchedulePolicyContext(connectionInfo))
            {
                DateTime utcNow = DateTime.UtcNow;

                AddOrUpdateAllocationToStore(allocation, allocationStartDate, allocationEndDate, utcNow, context);
                AddOrUpdateDeliverablePaymentsToStore(allocation, utcNow, context);

                context.SaveChanges();
            }
        }

        private void AddOrUpdateAllocationToStore(PaymentSchedule.Allocation allocation, DateTime allocationStartDate, DateTime allocationEndDate, DateTime utcNow,
            DataStore.IPaymentSchedulePolicyContext context)
        {
            UpSertHelper.AddOrUpdatePaymentScheduleEntity(
                entity: new Model.Allocation
                {
                    AllocationNumber = allocation.AllocationNumber,
                    ContractNumber = allocation.ContractNumber,
                    ContractVersionNumber = allocation.ContractVersionNumber,
                    VersionNumber = allocation.VersionNumber,
                    FundingStreamPeriodCode = allocation.FundingStreamPeriodCode,
                    AllocationStartDate = allocationStartDate,
                    AllocationEndDate = allocationEndDate,
                    LastModifiedDate = utcNow
                },
                getExisting: () => context.Allocations.Find(allocation.AllocationNumber, allocation.VersionNumber),
                dbSet: context.Allocations,
                updateDb: (entityInDb, changedEntity) => context.UpdateEntry(entityInDb, changedEntity));
        }

        private void AddOrUpdateDeliverablePaymentsToStore(PaymentSchedule.Allocation allocation, DateTime utcNow, DataStore.IPaymentSchedulePolicyContext context)
        {
            allocation.AllocationDeliverables.SelectMany(d => d.ScheduledPayments.Select(sp => new Model.DeliverablePayment
            {
                AllocationNumber = allocation.AllocationNumber,
                VersionNumber = allocation.VersionNumber,
                DeliverableCode = d.DeliverableCode,
                Period = sp.Period,
                PeriodTypeCode = (Model.PeriodTypeCode)Enum.Parse(typeof(Model.PeriodTypeCode), sp.PeriodTypeCode),
                CollectionReturnCode = sp.CollectionReturnCode,
                ActualValue = sp.ActualValue,
                ActualVolume = sp.ActualVolume,
                BalancingPaymentAmount = sp.BalancingPaymentAmount,
                CappedPaymentAmount = sp.CappedPaymentAmount,
                NetPaymentAmount = sp.NetPaymentAmount,
                PlannedValue = sp.PlannedValue,
                PlannedVolume = sp.PlannedVolume,
                ProfilePaymentAmount = sp.ProfilePaymentAmount,
                ReconciliationPaymentAmount = sp.ReconciliationPaymentAmount,
                LastModifiedDate = utcNow
            }))
            .ToList()
            .ForEach(dp => AddOrUpdateDeliverablePayment(dp, context));
        }

        private void AddOrUpdateDeliverablePayment(Model.DeliverablePayment deliverablePayment, DataStore.IPaymentSchedulePolicyContext context)
        {
            UpSertHelper.AddOrUpdatePaymentScheduleEntity(
                entity: deliverablePayment,
                getExisting: () => context.DeliverablePayments.Find(
                    deliverablePayment.AllocationNumber,
                    deliverablePayment.VersionNumber,
                    deliverablePayment.DeliverableCode,
                    deliverablePayment.Period),
                dbSet: context.DeliverablePayments,
                updateDb: ((entityInDb, changedEntity) => context.UpdateEntry(entityInDb, changedEntity)));
        }
    }
}