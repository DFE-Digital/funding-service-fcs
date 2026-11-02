namespace Operations.Web.Filters
{
    using System.Net;
    using System.Net.Http;
    using System.Web.Http.Filters;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class CustomExceptionFilter : ExceptionFilterAttribute
    {
        private readonly ILogger _logger;

        public CustomExceptionFilter(ILogger logger)
        {
            _logger = logger;
        }

        public override void OnException(HttpActionExecutedContext context)
        {
            // Log the exception
            _logger.LogError(1,context.Exception, "An unhandled exception occurred.");

            // Return a generic error response
            context.Response = context.Request.CreateErrorResponse(HttpStatusCode.InternalServerError, "An unexpected error occurred. Please try again later.");
        }
    }
}