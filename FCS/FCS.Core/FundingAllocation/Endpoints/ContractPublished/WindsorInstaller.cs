namespace FundingAllocation.Endpoints.ContractPublished
{
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using Microsoft.Extensions.Configuration;
    using Repositories;
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
                Component.For<IContractRepository>()
                    .ImplementedBy<ContractRepository>().LifestyleTransient(),
                Component.For<IFundingAllocationRepository>()
                    .ImplementedBy<FundingAllocationRepository>().LifestyleTransient());
        }
    }
}
