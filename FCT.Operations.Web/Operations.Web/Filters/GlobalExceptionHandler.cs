namespace Operations.Web.Filters
{
    using System.Net;
    using System.Net.Http;
    using System.Threading;
    using System.Threading.Tasks;
    using System.Web.Http;
    using System.Web.Http.ExceptionHandling;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class GlobalExceptionHandler : ExceptionHandler
    {
        private readonly ILogger _logger;

        public GlobalExceptionHandler(ILogger logger)
        {
            _logger = logger;
        }

        public override Task HandleAsync(ExceptionHandlerContext context, CancellationToken cancellationToken)
        {
            // Log the exception
            _logger.LogError(1,context.Exception, "An unhandled exception occurred.");

            // Return a generic error response
            context.Result = new InternalServerErrorResult(context.Request, "An unexpected error occurred. Please try again later.");
            return Task.CompletedTask;
        }
    }

    public class InternalServerErrorResult : IHttpActionResult
    {
        private readonly HttpRequestMessage _request;
        private readonly string _message;

        public InternalServerErrorResult(HttpRequestMessage request, string message)
        {
            _request = request;
            _message = message;
        }

        public Task<HttpResponseMessage> ExecuteAsync(CancellationToken cancellationToken)
        {
            var response = _request.CreateErrorResponse(HttpStatusCode.InternalServerError, _message);
            return Task.FromResult(response);
        }
    }
}