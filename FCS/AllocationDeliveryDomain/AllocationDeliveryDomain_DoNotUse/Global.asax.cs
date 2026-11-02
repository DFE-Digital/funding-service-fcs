namespace SFA.FCT.AllocationDeliveryDomain
{
    using Castle.Windsor;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Interfaces;
    using System.Web.Http.Dispatcher;
    using SFA.FCT.AllocationDeliveryDomain.IoC;
    using System.Web.Http;

    public class WebApiApplication : System.Web.HttpApplication
    {
        private readonly IWindsorContainer _container;
        private readonly ILoggerFactory _loggerFactory = new LoggerFactory();
        private ILogger _logger;

        protected WebApiApplication()
        {
            _container = new WindsorContainer().Install(new WindsorInstaller(_loggerFactory));
        }

        protected void Application_Start()
        {
            // NOTE: We only need one instance of the logger and factory so invoke here
            _logger = _loggerFactory.CreateLogger("ADWebRole");
            _logger.LogInformation("Starting AllocationDelivery Web Service");

            GlobalConfiguration.Configure(WebApiConfig.Register);

            GlobalConfiguration.Configuration.Services.Replace(
                typeof(IHttpControllerActivator),
                new WindsorCompositionRoot(_container));
        }
    }
}
