namespace FundingAllocation.Endpoints.CheckForJobComplete
{
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using Repositories;
    using Microsoft.Extensions.Configuration;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class WindsorInstaller : IWindsorInstaller
    {
        private readonly ILogger _logger;
        private readonly IConfigurationRoot _appConfiguration;

        public WindsorInstaller(ILogger logger, IConfigurationRoot appConfiguration)
        {
            _logger = logger;
            _appConfiguration = appConfiguration;
        }

        public void Install(IWindsorContainer container, IConfigurationStore store)
        {
            container.Register(
                Component.For<ILogger>().Instance(_logger),
                Component.For<IFeedReadRepository>().ImplementedBy<FeedReadRepository>().LifestyleTransient(),
                Component.For<IJobCompleteRepository>().ImplementedBy<JobCompleteRepository>().LifestyleTransient(),
                Component.For<IConfigurationRoot>().Instance(_appConfiguration));
        }
    }
}