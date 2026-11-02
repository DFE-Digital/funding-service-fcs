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
        public static void DiscoverFctAssemblies(this BusConfiguration busConfig, Type endpointType)
        {
            var assembliesToScan =
                new List<Assembly>
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
                    assembliesToScan.Add(Assembly.Load(assemblyName));
                }
                catch (FileNotFoundException)
                {
                    // The above assemblies may not exist in the directory which this code is running within, so silently
                    // ignore the failure to find the assembly file.
                }
            }

            assembliesToScan.AddRange(endpointType.Assembly
                                                  .GetReferencedAssemblies()
                                                  .Where(a => !a.ToString().StartsWith("System"))
                                                  .Where(a => !a.ToString().StartsWith("mscorlib"))
                                                  .Select(Assembly.Load)
                                                  .ToList());

            busConfig.AssembliesToScan(assembliesToScan);
        }
    }
}
