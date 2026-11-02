namespace SFA.FCT.FundingPolicyDomain.Attributes
{
    using System.Net;
    using System.Net.Http;
    using System.Security.Claims;
    using System.Web.Http;
    using System.Web.Http.Controllers;
    using System.Web.Http.Filters;

    public class SecureResourceAttribute : AuthorizationFilterAttribute
    {
        public override void OnAuthorization(HttpActionContext actionContext)
        {
            var authorizeHeader = actionContext.Request.Headers.Authorization;
            if (authorizeHeader != null)
            {
                Claim scopeClaim = ClaimsPrincipal.Current.FindFirst("http://schemas.microsoft.com/identity/claims/scope");
                if (scopeClaim != null)
                {
                    if (scopeClaim.Value != "user_impersonation")
                    {
                        throw new HttpResponseException(new HttpResponseMessage { StatusCode = HttpStatusCode.Unauthorized, ReasonPhrase = "The Scope claim does not contain 'user_impersonation' or scope claim not found" });
                    }
                }

                Claim subject = ClaimsPrincipal.Current.FindFirst(ClaimTypes.NameIdentifier);
                return;
            }

            actionContext.Response = actionContext.Request.CreateResponse(HttpStatusCode.Unauthorized);
            actionContext.Response.Content = new StringContent("Invalid credentials");
        }
    }
}