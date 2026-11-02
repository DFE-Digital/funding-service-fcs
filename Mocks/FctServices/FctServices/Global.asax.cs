namespace FctServices
{
    using System.Web.Http;
    using Castle.Facilities.WcfIntegration;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Deds;
    using global::DedsSearchService;
    using Storage;

    public class WebApplication : System.Web.HttpApplication
    {
        private readonly IWindsorContainer _container = new WindsorContainer();

        protected WebApplication()
        {
            _container.Kernel.AddFacility<WcfFacility>();
            _container.Kernel.Register(
                Component.For<IAzureTableStore>().ImplementedBy<AzureTableStore>().LifestyleSingleton(),
                Component.For<IEnvironmentContext>().ImplementedBy<EnvironmentContext>().LifestyleSingleton(),
                Component.For<IReportedActualRepository>().ImplementedBy<ReportedActualRepository>().LifestyleSingleton(),
                Component.For<IFundingClaimRepository>().ImplementedBy<FundingClaimRepository>().LifestyleSingleton(),
                Component.For<IDedsSearchService>()
                  .ImplementedBy<DedsSearchService>()
                  .Named("FctServices.DedsSearchService"));
        }

        protected void Application_Start()
        {
            GlobalConfiguration.Configure(WebApiConfig.Register);
        }
    }
}