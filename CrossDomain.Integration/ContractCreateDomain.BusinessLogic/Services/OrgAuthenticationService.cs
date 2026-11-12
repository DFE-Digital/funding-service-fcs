
using System.Configuration;
using System.Globalization;
using System.Security.Authentication;
using System.Threading.Tasks;
using Microsoft.Identity.Client; // MSAL

namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Services
{
    public static class OrgAuthenticationService
    {
        private static readonly string AadInstance = ConfigurationManager.AppSettings["ida:AADInstance_OrgService"];  // e.g. "https://login.microsoftonline.com/{0}/"
        private static readonly string Tenant = ConfigurationManager.AppSettings["ida:Tenant_OrgService"];         // e.g. "<tenant-id-or-name>"
        private static readonly string ClientId = ConfigurationManager.AppSettings["ida:ClientId_OrgService"];
        private static readonly string ClientSecret = ConfigurationManager.AppSettings["ida:AppKey_OrgService"];       // same value as AppKey
        private static readonly string ResourceId = ConfigurationManager.AppSettings["ida:ResourceId_OrgService"];    // e.g. "https://graph.microsoft.com" or "api://<app-id>"

        /// <summary>
        /// Acquires an app-only access token using MSAL client credentials flow.
        /// Returns MSAL's AuthenticationResult (access token, expiry, etc.).
        /// </summary>
        public static async Task<AuthenticationResult> GetAuthenticationResultAsync()
        {
            // Build a tenant-specific authority (avoid "common"/"organizations")
            var authority = string.Format(CultureInfo.InvariantCulture, AadInstance, Tenant);

            // Build a confidential client (keep this as a singleton in a real app to leverage token caching)
            var app = ConfidentialClientApplicationBuilder
                .Create(ClientId)
                .WithClientSecret(ClientSecret)   // or .WithCertificate(cert)
                .WithAuthority(authority)
                .Build();

            // For client credentials, always request {resource}/.default
            // e.g. "https://graph.microsoft.com/.default" or "api://<app-id>/.default"
            var scopes = new[] { $"{ResourceId}/.default" };

            // Retry a few times on transient errors
            for (int attempt = 0; attempt < 3; attempt++)
            {
                try
                {
                    return await app.AcquireTokenForClient(scopes)
                                    .ExecuteAsync()
                                    .ConfigureAwait(false);
                }
                catch (MsalServiceException ex) when (IsTransient(ex) && attempt < 2)
                {
                    // Backoff: 3 seconds like your original code
                    await Task.Delay(3000).ConfigureAwait(false);
                }
            }

            throw new AuthenticationException("Could not acquire an application token with MSAL after several attempts.");
        }

        private static bool IsTransient(MsalServiceException ex)
            => ex.ErrorCode == "temporarily_unavailable" || ex.StatusCode is 429 or >= 500;
    }
}
