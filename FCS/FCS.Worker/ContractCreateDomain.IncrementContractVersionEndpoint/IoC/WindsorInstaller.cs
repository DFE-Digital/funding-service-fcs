namespace ContractCreateDomain.IncrementContractVersionEndpoint.IoC
{
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using Infrastructure;
    using Repositories;
    using Microsoft.Xrm.Sdk;
    using Services;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.ContractCreateDomain.BusinessLogic;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.ContractCreateDomain.Implementation.Repositories;
    using SFA.FCT.ContractCreateDomain.Implementation.Services;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class WindsorInstaller : IWindsorInstaller
    {
        private readonly ILoggerFactory _loggerFactory;

        public WindsorInstaller(ILoggerFactory loggerFactory)
        {
            _loggerFactory = loggerFactory;
        }

        public void Install(IWindsorContainer container, IConfigurationStore store)
        {
            container.Register(
                Component.For<IOrganizationService>().UsingFactoryMethod(k => CrmConnectionFactory.GetOrganizationService()).LifestyleScoped(),
                Component.For<ILogger>().Instance(_loggerFactory.CreateLogger("ContractCreateDomain")),
                Component.For<IContractsManager>().ImplementedBy<ContractsManager>().LifestyleScoped(),
                Component.For<IContractDeliverableEnricher>().ImplementedBy<ContractDeliverableEnricher>().LifestyleScoped(),
                Component.For<IFundingStreamConfigService>().ImplementedBy<FundingStreamConfigService>().LifestyleScoped(),
                Component.For<IContractRequestTransformer>().ImplementedBy<ContractRequestTransformer>().LifestyleScoped(),
                Component.For<IFundingTypePeriodService>().ImplementedBy<FundingTypePeriodService>().LifestyleScoped(),
                Component.For<IFundingTypeFundingPeriodQueryRepository>().ImplementedBy<FundingTypeFundingPeriodQueryRepository>().LifestyleSingleton(),
                Component.For<IContractValueAggregator>().ImplementedBy<ContractValueAggregator>().LifestyleSingleton(),
                Component.For<IContractStorage>().ImplementedBy<AzureContractStorage>().LifestyleSingleton(),
                Component.For<IContractVersionIncrementService>().ImplementedBy<ContractVersionIncrementService>().LifestyleScoped(),
                Component.For<ISiblingApprovedContractService>().ImplementedBy<SiblingApprovedContractService>().LifestyleScoped(),
                Component.For<IApprovedContractRepository>().ImplementedBy<ApprovedContractRepository>().LifestyleScoped(),
                Component.For<IFundingTypeFundingPeriodRepository>().ImplementedBy<FundingTypeFundingPeriodRepository>().LifestyleSingleton(),
                Component.For<ILevyContractAllocationService>().ImplementedBy<LevyContractAllocationService>().LifestyleScoped(),
                Component.For<IFundingStreamPeriodRepository>().ImplementedBy<FundingStreamPeriodRepository>().LifestyleScoped(),
                Component.For<IAllocationNumberRepository>().ImplementedBy<AllocationNumberRepository>().LifestyleScoped(),
                Component.For<ISessionConnectionFactory>().ImplementedBy<SessionConnectionFactory>().LifestyleSingleton(),
                Component.For<ISequenceRepository>().ImplementedBy<SequenceRepository>().LifestyleSingleton(),
                Component.For<ICreatedContractRepository>().ImplementedBy<CreatedContractRepository>().LifestyleSingleton(),
                Component.For<ICrmContractRepository>().ImplementedBy<CrmContractRepository>().LifestyleScoped()
                    );
        }
    }
}