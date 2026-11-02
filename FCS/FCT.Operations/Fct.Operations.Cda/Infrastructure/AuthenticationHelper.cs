
namespace FCT.Operations.Cda.Infrastructure
{   
    using Polly;
    using System;
    using System.Net.Http;
    using System.Net.Http.Headers;
        
    public class AuthenticationHelper : IAuthenticationHelper
    {
        private readonly ISharepointOAuthAccessTokenFactory _accessTokenFactory;

        public AuthenticationHelper(ISharepointOAuthAccessTokenFactory accessTokenFactory)
        {
            _accessTokenFactory = accessTokenFactory ?? throw new ArgumentNullException(nameof(accessTokenFactory));
        }
        public HttpClient EnsureClient(string url)
        {
            // (Optional) Validate the URL format; we don't use it directly here.
            if (string.IsNullOrWhiteSpace(url))
                throw new ArgumentException("Site URL must be provided (e.g., ida:Resource).", nameof(url));

            // Acquire token (with retry & cache clear on retry)
            var token = GetAccessTokenWithRetry();

            var http = new HttpClient();
            http.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);
            http.DefaultRequestHeaders.Accept.ParseAdd("application/json");

            return http;
        }

        private string GetAccessTokenWithRetry()
        {
            // Use 3-parameter onRetry to avoid Polly overload ambiguity in v7
            return Policy
                .Handle<Exception>(delegate { return true; })
                .WaitAndRetry(
                    retryCount: 5,
                    sleepDurationProvider: delegate (int _) { return TimeSpan.FromSeconds(3); },
                    onRetry: delegate (Exception ex, TimeSpan _, Context __)
                    {
                        // Clear token cache before the next attempt
                        _accessTokenFactory.ClearCache();
                    })
                .Execute(_accessTokenFactory.GetAccessToken);
        }
    }
}
