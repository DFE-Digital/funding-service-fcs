namespace Datafix.Tests
{
    using System.Configuration;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Client;
    using Microsoft.Xrm.Client.Services;
    using Microsoft.Xrm.Sdk;
    using NServiceBus;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Events;

    [TestClass]
    public class PublishContractApprovedEventDataFixes
    {
        [TestMethod, TestCategory("DataFix_R37a")]
        public void DataFix_21666_PublishContractApprovedEvent()
        {
            const string masterContractNumber = "SFA-6389";
            const string contractNumber = "24Loans-4133";
            const int expectedContractVersion = 3;

            IContractsManager contractManager = GetContractManager();
            contract lastApprovedContract = contractManager.GetCorporateContract(contractNumber, masterContractNumber);
            Assert.IsNotNull(expectedContractVersion, "Contract not present in CRM");
            int lastApprovedContractVersion = lastApprovedContract.contracts.Single().contractVersionNumber;
            Assert.AreEqual(expectedContractVersion, lastApprovedContractVersion, "Last approved contract version has changed");
            
            using (ISendOnlyBus bus = CreateBus())
            {
                bus.Publish(new ContractApprovedEvent
                {
                    CorporateContract = lastApprovedContract
                });
            }
        }

        [TestMethod, TestCategory("DataFix_R37b")]
        public void PublishContractApprovedEventDataFixes_PublishContractApprovedEvent_Main4103()
        {
            const string masterContractNumber = "SFA-3035";
            const string contractNumber = "Main-4103";
            const int expectedContractVersion = 8;

            IContractsManager contractManager = GetContractManager();
            contract lastApprovedContract = contractManager.GetCorporateContract(contractNumber, masterContractNumber);
            Assert.IsNotNull(expectedContractVersion, "Contract not present in CRM");
            int lastApprovedContractVersion = lastApprovedContract.contracts.Single().contractVersionNumber;
            Assert.AreEqual(expectedContractVersion, lastApprovedContractVersion, "Last approved contract version has changed");

            using (ISendOnlyBus bus = CreateBus())
            {
                bus.Publish(new ContractApprovedEvent
                {
                    CorporateContract = lastApprovedContract
                });
            }
        }

        private static ISendOnlyBus CreateBus()
        {
            BusConfiguration configuration = new BusConfiguration();
            configuration.Conventions().DefiningEventsAs(t => t == typeof(ContractApprovedEvent));
            configuration.UseSerialization<JsonSerializer>();
            configuration.UseTransport<AzureServiceBusTransport>();
            configuration.EnableInstallers();
            configuration.EndpointName(FctEndpoint.GenerateEndpointName("ContractManagementDomain.ContractApproved"));

            return Bus.CreateSendOnly(configuration);
        }

        private static IContractsManager GetContractManager()
        {
            CrmConnection crmConnection = CrmConnection.Parse(ConfigurationManager.ConnectionStrings["CrmConnectionString"].ConnectionString);
            IOrganizationService organizationSvc = new OrganizationService(crmConnection);

            return new ContractsManager
            {
                OrganizationService = organizationSvc
            };
        }
    }
}
