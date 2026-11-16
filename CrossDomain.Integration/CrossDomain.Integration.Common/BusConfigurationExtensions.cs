namespace SFA.FCT.CrossDomain.Integration.Common
{

    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using System.Reflection;
    using NServiceBus;


    public static class BusConfigurationExtensions
    {
        public static void DiscoverFctAssemblies(this EndpointConfiguration endpointConfiguration, Type endpointType)
        {
            var scanner = endpointConfiguration.AssemblyScanner();

            // Optional: disable scanning of AppDomain assemblies if needed
            // scanner.ScanAppDomainAssemblies = false;

            // Load additional assemblies manually
            var additionalAssemblies = new List<Assembly>
            {
                endpointType.Assembly
            };

            foreach (string assemblyName in new[]
            {
                "NServiceBus.Azure",
                "NServiceBus.Azure.Transports.WindowsAzureServiceBus",
                "NServiceBus.NHibernate"
            })
            {
                try
                {
                    additionalAssemblies.Add(Assembly.Load(assemblyName));
                }
                catch (FileNotFoundException)
                {
                    // Silently ignore missing optional assemblies
                }
            }

            additionalAssemblies.AddRange(endpointType.Assembly
                .GetReferencedAssemblies()
                .Where(a => !a.Name.StartsWith("System", StringComparison.OrdinalIgnoreCase))
                .Where(a => !a.Name.StartsWith("mscorlib", StringComparison.OrdinalIgnoreCase))
                .Select(Assembly.Load));

            // Add manually loaded assemblies to scanner
            foreach (var assembly in additionalAssemblies)
            {
                //scanner.ScanAssemblies.Add(assembly);
            }

        }

    }
}
