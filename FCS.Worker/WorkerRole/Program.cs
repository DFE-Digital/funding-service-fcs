using System;
using System.IO;
using SFA.FCT.Framework.Logging.Bespoke;
using SFA.FCT.Framework.Logging;
using System.Configuration;

namespace WorkerRole
{
    using System.Net;

    class Program
    {
        /// <summary>
        /// This will be run as a continuous webjob and should continue until %WEBJOBS_SHUTDOWN_FILE% exists.  This file is
        /// created by the kudu hosting environment when shutdown has been requested.  By default this application will have
        /// five seconds - this can be adjusted by using the "stopping_wait_time" setting in the settings.job file.
        /// </summary>
        /// <param name="args"></param>
        /// <returns></returns>
        public static int Main(string[] args)
        {
            System.Net.ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12;
            return new Program(args).Execute();
        }

        readonly string[] _args;
        readonly System.IO.FileSystemWatcher _shutdownFileWatcher = null;
        WorkerRole _worker = null;

        private Program(string[] args)
        {
            _args = args;

            FileInfo shutdownFile = new FileInfo(Environment.GetEnvironmentVariable("WEBJOBS_SHUTDOWN_FILE"));

            _shutdownFileWatcher = new System.IO.FileSystemWatcher(shutdownFile.DirectoryName, shutdownFile.Name);
            _shutdownFileWatcher.Created += (sender, e) => { Stop(); };
            _shutdownFileWatcher.EnableRaisingEvents = true;

            Console.WriteLine($"Watching for shutdown file: {shutdownFile.FullName}");

        }

        private int Execute()
        {
            Console.WriteLine("Starting the worker role");
            _worker = new WorkerRole(
                new LoggerFactory(
                    new AppServiceEnvironment(
                        Environment.GetEnvironmentVariable("WEBSITE_SITE_NAME"),
                        Environment.GetEnvironmentVariable("WEBSITE_INSTANCE_ID")?.Substring(0, 6),
                        ConfigurationManager.AppSettings["DeploymentId"])));

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
