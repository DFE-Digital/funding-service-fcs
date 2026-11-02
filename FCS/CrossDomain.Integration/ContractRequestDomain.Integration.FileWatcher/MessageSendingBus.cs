namespace SFA.FCT.ContractRequestDomain.Integration.FileWatcher
{
    using System;
    using System.IO;
    using System.Linq;
    using System.Threading.Tasks;
    using CrossDomain.Integration.Events;
    using NServiceBus;

    public class MessageSendingBus : IFcsBus
    {
        private IEndpointInstance _endpoint;
        
        public async Task Publish<T>(Action<T> messageConstructor)
        {
            await CreateEndpoint().Publish(messageConstructor);
        }

        private IEndpointInstance CreateEndpoint()
        {
            if (_endpoint == null)
            {
                _endpoint = CreateSendOnlyEndpoint<INewExcelUploadFileEvent>();
            }

            return _endpoint;
        }

        private static IEndpointInstance CreateSendOnlyEndpoint<TEvent>()
        {
            EndpointConfiguration endpointConfiguration = new EndpointConfiguration("ContractRequestDomain.FileWatcher");
            endpointConfiguration.UseTransport<AzureServiceBusTransport>();
            endpointConfiguration.Conventions()
                .DefiningEventsAs(t => t == typeof(TEvent));

            // exclude all
            string[] assembliesToExclude = Directory.EnumerateFiles(AppDomain.CurrentDomain.BaseDirectory, "*.dll")
                .Select(Path.GetFileName)
                .ToArray();

            AssemblyScannerConfiguration scanner = endpointConfiguration.AssemblyScanner();
            scanner.ExcludeAssemblies(assembliesToExclude);
            scanner.ThrowExceptions = false;

            AzureServiceBusEndpointOrientedTopologySettings transport = endpointConfiguration.UseTransport<AzureServiceBusTransport>().UseEndpointOrientedTopology();
            transport.Transactions(TransportTransactionMode.ReceiveOnly);

            endpointConfiguration.UseSerialization<NewtonsoftSerializer>();

            return Endpoint.Start(endpointConfiguration).GetAwaiter().GetResult();
        }
    }
}
