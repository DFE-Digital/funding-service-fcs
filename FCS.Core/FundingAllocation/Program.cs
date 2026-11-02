namespace FundingAllocation
{
    using System;
    using System.IO;
    using System.Net;
    using System.Net.Http;
    using System.Threading;
    using System.Threading.Tasks;
    using Microsoft.Extensions.DependencyInjection;
    using Microsoft.Extensions.Hosting;
    using Microsoft.Extensions.Configuration;
    using ServiceBus;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Bespoke;
    using SFA.FCT.Framework.Logging.Interfaces;
    using Polly;

    public class Program
    {
        private readonly CancellationTokenSource _cancellationTokenSource = new CancellationTokenSource();
        private readonly ManualResetEvent _runCompleteEvent = new ManualResetEvent(false);
        private static ILoggerFactory _loggerFactory;
        private static ILogger _logger;
        private static IConfigurationRoot _appConfiguration;
        public static IHttpClientFactory _httpClientFactory;

        public static int Main()
        {
            _appConfiguration = new ConfigurationBuilder()
                .SetBasePath(Directory.GetParent(AppContext.BaseDirectory).FullName)
                .AddJsonFile("appsettings.json", false)
                .AddEnvironmentVariables()
                .Build();

            _logger = GetLogger();
            _logger.LogInformation(1, "Starting Fcs Core - 1");

            ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12;
            ServicePointManager.DefaultConnectionLimit = 12;

            var builder = new HostBuilder();
            builder.ConfigureServices((context, services) =>
            {
                services.AddSingleton<IHostedService, HostedService>();
                services.AddHttpClient();
            });
            var host = builder.Build();
            _httpClientFactory = host.Services.GetService<IHttpClientFactory>();
            _logger.LogInformation(1, $"Starting Fcs Core - {_httpClientFactory}");
            using (host)
            {
                host.Run();
            }
            return 1;
        }

        public ILogger Logger => _logger;

        private class HostedService : IHostedService
        {
            private readonly Program _program = new Program();

            public Task StartAsync(CancellationToken cancellationToken)
            {
                Console.WriteLine("StartAsync called - via console");
                _program.Logger.LogInformation(1, $"StartAsync called: {_httpClientFactory}");
                try
                {
                    _program.Execute();
                }
                catch (Exception e)
                {
                    Console.WriteLine($"StartAsync exception - via console: {e.Message}, {e.StackTrace}");
                    _program.Logger.LogInformation(1, $"StartAsync failed: {e.Message}, {e.StackTrace}");
                }

                return Task.CompletedTask;
            }

            public Task StopAsync(CancellationToken cancellationToken)
            {
               _program.Stop();

               return Task.CompletedTask;
            }
        }

        private Program()
        {
            CreateShutdownFileWatcher();
        }

        private static ILoggerFactory GetLoggerFactory()
        {
            if (_loggerFactory == null)
            {
                _loggerFactory = _loggerFactory = new LoggerFactory(
                    new AppServiceEnvironment(
                        Environment.GetEnvironmentVariable("WEBSITE_SITE_NAME"),
                        Environment.GetEnvironmentVariable("WEBSITE_INSTANCE_ID")?.Substring(0, 6),
                        _appConfiguration["DeploymentId"]));

            }

            return _loggerFactory;
        }

        private int Execute()
        {
            Console.WriteLine("App Service starting");

            NServiceBus.Logging.LogManager.UseFactory(new NsbLoggerFactory(GetLogger()));

            Bootstrapper.Start(GetLoggerFactory(), GetLogger(), _appConfiguration, _httpClientFactory).Wait();

            Console.WriteLine("Endpoints have started");

            try
            {
                RunAsync(_cancellationTokenSource.Token).Wait();
            }
            finally
            {
                _runCompleteEvent.Set();
            }

            Console.WriteLine("FundingAllocation App Service stopping");

            return 0;
        }

        private static ILogger GetLogger()
        {
            var storageConnectionString = _appConfiguration.GetConnectionString("StorageConnectionString");

            return GetLoggerFactory().CreateDefaultLogger(
                storageConnectionString,
                new NetCoreCloudEnvironment(_appConfiguration, GetRoleId()), le =>
                {
                    try
                    {
                        Policy.Handle<Exception>()
                            .WaitAndRetry(1, count => TimeSpan.FromSeconds(1))
                            .Execute(() => AzureStorageTable.CreateRowInAzure(le, storageConnectionString));
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine($"CreateRowInAzure - error: {e.Message}, {e.StackTrace}");
                    }
                });
        }

        private static string GetRoleId()
        {
            string roleId = Environment.GetEnvironmentVariable("WEBSITE_INSTANCE_ID")?.Substring(0, 6);

            if (string.IsNullOrEmpty(roleId))
            {
                return "local_machine";
            }

            return roleId;
        }

        private static async Task RunAsync(CancellationToken cancellationToken)
        {
            while (!cancellationToken.IsCancellationRequested)
            {
                Console.WriteLine("FundingAllocation App Service running..");
                await Task.Delay(1000);
            }
        }

        private void Stop()
        {
            Console.WriteLine("Shutdown requested, stopping all endpoints");

            _cancellationTokenSource.Cancel();
            _runCompleteEvent.WaitOne();

            Bootstrapper.Stop().Wait();

            Console.WriteLine("Endpoints stopped");
        }

        private void CreateShutdownFileWatcher()
        {
            try
            {
                FileInfo shutdownFile = new FileInfo(Environment.GetEnvironmentVariable("WEBJOBS_SHUTDOWN_FILE"));

                FileSystemWatcher shutdownFileWatcher =
                    new FileSystemWatcher(shutdownFile.DirectoryName, shutdownFile.Name);
                shutdownFileWatcher.Created += (sender, e) => { Stop(); };
                shutdownFileWatcher.EnableRaisingEvents = true;

                Console.WriteLine($"Watching for shutdown file: {shutdownFile.Name}");
            }
            catch (Exception e)
            {
                Console.WriteLine($"Watching for shutdown file failed: {e}");
            }
        }
    }
}
