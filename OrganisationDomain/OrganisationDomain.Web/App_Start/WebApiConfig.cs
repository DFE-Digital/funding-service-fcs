namespace OrganisationDomain.Web
{
    using System.Web.Http;
    using Handlers;

    public static class WebApiConfig
    {
        public static void Register(HttpConfiguration config)
        {
            // Web API configuration and services

            // Web API routes
            config.MapHttpAttributeRoutes();

            // Web API configuration and services
            config.MessageHandlers.Add(new ActivityHandler());

            config.Formatters.XmlFormatter.UseXmlSerializer = true;
        }
    }
}
