namespace SFA.FCT.Operations.Integrity.IntegrityCheckers
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Repositories;
    using Services;
    using Utils;

    public class PayCalcVsPayGenChecker : IIntegrityChecker
    {
        private readonly IPaasDeliverablePaymentLazyRepository _paasDeliverablePaymentLazyRepository;
        private readonly IPaasSubnominalAggregationRepository _paasSubnominalAggregationRepository;
        private readonly IPaasFundingStreamPeriodRepository _paasFundingStreamPeriodRepository;

        public PayCalcVsPayGenChecker(
            IPaasDeliverablePaymentLazyRepository paasDeliverablePaymentLazyRepository,
            IPaasSubnominalAggregationRepository paasSubnominalAggregationRepository,
            IPaasFundingStreamPeriodRepository paasFundingStreamPeriodRepository)
        {
            _paasDeliverablePaymentLazyRepository = paasDeliverablePaymentLazyRepository;
            _paasSubnominalAggregationRepository = paasSubnominalAggregationRepository;
            _paasFundingStreamPeriodRepository = paasFundingStreamPeriodRepository;
        }

        public IntegrityCheckResult CheckValues()
        {
            IReadOnlyCollection<string> activeFsps = _paasFundingStreamPeriodRepository.GetFundingStreamPeriodCodesThatAreActive(DateTime.UtcNow);

            IDictionary<PaymentKey, decimal> deliverablePaymentDictionary = GetDeliverablePaymentsForPayableFundingStreamPeriods();
            IDictionary<PaymentKey, decimal> subnominalAggregationDictionary = GetSubnominalAggregations(activeFsps);

            IReadOnlyCollection<DifferenceItem> conflicts = Enumerable.Empty<DifferenceItem>()
                .Concat(GetMismatchedValuesBetweenDeliverablePaymentsAndSubnominalAggregations())
                .Concat(GetDeliverablePaymentsNotPresentInSubnominalAggregations())
                .Concat(GetSubnominalAggregationsNotPresentInDeliverablePayments())
                .ToList();

            return new IntegrityCheckResult(conflicts.Any(), conflicts.Any() ? new CsvWriter<DifferenceItem>().CreateCsv(conflicts) : null);

            IEnumerable<DifferenceItem> GetMismatchedValuesBetweenDeliverablePaymentsAndSubnominalAggregations()
                => deliverablePaymentDictionary
                        .Join(subnominalAggregationDictionary, dp => dp.Key, sa => sa.Key, (dp, sa) => new {dp, sa})
                        .Where(joined => joined.dp.Value != joined.sa.Value)
                        .Select(joined => new DifferenceItem
                        {
                            AllocationNumber = joined.dp.Key.AllocationNumber,
                            Period = joined.dp.Key.Period,
                            DeliverablePayments = joined.dp.Value,
                            SubnominalPayments = joined.sa.Value
                        });

            IEnumerable<DifferenceItem> GetDeliverablePaymentsNotPresentInSubnominalAggregations()
                => deliverablePaymentDictionary
                        .Where(dp => !subnominalAggregationDictionary.ContainsKey(dp.Key))
                        .Select(kvp => new DifferenceItem
                        {
                            AllocationNumber = kvp.Key.AllocationNumber,
                            Period = kvp.Key.Period,
                            DeliverablePayments = kvp.Value
                        });

            IEnumerable<DifferenceItem> GetSubnominalAggregationsNotPresentInDeliverablePayments()
                => subnominalAggregationDictionary
                        .Where(dp => !deliverablePaymentDictionary.ContainsKey(dp.Key))
                        .Select(kvp => new DifferenceItem
                        {
                            AllocationNumber = kvp.Key.AllocationNumber,
                            Period = kvp.Key.Period,
                            SubnominalPayments = kvp.Value
                        });
        }

        private IDictionary<PaymentKey, decimal> GetDeliverablePaymentsForPayableFundingStreamPeriods()
        {
            return _paasDeliverablePaymentLazyRepository.GetDeliverablePaymentsNotPaidExternally()
                .GroupBy(dp => new PaymentKey(dp.AllocationNumber, dp.YearPeriod))
                .Select(grp => new
                {
                    grp.Key,
                    TotalPaymentValue = grp.Sum(dp => dp.ProfilePaymentAmount + dp.CappedPaymentAmount + dp.BalancingPaymentAmount + dp.ReconciliationPaymentAmount)
                })
                .Where(dp => dp.TotalPaymentValue != 0)
                .ToDictionary(dp => dp.Key, dp => dp.TotalPaymentValue);
        }

        private IDictionary<PaymentKey, decimal> GetSubnominalAggregations(IReadOnlyCollection<string> fspCodes)
        {
            return _paasSubnominalAggregationRepository.GetSubnominalAggregationsForOpenContracts(fspCodes)
                .GroupBy(sa => new PaymentKey(sa.AllocationNumber, sa.Period))
                .Select(grp => new
                {
                    grp.Key,
                    TotalPaymentValue = grp.Sum(sa => sa.AggregatedValue)
                })
                .Where(sa => sa.TotalPaymentValue != 0)
                .ToDictionary(sa => sa.Key, sa => sa.TotalPaymentValue);
        }

        public class PaymentKey
        {
            public PaymentKey(string allocationNumber, string period)
            {
                AllocationNumber = allocationNumber;
                Period = period;
            }

            public string AllocationNumber { get; }

            public string Period { get; }

            public override bool Equals(object obj)
            {
                PaymentKey other = obj as PaymentKey;
                return AllocationNumber == other?.AllocationNumber && Period == other?.Period;
            }

            public override int GetHashCode()
            {
                return AllocationNumber.GetHashCode() ^ Period.GetHashCode();
            }
        }
        
        private class DifferenceItem
        {
            public string AllocationNumber { get; set; }

            public string Period { get; set; }

            public decimal? DeliverablePayments { get; set; }

            public decimal? SubnominalPayments { get; set; }
        }
    }
}
