
using AutoMapper;
using Microsoft.Extensions.Logging;
using MoreLinq;
using SFA.FCT.CrossDomain.Integration.Entities.Data;
using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Dtos;
using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Model;
using System;
using System.Collections.Generic;
using System.Linq;

namespace SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Repositories
{
    public class DeliverablePaymentRepository : IDeliverablePaymentRepository
    {
        // --------------------------------------------------------------------
        // STATIC MAPPING SETUP - replaces old Mapper.CreateMap(...)
        // --------------------------------------------------------------------
        private static readonly IMapper _mapper;

        static DeliverablePaymentRepository()
        {
            var loggerFactory = LoggerFactory.Create(builder =>
            {
                builder.AddDebug();
                builder.AddConsole();
            });
            var cfgExpr = new MapperConfigurationExpression();
            cfgExpr.CreateMap<DeliverablePayment, DeliverablePayment>();
            var config = new MapperConfiguration(cfgExpr, loggerFactory);
            _mapper = config.CreateMapper();
        }

        // --------------------------------------------------------------------
        // REPOSITORY METHODS (unchanged)
        // --------------------------------------------------------------------

        public IReadOnlyCollection<DeliverablePayment> GetDeliverablePaymentsForAllocation(
            string allocationNumber, int versionNumber, ConnectionInfo connectionInfo)
        {
            using (var context = new PaymentSchedulePolicyContext(connectionInfo))
            {
                return context.DeliverablePayments
                    .Where(dp => dp.AllocationNumber == allocationNumber &&
                                 dp.VersionNumber == versionNumber)
                    .ToList();
            }
        }

        public IReadOnlyCollection<DeliverablePeriodActualVolume> GetDeliverablePeriodActualVolumesForAllocation(
            string allocationNumber, int versionNumber, ConnectionInfo connectionInfo)
        {
            using (var context = new PaymentSchedulePolicyContext(connectionInfo))
            {
                return context.DeliverablePayments
                    .Where(dp => dp.AllocationNumber == allocationNumber &&
                                 dp.VersionNumber == versionNumber)
                    .Select(dp => new { dp.Period, dp.DeliverableCode, dp.ActualVolume })
                    .AsEnumerable()
                    .Select(dp => new DeliverablePeriodActualVolume(dp.Period, dp.DeliverableCode, dp.ActualVolume))
                    .ToList();
            }
        }

        public IReadOnlyCollection<DeliverableActual> GetSummedActualsByDeliverableForAllocation(
            string allocationNumber, int versionNumber, ConnectionInfo connectionInfo)
        {
            using (var context = new PaymentSchedulePolicyContext(connectionInfo))
            {
                return context.DeliverablePayments
                    .Where(dp => dp.AllocationNumber == allocationNumber &&
                                 dp.VersionNumber == versionNumber)
                    .GroupBy(dp => dp.DeliverableCode)
                    .Select(g => new
                    {
                        g.Key,
                        Value = g.Sum(dp => dp.ActualValue),
                        Volume = g.Sum(dp => dp.ActualVolume)
                    })
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
            return deliverablePayments
                .Select(dp => CreateDeliverablePaymentCopy(dp, deliverableCodesWherePlannedValueShouldBeRemoved))
                .ToList();
        }

        public void AddOrUpdateDeliverablePaymentsForAllocation(
            IReadOnlyCollection<DeliverablePayment> deliverablePayments,
            string allocationNumber, int version, ConnectionInfo connectionInfo)
        {
            using (var context = new PaymentSchedulePolicyContext(connectionInfo))
            {
                var existingPayments = context.DeliverablePayments
                    .Where(dp => dp.AllocationNumber == allocationNumber &&
                                 dp.VersionNumber == version)
                    .ToList();

                deliverablePayments.ForEach(dp =>
                {
                    var existingDeliverablePayment =
                        existingPayments.FirstOrDefault(exDp => exDp.Equals(dp));

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

        public void UpdateActualValuesAndVolumes(
            IReadOnlyCollection<DeliverablePayment> deliverablePayments, ConnectionInfo connectionInfo)
        {
            string allocationNumber = deliverablePayments.First().AllocationNumber;
            int versionNumber = deliverablePayments.First().VersionNumber;

            using (var context = new PaymentSchedulePolicyContext(connectionInfo))
            {
                var existingPayments = context.DeliverablePayments
                    .Where(dp => dp.AllocationNumber == allocationNumber &&
                                 dp.VersionNumber == versionNumber)
                    .ToList();

                deliverablePayments.ForEach(dp =>
                {
                    var existingDeliverablePayment =
                        existingPayments.SingleOrDefault(exDp => exDp.Equals(dp));

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
                var versions = context.DeliverablePayments
                    .Where(dp => dp.AllocationNumber == allocationNumber)
                    .Select(dp => dp.VersionNumber)
                    .ToList();

                return versions.Any() ? versions.Max() : (int?)null;
            }
        }

        public void AddOrUpdate(DeliverablePayment deliverablePayment, ConnectionInfo connectionInfo)
        {
            using (var context = new PaymentSchedulePolicyContext(connectionInfo))
            {
                deliverablePayment.LastModifiedDate = DateTime.UtcNow;

                var existing = context.DeliverablePayments.Find(
                    deliverablePayment.AllocationNumber,
                    deliverablePayment.VersionNumber,
                    deliverablePayment.DeliverableCode,
                    deliverablePayment.Period);

                if (existing != null)
                {
                    existing.BalancingPaymentAmount = deliverablePayment.BalancingPaymentAmount;
                    existing.CappedPaymentAmount = deliverablePayment.CappedPaymentAmount;
                    existing.NetPaymentAmount = deliverablePayment.NetPaymentAmount;
                    existing.ActualValue = deliverablePayment.ActualValue;
                    existing.ActualVolume = deliverablePayment.ActualVolume;
                    existing.ProfilePaymentAmount = deliverablePayment.ProfilePaymentAmount;
                    existing.ReconciliationPaymentAmount = deliverablePayment.ReconciliationPaymentAmount;
                }
                else
                {
                    context.DeliverablePayments.Add(deliverablePayment);
                }

                context.SaveChanges();
            }
        }
        private static DeliverablePayment CreateDeliverablePaymentCopy(
            DeliverablePayment deliverablePayment,
            IReadOnlyCollection<int> deliverableCodesWherePlannedValueShouldBeRemoved)
        {
            bool removePlanned =
                deliverableCodesWherePlannedValueShouldBeRemoved.Contains(deliverablePayment.DeliverableCode);

            DeliverablePayment copy = _mapper.Map<DeliverablePayment>(deliverablePayment);

            if (removePlanned)
            {
                copy.PlannedValue = 0;
            }

            return copy;
        }
    }
}
