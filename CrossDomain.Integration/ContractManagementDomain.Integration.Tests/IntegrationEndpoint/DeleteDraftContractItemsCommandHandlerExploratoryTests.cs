namespace SFA.FCT.ContractManagementDomain.Integration.Tests.IntegrationEndpoint
{
    using System;
    using System.IO;
    using System.Linq;
    using ContractManagementService.Common.Commands;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using NServiceBus;
    using System.Configuration;

    [TestClass]
    public class DeleteDraftContractItemsCommandHandlerExploratoryTests
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void DeleteDraftContractItemsCommandHandler_ShouldHitHandlerWhenCommandSentIn()
        {
            CreateSendOnlyEndpoint<DeleteDraftContractItemsCommand>().Send(new DeleteDraftContractItemsCommand
            {
                ContractNumber = "AEBP-1237",
                VersionNumber = 1
            }).Wait();
        }

        public static IEndpointInstance CreateSendOnlyEndpoint<TCommand>()
        {
            var endpointConfiguration = new EndpointConfiguration("WebJobs");
            endpointConfiguration.SendOnly();

            // 1) Instantiate the modern ASB transport with topology
            var transport = new AzureServiceBusTransport(
                ConfigurationManager.ConnectionStrings["NServiceBus/Transport"].ConnectionString,
                TopicTopology.Default
            );

            // 2) Register the transport
            endpointConfiguration.UseTransport(transport);
            endpointConfiguration.Conventions()
                .DefiningCommandsAs(t => t == typeof(TCommand));

            // Your existing scanner settings
            var assembliesToExclude = Directory.EnumerateFiles(AppDomain.CurrentDomain.BaseDirectory, "*.dll")
                .Select(Path.GetFileName)
                .ToArray();

            var scanner = endpointConfiguration.AssemblyScanner();
            scanner.ExcludeAssemblies(assembliesToExclude);
            scanner.ThrowExceptions = false;

            endpointConfiguration.UseSerialization<NewtonsoftJsonSerializer>();

            return Endpoint.Start(endpointConfiguration).GetAwaiter().GetResult();
        }
    }
}
