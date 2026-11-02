
namespace SFA.FCT.CrossDomain.Integration.Common.Storage.Office365Helpers
{
    using System;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using Polly;
   
    public static class AuthenticationHelper
    {
       public static HttpClient EnsureClient()
        {
            string token = GetGraphAccessTokenWithRetry();

            var http = new HttpClient();
            http.DefaultRequestHeaders.Authorization =
                new AuthenticationHeaderValue("Bearer", token);
            http.DefaultRequestHeaders.Accept.ParseAdd("application/json");
            return http;
        }

        private static string GetGraphAccessTokenWithRetry()
        {
            return Policy
                .Handle<Exception>(delegate { return true; })
                .WaitAndRetry(
                    retryCount: 5,
                    sleepDurationProvider: delegate (int _) { return TimeSpan.FromSeconds(3); },
                    // Use the 3-parameter onRetry to avoid Polly overload ambiguity
                    onRetry: delegate (Exception ex, TimeSpan ts, Context ctx)
                    {
                        // Clear token cache before next attempt
                        SharepointOAuthAccessTokenFactory.ClearCache();
                    })
                .Execute(SharepointOAuthAccessTokenFactory.GetAccessToken);
        }
    }
}
