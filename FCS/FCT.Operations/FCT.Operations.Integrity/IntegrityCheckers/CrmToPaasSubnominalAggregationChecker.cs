namespace SFA.FCT.Operations.Integrity.IntegrityCheckers
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using FCS.Worker.Common;
    using Repositories;
    using Services;
    using Utils;

    public class CrmToPaasSubnominalAggregationChecker : SubnominalAggregationChecker, IIntegrityChecker
    {
        private readonly PaasFundingStreamPeriodRepository _paasFundingStreamPeriodRepository;

        public CrmToPaasSubnominalAggregationChecker(
            PaasSubnominalAggregationRepository paasSubnominalAggregationRepository,
            PaasFundingStreamPeriodRepository paasFundingStreamPeriodRepository, IFcsConfiguration configuration)
            : base(paasSubnominalAggregationRepository, configuration)
        {
            _paasFundingStreamPeriodRepository = paasFundingStreamPeriodRepository;
        }

        public IntegrityCheckResult CheckValues()
        {
            IReadOnlyCollection<string> activeFsps = _paasFundingStreamPeriodRepository.GetFundingStreamPeriodCodesThatAreActive(DateTime.UtcNow);

            IReadOnlyCollection<SubnominalAggregationComparisonItem> paasData = GetPaasSubnominalAggregations(activeFsps);
            IReadOnlyCollection<SubnominalAggregationComparisonItem> crmData = GetCrmSubnominalAggregations(activeFsps);

            IReadOnlyCollection<SubnominalAggregationDifferenceItem> differences = CompareCrmToPaas(paasData, crmData);

            return new IntegrityCheckResult(
                foundIssues: differences.Any(),
                issuesCsv: differences.Any() ? new CsvWriter<SubnominalAggregationDifferenceItem>().CreateCsv(differences) : null);
        }

        private static IReadOnlyCollection<SubnominalAggregationDifferenceItem> CompareCrmToPaas(
            IReadOnlyCollection<SubnominalAggregationComparisonItem> paasData,
            IReadOnlyCollection<SubnominalAggregationComparisonItem> crmData)
        {
            IReadOnlyDictionary<string, SubnominalAggregationComparisonItem> paasDictionary = paasData.ToDictionary(sa => sa.Key, sa => sa);
            ILookup<string, SubnominalAggregationComparisonItem> crmLookup = crmData.ToLookup(sa => sa.Key, sa => sa);

            return (
                from crmValue in crmData
                let matchingPaasValue = paasDictionary.ContainsKey(crmValue.Key) ? paasDictionary[crmValue.Key] : null
                where matchingPaasValue == null || matchingPaasValue.AggregatedValue != crmValue.AggregatedValue || crmLookup[crmValue.Key].Count() > 1
                select new SubnominalAggregationDifferenceItem
                {
                    AllocationNumber = crmValue.AllocationNumber,
                    Period = crmValue.Period,
                    SubnominalCode = crmValue.SubnominalCode,
                    PaymentType = crmValue.PaymentType,
                    CrmAggregatedValue = crmValue.AggregatedValue,
                    PaasAggregatedValue = matchingPaasValue?.AggregatedValue,
                    HasMatchingPaasRecord = matchingPaasValue != null,
                    HasDuplicateCrmEntities = crmLookup[crmValue.Key].Count() > 1
                }).ToList();
        }
        
        private class SubnominalAggregationDifferenceItem
        {
            [Order(1)]
            public string AllocationNumber { get; set; }

            [Order(2)]
            public string Period { get; set; }

            [Order(3)]
            public string SubnominalCode { get; set; }

            [Order(4)]
            public string PaymentType { get; set; }

            [Order(5)]
            public decimal? CrmAggregatedValue { get; set; }

            [Order(6)]
            public decimal? PaasAggregatedValue { get; set; }

            [Order(7)]
            public bool HasMatchingPaasRecord { get; set; }

            [Order(8)]
            public bool HasDuplicateCrmEntities { get; set; }
        }
    }
}