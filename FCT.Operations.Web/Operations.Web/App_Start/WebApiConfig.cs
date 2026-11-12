namespace Operations.Web
{
    using System.Net;
    using System.Web.Http;
    using Formatters;
    using Newtonsoft.Json;
    using SFA.FCT.Framework.Logging.Interfaces;
    using System.Web.Http.ExceptionHandling;
    using Operations.Web.Filters;
    using System.Web.Http.Cors;

    public static class WebApiConfig
    {
        public static void Register(HttpConfiguration config)
        {
            // Create a logger factory instance
            ILoggerFactory loggerFactory = new SFA.FCT.Framework.Logging.LoggerFactory();

            config.EnableCors(new EnableCorsAttribute("*", "*", "*"));

            // Create a logger instance
            ILogger logger = loggerFactory.CreateDefaultLogger();

            config.MapHttpAttributeRoutes();
            config.Formatters.Add(new TextMediaTypeFormatter());

            JsonSerializerSettings jsonSerializerSettings = new JsonSerializerSettings();
            jsonSerializerSettings.Converters.Add(new Newtonsoft.Json.Converters.StringEnumConverter());
            config.Formatters.JsonFormatter.SerializerSettings = jsonSerializerSettings;
            System.Net.ServicePointManager.SecurityProtocol |= SecurityProtocolType.Tls12;

            config.Routes.MapHttpRoute(
                name: "DefaultApi",
                routeTemplate: "api/{controller}/{id}",
                defaults: new { id = RouteParameter.Optional }
            );

            // Register the custom exception filter
            config.Filters.Add(new CustomExceptionFilter(logger));

            // Register the global error handler
            config.Services.Replace(typeof(IExceptionHandler), new GlobalExceptionHandler(logger));
        }
    }
}