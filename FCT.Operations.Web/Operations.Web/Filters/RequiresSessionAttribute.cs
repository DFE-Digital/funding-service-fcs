namespace Operations.Web.Filters
{
    using System;
    using System.Linq;
    using System.Net;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using System.Threading;
    using System.Threading.Tasks;
    using System.Web.Http.Controllers;
    using System.Web.Http.Filters;
    using DataStore;
    using DataStore.Repositories;

    public class RequiresSessionAttribute : AuthorizationFilterAttribute
    {
        public const string SessionTokenName = "session-token";

        public override async Task OnAuthorizationAsync(HttpActionContext actionContext, CancellationToken cancellationToken)
        {
            HttpRequestHeaders requestHeaders = actionContext.Request.Headers;
            string sessionTokenHeaderValue = GetHeaderSessionToken(requestHeaders);

            using (var operationsContext = new OperationsDbContext())
            {
                var sessionRepository = new SessionRepository(operationsContext);
                if (sessionTokenHeaderValue == null ||
                !IsSessionTokenPresentInCookies(requestHeaders, sessionTokenHeaderValue)
                || !await sessionRepository.IsSessionPresentAsync(Guid.Parse(sessionTokenHeaderValue)))
                {
                    actionContext.Response = actionContext.Request.CreateResponse(HttpStatusCode.Unauthorized);
                }
            }
            
        }

        private static string GetHeaderSessionToken(HttpRequestHeaders requestHeaders)
        {
            return requestHeaders.Authorization?.Parameter;
        }

        private static bool IsSessionTokenPresentInCookies(HttpRequestHeaders requestHeaders, string sessionToken)
        {
            return requestHeaders.GetCookies().Any(c => c[SessionTokenName].Value == sessionToken);
        }
    }
}