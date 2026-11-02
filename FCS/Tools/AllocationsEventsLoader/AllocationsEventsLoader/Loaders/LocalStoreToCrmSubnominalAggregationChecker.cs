namespace AllocationsEventsLoader.Loaders
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Linq;
    using Entities;
    using Microsoft.Xrm.Client;
    using Microsoft.Xrm.Client.Services;
    using Microsoft.Xrm.Sdk;
    using PaymentGenerationDomain.Integration.DataStore;
    using Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;

    public class LocalStoreToCrmSubnominalAggregationChecker
    {
        public void CheckValues()
        {
            Console.WriteLine("Run started: {0}", DateTime.Now);

            Console.WriteLine($"Retrieving subnominal aggregations from SQL storage with connection: {ConfigurationManager.ConnectionStrings["PaymentGenerationDbContext"].ConnectionString}...");
            List<SubnominalAggregationSqlItem> sqlData = GetAllDataFromSql();

            Console.WriteLine($"Retrieving subnominal aggregations from CRM storage with connection: {ConfigurationManager.ConnectionStrings["CrmConnectionString"].ConnectionString}...");
            Dictionary<string, List<SubnominalAggregationCrmItem>> crmData = GetAllDataFromCrm();

            Console.WriteLine("Comparing SQL to CRM differences...");
            IEnumerable<SubnominalAggregationDifferenceItem> differences = new SubnominalAggregationIntegrityChecker(sqlData, crmData).CompareDataStores().ToList();

            Console.WriteLine($"{differences.Count()} differences found...");

            Console.WriteLine("Writing CSV...");
            new CsvWriter<SubnominalAggregationDifferenceItem>($"subnominal_differences_{DateTime.Now.ToString("yyyy-MM-dd HH-mm-ss")}.csv").SaveItems(differences);

            Console.WriteLine("Run Completed: {0}", DateTime.Now);
        }

        private static List<SubnominalAggregationSqlItem> GetAllDataFromSql()
        {
            using (var paymentGenerationDbContext = new PaymentGenerationDbContext())
            {
                return paymentGenerationDbContext.Database.SqlQuery<SubnominalAggregationSqlItem>(@"SELECT [AllocationNumber]
      ,[Period]
      ,[SubnominalCode]
      ,[PaymentType]
      ,ISNULL([AggregatedValue], 0) AS 'AggregatedValue'
FROM [PaymentGeneration].[SubnominalAggregation]").ToList();
            }
        }

        private static Dictionary<string, List<SubnominalAggregationCrmItem>> GetAllDataFromCrm()
        {
            Dictionary<string, List<SubnominalAggregationCrmItem>> dataDictionary = new Dictionary<string, List<SubnominalAggregationCrmItem>>();

            using (var xrmContext = new XrmServiceContext(new OrganizationService(CrmConnection.Parse(ConfigurationManager.ConnectionStrings["CrmConnectionString"].ConnectionString))))
            {
                OptionSetValue activeStatusOptionSetValue = new OptionSetValue(1);

                xrmContext.sfa_subnominalaggregationSet
                    .Where(sn => sn.statuscode.Equals(activeStatusOptionSetValue))
                    .Select(sn => new SubnominalAggregationCrmItem
                    {
                        sfa_SubnominalAggregateKey = sn.sfa_SubnominalAggregateKey,
                        sfa_Period = sn.sfa_Period,
                        sfa_SubnominalCode = sn.sfa_SubnominalCode,
                        sfa_PaymentType = sn.sfa_PaymentType,
                        sfa_AggregatedValue = sn.sfa_AggregatedValue
                    })
                    .ToList()
                    .ForEach(sn =>
                    {
                        if (!dataDictionary.ContainsKey(sn.sfa_SubnominalAggregateKey))
                        {
                            dataDictionary[sn.sfa_SubnominalAggregateKey] = new List<SubnominalAggregationCrmItem>();
                        }

                        dataDictionary[sn.sfa_SubnominalAggregateKey].Add(sn);
                    });
            }

            return dataDictionary;
        }
    }
}
