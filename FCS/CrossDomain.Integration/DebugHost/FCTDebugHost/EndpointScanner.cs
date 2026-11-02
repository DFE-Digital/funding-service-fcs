namespace SFA.FCT.FCTDebugHost
{
    using System;
    using System.Collections.Generic;
    using System.Diagnostics;
    using System.IO;
    using System.Linq;
    using System.Reflection;
    using CrossDomain.Integration.Common;

    internal static class EndpointScanner
    {
        internal static Type[] GetEndpointTypes()
        {
            var baseDirectory = AppDomain.CurrentDomain.BaseDirectory;
            Console.WriteLine("Scanning for AsA_FctEndpoint types in {0}", baseDirectory);

            var assemblyFilesToSkip = new string[] { "AutoMapper", "Castle.Core", "Castle.Windsor", "Iesi.Collections", "\\Microsoft", "\\NServiceBus", "\\NHibernate.dll", "\\System", "\\Newtonsoft.Json" };

            IEnumerable<string> assemblyPaths =
                Directory
                    .GetFiles(AppDomain.CurrentDomain.BaseDirectory, "*.dll")
                    .Where(p => !assemblyFilesToSkip.Any(s => p.Contains(s)));

            IEnumerable<Assembly> assemblies = assemblyPaths.Select(p => Assembly.LoadFrom(p));

            var types =
                assemblies
                    .Where(a => a != Assembly.GetExecutingAssembly())
                    .Where(a => a != typeof(AsA_FctEndpoint).Assembly)
                    .Act(a => Console.WriteLine("Scanning {0}", a.GetName()))
                    .SelectMany(a => a.GetTypes())
                    .Where(t => !t.IsInterface && t.GetInterfaces().Contains(typeof(AsA_FctEndpoint)))
                    .Act(t => Console.WriteLine("Found FctEndpoint {0}", t.Name))
                    .ToArray();

            if (types.Length == 0)
            {
                Console.ForegroundColor = ConsoleColor.Red;
                Debug.WriteLine("No AsA_FctEndpoint classes found in the working directory");
                Environment.Exit(1);
            }

            return types;
        }
    }
}
