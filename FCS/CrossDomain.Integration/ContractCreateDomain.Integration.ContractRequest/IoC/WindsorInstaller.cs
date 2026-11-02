namespace SFA.FCT.ContractCreateDomain.Integration.ContractRequest.IoC
{
    using System.Configuration;
    using System.Diagnostics.CodeAnalysis;
    using Implementation;
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using Implementation.Persistence;
    using BusinessLogic;
    using BusinessLogic.Services;
    using BusinessLogic.Validation;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Repositories;
    using CrossDomain.Integration.Entities.Data;
    using Framework.Logging.Interfaces;
    using Implementation.Services;
    using Microsoft.Xrm.Client;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Client.Services;

    public class WindsorInstaller : IWindsorInstaller
    {
        private readonly ILoggerFactory _loggerFactory;

        public WindsorInstaller(ILoggerFactory loggerFactory)
        {
            _loggerFactory = loggerFactory;
        }

        public void Install(IWindsorContainer container, IConfigurationStore store)
        {
            container.Install(
                new OrganizationServiceInstaller());

            container.Register(
                Component.For<IContractManagementDbContext>().ImplementedBy<ContractManagementDbContext>().LifestyleScoped(),
                Component.For<IFundingTypeFundingPeriodQueryRepository>().ImplementedBy<FundingTypeFundingPeriodQueryRepository>().LifestyleScoped(),
                Component.For<IFundingTypePeriodFundingStreamPeriodQueryRepository>().ImplementedBy<FundingTypePeriodFundingStreamPeriodQueryRepository>().LifestyleScoped(),
                Component.For(typeof(IEntityCache<,>)).ImplementedBy(typeof(EntityCache<,>)).LifestyleSingleton(),
                Component.For<IContractRequestTransformer>().ImplementedBy<ContractRequestTransformer>(),
                Component.For<IOrganisationMessageEnricher>()
                    .ImplementedBy<OrganisationMessageEnricher>()
                    .LifestyleTransient(),
                Component.For<IOrganisationService>().ImplementedBy<OrganisationService>().LifestyleSingleton(),
                Component.For<IOrganisationServiceApiHttpClient>().ImplementedBy<OrganisationServiceApiHttpClient>().LifestyleSingleton(),
                Component.For<IContractDeliverableEnricher>().ImplementedBy<ContractDeliverableEnricher>(),
                Component.For<IFundingStreamConfigService>().ImplementedBy<FundingStreamConfigService>(),
                Component.For<IContractValueAggregator>().ImplementedBy<ContractValueAggregator>(),
                Component.For<IContractValidationLookupDataCreator>()
                    .ImplementedBy<ContractValidationLookupDataCreator>().LifestyleScoped(),
                Component.For<IMasher>().ImplementedBy<Masher>(),
                Component.For<IValidator>()
                    .ImplementedBy<Validator>(),
                Component.For<IContractOperationRules>()
                    .ImplementedBy<ContractOperationRules>()
                    .LifestyleScoped(),
                Component.For<ILookupManager>().ImplementedBy<LookupManager>().LifestyleTransient(),
                Component.For<IBatchCacheManager>().ImplementedBy<BatchCacheManager>(),
                Component.For<IEnduringCacheManager>().ImplementedBy<EnduringCacheManager>().LifestyleSingleton(),
                Component.For<INumberRequestManager>().ImplementedBy<XrmNumberRequestManager>().LifestyleTransient(),
                Component.For<IContractsManager>().ImplementedBy<ContractsManager>().LifestyleTransient(),
                Component.For<IXrmOrganisationManager>().ImplementedBy<XrmOrganisationManager>().LifestyleTransient(),
                Component.For<IXrmWorkflowManager>().ImplementedBy<XrmWorkflowManager>().LifestyleTransient(),
                Component.For<IFundingTypePeriodService>().ImplementedBy<FundingTypePeriodService>().LifestyleScoped(),
                Component.For<IProcessedMessageRepository>().ImplementedBy<ProcessedMessageRepository>().LifestyleScoped(),
                Component.For<ILogger>().Instance(_loggerFactory.CreateLogger("ContractCreateDomain")),
                Component.For<IPolicyConfigRepository>().ImplementedBy<PolicyConfigRepository>().LifestyleScoped(),
                Component.For<IFundingStreamPeriodLegalDeliverableRepository>().ImplementedBy<FundingStreamPeriodLegalDeliverableRepository>().LifestyleScoped(),
                Component.For<IPreviousContractMerger>().ImplementedBy<PreviousContractMerger>().LifestyleScoped(),
                Component.For<IPreviousContractRepository>().ImplementedBy<PreviousContractRepository>().LifestyleScoped(),
                Component.For<IFundingTypeFundingPeriodContractTypeQueryRepository>().ImplementedBy<FundingTypeFundingPeriodContractTypeQueryRepository>().LifestyleScoped());
        }
    }

    public class OrganizationServiceInstaller : IWindsorInstaller
    {
        public void Install(IWindsorContainer container, IConfigurationStore store)
        {
            var xrmConnection =
                CrmConnection.Parse(ConfigurationManager.ConnectionStrings["CrmConnectionString"].ConnectionString);

            container.Register(
                Component.For<CrmConnection>()
                    .Instance(xrmConnection),
                Component.For<IOrganizationService>()
                    .ImplementedBy<OrganizationService>()
                    .LifestyleTransient());
        }
    }

    public class XrmContractManagerInstaller : IWindsorInstaller
    {
        public void Install(IWindsorContainer container, IConfigurationStore store)
        {
            container.Register(
                ////  Component.For<IXrmContractManager>().ImplementedBy<XrmContractManager>(),
                Component.For<IContractsManager>().ImplementedBy<ContractsManager>().LifestyleTransient(),
                Component.For<ILookupManager>().ImplementedBy<LookupManager>().LifestyleTransient(),
                Component.For<IContractValidationLookupDataCreator>().ImplementedBy<ContractValidationLookupDataCreator>().LifestyleTransient(),
                Component.For<IXrmWorkflowManager>().ImplementedBy<XrmWorkflowManager>().LifestyleTransient(),
                Component.For<IBatchCacheManager>().ImplementedBy<BatchCacheManager>(),
                Component.For<IEnduringCacheManager>().ImplementedBy<EnduringCacheManager>(),
                Component.For<IPolicyConfigRepository>().ImplementedBy<PolicyConfigRepository>().LifestyleScoped(),
                Component.For<IContractManagementDbContext>().ImplementedBy<ContractManagementDbContext>().LifestyleScoped());
        }
    }

    [ExcludeFromCodeCoverage]
    public class XrmNumberRequestManagerInstaller : IWindsorInstaller
    {
        public void Install(IWindsorContainer container, IConfigurationStore store)
        {
            container.Register(
                Component.For<INumberRequestManager>()
                    .ImplementedBy<XrmNumberRequestManager>().LifestyleTransient());
        }
    }

    public class XrmOrganisationManagerInstaller : IWindsorInstaller
    {
        public void Install(IWindsorContainer container, IConfigurationStore store)
        {
            container.Register(
                Component.For<IXrmOrganisationManager>()
                    .ImplementedBy<XrmOrganisationManager>().LifestyleTransient());
        }
    }
}