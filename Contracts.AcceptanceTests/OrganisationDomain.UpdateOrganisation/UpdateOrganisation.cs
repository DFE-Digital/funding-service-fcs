//namespace OrganisationDomain.UpdateOrganisation
//{
//    using NServiceBus;

//    public static class UpdateOrganisation
//    {
//        private const string ProcessId = "UpdateOrg1";

//        public static void TriggerUpdate()
//        {
//            var config = new BusConfiguration();


//            config.AssembliesToScan(AllAssemblies.Matching("OrganisationDomain.Integration.Messages.dll")
//                .And("Microsoft.WindowsAzure.Configuration.dll")
//                .And("NServiceBus.Azure.Transports.WindowsAzureServiceBus.dll"));
//            config.UseTransport<AzureServiceBusTransport>();
//            config.UseSerialization<JsonSerializer>();
//            config.UsePersistence<InMemoryPersistence>();
//            config.DiscardFailedMessagesInsteadOfSendingToErrorQueue();

//            config.Conventions()
//                .DefiningMessagesAs(t => null != t.Namespace && t.Namespace == "OrganisationDomain.Integration.Messages.Commands");

//            var bus = Bus.CreateSendOnly(config);

//            bus.Send(new Integration.Messages.Commands.InitOrganisationUpdate
//            {
//                ProcessId = ProcessId
//            });
//        }
//    }
//}


using System.Threading.Tasks;
using NServiceBus;

namespace OrganisationDomain.UpdateOrganisation
{
    public static class UpdateOrganisation
    {
        private const string ProcessId = "UpdateOrg1";

        public static void TriggerUpdate()
        {
            TriggerUpdateAsync().GetAwaiter().GetResult();
        }

        private static async Task TriggerUpdateAsync()
        {
            var endpointConfiguration =
                new EndpointConfiguration("UpdateOrganisation");

            endpointConfiguration.SendOnly();

            var endpoint =
                await Endpoint.Start(endpointConfiguration);

            try
            {
                await endpoint.Send(
                    new Integration.Messages.Commands.InitOrganisationUpdate
                    {
                        ProcessId = ProcessId
                    });
            }
            finally
            {
                await endpoint.Stop();
            }
        }
    }
}
