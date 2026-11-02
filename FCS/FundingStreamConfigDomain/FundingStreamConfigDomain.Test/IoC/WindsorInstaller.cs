namespace SFA.FCT.FundingPolicy.Test.IoC
{
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;

    public class WindsorInstaller : IWindsorInstaller
    {
        //private readonly ILoggerFactory _loggerFactory;

        //public WindsorInstaller(ILoggerFactory loggerFactory)
        //{
        //    _loggerFactory = loggerFactory;
        //}

        public void Install(IWindsorContainer container, IConfigurationStore store)
        {
            //var xrmConnection =
            //    CrmConnection.Parse(ConfigurationManager.ConnectionStrings["CrmConnectionString"].ConnectionString);

            //container.Register(
            //    Component.For<IDate>().ImplementedBy<Date>().LifestyleSingleton(),
            //    Component.For<CrmConnection>().Instance(xrmConnection),
            //    Component.For<IOrganizationService>().ImplementedBy<OrganizationService>().LifestyleSingleton(),
            //    Component.For<IXrmOrganisationManager>().ImplementedBy<XrmOrganisationManager>().LifestyleSingleton(),
            //    Component.For<IBatchCacheManager>().ImplementedBy<BatchCacheManager>().LifestyleSingleton(),
            //    Component.For<ILookupManager>().ImplementedBy<LookupManager>().LifestyleSingleton(),
            //    Component.For<IEnduringCacheManager>().ImplementedBy<EnduringCacheManager>().LifestyleSingleton(),
            //    Component.For<IContractsManager>().ImplementedBy<ContractsManager>().LifeStyle.Transient);
        }
    }
}
