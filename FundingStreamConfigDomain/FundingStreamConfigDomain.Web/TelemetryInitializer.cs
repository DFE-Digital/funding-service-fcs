namespace SFA.FCT.FundingPolicyDomain
{
    using Microsoft.ApplicationInsights.DataContracts;
    using Microsoft.ApplicationInsights.Extensibility;

    public class TelemetryInitializer : IContextInitializer
    {
        public void Initialize(TelemetryContext context)
        {
            context.Properties["ComponentName"] = GetType().Assembly.GetName().Name;
        }
    }
}
