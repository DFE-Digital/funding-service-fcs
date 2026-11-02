namespace OrganisationDomain.Web
{
    using System;
    using System.Web;
    using System.Web.Configuration;
    using System.Web.Http;
    using System.Web.Http.Dispatcher;
    using Castle.Windsor;
    using IoC;
    using Microsoft.ApplicationInsights.Extensibility;
    using SFA.FCT.Framework.Logging;

    public class WebApiApplication : HttpApplication
    {
        protected void Application_Start()
        {
            GlobalConfiguration.Configure(WebApiConfig.Register);
            ServiceBus.Init();

            GlobalConfiguration.Configuration.Services.Replace(typeof(IHttpControllerActivator), new WindsorCompositionRoot(GetContainer()));

            if (WebConfigurationManager.AppSettings["iKey"] != null)
            {
                TelemetryConfiguration.Active.InstrumentationKey = WebConfigurationManager.AppSettings["iKey"];
            }
        }

        protected void Application_BeginRequest(object sender, EventArgs e)
        {
            var app = sender as HttpApplication;
            app?.Context?.Response.Headers.Remove("Server");
        }

        private IWindsorContainer GetContainer()
        {
            return new WindsorContainer().Install(new WindsorInstaller(new LoggerFactory()));
        }
    }
}
