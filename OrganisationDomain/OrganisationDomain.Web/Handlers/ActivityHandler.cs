namespace OrganisationDomain.Web.Handlers
{
    using System;
    using System.Collections.Generic;
    using System.Diagnostics;
    using System.Linq;
    using System.Net.Http;
    using System.Threading;
    using System.Threading.Tasks;

    public class ActivityHandler : DelegatingHandler
    {
        /// <summary>
        /// The name of the header used to check for passed Correlation IDs
        /// </summary>
        private const string HeaderName = "Correlation-ID";

        /// <summary>
        /// The specific trace source used to trace data to
        /// </summary>
        private static readonly TraceSource TraceSource = new TraceSource("OrganisationService");

        protected async override Task<HttpResponseMessage> SendAsync(HttpRequestMessage request, CancellationToken cancellationToken)
        {
            IEnumerable<string> headerValues;
            var createNewActivity = true;
            if (request.Headers.TryGetValues(HeaderName, out headerValues))
            {
                var headers = new List<string>(headerValues);
                var count = headers.Count();
                if (count > 0)
                {
                    if (count > 1)
                    {
                        TraceSource.TraceEvent(TraceEventType.Warning, 0, "Unable to set the activityId as there are multiple values");
                    }
                    else
                    {
                        Guid activityId;
                        if (Guid.TryParse(headers[0], out activityId))
                        {
                            // We have been passed a valid ActivityId
                            Trace.CorrelationManager.ActivityId = activityId;
                            createNewActivity = false;
                        }
                        else
                        {
                            TraceSource.TraceEvent(TraceEventType.Warning, 0, "Unable to parse the activityId as it is not a Guid");
                        }
                    }
                }
            }

            if (createNewActivity)
            {
                // No ActivityId was passed so create a new one
                Trace.CorrelationManager.ActivityId = Guid.NewGuid();
            }

            // Call the inner handler.
            var response = await base.SendAsync(request, cancellationToken);

            response.Headers.Add("Correlation-ID", Trace.CorrelationManager.ActivityId.ToString());
            return response;
        }
    }
}