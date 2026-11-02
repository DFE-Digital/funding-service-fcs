namespace FundingAllocation.Endpoints.CreateProvidersIfNecessaryReply
{
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using Microsoft.Extensions.Configuration;
    using Repositories;
    using Services;
    using SFA.FCT.Framework.Logging.Interfaces;
    using Slack;

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
                Component.For<IFundingAllocationRepository>().ImplementedBy<FundingAllocationRepository>().LifestyleTransient(),
                Component.For<ICreateProvidersIfNecessaryNotificationService>().ImplementedBy<CreateProvidersIfNecessaryNotificationService>().LifestyleSingleton(),
                Component.For<ISlackMessageSender>().ImplementedBy<SlackMessageSender>().LifestyleTransient(),
                Component.For<IConfigurationRoot>().Instance(_appConfiguration));
        }
    }
}
