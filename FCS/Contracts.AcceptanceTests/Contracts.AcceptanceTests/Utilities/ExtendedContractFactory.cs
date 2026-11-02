namespace SFA.FCT.Contracts.AcceptanceTests.Utilities
{
    using System.IO;
    using System.Linq;
    using System.Reflection;
    using CrossDomain.Integration.Entities.CorporateContract;
    using Newtonsoft.Json;

    public static class ExtendedContractFactory
    {
        public static ExtendedContract GetLevyExtendedContract(
            string masterContractNumber,
            string contractNumber,
            string allocationNumber,
            int ukprn)
        {
            ExtendedContract masterContract = FromJson<ExtendedContract>("SFA.FCT.Contracts.AcceptanceTests",
                "Resources.LevyExtendedContract.json");
            var childContract = masterContract.contracts.First();
            masterContract.contractNumber = masterContractNumber;
            masterContract.contractor.ukprn = ukprn;
            childContract.contractNumber = contractNumber;
            childContract.contractor.ukprn = ukprn;
            childContract.contractAllocations.First().contractAllocationNumber = allocationNumber;

            return masterContract;
        }

        private static T FromJson<T>(string nameSpace, string resourceName)
        {
            using (Stream stream =
                Assembly.GetCallingAssembly().GetManifestResourceStream($"{nameSpace}.{resourceName}"))
            using (StreamReader streamReader = new StreamReader(stream))
            {
                return JsonConvert.DeserializeObject<T>(streamReader.ReadToEnd());
            }
        }
    }

}