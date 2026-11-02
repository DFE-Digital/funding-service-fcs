namespace SFA.FCT.Operations.Integrity.IntegrityCheckers
{
    using System;
    using System.Collections.Concurrent;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data.SqlClient;
    using System.Globalization;
    using System.Linq;
    using Dapper;
    using Extensions;
    using FCS.Worker.Common;
    using Microsoft.Xrm.Sdk;
    using Repositories;

    public abstract class SubnominalAggregationChecker
    {
        private readonly PaasSubnominalAggregationRepository _paasSubnominalAggregationRepository;
        private readonly IFcsConfiguration _configuration;
        private static readonly ConcurrentDictionary<int, IReadOnlyCollection<SubnominalAggregationComparisonItem>> CrmSubnominalAggregations = new ConcurrentDictionary<int, IReadOnlyCollection<SubnominalAggregationComparisonItem>>();

        protected SubnominalAggregationChecker(
            PaasSubnominalAggregationRepository paasSubnominalAggregationRepository,
            IFcsConfiguration configuration)
        {
            _paasSubnominalAggregationRepository = paasSubnominalAggregationRepository;
            _configuration = configuration;
        }

        public static void ClearCache()
        {
            CrmSubnominalAggregations.Clear();
        }

        protected IReadOnlyCollection<SubnominalAggregationComparisonItem> GetPaasSubnominalAggregations(IReadOnlyCollection<string> activeFsps)
        {
            return
                _paasSubnominalAggregationRepository.GetSubnominalAggregations(activeFsps)
                    .Select(sa => new SubnominalAggregationComparisonItem
                    {
                        AllocationNumber = sa.AllocationNumber,
                        Period = sa.Period,
                        SubnominalCode = sa.SubnominalCode,
                        PaymentType = sa.PaymentType,
                        AggregatedValue = sa.AggregatedValue
                    })
                    .ToList();
        }

        protected IReadOnlyCollection<SubnominalAggregationComparisonItem> GetCrmSubnominalAggregations(IReadOnlyCollection<string> activeFsps)
        {
            const string query = @"
SELECT
	sa.sfa_subnominalaggregatekey,
	sa.sfa_aggregatedvalue,
	sa.sfa_period,
	sa.sfa_subnominalcode,
	sa.sfa_paymenttype
FROM
	dbo.sfa_subnominalaggregation sa
	INNER JOIN dbo.sfa_fundingstreamperiod fsp ON fsp.Id = sa.sfa_fundingstreamperiod
WHERE
	fsp.sfa_fundingstreamperiodcode IN @activeFsps";

            return CrmSubnominalAggregations.GetOrAdd(activeFsps.GetHashcodeOfCollection(), hashCode =>
            {
                string connectionString = _configuration["ConnectionStrings:CrmDatabaseConnectionString"];

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    return connection.Query(query, new { activeFsps })
                        .Select(r => new SubnominalAggregationComparisonItem
                        {
                            CrmSubnominalAggregateKey = r.sfa_subnominalaggregatekey,
                            AggregatedValue = r.sfa_aggregatedvalue,
                            AllocationNumber = ExtractAllocationNumberFromCrmSubnominalAggregateKey(r.sfa_subnominalaggregatekey),
                            Period = TranslateCrmPeriod(r.sfa_period),
                            SubnominalCode = r.sfa_subnominalcode,
                            PaymentType = TranslateCrmPaymentType(new OptionSetValue(r.sfa_paymenttype))
                        })
                        .ToList();
                }
            });
        }

        private static string ExtractAllocationNumberFromCrmSubnominalAggregateKey(string crmSubnominalAggregateKey)
        {
            return crmSubnominalAggregateKey.Split('_')[1];
        }

        private static string TranslateCrmPeriod(string crmPeriod)
        {
            return DateTime.ParseExact(crmPeriod, "MMM-yy", CultureInfo.InvariantCulture).ToString("yyyyMM");
        }

        private static string TranslateCrmPaymentType(OptionSetValue crmPaymentType)
        {
            Dictionary<OptionSetValue, string> crmPaymentTypes = new Dictionary<OptionSetValue, string>
            {
                { new OptionSetValue(229660000), "PROFILE" },
                { new OptionSetValue(229660001), "RECONCILIATION" },
                { new OptionSetValue(229660002), "CAPPING" }
            };

            return crmPaymentTypes[crmPaymentType];
        }

        public class SubnominalAggregationComparisonItem
        {
            public string AllocationNumber { get; set; }

            public string Period { get; set; }

            public string SubnominalCode { get; set; }

            public string PaymentType { get; set; }

            public decimal? AggregatedValue { get; set; }

            public string Key => $"{AllocationNumber}_{Period}_{SubnominalCode}_{PaymentType}";

            public string CrmSubnominalAggregateKey { get; set; }
        }
    }
}