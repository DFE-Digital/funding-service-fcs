namespace OrganisationDomain.Web
{
    using Microsoft.ApplicationInsights.Channel;
    using Microsoft.ApplicationInsights.Extensibility;

    public class TelemetryInitializer 
    {
        private readonly string componentName =
            typeof(TelemetryInitializer).Assembly.GetName().Name!;

        public void Initialize(ITelemetry telemetry)
        {
            telemetry.Context.Component.Version = componentName;
        }
    }
}