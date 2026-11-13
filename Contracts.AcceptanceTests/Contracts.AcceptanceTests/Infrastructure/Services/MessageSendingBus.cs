namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Services
{
    using System;
    using System.IO;
    using System.Linq;
    using NServiceBus;
    using NServiceBus.Logging;

    public static class MessageSendingBus
    {
        static MessageSendingBus()
        {
            DefaultFactory defaultFactory = LogManager.Use<DefaultFactory>();
            defaultFactory.Level(LogLevel.Error);
        }

        public static void Publish<T>(string publisherEndpointName, T message)
        {
            var endpoint = CreatePublishingEndpoint<T>(publisherEndpointName);
            endpoint.Publish(message).Wait();
        }

        public static void Send<T>(string destinationEndpointName, T message)
        {
            var endpoint = CreateEndpoint<T>();
            endpoint.Send(destinationEndpointName, message).Wait();
        }

        public static void Send<T>(string destinationEndpointName, Action<T> messageConstructor)
        {
            var endpoint = CreateEndpoint<T>();
            endpoint.Send(destinationEndpointName, messageConstructor).Wait();
        }

        public static IEndpointInstance CreateEndpoint<TCommand>(
            string endpointName = "TestSendingEndpoint")
        {
            string connectionString = TestConfiguration.Configuration["Microsoft.ServiceBus.ConnectionString"];
            var topology = TopicTopology.Default;

            EndpointConfiguration endpointConfiguration = new EndpointConfiguration(endpointName);
            endpointConfiguration.UseTransport<AzureServiceBusTransport>(connectionString, topology);
            endpointConfiguration.Conventions()
                .DefiningCommandsAs(t => t == typeof(TCommand));
            endpointConfiguration.SendOnly();

            // exclude all
            string[] assembliesToExclude = Directory.EnumerateFiles(AppDomain.CurrentDomain.BaseDirectory, "*.dll")
                .Select(Path.GetFileName)
                .ToArray();

            AssemblyScannerConfiguration scanner = endpointConfiguration.AssemblyScanner();
            scanner.ExcludeAssemblies(assembliesToExclude);
            scanner.ThrowExceptions = false;

            //AzureServiceBusEndpointOrientedTopologySettings transport = endpointConfiguration.UseTransport<AzureServiceBusTransport>().UseEndpointOrientedTopology();
            //transport.Transactions(TransportTransactionMode.ReceiveOnly);

            // endpointConfiguration.UseSerialization<NewtonsoftSerializer>();
            endpointConfiguration.UseSerialization<NewtonsoftJsonSerializer>();

            return Endpoint.Start(endpointConfiguration).GetAwaiter().GetResult();
        }

        public static IEndpointInstance CreatePublishingEndpoint<TEvent>(
            string endpointName = "TestSendingEndpoint")
        {
            string connectionString = Environment.GetEnvironmentVariable("AzureServiceBusConnectionString");
            var topology = TopicTopology.Default;

            EndpointConfiguration endpointConfiguration = new EndpointConfiguration(endpointName);
            endpointConfiguration.UseTransport<AzureServiceBusTransport>(connectionString, topology);
            endpointConfiguration.Conventions()
                .DefiningEventsAs(t => t == typeof(TEvent));

            // exclude all
            string[] assembliesToExclude = Directory.EnumerateFiles(AppDomain.CurrentDomain.BaseDirectory, "*.dll")
                .Select(Path.GetFileName)
                .ToArray();

            AssemblyScannerConfiguration scanner = endpointConfiguration.AssemblyScanner();
            scanner.ExcludeAssemblies(assembliesToExclude);
            scanner.ThrowExceptions = false;

            // AzureServiceBusEndpointOrientedTopologySettings transport = endpointConfiguration.UseTransport<AzureServiceBusTransport>().UseEndpointOrientedTopology();
            // transport.Transactions(TransportTransactionMode.ReceiveOnly);

            //endpointConfiguration.UseSerialization<NewtonsoftSerializer>();
            endpointConfiguration.UseSerialization<NewtonsoftJsonSerializer>();

            return Endpoint.Start(endpointConfiguration).GetAwaiter().GetResult();
        }
    }
}