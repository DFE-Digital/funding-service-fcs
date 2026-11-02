namespace AllocationDeliveryPerformance
{
    using System;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Bespoke;

    class Program
    {
        private AppService _appService = null;

        static void Main(string[] args)
        {
            new Program().Execute();
        }

        private int Execute()
        {
            Console.WriteLine($"Starting the app service AllocationDeliveryPerformance");
            _appService = new AppService(
                new LoggerFactory(
                    new AppServiceEnvironment(
                        "ADP",
                        "1",
                        Config.GetAppSetting("Environment:DeploymentId"))));

            Console.WriteLine(Config.GetAppSetting("Environment:DeploymentId"));
            _appService.Start();

            Console.WriteLine("Started AllocationDeliveryPerformance");
            _appService.Run();

            Console.WriteLine("AllocationDeliveryPerformance terminating");
            return 0;
        }
    }
}
