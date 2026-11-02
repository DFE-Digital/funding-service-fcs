namespace OrganisationDomain.Web
{
    using System.Configuration;
    using NServiceBus.Config;
    using NServiceBus.Config.ConfigurationSource;
    using SFA.FCT.CrossDomain.Integration.Common;

    public class CustomConfigurationSource : IConfigurationSource
    {
        public T GetConfiguration<T>() where T : class, new()
        {
            if (typeof(T) == typeof(UnicastBusConfig))
            {
                MessageEndpointMappingCollection mapping = new MessageEndpointMappingCollection();
                mapping.Add(new MessageEndpointMapping
                {
                    AssemblyName = "OrganisationDomain.Integration.Messages",
                    Endpoint = FctEndpoint.GenerateEndpointName("OrgService.Main"),
                });

                return new UnicastBusConfig
                {
                    MessageEndpointMappings = mapping
                } 

                as T;
            }

            //// leaving the rest of the configuration as is:
            return ConfigurationManager.GetSection(typeof(T).Name) as T;
        }
    }
}