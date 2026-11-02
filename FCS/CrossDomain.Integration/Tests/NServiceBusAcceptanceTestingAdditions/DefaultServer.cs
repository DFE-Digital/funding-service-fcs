namespace NServiceBusAcceptanceTestingAdditions
{
    using System;
    using System.Collections.Generic;
    using System.Diagnostics.CodeAnalysis;
    using System.Linq;
    using System.Reflection;
    using NServiceBus;
    using NServiceBus.AcceptanceTesting;
    using NServiceBus.AcceptanceTesting.Support;
    using NServiceBus.Config.ConfigurationSource;
    using SFA.FCT.CrossDomain.Integration.Common.MessageMutators;

    [ExcludeFromCodeCoverage]
    public class DefaultServer : IEndpointSetupTemplate
    {
        public BusConfiguration GetConfiguration(RunDescriptor runDescriptor, EndpointConfiguration endpointConfiguration, IConfigurationSource configSource, Action<BusConfiguration> configurationBuilderCustomization)
        {
            var types = GetTypesToUse(endpointConfiguration);

            var config = new BusConfiguration();
            config.EndpointName(endpointConfiguration.EndpointName);
            config.TypesToScan(types);

            config.CustomConfigurationSource(configSource);
            config.UsePersistence<InMemoryPersistence>();
            config.PurgeOnStartup(true);

            // Plugin a behavior that listens for subscription messages
            config.Pipeline.Register<SubscriptionBehavior.Registration>();
            config.RegisterComponents(c =>
            {
                c.ConfigureComponent<SubscriptionBehavior>(DependencyLifecycle.InstancePerCall);
                c.ConfigureComponent<TransportMessageCompressionMutator>(DependencyLifecycle.InstancePerCall);
            });

            config.RegisterComponents(r =>
            {
                r.RegisterSingleton(runDescriptor.ScenarioContext.GetType(), runDescriptor.ScenarioContext);
                r.RegisterSingleton(typeof(ScenarioContext), runDescriptor.ScenarioContext);
            });

            config.UseTransport<InMemoryTransport.InMemoryTransport>();

            // needed to ensure that the queues are created when not debugging
            config.EnableInstallers();

            if (configurationBuilderCustomization != null)
            {
                configurationBuilderCustomization(config);
            }

            return config;
        }

        public static IEnumerable<Type> GetTypesToUse(EndpointConfiguration endpointConfiguration)
        {
            // start with only the NServiceBus.Core assembly
            var types = typeof(IBus).Assembly.GetTypes().AsEnumerable();

            // add in the InMemoryTransport stuff from this assembly
            types = types.Union(Assembly.GetExecutingAssembly().GetTypes().Where(t => t.Namespace != null && t.Namespace == typeof(InMemoryTransport.InMemoryTransport).Namespace));

            // add in any types specifically included by the Endpoint
            types = types.Union(endpointConfiguration.TypesToInclude);

            // remove any types specifically excluded by the Endpoint
            types = types.Where(t => !endpointConfiguration.TypesToExclude.Contains(t)).ToList();

            // and we are done
            return types;
        }
    }
}