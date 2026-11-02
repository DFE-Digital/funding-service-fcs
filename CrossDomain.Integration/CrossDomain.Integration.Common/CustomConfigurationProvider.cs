namespace SFA.FCT.CrossDomain.Integration.Common
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;

    using NServiceBus.Config;
    using NServiceBus.Config.ConfigurationSource;

    public class CustomConfigurationProvider : IConfigurationSource
    {
        private readonly IDictionary<Type, string> _typeToEndpointNameMappings;
        private readonly int _concurrentThreadCount;
        private readonly bool _shouldSuppressAuditMessages;

        public CustomConfigurationProvider(IDictionary<Type, string> typeToEndpointNameMappings, int concurrentThreadCount = 1, bool shouldSuppressAuditMessages = false)
        {
            _typeToEndpointNameMappings = typeToEndpointNameMappings;
            _concurrentThreadCount = concurrentThreadCount;
            _shouldSuppressAuditMessages = shouldSuppressAuditMessages;
        }

        public T GetConfiguration<T>() where T : class, new()
        {
            if (typeof(T) == typeof(UnicastBusConfig) && _typeToEndpointNameMappings != null)
            {
                return GetUnicastBusConfig() as T;
            }

            if (typeof(T)  == typeof(TransportConfig))
            {
                return GetTransportConfig() as T;
            }

            if (typeof(T) == typeof(AuditConfig) && _shouldSuppressAuditMessages)
            {
                return new AuditConfig() as T;
            }

            // leaving the rest of the configuration as is:
            return ConfigurationManager.GetSection(typeof(T).Name) as T;
        }

        private UnicastBusConfig GetUnicastBusConfig()
        {
            var result = new MessageEndpointMappingCollection();

            foreach (var mapping in _typeToEndpointNameMappings)
            {
                result.Add(
                    new MessageEndpointMapping
                    {
                        AssemblyName = mapping.Key.Assembly.GetName().Name,
                        TypeFullName = mapping.Key.FullName,
                        Endpoint = FctEndpoint.GenerateEndpointName(mapping.Value),
                    });
            }

            return new UnicastBusConfig { MessageEndpointMappings = result };
        }

        private TransportConfig GetTransportConfig()
        {
            // these are the default settings plus the threading value which is defaulted in the CTOR above to its default value of 1
            return new TransportConfig
            {
                MaxRetries = 5,
                MaximumMessageThroughputPerSecond = 0,
                MaximumConcurrencyLevel = _concurrentThreadCount
            };
        }
    }
}
