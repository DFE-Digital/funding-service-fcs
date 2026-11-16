using System;
using System.Configuration;
using System.IO;
using Microsoft.Extensions.Logging;


namespace SFA.FCT.CrossDomain.Integration.Azure.Worker
{
    using System.Net;

    public class Program
    {
        readonly string[] _args;
        readonly System.IO.FileSystemWatcher _shutdownFileWatcher = null;
        WorkerRole _worker = null;

        public static int Main(string[] args)
        {
            System.Net.ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12;
            return new Program(args).Execute();
        }

        private Program(string[] args)
        {
            _args = args;
            string shutdownFilePath = Environment.GetEnvironmentVariable("WEBJOBS_SHUTDOWN_FILE");
            if (shutdownFilePath == null || shutdownFilePath.Length == 0)
            {
                // something for when running locally through VS
                shutdownFilePath = "shutdown.txt";
            }

            FileInfo shutdownFile = new FileInfo(shutdownFilePath);

            _shutdownFileWatcher = new System.IO.FileSystemWatcher(shutdownFile.DirectoryName, shutdownFile.Name);
            _shutdownFileWatcher.Created += (sender, e) => { Stop(); };
            _shutdownFileWatcher.EnableRaisingEvents = true;

            Console.WriteLine($"Watching for shutdown file: {shutdownFile.FullName}");

        }

        private int Execute()
        {
            Console.WriteLine("Starting the worker role");

            var loggerFactory = LoggerFactory.Create(builder =>
            {
                builder.ClearProviders();
                builder.AddConsole();
                builder.AddDebug();
                builder.SetMinimumLevel(LogLevel.Information);
            });

            _worker = new WorkerRole(loggerFactory);


            _worker.OnStart();
            Console.WriteLine("Worker role started, now running");
            _worker.Run();
            Console.WriteLine("Worker role terminating");
            return 0;
        }

        private void Stop()
        {
            Console.WriteLine("Shutdown requested, stopping all endpoints");
            // perform all actions necessary to stop the application here
            _worker.OnStop();
            Console.WriteLine("Shutdown complete");
        }

    }
}
