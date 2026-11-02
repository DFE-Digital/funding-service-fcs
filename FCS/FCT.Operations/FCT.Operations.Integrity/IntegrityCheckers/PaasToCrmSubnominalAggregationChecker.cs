namespace SFA.FCT.Operations.Integrity.IntegrityCheckers
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using FCS.Worker.Common;
    using Repositories;
    using Services;
    using Utils;

    public class PaasToCrmSubnominalAggregationChecker : SubnominalAggregationChecker, IIntegrityChecker
    {
        private readonly PaasFundingStreamPeriodRepository _paasFundingStreamPeriodRepository;
        private readonly IFcsConfiguration _configuration;

        public PaasToCrmSubnominalAggregationChecker(
            PaasSubnominalAggregationRepository paasSubnominalAggregationRepository,
            PaasFundingStreamPeriodRepository paasFundingStreamPeriodRepository, IFcsConfiguration configuration)
            : base(paasSubnominalAggregationRepository, configuration)
        {
            _paasFundingStreamPeriodRepository = paasFundingStreamPeriodRepository;
            _configuration = configuration;
        }

        public IntegrityCheckResult CheckValues()
        {
            IReadOnlyCollection<string> activeFsps = _paasFundingStreamPeriodRepository.GetFundingStreamPeriodCodesThatAreActive(DateTime.UtcNow);

            IReadOnlyCollection<SubnominalAggregationComparisonItem> paasData = GetPaasSubnominalAggregations(activeFsps);
            IReadOnlyCollection<SubnominalAggregationComparisonItem> crmData = GetCrmSubnominalAggregations(activeFsps);

            IReadOnlyCollection<SubnominalAggregationDifferenceItem> differences = ComparePaasToCrm(paasData, crmData);

            return new IntegrityCheckResult(
                foundIssues: differences.Any(),
                issuesCsv: differences.Any() ? new CsvWriter<SubnominalAggregationDifferenceItem>().CreateCsv(differences) : null);
        }

        private static IReadOnlyCollection<SubnominalAggregationDifferenceItem> ComparePaasToCrm(
            IReadOnlyCollection<SubnominalAggregationComparisonItem> paasData,
            IReadOnlyCollection<SubnominalAggregationComparisonItem> crmData)
        {
            ILookup<string, SubnominalAggregationComparisonItem> crmLookup = crmData.ToLookup(sa => sa.Key, sa => sa);

            return (
                from paasValue in paasData
                let matchingCrmItems = crmLookup[paasValue.Key].ToList()
                where !matchingCrmItems.Any() || matchingCrmItems.Count() > 1 || matchingCrmItems.Single().AggregatedValue != paasValue.AggregatedValue
                select new SubnominalAggregationDifferenceItem
                {
                    AllocationNumber = paasValue.AllocationNumber,
                    Period = paasValue.Period,
                    SubnominalCode = paasValue.SubnominalCode,
                    PaymentType = paasValue.PaymentType,
                    PaasAggregatedValue = paasValue.AggregatedValue,
                    CrmAggregatedValue = matchingCrmItems.Count() == 1 ? matchingCrmItems.Single().AggregatedValue : null,
                    HasMatchingCrmEntity = matchingCrmItems.Any(),
                    HasDuplicateCrmEntities = matchingCrmItems.Count() > 1
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
            public decimal? PaasAggregatedValue { get; set; }

            [Order(6)]
            public decimal? CrmAggregatedValue { get; set; }

            [Order(7)]
            public bool HasMatchingCrmEntity { get; set; }

            [Order(8)]
            public bool HasDuplicateCrmEntities { get; set; }
        }
    }
}
