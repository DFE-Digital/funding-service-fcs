namespace FundingAllocation.Endpoints.DocumentGenerationComplete
{
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using FundingAllocation.Repositories;
    using Infrastructure;
    using Microsoft.Extensions.Configuration;
    using Repositories;
    using SFA.FCT.Framework.Logging.Interfaces;
    using ContractRepository = Repositories.ContractRepository;
    using IContractRepository = Repositories.IContractRepository;

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
                Component.For<IContractStorage>().ImplementedBy<ContractStorage>().LifestyleSingleton(),
                Component.For<ICrmFundingAllocationCommandRepository>().ImplementedBy<CrmFundingAllocationCommandRepository>().LifestyleSingleton(),
                Component.For<IContractRepository>().ImplementedBy<ContractRepository>().LifestyleTransient(),
                Component.For<IFundingAllocationRepository>().ImplementedBy<FundingAllocationRepository>().LifestyleTransient(),
                Component.For<IConfigurationRoot>().Instance(_appConfiguration));
        }
    }
}
