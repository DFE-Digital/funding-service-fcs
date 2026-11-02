namespace ContractRequestDomain.Tests.Services
{
    using System.IO;
    using System.Linq;
    using System.Reflection;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Newtonsoft.Json;
    using SFA.FCT.ContractRequestDomain.Integration.BulkUpload.Das.Services;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;

    [TestClass]
    public class ContractRequestMutatorTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ContractRequestMutator_ShouldAddNonLevy()
        {
            // arrange
            contractRequestType contractRequest = FromJson<contractRequestType>("ContractRequestDomain.Tests",
                @"Resources.contract_request_das.json");

            int GetCountNonLevyAllocations(contractRequestType cr)
            {
                return cr.contract.contracts.SelectMany(c => c.contractAllocations)
                    .Count(a => a.fundingStreamPeriodCode == "NONLEVY2019");
            }

            Assert.AreEqual(0, GetCountNonLevyAllocations(contractRequest), "Before the handler is called we should not have a non levy alloc");
            
            // act
            new ContractRequestMutator().AddNonLevyAllocationToContractRequest(contractRequest);

            // assert
            Assert.AreEqual(1, GetCountNonLevyAllocations(contractRequest), "After the handler is called we should have a non levy allocation");
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
