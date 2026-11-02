namespace SFA.FCT.Contracts.AcceptanceTests.Utilities
{
    using System.Collections.Generic;
    using System.Linq;
    using UnitTests.Common;
    using Newtonsoft.Json.Linq;
    using System.IO;
    using Infrastructure.Repositories.FundingAllocationConfig;
    using DTO;

    public class CfsConfig
    {
        public static void ResetCfsConfigTables()
        {
            var configJson = GetConfigJson();

            // Note:- StatusSubStatusConfig table cannot be reset

            ResetAllocationFundingStreamConfig(configJson);
            ResetProviderCategoryExceptionConfig(configJson);
            ResetProviderTypeConfig(configJson);
            ResetCfsCodesToContractTypeConfig(configJson);
            ResetAllocationLineConfig(configJson);
        }

        private static JObject GetConfigJson()
        {
            var resource = new TestResource(@"SFA.FCT.Contracts.AcceptanceTests", @"Resources.Config.json");
            var streamReader = new StreamReader(resource.Stream);
            return JObject.Parse(streamReader.ReadToEnd());
        }

        private static void ResetAllocationFundingStreamConfig(JObject configJson)
        {
            var arrayRows = configJson["Allocation Funding Streams"] as JArray;
            var dtoRows = arrayRows.ToObject<List<AllocationFundingStreamConfig>>();
            var rowsToAdd = dtoRows.Where(r => r.PolicyStatus == PolicyStatus.Approved).ToList();

            AllocationFundingStreamConfigRepository.ClearAll();

            rowsToAdd.ForEach(r =>
            {
                AllocationFundingStreamConfigRepository.Insert(r.AllocationFundingStreamCode, r.AllocationPeriodId, r.FundingTypeCode,
                    r.FundingPeriodCode, r.FspGroupCode);
            });
        }

        private static void ResetProviderCategoryExceptionConfig(JObject configJson)
        {
            var arrayRows = configJson["Provider Category Exceptions"] as JArray;
            var dtoRows = arrayRows.ToObject<List<ProviderCategoryExceptionConfig>>();
            var rowsToAdd = dtoRows.Where(r => r.PolicyStatus == PolicyStatus.Approved).ToList();

            ProviderCategoryExceptionRepository.ClearAll();

            rowsToAdd.ForEach(r =>
            {
                ProviderCategoryExceptionRepository.Insert(r.FundingTypeCode, r.FundingPeriodCode, r.UKPRN, r.Category);
            });
        }

        private static void ResetProviderTypeConfig(JObject configJson)
        {
            var arrayRows = configJson["Allocation Provider Types"] as JArray;
            var dtoRows = arrayRows.ToObject<List<ProviderTypeConfig>>();
            var rowsToAdd = dtoRows.Where(r => r.PolicyStatus == PolicyStatus.Approved).ToList();

            ProviderTypeConfigRepository.ClearAll();

            rowsToAdd.ForEach(r =>
            {
                ProviderTypeConfigRepository.Insert(r.ProviderType, r.ProviderSubType, r.ProviderCategory);
            });
        }

        private static void ResetCfsCodesToContractTypeConfig(JObject configJson)
        {
            var arrayRows = configJson["PC-CT"] as JArray;
            var dtoRows = arrayRows.ToObject<List<CfsCodesToContractTypeConfig>>();
            var rowsToAdd = dtoRows.Where(r => r.PolicyStatus == PolicyStatus.Approved).ToList();

            CfsCodesToContractTypeConfigRepository.ClearAll();

            rowsToAdd.ForEach(r =>
            {
                CfsCodesToContractTypeConfigRepository.Insert(r.FundingTypeCode, r.FundingPeriodCode, r.ProviderCategory, r.ContractType);
            });
        }

        private static void ResetAllocationLineConfig(JObject configJson)
        {
            var arrayRows = configJson["Allocation Lines"] as JArray;
            var dtoRows = arrayRows.ToObject<List<AllocationLineConfig>>();
            var rowsToAdd = dtoRows.Where(r => r.PolicyStatus == PolicyStatus.Approved).ToList();

            AllocationLineConfigRepository.ClearAll();

            rowsToAdd.ForEach(r =>
            {
                AllocationLineConfigRepository.Insert(r.AllocationFundingStreamCode, r.AllocationPeriodId, r.AllocationFundingLineCode,
                    r.ProviderCategory, r.FspCode, r.DeliverableCode);
            });
        }
    }
}