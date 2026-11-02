namespace SFA.FCT.AllocationDeliveryDomain
{
    using System.Web.Http;
    using CrossDomain.Integration.Common.Atom;

    public static class WebApiConfig
    {
        public static void Register(HttpConfiguration config)
        {
            // Web API configuration and services

            // Web API routes
            config.MapHttpAttributeRoutes();

            //config.Routes.MapHttpRoute(
            //    name: "DefaultApi",
            //    routeTemplate: "api/{controller}/{id}",
            //    defaults: new { id = RouteParameter.Optional }
            //);

            config.Formatters.Clear();
            config.Formatters.Add(new AtomMediaTypeFormatter());

        }
    }
}
