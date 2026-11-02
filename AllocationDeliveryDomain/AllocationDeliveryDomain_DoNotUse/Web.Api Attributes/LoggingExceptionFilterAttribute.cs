namespace SFA.FCT.AllocationDeliveryDomain.Web.Api_Attributes
{
    using System;
    using System.Net;
    using System.Net.Http;
    using System.Web.Http.Filters;
    using System.Diagnostics;
    using System.Threading;
    using System.Threading.Tasks;
    using System.Web.Http;
    using SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.Framework.Logging;
    
    //TODO: candidate for common, if so use CommonLoggingEventId instead
    // might rename if responsibilities increase

    public class AllocationDeliveryServiceEventLoggingId
    {
        public const int ServerError = LoggingEventId.AllocationDeliveryService;
    }

    public sealed class LoggingExceptionFilterAttribute : ExceptionFilterAttribute
    {
        //public override async Task OnExceptionAsync(HttpActionExecutedContext context, CancellationToken cancellationToken)
        //{
        //}

        public override void OnException(HttpActionExecutedContext context)
        {
            // web.api bug workaround: sometimes the exceptionfilter is incorrectly triggered (especially, but not always, when the action return IHttpActionResult)
            // so we look out for that scenario here, and pass through the HttpResponseException's response
            var httpResponseException = context.Exception as HttpResponseException;
            if (httpResponseException != null)
            {
                context.Response = httpResponseException.Response;
                return;
            }

            //TODO: need to sort out logging, i.e. set up tracelistener so that it logs to file? where should it log to?
            // to pick up the dependency, we probably need to switch from this...
            // http://blog.ploeh.dk/2012/10/03/DependencyInjectioninASP.NETWebAPIwithCastleWindsor/
            // to setting the dependency resolver...
            // http://www.artisancode.co.uk/2014/04/integrating-windsor-castle-web-api/
            // http://stackoverflow.com/questions/19905186/dependency-injection-in-webapi-with-castle-windsor
            // unless we just create the logger for simplicities sake

            var logger = new Logger(new TraceSource("AllocationDeliveryService"));

            //var logger = (ILogger)context.ActionContext.ControllerContext.Configuration.DependencyResolver.GetService(typeof(ILogger));
            if (logger != null)
                logger.LogError(AllocationDeliveryServiceEventLoggingId.ServerError, context.Exception, "Uncaught exception processing action");

            context.Response = new HttpResponseMessage(HttpStatusCode.InternalServerError);
        }
    }
}