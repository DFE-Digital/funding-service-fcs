namespace SFA.FCT.FundingPolicyDomain
{
    using System.Web.Http;
    using System.Web.Http.ExceptionHandling;
    using Controllers;
    using CrossDomain.Integration.Common.Atom;

    public static class WebApiConfig
    {
        private const string AtomMediaType = "APPLICATION/ATOM+XML";

        public static void Register(HttpConfiguration config)
        {
            // Web API configuration and services
            config.Formatters.Clear();
            config.Formatters.Add(new CustomNamespaceXmlFormatter { UseXmlSerializer = true });

            config.MessageHandlers.Add(new AtomMediaTypeFilterHandler(
                new[]
                {
                    new MediaTypeFilterCriteria
                    {
                        UrlPortion = DeliverableSettingConfigurationFeedController.RoutePrefix + "/" + DeliverableSettingConfigurationFeedController.RouteSuffix,
                        SupportedMediaTypes = new[]
                        {
                            AtomMediaType,
                            "APPLICATION/VND.SFA.FUNDING-POLICY.DELIVERABLE.SETTING.V1+ATOM+XML"
                        }
                    }
                }));
            config.Formatters.Add(new AtomMediaTypeFormatter(
                new[]
                {
                    AtomMediaType,
                    "APPLICATION/VND.SFA.FUNDING-POLICY.DELIVERABLE.SETTING.V1+ATOM+XML"
                }));

            // Web API routes
            config.MapHttpAttributeRoutes();
            config.Routes.MapHttpRoute(
                name: "DefaultApi",
                routeTemplate: "api/{controller}/{id}",
                defaults: new { id = RouteParameter.Optional });
            config.Services.Add(typeof(IExceptionLogger), new AppInsightsExceptionLogger());

        }
    }
}