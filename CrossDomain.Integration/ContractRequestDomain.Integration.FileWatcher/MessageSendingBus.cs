
namespace SFA.FCT.ContractRequestDomain.Integration.FileWatcher
{
    using System;
    using System.IO;
    using System.Linq;
    using System.Threading.Tasks;
    using CrossDomain.Integration.Events;
    using NServiceBus;
    using NServiceBus.Newtonsoft.Json;
    using NServiceBus.Transport.AzureServiceBus;   // IMPORTANT: new transport namespace

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
            var endpointConfiguration =
                new EndpointConfiguration("ContractRequestDomain.FileWatcher");

            endpointConfiguration.SendOnly();

            // -------------------- NEW AZURE SERVICE BUS TRANSPORT --------------------
            string connectionString =
                Environment.GetEnvironmentVariable("AzureServiceBusConnectionString");

            // Required topology for the new transport
            var topology = TopicTopology.Default;

            // Construct the transport with connection string + topology
            var transportDefinition =
                new AzureServiceBusTransport(connectionString, topology)
                {
                    TransportTransactionMode = TransportTransactionMode.ReceiveOnly
                };

            // Register the transport (no <T> generic overloads anymore)
            endpointConfiguration.UseTransport(transportDefinition);

            // -------------------- CONVENTIONS --------------------
            endpointConfiguration.Conventions()
                .DefiningEventsAs(t => t == typeof(TEvent));

            // -------------------- ASSEMBLY SCANNER --------------------
            var assembliesToExclude = Directory
                .EnumerateFiles(AppDomain.CurrentDomain.BaseDirectory, "*.dll")
                .Select(Path.GetFileName)
                .ToArray();

            var scanner = endpointConfiguration.AssemblyScanner();
            scanner.ExcludeAssemblies(assembliesToExclude);
            scanner.ThrowExceptions = false;

            // -------------------- SERIALIZER (JSON.NET) --------------------
            endpointConfiguration.UseSerialization<NewtonsoftJsonSerializer>();

            // -------------------- START SEND-ONLY ENDPOINT --------------------
            return Endpoint.Start(endpointConfiguration).GetAwaiter().GetResult();
        }
    }
}
