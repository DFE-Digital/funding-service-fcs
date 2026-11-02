namespace ConsoleApplication1
{
    using NServiceBus;
    using SFA.FCT.ContractManagementService.Common.Commands;
    using SFA.FCT.CrossDomain.Integration.Common;

    class Program
    {
        static void Main(string[] args)
        {
            BusConfiguration busConfig = new BusConfiguration();
            busConfig.UseSerialization<JsonSerializer>();
            busConfig.UsePersistence<InMemoryPersistence>();
            busConfig.UseTransport<AzureServiceBusTransport>();

                ISendOnlyBus bus = Bus.CreateSendOnly(busConfig);

            bus.Send<PublishApprovedContractCommand>(
                FctEndpoint.GenerateEndpointName("ContractManagementDomain.ContractApproved"),
                m =>
                {
                    m.ContractNumber = "UDC-2084";
                    m.MasterContractNumber = "MAC-2084";
                });
        }
    }
}
