// Requires Azure SDK to be installed from : http://azure.microsoft.com/en-us/downloads/
// Nuget package is not available

namespace SFA.FCT.CrossDomain.Integration.Azure.Worker
{
    using System;
    using System.Collections.Generic;
    using System.Diagnostics;
    using System.IO;
    using System.Linq;
    using System.Net;
    using System.Threading;
    using System.Threading.Tasks;
    using Framework.Logging;
    using Framework.Logging.Interfaces;
    using Framework.NSBLogging;
    using Microsoft.WindowsAzure.ServiceRuntime;
    using Newtonsoft.Json;
    using SFA.FCT.Framework.Logging.Bespoke;

    //public class WorkerRole : RoleEntryPoint
    //{
    //    private const int ErrorEventId = 2;
    //    private const string ACTIVE_ENDPOINTS_FILENAME = "ActiveEndpoints.json";
    //    private const string ROOT_DIRECTORYNAME = @"approot\";


    //    private readonly CancellationTokenSource _tokenSource = new CancellationTokenSource();
    //    private readonly ManualResetEvent _runCompleteEvent = new ManualResetEvent(false);

    //    private Task[] _busTasks;

    //    private ILoggerFactory _loggerFactory = null;
    //    private ILogger _logger;
    //    private IEnumerable<string> _activeEndpoints = null;

    //    public WorkerRole()
    //    {
    //    }

    //    public WorkerRole(ILoggerFactory loggerFactory)
    //    {
    //        _loggerFactory = loggerFactory;
    //    }

    //    public override void Run()
    //    {
    //        _logger.LogInformation("NServiceBus Worker Role is running");

    //        try
    //        {
    //            //var bootstrapper = new FctBootstrapper(_loggerFactory, _logger, _activeEndpoints);
    //            //_busTasks = bootstrapper.BootstrapBusHost(_tokenSource).ToArray();

    //            //// if any of the tasks end then cancel all of the tasks, wait for them to stop and then 
    //            //// exit which will cause the worker to recycle if the OnStop() wasn't called.
    //            //Task.WaitAny(_busTasks);
    //            //_tokenSource.Cancel();
    //            //Task.WaitAll(_busTasks);
    //        }
    //        catch (AggregateException ex)
    //        {               
    //            Trace.TraceError("NServiceBus Endpoint has finished in error: {0}", ex);
    //            if (_logger != null)
    //            {
    //                _logger.LogError(ErrorEventId, ex, "NServiceBus Endpoint has finished in error");
    //            }
    //        }
    //        catch (Exception ex)
    //        {
    //            Trace.TraceError("General error occured during worker role Run: {0}", ex);
    //            if (_logger != null)
    //            {
    //                _logger.LogError(ErrorEventId, ex, "General error occured during worker role Run");
    //            }
    //        }
    //        finally
    //        {
    //            _runCompleteEvent.Set();
    //        }
    //    }

    //    public override bool OnStart()
    //    {
    //        if (_loggerFactory == null)
    //        {
    //            _loggerFactory = new LoggerFactory();
    //        }

    //        _logger = _loggerFactory.CreateLogger("WorkerRole");

    //        #region Debugging selected endpoints
    //        if (Debugger.IsAttached)
    //        {
    //            var rootpath = Path.Combine(Environment.GetEnvironmentVariable("RoleRoot") + @"\", ROOT_DIRECTORYNAME);
    //            var filePath = rootpath + ACTIVE_ENDPOINTS_FILENAME;
    //            if (Directory.Exists(rootpath) && File.Exists(filePath))
    //            {
    //                using (var r = new StreamReader(filePath))
    //                {
    //                    var json = r.ReadToEnd();
    //                    try
    //                    {
    //                         _activeEndpoints = JsonConvert.DeserializeObject<List<string>>(json);
    //                    }
    //                    catch (Exception ex)
    //                    {
    //                        _logger.LogError(1, ex, "An error occured reading the active endpoints json file so starting ALL endpoints");
    //                    }
    //                }
    //            }
    //        }
    //        #endregion

    //        string disableNSBLogger = System.Configuration.ConfigurationManager.AppSettings["DisableNSBLogger"];
    //        if (disableNSBLogger == null || disableNSBLogger.ToLower() != "true")
    //        {
    //            NServiceBus.Logging.LogManager.UseFactory(new NSBLoggerFactory(_loggerFactory.CreateDefaultLogger(LogLevel.Error)));
    //        }

    //        var result = base.OnStart();
    //        _logger.LogInformation("NServiceBus Worker Role has been started");

    //        return result;
    //    }

    //    public override void OnStop()
    //    {
    //        _logger.LogInformation("NServiceBus Worker Role is stopping");

    //        _tokenSource.Cancel();
    //        _runCompleteEvent.WaitOne();

    //        base.OnStop();

    //        _logger.LogInformation("NServiceBus Worker Role has stopped");
    //    }
    // }
    public class WorkerRole
    {
        private readonly CancellationTokenSource cancellationTokenSource = new CancellationTokenSource();
        private readonly ManualResetEvent runCompleteEvent = new ManualResetEvent(false);

        private ILoggerFactory _loggerFactory;
        private ILogger _logger;

        public WorkerRole()
        {
        }

        public WorkerRole(ILoggerFactory loggerFactory)
        {
            _loggerFactory = loggerFactory;
        }

        public void Run()
        {
            GetLogger().LogInformation("NServiceBus 6 Worker Role has been started");

            try
            {
                this.RunAsync(this.cancellationTokenSource.Token).Wait();
            }
            finally
            {
                this.runCompleteEvent.Set();
            }
        }

        public bool OnStart()
        {
            // Set the maximum number of concurrent connections
            ServicePointManager.DefaultConnectionLimit = 12;

            // For information on handling configuration changes
            // see the MSDN topic at http://go.microsoft.com/fwlink/?LinkId=166357.

            NServiceBus.Logging.LogManager.UseFactory(new NsbLoggerFactory(GetErrorLogger()));
            Bootstrapper.Start(GetLoggerFactory(), GetLogger()).Wait();

            Trace.TraceInformation("WorkerRole has been started - NSB7 CDI");

            return true;
        }

        public void OnStop()
        {
            Trace.TraceInformation("WorkerRole is stopping");

            this.cancellationTokenSource.Cancel();
            this.runCompleteEvent.WaitOne();

            Bootstrapper.Stop().Wait();


            Trace.TraceInformation("WorkerRole has stopped");
        }

        private ILogger GetLogger()
        {
            return _logger ?? (_logger = _logger = GetLoggerFactory().CreateLogger("WorkerRole"));
        }

        private ILogger GetErrorLogger()
        {
            //// todo: remove this line
            //return new SimpleConsoleLogger();
            return GetLoggerFactory().CreateDefaultLogger(LogLevel.Error);
        }

        private ILoggerFactory GetLoggerFactory()
        {
            return _loggerFactory ?? (_loggerFactory = new LoggerFactory());
        }

        private async Task RunAsync(CancellationToken cancellationToken)
        {
            // TODO: Replace the following with your own logic.
            while (!cancellationToken.IsCancellationRequested)
            {
                Trace.TraceInformation("Working");
                await Task.Delay(1000);
            }
        }
    }
}