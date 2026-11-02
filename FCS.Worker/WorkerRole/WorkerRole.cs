namespace WorkerRole
{
    using System.Diagnostics;
    using System.Net;
    using System.Threading;
    using System.Threading.Tasks;
    using Microsoft.WindowsAzure.ServiceRuntime;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Bespoke;
    using SFA.FCT.Framework.Logging.Interfaces;

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
            
            Trace.TraceInformation("WorkerRole has been started");

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
