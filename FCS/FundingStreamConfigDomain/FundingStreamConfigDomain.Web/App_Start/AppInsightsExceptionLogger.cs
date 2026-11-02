namespace SFA.FCT.FundingPolicyDomain
{
    using System.Web.Http.ExceptionHandling;
    using Microsoft.ApplicationInsights;

    public class AppInsightsExceptionLogger : ExceptionLogger
    {
        public override void Log(ExceptionLoggerContext context)
        {
            if (context?.Exception != null)
            {
                //or reuse instance (recommended!). see note above 
                var ai = new TelemetryClient();
                ai.TrackException(context.Exception);
            }
            base.Log(context);
        }

    }
}