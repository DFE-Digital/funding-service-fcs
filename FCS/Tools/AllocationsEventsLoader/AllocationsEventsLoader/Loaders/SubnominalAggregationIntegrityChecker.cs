namespace AllocationsEventsLoader.Loaders
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Entities;
    using Microsoft.Xrm.Sdk;

    public class SubnominalAggregationIntegrityChecker
    {
        private readonly IList<SubnominalAggregationSqlItem> _sqlData;
        private readonly Dictionary<string, List<SubnominalAggregationCrmItem>> _crmData;
        
        public SubnominalAggregationIntegrityChecker(IEnumerable<SubnominalAggregationSqlItem> sqlData, Dictionary<string, List<SubnominalAggregationCrmItem>> crmData)
        {
            _sqlData = sqlData.ToList();
            _crmData = crmData;
        }

        public IEnumerable<SubnominalAggregationDifferenceItem> CompareDataStores()
        {
            List<SubnominalAggregationDifferenceItem> differences = new List<SubnominalAggregationDifferenceItem>();

            Console.WriteLine("Comparing SQL data to CRM data...");
            differences.AddRange(CompareSqlDataToCrmData());

            Console.WriteLine("Comparing CRM data to SQL data...");
            differences.AddRange(CompareCrmDataToSqlData());

            return differences;
        }

        private IEnumerable<SubnominalAggregationDifferenceItem> CompareSqlDataToCrmData()
        {
            List<SubnominalAggregationDifferenceItem> differences = new List<SubnominalAggregationDifferenceItem>();
            int counter = 0;

            foreach (SubnominalAggregationSqlItem sqlItem in _sqlData)
            {
                Console.WriteLine($"Processing item {++counter} of {_sqlData.Count} SQL data items");

                SubnominalAggregationCrmItem crmItem = GetMatchingCrmDataItem(sqlItem);

                if (crmItem == null || !CompareDataItems(sqlItem, crmItem))
                {
                    Console.WriteLine($"Difference found for SQL Subnominal - Allocation: {sqlItem.AllocationNumber}, Period: {sqlItem.Period}, Subnominal Code: {sqlItem.SubnominalCode}, Payment Type: {sqlItem.PaymentType}.");

                    differences.Add(new SubnominalAggregationDifferenceItem
                    {
                        AllocationNumber = sqlItem.AllocationNumber,
                        Period = sqlItem.Period,
                        SubnominalCode = sqlItem.SubnominalCode,
                        PaymentType = sqlItem.PaymentType,
                        SqlAggregatedValue = sqlItem.AggregatedValue,
                        CrmAggregatedValue = crmItem?.sfa_AggregatedValue,
                        ComparisonDirection = "SQL to CRM"
                    });
                }
            }

            return differences;
        }

        private IEnumerable<SubnominalAggregationDifferenceItem> CompareCrmDataToSqlData()
        {
            List<SubnominalAggregationDifferenceItem> differences = new List<SubnominalAggregationDifferenceItem>();
            List<SubnominalAggregationCrmItem> allCrmData = _crmData.Values.SelectMany(v => v.ToList()).ToList();
            int counter = 0;

            foreach (SubnominalAggregationCrmItem crmItem in allCrmData)
            {
                Console.WriteLine($"Processing item {++counter} of {allCrmData.Count} CRM data items");

                SubnominalAggregationSqlItem sqlItem = GetMatchingSqlDataItem(crmItem);

                if (sqlItem == null || !CompareDataItems(sqlItem, crmItem))
                {
                    Console.WriteLine($"Difference found for CRM Subnominal - Aggregate Key: {crmItem.sfa_SubnominalAggregateKey}, Payment Type: {crmItem.sfa_PaymentType}.");

                    differences.Add(new SubnominalAggregationDifferenceItem
                    {
                        AllocationNumber = ExtractAllocationNumberFromCrmSubnominalAggregateKey(crmItem.sfa_SubnominalAggregateKey),
                        Period = crmItem.sfa_Period,
                        SubnominalCode = crmItem.sfa_SubnominalCode,
                        PaymentType = TranslateCrmPaymentTypeToSqlFormat(crmItem.sfa_PaymentType),
                        SqlAggregatedValue = sqlItem?.AggregatedValue,
                        CrmAggregatedValue = crmItem.sfa_AggregatedValue,
                        ComparisonDirection = "CRM to SQL"
                    });
                }
            }

            return differences;
        }

        private SubnominalAggregationCrmItem GetMatchingCrmDataItem(SubnominalAggregationSqlItem sqlItem)
        {
            string crmSubnominalAggregateKey = CreateCrmSubnominalAggregateKeyFromFromSqlDataItem(sqlItem);
            OptionSetValue crmPaymentType = TranslateSqlPaymentTypeToCrmFormat(sqlItem.PaymentType);

            return
                _crmData[crmSubnominalAggregateKey]?
                .SingleOrDefault(sn => sn.sfa_PaymentType.Equals(crmPaymentType));
        }

        private SubnominalAggregationSqlItem GetMatchingSqlDataItem(SubnominalAggregationCrmItem crmItem)
        {
            string allocationNumber = ExtractAllocationNumberFromCrmSubnominalAggregateKey(crmItem.sfa_SubnominalAggregateKey);
            string period = TranslateCrmPeriodToSqlFormat(crmItem.sfa_Period);
            string paymentType = TranslateCrmPaymentTypeToSqlFormat(crmItem.sfa_PaymentType);

            return _sqlData
                .SingleOrDefault(sn =>
                    sn.SubnominalCode == crmItem.sfa_SubnominalCode &&
                    sn.AllocationNumber == allocationNumber &&
                    sn.Period == period &&
                    sn.PaymentType == paymentType);
        }

        private static bool CompareDataItems(SubnominalAggregationSqlItem sqlValue, SubnominalAggregationCrmItem crmValue)
        {
            return sqlValue.AggregatedValue == crmValue.sfa_AggregatedValue;
        }

        private static string TranslateSqlPeriodToCrmFormat(string sqlPeriod)
        {
            Dictionary<string, string> periods = new Dictionary<string, string>
            {
                ["01"] = "Jan",
                ["02"] = "Feb",
                ["03"] = "Mar",
                ["04"] = "Apr",
                ["05"] = "May",
                ["06"] = "Jun",
                ["07"] = "Jul",
                ["08"] = "Aug",
                ["09"] = "Sep",
                ["10"] = "Oct",
                ["11"] = "Nov",
                ["12"] = "Dec"
            };

            return $"{periods[sqlPeriod.Substring(4, 2)]}-{sqlPeriod.Substring(2, 2)}";
        }

        private static string TranslateCrmPeriodToSqlFormat(string crmPeriod)
        {
            Dictionary<string, string> periods = new Dictionary<string, string>
            {
                ["Jan"] = "01",
                ["Feb"] = "02",
                ["Mar"] = "03",
                ["Apr"] = "04",
                ["May"] = "05",
                ["Jun"] = "06",
                ["Jul"] = "07",
                ["Aug"] = "08",
                ["Sep"] = "09",
                ["Oct"] = "10",
                ["Nov"] = "11",
                ["Dec"] = "12"
            };

            return $"20{crmPeriod.Substring(4, 2)}{periods[crmPeriod.Substring(0, 3)]}";
        }

        private static OptionSetValue TranslateSqlPaymentTypeToCrmFormat(string sqlPayment)
        {
            Dictionary<string, OptionSetValue> paymentTypes = new Dictionary<string, OptionSetValue>
            {
                ["PROFILE"] = new OptionSetValue(229660000),
                ["RECONCILIATION"] = new OptionSetValue(229660001),
                ["CAPPING"] = new OptionSetValue(229660002)
            };

            return paymentTypes[sqlPayment];
        }

        private string TranslateCrmPaymentTypeToSqlFormat(OptionSetValue crmPayment)
        {
            Dictionary<OptionSetValue, string> paymentTypes = new Dictionary<OptionSetValue, string>
            {
                { new OptionSetValue(229660000), "PROFILE" },
                { new OptionSetValue(229660001), "RECONCILIATION" },
                { new OptionSetValue(229660002), "CAPPING" }
            };

            return paymentTypes[crmPayment];
        }

        private static string ExtractAllocationNumberFromCrmSubnominalAggregateKey(string crmSubnominalAggregateKey)
        {
            return crmSubnominalAggregateKey.Split('_')[1];
        }

        private static string CreateCrmSubnominalAggregateKeyFromFromSqlDataItem(SubnominalAggregationSqlItem sqlValue)
        {
            return $"{sqlValue.SubnominalCode}_{sqlValue.AllocationNumber}_{TranslateSqlPeriodToCrmFormat(sqlValue.Period)}";
        }
    }
}
