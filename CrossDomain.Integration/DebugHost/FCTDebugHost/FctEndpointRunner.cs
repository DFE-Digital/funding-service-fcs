namespace SFA.FCT.FCTDebugHost
{
    using System;
    using System.Collections.Generic;
    using System.Diagnostics;
    using System.IO;
    using System.Linq;
    using System.Reflection;
    using System.Runtime.Remoting;
    using System.Threading;
    using System.Threading.Tasks;
    using CrossDomain.Integration.Common;
    using Framework.Logging;
    using Framework.Logging.Interfaces;
    using NServiceBus;

    internal class FctEndpointRunner
    {
        public Task[] Run(CancellationTokenSource cancellationTokenSource)
        {
            var loggerFactory = new LoggerFactory();
            
            // find all of the endpoints that implement AsA_FctEndpoint and start a task for each in turn if the config file is found
            var busTasks =
                EndpointScanner
                    .GetEndpointTypes()
                    .Select(t => t.Assembly)
                    .Distinct()
                    .Act(a => 
                        {
                            string configFile = a.GetName().Name + ".dll.config";
                            if (!File.Exists(configFile))
                            {
                                const string format = "Config file for {0} not found as {1}";
                                Debug.WriteLine(format, a.GetName(), configFile);
                                Console.WriteLine(format, a.GetName(), configFile);
                                Environment.Exit(1);
                            }
                        })
                    .Select(a => Task.Factory.StartNew(() => StartEndpoint(a, cancellationTokenSource.Token, loggerFactory)))
                    .ToArray();

            return busTasks;
        }

        private static void StartEndpoint(Assembly endpointAssembly, CancellationToken cancellationToken, ILoggerFactory loggerFactory)
        {
            Console.WriteLine("Starting up endpoints found in {0}", endpointAssembly.GetName());

            AppDomain appDomain = null;

            // create this endpoint an AppDomain so that it can have its .dll.config file as its application configuration file
            // and so they are isolated to ensure there isn't any dependency on being in the same instance.
            appDomain = AppDomain.CreateDomain(
                "EndpointDomain-" + endpointAssembly.GetName(),
                null,
                new AppDomainSetup
                {
                    ConfigurationFile = endpointAssembly.GetName().Name + ".dll.config"
                });

            var runner = (EndpointRunner)appDomain.CreateInstanceAndUnwrap(Assembly.GetExecutingAssembly().FullName, typeof(EndpointRunner).FullName);

            try
            {
                runner.Run(endpointAssembly, loggerFactory, cancellationToken.WaitHandle);
            }
            catch (RemotingException)
            {
                // if cancellation has been requested the remoting exception may occur due to timing issues so just ignore it
                if (!cancellationToken.IsCancellationRequested)
                {
                    throw;
                }
            }
            catch (AppDomainUnloadedException)
            {
                appDomain = null;
            }
            finally
            {
                if (appDomain != null)
                {
                    AppDomain.Unload(appDomain);
                }
            }
        }

        /// <summary>
        /// This class runs in the AppDomain created to host the endpoint and starts up the Bus to service it.
        /// That means each assembly gets its own AppDomain and so they are isolated as if they were running
        /// on independent machines.
        /// </summary>
        internal class EndpointRunner : MarshalByRefObject
        {
            public void Run(Assembly endpointAssembly, ILoggerFactory loggerFactory, WaitHandle programExitWaitHandle)
            {
                AutoResetEvent sequentialStart = new AutoResetEvent(true); 
                
                IEnumerable<Task> tasks = endpointAssembly
                    .GetTypes()
                    .Where(t => !t.IsInterface && t.GetInterfaces().Contains(typeof(AsA_FctEndpoint)))
                    .Select(t => Task.Factory.StartNew(() =>
                    {
                        var configuration = new BusConfiguration();
                        configuration.DiscoverFctAssemblies(t);

                        var endpoint = (AsA_FctEndpoint)Activator.CreateInstance(t);
                        endpoint.Customize(configuration, loggerFactory);

                        sequentialStart.WaitOne();
                        using (Bus.Create(configuration).Start())
                        {
                            sequentialStart.Set();
                            programExitWaitHandle.WaitOne();
                        }
                    }));

                Task.WaitAll(tasks.ToArray());
            }
        }
    }
}
