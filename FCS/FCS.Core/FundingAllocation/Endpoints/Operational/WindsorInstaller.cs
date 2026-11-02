namespace FundingAllocation.Endpoints.Operational
{
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using FundingAllocation.Extensions;
    using Microsoft.Extensions.Configuration;
    using Services;
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
                Component.For<IConfigurationRoot>().Instance(_appConfiguration),
                Component.For<IFundingNotificationApi>().Instance(GetFundingNotificationApi()).LifestyleSingleton());
        }

        private IFundingNotificationApi GetFundingNotificationApi()
        {
            var shouldUseStub = _appConfiguration["Cfs:ShouldUseStub"];
            if (shouldUseStub.IsEqual("true"))
            {
                return new FundingNotificationApiTestImpl(_appConfiguration);
            }

            return new FundingNotificationApi(_appConfiguration);
        }
    }
}
