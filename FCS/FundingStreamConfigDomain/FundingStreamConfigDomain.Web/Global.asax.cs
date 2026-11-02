namespace SFA.FCT.FundingPolicyDomain
{
    using System.Diagnostics;
    using System.Web.Configuration;
    using System.Web.Http;
    using System.Web.Http.Dispatcher;
    using Castle.Windsor;
    using IoC;
    using Microsoft.ApplicationInsights.Extensibility;

    public class WebApiApplication : System.Web.HttpApplication
    {
        private readonly IWindsorContainer _container;

        protected WebApiApplication()
        {
            _container = new WindsorContainer().Install(
                new WindsorInstaller(),
                new FundingStreamConfigDomain.BusinessLogic.IoC.WindsorInstaller());
        }

        public override void Dispose()
        {
            _container.Dispose();
            base.Dispose();
        }

        protected void Application_Start()
        {
            GlobalConfiguration.Configure(WebApiConfig.Register);
            GlobalConfiguration.Configuration.Services.Replace(
                typeof(IHttpControllerActivator),
                new WindsorCompositionRoot(_container));

            if (WebConfigurationManager.AppSettings["iKey"] != null)
            {
                TelemetryConfiguration.Active.InstrumentationKey = WebConfigurationManager.AppSettings["iKey"];

                if (Debugger.IsAttached)
                {
                    TelemetryConfiguration.Active.DisableTelemetry = true;
                }
            }
        }
    }
}