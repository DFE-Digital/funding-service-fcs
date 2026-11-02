namespace SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using AutoMapper;
    using Model;
    using MoreLinq;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Dtos;

    public class DeliverablePaymentRepository : IDeliverablePaymentRepository
    {
        static DeliverablePaymentRepository()
        {
            Mapper.CreateMap<DeliverablePayment, DeliverablePayment>();
        }

        public IReadOnlyCollection<DeliverablePayment> GetDeliverablePaymentsForAllocation(string allocationNumber, int versionNumber,
            ConnectionInfo connectionInfo)
        {
            using (var context = new PaymentSchedulePolicyContext(connectionInfo))
            {
                return context.DeliverablePayments.Where(dp => dp.AllocationNumber == allocationNumber
                                                                                     && dp.VersionNumber == versionNumber)
                                                                                     .ToList();
            }
        }

        public IReadOnlyCollection<DeliverablePeriodActualVolume> GetDeliverablePeriodActualVolumesForAllocation(string allocationNumber, int versionNumber,
            ConnectionInfo connectionInfo)
        {
            using (var context = new PaymentSchedulePolicyContext(connectionInfo))
            {
                return context.DeliverablePayments
                    .Where(dp => dp.AllocationNumber == allocationNumber && dp.VersionNumber == versionNumber)
                    .Select(dp => new { dp.Period, dp.DeliverableCode, dp.ActualVolume })
                    .AsEnumerable()
                    .Select(dp => new DeliverablePeriodActualVolume(dp.Period, dp.DeliverableCode, dp.ActualVolume))
                    .ToList();
            }
        }

        public IReadOnlyCollection<DeliverableActual> GetSummedActualsByDeliverableForAllocation(string allocationNumber, int versionNumber, ConnectionInfo connectionInfo)
        {
            using (var context = new PaymentSchedulePolicyContext(connectionInfo))
            {
                return context.DeliverablePayments
                    .Where(dp => dp.AllocationNumber == allocationNumber && dp.VersionNumber == versionNumber)
                    .GroupBy(dp => dp.DeliverableCode)
                    .Select(g => new { g.Key, Value = g.Sum(dp => dp.ActualValue), Volume = g.Sum(dp => dp.ActualVolume) })
                    .AsEnumerable()
                    .Select(g => new DeliverableActual(g.Key, g.Value, g.Volume))
                    .ToList();
            }
        }

        public IReadOnlyCollection<DeliverablePayment>
            CopyDeliverablePaymentsWithoutPlannedValueOnCertainDeliverableCodes(
            IReadOnlyCollection<DeliverablePayment> deliverablePayments,
            IReadOnlyCollection<int> deliverableCodesWherePlannedValueShouldBeRemoved)
        {
            return deliverablePayments.Select(dp => CreateDeliverablePaymentCopy(dp, deliverableCodesWherePlannedValueShouldBeRemoved)).ToList();
        }

        public void AddOrUpdateDeliverablePaymentsForAllocation(IReadOnlyCollection<DeliverablePayment> deliverablePayments, string allocationNumber, int version,
            ConnectionInfo connectionInfo)
        {
            using (var context = new PaymentSchedulePolicyContext(connectionInfo))
            {
                var existingPayments = context.DeliverablePayments
                    .Where(dp => dp.AllocationNumber == allocationNumber && dp.VersionNumber == version)
                    .ToList();

                deliverablePayments.ForEach(dp =>
                {
                    var existingDeliverablePayment = existingPayments.FirstOrDefault(exDp => exDp.Equals(dp));
                    if (existingDeliverablePayment != null)
                    {
                        existingDeliverablePayment.BalancingPaymentAmount = dp.BalancingPaymentAmount;
                        existingDeliverablePayment.CappedPaymentAmount = dp.CappedPaymentAmount;
                        existingDeliverablePayment.NetPaymentAmount = dp.NetPaymentAmount;
                        existingDeliverablePayment.ActualValue = dp.ActualValue;
                        existingDeliverablePayment.ActualVolume = dp.ActualVolume;
                        existingDeliverablePayment.ProfilePaymentAmount = dp.ProfilePaymentAmount;
                        existingDeliverablePayment.ReconciliationPaymentAmount = dp.ReconciliationPaymentAmount;
                    }
                    else
                    {
                        context.DeliverablePayments.Add(dp);
                    }
                });

                context.SaveChanges();
            }
        }

        public void UpdateActualValuesAndVolumes(IReadOnlyCollection<DeliverablePayment> deliverablePayments, ConnectionInfo connectionInfo)
        {
            string allocationNumber = deliverablePayments.First().AllocationNumber;
            int versionNumber = deliverablePayments.First().VersionNumber;

            using (var context = new PaymentSchedulePolicyContext(connectionInfo))
            {
                IReadOnlyCollection<DeliverablePayment> existingPayments = context.DeliverablePayments
                    .Where(dp => dp.AllocationNumber == allocationNumber && dp.VersionNumber == versionNumber)
                    .ToList();

                deliverablePayments.ForEach(dp =>
                {
                    DeliverablePayment existingDeliverablePayment = existingPayments.SingleOrDefault(exDp => exDp.Equals(dp));

                    if (existingDeliverablePayment != null)
                    {
                        existingDeliverablePayment.ActualValue = dp.ActualValue;
                        existingDeliverablePayment.ActualVolume = dp.ActualVolume;
                    }
                });

                context.SaveChanges();
            }
        }

        public int? GetLatestVersion(string allocationNumber, ConnectionInfo connectionInfo)
        {
            using (var context = new PaymentSchedulePolicyContext(connectionInfo))
            {
                IReadOnlyCollection<int> versionNumbers = context.DeliverablePayments
                        .Where(dp => dp.AllocationNumber == allocationNumber)
                        .Select(dp => dp.VersionNumber)
                        .ToList();

                int? maxVersionNumber = null;

                if (versionNumbers.Any())
                {
                    maxVersionNumber = versionNumbers.Max();
                }

                return maxVersionNumber;
            }
        }

        public void AddOrUpdate(DeliverablePayment deliverablePayment, ConnectionInfo connectionInfo)
        {
            using (var context = new PaymentSchedulePolicyContext(connectionInfo))
            {
                deliverablePayment.LastModifiedDate = DateTime.UtcNow;

                DeliverablePayment existingDeliverablePayment = context.DeliverablePayments.Find(
                    deliverablePayment.AllocationNumber,
                    deliverablePayment.VersionNumber,
                    deliverablePayment.DeliverableCode,
                    deliverablePayment.Period);

                if (existingDeliverablePayment != null)
                {
                    existingDeliverablePayment.BalancingPaymentAmount = deliverablePayment.BalancingPaymentAmount;
                    existingDeliverablePayment.CappedPaymentAmount = deliverablePayment.CappedPaymentAmount;
                    existingDeliverablePayment.NetPaymentAmount = deliverablePayment.NetPaymentAmount;
                    existingDeliverablePayment.ActualValue = deliverablePayment.ActualValue;
                    existingDeliverablePayment.ActualVolume = deliverablePayment.ActualVolume;
                    existingDeliverablePayment.ProfilePaymentAmount = deliverablePayment.ProfilePaymentAmount;
                    existingDeliverablePayment.ReconciliationPaymentAmount = deliverablePayment.ReconciliationPaymentAmount;
                }
                else
                {
                    context.DeliverablePayments.Add(deliverablePayment);
                }

                context.SaveChanges();
            }
        }

        private static DeliverablePayment CreateDeliverablePaymentCopy(DeliverablePayment deliverablePayment, IReadOnlyCollection<int> deliverableCodesWherePlannedValueShouldBeRemoved)
        {
            bool removePlannedValue =
                deliverableCodesWherePlannedValueShouldBeRemoved.Contains(deliverablePayment.DeliverableCode);

            DeliverablePayment copy = Mapper.Map<DeliverablePayment, DeliverablePayment>(deliverablePayment);

            if (removePlannedValue)
            {
                copy.PlannedValue = 0;
            }

            return copy;
        }
    }
}
