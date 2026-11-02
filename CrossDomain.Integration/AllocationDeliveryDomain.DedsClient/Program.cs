namespace AllocationDeliveryDomain.DedsClient
{
    using System;
    using Castle.Windsor;
    using IoC;
    using SFA.FCT.Framework.Logging;

    public class Program
    {
        private static void Main(string[] args)
        {
            using (var container = new WindsorContainer().Install(new WindsorInstaller(new LoggerFactory())))
            {
                while (true)
                {
                    Client client = new Client();
                    Console.Clear();
                    client.Execute();
                }
            }
        }
    }
}