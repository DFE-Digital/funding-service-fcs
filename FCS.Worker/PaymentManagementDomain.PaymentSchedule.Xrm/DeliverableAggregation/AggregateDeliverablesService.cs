namespace PaymentManagementDomain.PaymentSchedule.DeliverableAggregation
{
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Repositories;
    using System.Collections.Generic;
    using System.Linq;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Dtos;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Repositories;
    using System;

    public class AggregateDeliverablesService : IAggregateDeliverablesService
    {
        private readonly IDeliverablePaymentRepository _deliverablePaymentRepository;
        private readonly IPayCalcPolicyQueryRepository _policyQueryRepository;

        public AggregateDeliverablesService(IDeliverablePaymentRepository deliverablePaymentRepository, IPayCalcPolicyQueryRepository policyQueryRepository)
        {
            _deliverablePaymentRepository = deliverablePaymentRepository;
            _policyQueryRepository = policyQueryRepository;
        }

        public IReadOnlyCollection<DeliverableActual> GetAggregatedDeliverablesForAllocation(
            string allocationNumber,
            int version, string fundingStreamPeriodCode,
            ConnectionInfo connectionInfo)
        {
            IReadOnlyCollection<DeliverableActual> deliverableActuals = _deliverablePaymentRepository.GetSummedActualsByDeliverableForAllocation(allocationNumber, version, connectionInfo);

            IReadOnlyCollection<PolicyDeliverable> policyDeliverables =_policyQueryRepository.GetFundingStreamPeriodDeliverables(fundingStreamPeriodCode, connectionInfo);

            IReadOnlyCollection<DeliverableActual> enrichWithParentDeliverableActuals = EnrichWithParentDeliverable(deliverableActuals, policyDeliverables);

            enrichWithParentDeliverableActuals.ToList().ForEach(a =>
            {
                Actual totalledActual = Aggregate(a, enrichWithParentDeliverableActuals);
                a.Value = totalledActual.Value;
                a.Volume = totalledActual.Volume;
            });

            return enrichWithParentDeliverableActuals;
        }

        private Actual Aggregate(DeliverableActual actual, IReadOnlyCollection<DeliverableActual> enrichWithParentDeliverableActuals)
        {
            var children = enrichWithParentDeliverableActuals.Where(e => e.ParentDeliverableCode == actual.DeliverableCode).ToList();

            if (children.Any())
            {
                IReadOnlyCollection<Actual> childActuals = children.Select(c => Aggregate(c, enrichWithParentDeliverableActuals)).ToList();
                return new Actual(
                    value: childActuals.NullableSum(a => a.Value),
                    volume: null);
            }

            return new Actual(volume: actual.Volume, value: actual.Value);
        }

        private IReadOnlyCollection<DeliverableActual> EnrichWithParentDeliverable(IReadOnlyCollection<DeliverableActual> deliverableActuals, IReadOnlyCollection<PolicyDeliverable> policyDeliverables)
        {
            return deliverableActuals.Select(da =>
            {
                var policyDeliverable = policyDeliverables.Single(pd => pd.DeliverableCode == da.DeliverableCode);
                return new DeliverableActual(da.DeliverableCode, da.Value, da.Volume, policyDeliverable.ParentDeliverableCode);
            }).ToList();
        }

        private class Actual
        {
            public Actual(decimal? value, int? volume)
            {
                Value = value;
                Volume = volume;
            }

            public decimal? Value { get; }

            public int? Volume { get; }
        }
    }

    internal static class EnumerableExtensionMethod
    {
        public static decimal? NullableSum<TSource>(this IEnumerable<TSource> source, Func<TSource, decimal?> selector)
        {
            var values = source.Select(selector).ToList();
            return values.All(v => v == null) ? null : values.Sum();
        }
    }
}