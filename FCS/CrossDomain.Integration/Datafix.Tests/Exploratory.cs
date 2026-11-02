namespace Datafix.Tests
{
    using System.Collections.Generic;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using NServiceBus;
    using OrganisationDomain.Integration.Messages.Commands;
    using SFA.FCT.CrossDomain.Integration.Common;
    using Microsoft.Xrm.Client;
    using Microsoft.Xrm.Client.Services;
    using System.Linq;
    using SFA.FCT.ContractCreateDomain.Implementation;
    using Microsoft.Xrm.Sdk;
    using SFA.FCT.ContractCreateDomain.Implementation.Entities;
    using System.Configuration;
    using SFA.FCT.AllocationDeliveryDomain.Common.Commands;
    using SFA.FCT.CrossDomain.Integration.Events;
    using UnitTests.Common;

    [TestClass]
    public class Exploratory
    {
        [TestMethod, TestCategory("DataDependentExploratoryDMO")]
        public void PopulateSupplementaryDataForUkprnBatchCommand_ShouldPopulateData()
        {
            BusConfiguration configuration = new BusConfiguration();
            configuration.Conventions().DefiningCommandsAs(t => t == typeof(PopulateSupplementaryDataForUkprnBatchCommand));
            configuration.UseSerialization<JsonSerializer>();
            configuration.UseTransport<AzureServiceBusTransport>();
            configuration.EnableInstallers();

            using (ISendOnlyBus bus = Bus.CreateSendOnly(configuration))
            {
                bus.Send(FctEndpoint.GenerateEndpointName("OrgService.Main"), new PopulateSupplementaryDataForUkprnBatchCommand {UkprnBatch = new List<int>{ 10000926, 10000927 }});
            }
        }

        [TestMethod, TestCategory("DataDependentExploratoryDMO")]
        public void PopulateSupplementaryDataForUkprnBatchCommand_ShouldPopulateData_IncludingCrm()
        {
            List<int> ukprnBatch = new List<int>
            {
                10000926,
                10000927
            };

            SetUpCrmOrganisations();

            BusConfiguration configuration = new BusConfiguration();
            configuration.Conventions().DefiningCommandsAs(t => t == typeof(PopulateSupplementaryDataForUkprnBatchCommand));
            configuration.UseSerialization<JsonSerializer>();
            configuration.UseTransport<AzureServiceBusTransport>();
            configuration.EnableInstallers();

            using (ISendOnlyBus bus = Bus.CreateSendOnly(configuration))
            {
                bus.Send(FctEndpoint.GenerateEndpointName("OrgService.Main"), new PopulateSupplementaryDataForUkprnBatchCommand { UkprnBatch = ukprnBatch });
            }
        }

        [TestMethod, TestCategory("DataDependentExploratoryDAT ")]
        public void CrmPaymentScheduleEvent_CompareNSB5AndNSB6Timings()
        {
            var message = GetEventFromFile("PaymentScheduleEvent_CompareNSB5AndNSB6Timings.json");
            Assert.IsNotNull(message);

            IEnumerable<int> numbers = Enumerable.Range(1, 20);
            foreach (int n in numbers)
            {
                CreateBusForPaymentScheduleEvent().Send("Xrm.ReceiveQueueForPaymentSchedule", message);
            }
        }

        [TestMethod, TestCategory("DataDependentExploratoryDAT")]
        public void SendMessageToReleaseHeldHandler()
        {
            CreateBus().Send("AllocationDeliveryDomain.ReleaseHeldReportedActuals", new ReleaseHeldReportedActualsCommand());
        }

        [TestMethod, TestCategory("Exploratory")]
        public void SendContractReadyToPublishEventToPublishContractToProviderHandlerEndpoint()
        {
            // arrange
            ContractReadyToPublishEvent message = TestResource.FromJson<ContractReadyToPublishEvent>(
                "Datafix.Tests.Resources",
                "ContractReadyToPublishEvent_ESFA-61919.json");

            // act
            using (ISendOnlyBus bus = CreateBus())
            {
                bus.Send("ContractManagementDomain.PublishContractToProvider", message);
            }

            ISendOnlyBus CreateBus()
            {
                BusConfiguration configuration = new BusConfiguration();

                configuration.AssembliesToScan(
                    AllAssemblies.Matching("CrossDomain.Integration.Events.dll")
                        .And("Microsoft.WindowsAzure.Configuration.dll")
                        .And("NServiceBus.Azure.Transports.WindowsAzureServiceBus.dll"));

                configuration.UseTransport<AzureServiceBusTransport>();
                configuration.ScaleOut().UseSingleBrokerQueue();
                configuration.UseSerialization<JsonSerializer>();
                configuration.UsePersistence<InMemoryPersistence>();
                configuration.Conventions().DefiningCommandsAs(t => t == typeof(ContractReadyToPublishEvent));

                return Bus.CreateSendOnly(configuration);
            }
        }

        private static ISendOnlyBus CreateBusForPaymentScheduleEvent()
        {
            var configuration = new BusConfiguration();
            configuration.UseTransport<AzureServiceBusTransport>();

            configuration.UseSerialization<NServiceBus.JsonSerializer>();
            configuration.UsePersistence<InMemoryPersistence>();
            configuration.Conventions()
                .DefiningCommandsAs(t => t == typeof(PaymentScheduleEvent));

            return Bus.CreateSendOnly(configuration);
        }

        private static PaymentScheduleEvent GetEventFromFile(string fileName)
        {
            return TestResource.FromJson<PaymentScheduleEvent>("Datafix.Tests", $"Resources.{fileName}");
        }

        private void SetUpCrmOrganisations()
        {
            var crmConnection = CrmConnection.Parse(ConfigurationManager.ConnectionStrings["CrmConnectionString"].ConnectionString);
            IOrganizationService organizationSvc = new OrganizationService(crmConnection);

            XrmOrganisationManager organisationManager = new XrmOrganisationManager()
            {
                OrgService = organizationSvc
            };

            List<ContractOrganisation> organisations = new List<ContractOrganisation>
            {
                new ContractOrganisation
                {
                    Name = "BRITISH PARACHUTE SCHOOLS LIMITED",
                    UKPRN = "10000926",
                    OrganisationId = "ORG0000312",
                    Status = "Active",
                    Upin = "10000926"
                },
                new ContractOrganisation
                {
                    Name = "BRITISH PEST CONTROL ASSOCIATION",
                    UKPRN = "10000927",
                    OrganisationId = "ORG0000313",
                    Status = "Active",
                    Upin = "10000927"
                }
            };

            organisations.ForEach(o => organisationManager.CreateOrganisationIfNotExists(o));
        }

        private static IBus CreateBus()
        {
            var configuration = new BusConfiguration();
            configuration.AssembliesToScan(
                AllAssemblies.Matching("AllocationDeliveryDomain.Common.dll")
                    .And("Microsoft.WindowsAzure.Configuration.dll")
                    .And("NServiceBus.Azure.Transports.WindowsAzureServiceBus.dll")
                    .And("CrossDomain.Integration.Messages.dll"));

            configuration.UseSerialization<JsonSerializer>();
            configuration.UseTransport<AzureServiceBusTransport>();
            configuration.UsePersistence<InMemoryPersistence>();
            configuration.EndpointName("AllocationDeliveryDomain.MonthEndCheck");
            configuration.Conventions()
                .DefiningCommandsAs(
                    t => t.Namespace != null && t.Namespace.Equals("SFA.FCT.AllocationDeliveryDomain.Common.Commands"))
                .DefiningMessagesAs(t => null != t.Namespace && t.Namespace.EndsWith("Messages"));

            configuration.ScaleOut().UseSingleBrokerQueue();

            return Bus.Create(configuration);
        }
    }
}