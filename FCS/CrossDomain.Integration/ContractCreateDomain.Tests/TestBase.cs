
namespace ContractCreateDomain.Tests
{
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Moq;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class TestBase
    {
        protected IWindsorContainer Container { get; private set; }

        public TestBase()
        {
            SetupIoC();
        }

        private void SetupIoC()
        {
            ILoggerFactory factory = new LoggerFactory();
            Container = new WindsorContainer();
            Container.Install(new ContractCreateDomain.Endpoint.WindsorInstallerForSagas(factory));
            Container.Register(Component.For<ILogger>().Instance(Mock.Of<ILogger>()).IsDefault());
        }
    }
}
