using System;
using System.Collections.Generic;
using NServiceBus;

namespace SFA.FCT.CrossDomain.Integration.Common
{
    public static class EndpointConfigurator
    {
        public static EndpointConfiguration CreateEndpointConfiguration(
            string endpointName,
            IDictionary<Type, string> typeToEndpointNameMappings,
            int concurrentThreadCount = 1,
            bool suppressAuditMessages = false)
        {
            var endpointConfiguration = new EndpointConfiguration(endpointName);

            // Transport configuration (example: LearningTransport)
            var transport = new LearningTransport();
            var routing = endpointConfiguration.UseTransport(transport);

            // Message routing
            if (typeToEndpointNameMappings != null)
            {
                foreach (var mapping in typeToEndpointNameMappings)
                {
                    routing.RouteToEndpoint(mapping.Key, FctEndpoint.GenerateEndpointName(mapping.Value));
                }
            }

            // Concurrency
            endpointConfiguration.LimitMessageProcessingConcurrencyTo(concurrentThreadCount);

            // Audit suppression
            if (suppressAuditMessages)
            {
                endpointConfiguration.AuditProcessedMessagesTo(null);
            }

            // Persistence (example: LearningPersistence)
            endpointConfiguration.UsePersistence<LearningPersistence>();

            // Other optional configurations
            endpointConfiguration.SendFailedMessagesTo("error");
            endpointConfiguration.EnableInstallers();

            return endpointConfiguration;
        }
    }
}