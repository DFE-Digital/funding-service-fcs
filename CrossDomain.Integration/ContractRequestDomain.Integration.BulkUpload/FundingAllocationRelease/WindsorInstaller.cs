namespace SFA.FCT.ContractRequestDomain.Integration.BulkUpload.FundingAllocationRelease
{
    using Castle.MicroKernel.Registration;
    using Framework.Logging.Interfaces;
    using Repositories;

    public class WindsorInstaller : IWindsorInstaller
    {
        private readonly ILoggerFactory _loggerFactory;

        public WindsorInstaller(ILoggerFactory loggerFactory)
        {
            _loggerFactory = loggerFactory;
        }

        public void Install(Castle.Windsor.IWindsorContainer container,
            Castle.MicroKernel.SubSystems.Configuration.IConfigurationStore store)
        {
            container.Register(
                Component.For<ILogger>().Instance(_loggerFactory.CreateDefaultLogger()),
                Component.For<IFundingAllocationReleaseRepository>().ImplementedBy<FundingAllocationReleaseRepository>().LifestyleSingleton(),
                Component.For<ISessionConnectionFactory>().ImplementedBy<SessionConnectionFactory>().LifestyleSingleton()
            );
        }
    }
}
