namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Services
{
    using NServiceBus;
    using NServiceBus.Logging;
    using System;
    using System.Configuration;
    using System.IO;
    using System.Linq;

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

        public static IEndpointInstance CreateEndpointOld<TCommand>(
            string endpointName = "TestSendingEndpoint")
        {
            EndpointConfiguration endpointConfiguration = new EndpointConfiguration(endpointName);
            endpointConfiguration.UseTransport<AzureServiceBusTransport>();
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

            AzureServiceBusEndpointOrientedTopologySettings transport = endpointConfiguration.UseTransport<AzureServiceBusTransport>().UseEndpointOrientedTopology();
            transport.Transactions(TransportTransactionMode.ReceiveOnly);

            endpointConfiguration.UseSerialization<NewtonsoftSerializer>();

            return Endpoint.Start(endpointConfiguration).GetAwaiter().GetResult();
        }
        public static IEndpointInstance CreateEndpoint<TCommand>(
    string endpointName = "TestSendingEndpoint")
        {
            EndpointConfiguration endpointConfiguration = new EndpointConfiguration(endpointName);

            var transport = endpointConfiguration
                .UseTransport<AzureServiceBusTransport>()
                .UseEndpointOrientedTopology();

            // ✅ ADD THIS BLOCK
            var connectionString =
                ConfigurationManager.AppSettings["NServiceBus/Transport"]
                ?? ConfigurationManager.ConnectionStrings["NServiceBus/Transport"]?.ConnectionString;


            if (string.IsNullOrWhiteSpace(connectionString))
                throw new InvalidOperationException("Azure Service Bus connection string is missing.");

            transport.ConnectionString(connectionString);

            transport.Transactions(TransportTransactionMode.ReceiveOnly);

            endpointConfiguration.Conventions()
                .DefiningCommandsAs(t => t == typeof(TCommand));

            endpointConfiguration.SendOnly();

            // exclude all
            string[] assembliesToExclude = Directory
                .EnumerateFiles(AppDomain.CurrentDomain.BaseDirectory, "*.dll")
                .Select(Path.GetFileName)
                .ToArray();

            AssemblyScannerConfiguration scanner = endpointConfiguration.AssemblyScanner();
            scanner.ExcludeAssemblies(assembliesToExclude);
            scanner.ThrowExceptions = false;

            endpointConfiguration.UseSerialization<NewtonsoftSerializer>();

            return Endpoint.Start(endpointConfiguration).GetAwaiter().GetResult();
        }


        public static IEndpointInstance CreatePublishingEndpoint<TEvent>(
            string endpointName = "TestSendingEndpoint")
        {
            EndpointConfiguration endpointConfiguration = new EndpointConfiguration(endpointName);
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


