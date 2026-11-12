
namespace SFA.FCT.CrossDomain.Integration.Azure.Worker
{
    using Microsoft.Extensions.Configuration;
    using Microsoft.Extensions.Logging;
    using NServiceBus.Logging;
    using NServiceBus.Extensions.Logging;
    using System;
    using System.Net;
    using System.Threading;
    using System.Threading.Tasks;

    // ✅ Fix ambiguity with aliases
    using MSLoggerFactory = Microsoft.Extensions.Logging.ILoggerFactory;
    using MSLogger = Microsoft.Extensions.Logging.ILogger;
    using MSLogLevel = Microsoft.Extensions.Logging.LogLevel;

    public class WorkerRole
    {
        private readonly CancellationTokenSource cancellationTokenSource = new();
        private readonly ManualResetEvent runCompleteEvent = new(false);

        private MSLoggerFactory _loggerFactory;
        private MSLogger _logger;

        public WorkerRole()
        {
        }

        public WorkerRole(MSLoggerFactory loggerFactory)
        {
            _loggerFactory = loggerFactory;
        }

        // ---------------------------------------
        // RUN
        // ---------------------------------------
        public void Run()
        {
            GetLogger().LogInformation("✅ WorkerRole started");

            try
            {
                RunAsync(cancellationTokenSource.Token).Wait();
            }
            finally
            {
                runCompleteEvent.Set();
            }
        }

        // ---------------------------------------
        // START
        // ---------------------------------------
        public bool OnStart()
        {
            ServicePointManager.DefaultConnectionLimit = 12;

            var configuration = new ConfigurationBuilder()
                .SetBasePath(AppContext.BaseDirectory)
                .AddJsonFile("appsettings.json", optional: true)
                .AddEnvironmentVariables()
                .Build();

            // ✅ Integrate Microsoft logging with NServiceBus
            LogManager.UseFactory(new ExtensionsLoggerFactory(GetLoggerFactory()));

            // ✅ Start all endpoints
            Bootstrapper.Start(GetLoggerFactory(), GetLogger(), configuration).Wait();

            GetLogger().LogInformation("✅ WorkerRole has been started");

            return true;
        }

        // ---------------------------------------
        // STOP
        // ---------------------------------------
        public void OnStop()
        {
            GetLogger().LogInformation("🛑 WorkerRole is stopping");

            cancellationTokenSource.Cancel();
            runCompleteEvent.WaitOne();

            Bootstrapper.Stop().Wait();

            GetLogger().LogInformation("✅ WorkerRole has stopped");
        }

        // ---------------------------------------
        // LOGGER
        // ---------------------------------------
        private MSLogger GetLogger()
        {
            return _logger ??= GetLoggerFactory().CreateLogger("WorkerRole");
        }

        // ---------------------------------------
        // LOGGER FACTORY
        // ---------------------------------------
        private MSLoggerFactory GetLoggerFactory()
        {
            return _loggerFactory ??= LoggerFactory.Create(builder =>
            {
                builder.ClearProviders();
                builder.AddConsole();
                builder.AddDebug();
                builder.SetMinimumLevel(MSLogLevel.Information);
            });
        }

        // ---------------------------------------
        // BACKGROUND LOOP
        // ---------------------------------------
        private async Task RunAsync(CancellationToken cancellationToken)
        {
            while (!cancellationToken.IsCancellationRequested)
            {
                GetLogger().LogInformation("Worker running...");
                await Task.Delay(1000, cancellationToken);
            }
        }
    }
}
