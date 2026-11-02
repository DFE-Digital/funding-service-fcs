namespace FundingAllocation.Endpoints.EnrichProviderFunding
{
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using Extensions;
    using FundingAllocation.Services;
    using Microsoft.Extensions.Configuration;
    using Repositories;
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
                Component.For<IFundingNotificationApi>().Instance(GetFundingNotificationApi()).LifestyleSingleton(),
                Component.For<IProviderService>().ImplementedBy<ProviderService>().LifestyleTransient(),
                Component.For<IProviderFundingRepository>().ImplementedBy<ProviderFundingRepository>().LifestyleTransient(),
                Component.For<IProviderFundingAllocationRepository>().ImplementedBy<ProviderFundingAllocationRepository>().LifestyleTransient());
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
