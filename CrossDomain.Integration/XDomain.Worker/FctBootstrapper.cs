namespace SFA.FCT.CrossDomain.Integration.Azure.Worker
{
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using System.Reflection;
    using System.Threading;
    using System.Threading.Tasks;
    using Common;
//    using Common.MessageMutators;
    using Framework.Logging.Interfaces;
    using Microsoft.ApplicationInsights.Extensibility.PerfCounterCollector;
    using Microsoft.ApplicationInsights.TraceListener;
    using NServiceBus;
    using NServiceBus.Persistence;

    public class FctBootstrapper
    {
        private static IEnumerable<Type> _dynamicTypes;
        private readonly ILoggerFactory _loggerFactory;
        private readonly ILogger _logger;
        private readonly AutoResetEvent _sequentialStartEnforcer;
        private IEnumerable<string> _activeEndpoints;

        //public FctBootstrapper(ILoggerFactory loggerFactory, ILogger logger,IEnumerable<string> activeEndpoints=null)
        //{
        //    _loggerFactory = loggerFactory;
        //    _logger = logger;
        //    _activeEndpoints = activeEndpoints;
        //    _sequentialStartEnforcer = new AutoResetEvent(true);
        //}

        internal virtual IEnumerable<Type> DynamicTypes
        {
            get
            {
                string currentDirectory = AppDomain.CurrentDomain.BaseDirectory;

                _logger.LogInformation("Scanning folder - " + currentDirectory);
                
                return _dynamicTypes ??
                       (_dynamicTypes = Directory.GetFiles(currentDirectory, "*.dll")
                                                 .Where(y=>_activeEndpoints == null || !_activeEndpoints.Any() || _activeEndpoints.Contains(y.Substring(y.LastIndexOf('\\')+1)))
                                                 .SelectMany(p => Assembly.LoadFile(Path.Combine(Environment.CurrentDirectory, p)).GetTypes()));
            }
        }

        //internal IEnumerable<Task> BootstrapBusHost(CancellationTokenSource tokenSource)
        //{
        //    return GetFctEndpointTypes().Select(
        //        t => Task.Factory.StartNew(
        //            () => StartServiceBus(t, tokenSource.Token), tokenSource.Token).ContinueWith(
        //                e =>
        //                {
        //                    _logger.LogError(1, e.Exception, "Endpoint- " + t.Assembly.FullName + " faulted with exception {1}{0}", e.Exception, Environment.NewLine);
        //                },
        //                CancellationToken.None,
        //                TaskContinuationOptions.OnlyOnFaulted,
        //                TaskScheduler.Default));
        //}

        internal virtual IEnumerable<Type> GetFctEndpointTypes()
        {
            if (_activeEndpoints == null || !_activeEndpoints.Any())
            {
                _logger.LogInformation("Starting all endpoints");
            }
            else
            {
                _logger.LogInformation("Starting only endpoints in:" + string.Join<string>(",", _activeEndpoints));
            }
            return DynamicTypes.Where(t => !t.IsAbstract &&
                                           t.GetInterfaces().Contains(typeof(AsA_FctEndpoint)));
        }

        //internal virtual void StartServiceBus(Type endpointType, CancellationToken endRunToken)
        //{
        //    //// Azure Databus Settings - the values below can be overriden and are set to their defaults if commented, these can be uncommented and use in the configuration
        //    //// string dataBusContainer = "databus";
        //    //// string dataBusBasePath = String.Empty;
        //    //// int dataBusBlockSize = 4096; // Note there is no documentation of what the order of magnitude is for this parameter - assumed KB.
        //    //// long dataBusDefaultTTL = Int64.MaxValue;
        //    //// int dataBusMaxRetries = 5;
        //    //// int databusNumberOfIOThreads = 5;
        //    //// int dataBusBackOffInterval = 30;
        //    try
        //    {
        //        _logger.LogVerbose("Configuring {0} as an endpoint", endpointType.FullName);

        //        var busConfig = new BusConfiguration();

        //        busConfig.EnableInstallers();

        //        var ep = (AsA_FctEndpoint)Activator.CreateInstance(endpointType);
        //        ep.Customize(busConfig, _loggerFactory);
        //        busConfig.DiscoverFctAssemblies(endpointType);

        //        busConfig.UsePersistence<NHibernatePersistence, StorageType.Sagas>();
        //        busConfig.UsePersistence<NHibernatePersistence, StorageType.Subscriptions>();
        //        busConfig.UsePersistence<NHibernatePersistence, StorageType.Timeouts>();
        //        busConfig.UsePersistence<NHibernatePersistence, StorageType.Outbox>();
        //        busConfig.UsePersistence<NHibernatePersistence, StorageType.GatewayDeduplication>();

        //        busConfig.UseTransport<AzureServiceBusTransport>();

        //        busConfig.UseSerialization<JsonSerializer>();
        //        busConfig.UseDataBus<AzureDataBus>();

        //        busConfig.RegisterComponents(components =>
        //        {
        //            components.ConfigureComponent<TransportMessageCompressionMutator>(DependencyLifecycle.SingleInstance);
        //        });

        //        // this setting causes the multiple instances to be competing consumers on subscriptions
        //        busConfig.ScaleOut().UseSingleBrokerQueue();

        //        _sequentialStartEnforcer.WaitOne();
        //        using (Bus.Create(busConfig).Start())
        //        {
        //            _sequentialStartEnforcer.Set();

        //            _logger.LogInformation("Configured and started {0} as an endpoint", endpointType.FullName);
        //            endRunToken.WaitHandle.WaitOne();
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        _logger.LogError(0, "Exception occured during bus config of {0} as an endpoint: {1}", endpointType.FullName, ex.ToString());
        //    }
        //}
    }
}
