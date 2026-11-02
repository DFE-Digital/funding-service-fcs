namespace Datafix.Tests
{
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using System.Reflection;
    using ContractManagement.DataStore;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using MoreLinq;
    using Newtonsoft.Json;
    using NServiceBus;
    using Services;
    using SFA.FCT.CrossDomain.Integration.Events;

    [TestClass]
    public class PerformanceManagementContractApprovedEventReplayTests
    {
        [TestMethod, TestCategory("Datafix_R65c")]
        public void ShouldSendContractApprovedEventAsCommandIntoPerformanceManagementFor_1619F_3553_v2()
        {
            // pre-assert
            IReadOnlyCollection<ContractInfo> contracts = new List<ContractInfo>
            {
                new ContractInfo("1619F-3553", 2, "ContractApprovedEvent_1619F-3553_v2.json"),
                new ContractInfo("1619F-3628", 3, "ContractApprovedEvent_1619F-3628_v3.json"),
                new ContractInfo("1619F-3506", 3, "ContractApprovedEvent_1619F-3506_v3.json"),
                new ContractInfo("1619F-3330", 3, "ContractApprovedEvent_1619F-3330_v3.json")
            };
            
            contracts.ForEach(c =>
            {
                 int actualLastApprovedContractVersion = GetLastApprovedContractVersion(c.ContractNumber);
                 Assert.IsTrue(actualLastApprovedContractVersion <= c.Version, $"Last Approved Contract Version is not as expected:{c.ContractNumber}"); 

                // arrange
                IEndpointInstance endpoint = EndpointBuilder.CreateSendOnlyEndpoint<ContractApprovedEvent>();

                ContractApprovedEvent message = FromJson<ContractApprovedEvent>(
                    "Datafix.Tests.Resources.R65c", c.FileName);

                // act
                endpoint.Send("PerformanceManagementDomain.ReconciliationCalculation", message).Wait();
            });
        }

        private static T FromJson<T>(string nameSpace, string resourceName)
        {
            using (Stream stream = Assembly.GetCallingAssembly().GetManifestResourceStream($"{nameSpace}.{resourceName}"))
            using (StreamReader streamReader = new StreamReader(stream))
            {
                return JsonConvert.DeserializeObject<T>(streamReader.ReadToEnd());
            }
        }

        private static int GetLastApprovedContractVersion(string contractNumber)
        {
            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                return context.ApprovedContracts
                    .Single(c => c.ContractNumber == contractNumber)
                    .ContractVersionNumber;
            }
        }

        private class ContractInfo
        {
            public ContractInfo(string contractNumber, int version, string fileName)
            {
                ContractNumber = contractNumber;
                Version = version;
                FileName = fileName;
            }

            public string ContractNumber { get; }
            public int Version { get; }

            public string FileName { get; }
        }
    }
}
