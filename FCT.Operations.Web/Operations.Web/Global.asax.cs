namespace Operations.Web
{
    using System;
    using System.Configuration;
    using System.Diagnostics;
    using System.Web;
    using System.Web.Http;
    using System.Web.Http.Dispatcher;
    using Castle.Windsor;
    using IoC;
    using Microsoft.ApplicationInsights.Extensibility;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class WebApiApplication : System.Web.HttpApplication
    {
        private readonly IWindsorContainer _container;
        private ILoggerFactory _loggerFactory;

        protected WebApiApplication()
        {
            _container = new WindsorContainer().Install(new WindsorInstaller(GetLoggerFactory()));
        }

        private ILoggerFactory GetLoggerFactory()
        {
            if (_loggerFactory == null)
            {
                // todo: We need do something different here if we are in an App Service
                _loggerFactory = new LoggerFactory();
            }

            return _loggerFactory;
        }

        protected void Application_Start()
        {
            // force outbound calls to use TLS1.2 - needed for hosting on app services
            System.Net.ServicePointManager.SecurityProtocol = System.Net.SecurityProtocolType.Tls12;

            GlobalConfiguration.Configure(WebApiConfig.Register);
            GlobalConfiguration.Configuration.Services.Replace(typeof(IHttpControllerActivator), new WindsorCompositionRoot(_container));
            ILogger logger = GetLoggerFactory().CreateDefaultLogger();
            logger.LogInformation("Starting Ops Web Service");

            if (ConfigurationManager.AppSettings["iKey"] != null)
            {
                TelemetryConfiguration.Active.InstrumentationKey = ConfigurationManager.AppSettings["iKey"];

                if (Debugger.IsAttached)
                {
                    TelemetryConfiguration.Active.DisableTelemetry = true;
                }
            }
        }

        protected void Application_BeginRequest(object sender, EventArgs e)
        {
            var app = sender as HttpApplication;
            app?.Context?.Response.Headers.Remove("Server");
        }
    }
}