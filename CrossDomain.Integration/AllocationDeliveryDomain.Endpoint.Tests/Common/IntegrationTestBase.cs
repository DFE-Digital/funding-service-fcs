namespace AllocationDeliveryDomain.Endpoint.Tests.Common
{
    using Castle.Windsor;
    using Endpoint.IoC;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class IntegrationTestBase
    {
        protected IWindsorContainer Container { get; private set; }


        public IntegrationTestBase()
        {
            SetupIoC();
        }

        private void SetupIoC()
        {
            ILoggerFactory factory = new LoggerFactory();

            Container = new WindsorContainer().Install(new WindsorInstaller(factory));
        }
    }
}
