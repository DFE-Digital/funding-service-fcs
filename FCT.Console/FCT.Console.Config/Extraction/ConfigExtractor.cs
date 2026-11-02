namespace FCT.Console.Config.Extraction
{
    using System;
    using System.IO;
    using System.Reflection;
    using System.Text;
    using Crm;
    using MoreLinq;
    using PaaS;

    public static class ConfigExtractor
    {
        private static readonly string[] CrmEntityNames =
        {
            "sfa_agency",
            "sfa_cappinggroups",
            "sfa_claimreconallocgroup",
            "sfa_claimreconciliationbehaviour",
            "sfa_claimreconciliationpublicationexception",
            "sfa_claimtype",
            "sfa_contracttype",
            "sfa_deliverable",
            "sfa_fundingstream",
            "sfa_fundingstreamperiod",
            "sfa_fundingstreamperioddeliverable",
            "sfa_fundingtype",
            "sfa_fundingtypefundingperiod",
            "sfa_fundingtype_fundingstream",
            "sfa_paymenttimetable",
            "sfa_period",
            "sfa_unitofprocurement",
            "sfa_fspgroup"
        };

        private static readonly string[] PaasTableNames =
        {
            "ContractManagement.ContractType",
            "ContractManagement.CdaExtract",
            "ContractManagement.CdaReportFundingStreamPeriod",
            "ContractManagement.FundingStreamPeriod",
            "ContractManagement.FundingStreamPeriodLegalDeliverable",
            "ContractManagement.FundingTypeFundingPeriod",
            "ContractManagement.FundingTypeFundingPeriodContractType",
            "ContractManagement.FundingTypePeriodFundingStreamPeriod",
            "ContractManagement.RegionType",
            "ContractRequest.FundingTypeFundingPeriod",
            "DocumentsDomain.ContractDocumentTemplate",
            "DocumentsDomain.FSPDeliverable",
            "DocumentsDomain.FSPGroup",
            "DocumentsDomain.FspGroupDocumentTemplate",
            "DocumentsDomain.ContractReferenceConfig",
            "DocumentsDomain.FundingStreamPeriod",
            "DocumentsDomain.FundingTypeFundingPeriod",
            "DocumentsDomain.NlapFundingConfig",
            "MonitoringDeliverables.FundingStreamPeriod",
            "MonitoringDeliverables.FundingStreamPeriodDeliverable",
            "MonitoringDeliverables.HeldFspCollectionConfig",
            "PaymentGeneration.FundingStream",
            "PaymentGeneration.FundingStreamPeriod",
            "PaymentGeneration.PaymentTimetable",
            "PaymentGeneration.Subnominal",
            "PerformanceManagement.ClaimCollection",
            "PerformanceManagement.ClaimReconciliationAllocationGroup",
            "PerformanceManagement.ClaimReconciliationAllocationGroupFsp",
            "PerformanceManagement.ClaimReconciliationBehaviour",
            "PerformanceManagement.ClaimReconciliationDeliverableGroup",
            "PerformanceManagement.ClaimReconciliationPublicationException",
            "PerformanceManagement.ClaimReconciliationReferenceDataProfile",
            "PerformanceManagement.ClaimType",
            "PerformanceManagement.FspDeliverableClaim",
            "PerformanceManagement.FundingStreamPeriod",
            "PolicyCache.CappingGroup",
            "PolicyCache.ESFRegionInvestmentPriority",
            "PolicyCache.FundingStreamPeriodPayCalcPolicy",
            "PolicyCache.PolicyDeliverable",
            "PolicyCache.PolicyDeliverableToSubnominals",
            "PolicyCache.PolicyFundingStreamCensusDate",
            "PolicyCache.PolicyFundingStreamPeriod",
            "PolicyCache.PolicySubnominal",
            "PolicyCache.FundingStreamPeriodCappingPeriodPayCalcPolicy",
            "FundingAllocation.AllocationLineConfig",
            "FundingAllocation.ProviderTypeConfig",
            "FundingAllocation.AllocationFundingStreamConfig",
            "FundingAllocation.CfsCodesToContractTypeConfig",
            "FundingAllocation.FundingStreamPeriodConfig",
            "FundingAllocation.FundingTypeConfig",
            "FundingAllocation.FspDeliverableConfig",
            "FundingAllocation.ProviderCategoryException",
            "FundingAllocation.FundingTypeFundingPeriodConfig",
            "PerformanceManagement.ClaimReconciliationReferenceDataReconProfiling",
            "Operations.FundingReportFSP",
            "Operations.FundingReportProvider",
             "Operations.LaFundingReportProvider"
        };

        public static void ExtractConfigToCsv()
        {
            string parentFolderName = $"Config {DateTime.Now:yyyy-MM-dd HH-mm-ss}";
            string crmFolderName = $@"{parentFolderName}\CRM";
            string paasFolderName = $@"{parentFolderName}\PaaS";

            CrmEntityNames.ForEach(entityName =>
            {
                Console.WriteLine($"{DateTime.Now}: Writing CRM extract for {entityName}");

                string csv = CrmEntityExtractor.ExtractDataAsCsv(entityName);
                WriteCsvToFile(entityName, crmFolderName, csv);
            });

            PaasTableNames.ForEach(tableName =>
            {
                Console.WriteLine($"{DateTime.Now}: Writing PaaS extract for {tableName}");

                string csv = SqlTableExtractor.ExtractDataAsCsv(tableName);
                WriteCsvToFile(tableName, paasFolderName, csv);
            });

            Console.WriteLine($"{DateTime.Now}: Finished writing extracts to destination folder {parentFolderName}");
        }

        private static void WriteCsvToFile(string fileName, string folderName, string csv)
        {
            string binPath = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location);
            string extractFolderPath = Path.Combine(binPath, folderName);

            Directory.CreateDirectory(extractFolderPath);

            string csvPath = Path.Combine(extractFolderPath, $"{fileName}.csv");

            File.WriteAllText(csvPath, csv, Encoding.UTF8);
        }
    }
}
