namespace AllocationDeliveryPerformance
{
    using System.Diagnostics;
    using System.Threading;
    using System.Threading.Tasks;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class AppService
    {
        private readonly CancellationTokenSource _cancellationTokenSource = new CancellationTokenSource();
        private readonly ManualResetEvent _runCompleteEvent = new ManualResetEvent(false);
        private ILoggerFactory _loggerFactory;
        private ILogger _logger;

        public AppService(ILoggerFactory loggerFactory)
        {
            _loggerFactory = loggerFactory;
        }

        public void Run()
        {
            GetLogger().LogInformation("NServiceBus 7 App Service has been started");

            try
            {
                this.RunAsync(this._cancellationTokenSource.Token).Wait();
            }
            finally
            {
                this._runCompleteEvent.Set();
            }
        }

        public void Start()
        {
            Bootstrapper.Start(_loggerFactory, GetLogger()).Wait();
            GetLogger().LogInformation("Starting AppService AllocationDeliveryPerformance");
        }

        private ILogger GetLogger()
        {
            if (_logger == null)
            {
                _logger = _loggerFactory.CreateDefaultLogger(Config.GetAppSetting("Environment:NoSqlConnectionString"));
            }

            return _logger;
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
