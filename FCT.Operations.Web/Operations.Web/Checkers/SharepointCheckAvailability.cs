
namespace Operations.Web.Checkers
{
    using System;
    using System.Configuration;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using System.Threading.Tasks;
    using Microsoft.SharePoint.Client; // kept to preserve the delegate type
    using Newtonsoft.Json.Linq;
    using Operations.Web.Dtos;
    using Operations.Web.Services;
    using Polly;

    public class SharepointCheckAvailability : ICheckAvailability
    {
        // Preserve original signature so callers don't change
        private readonly Func<ClientContext> _getSharepointContext;
        private static readonly HttpClient HttpClient = new HttpClient();

        public SharepointCheckAvailability(Func<ClientContext> getSharepointContext, string serviceName)
        {
            _getSharepointContext = getSharepointContext; // Not used in Graph path
            ServiceName = serviceName;
        }

        public string ServiceName { get; }

        public Task<AvailabilityCheckResult> GetCheckResult()
        {
            try
            {               
                string siteUrl = ConfigurationManager.AppSettings["ida:Resource"];
                if (string.IsNullOrWhiteSpace(siteUrl))
                    throw new ArgumentException("AppSetting 'ida:Resource' is missing or empty.");

                string hostname;
                string sitePath;
                ParseSharePointUrl(siteUrl, out hostname, out sitePath);

                // Acquire Graph token
                string token = GraphTokenProvider.GetAccessToken();

                // Minimal, fast health probe: resolve the site (proves Graph + permissions + site reachability)
                string url = "https://graph.microsoft.com/v1.0/sites/" + hostname + ":/sites/" + sitePath + "?$select=id,webUrl,displayName";

                var req = new HttpRequestMessage(HttpMethod.Get, url);
                req.Headers.Authorization = new AuthenticationHeaderValue("Bearer", token);
                req.Headers.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));

                using (var resp = ExecuteWithRetry(delegate { return HttpClient.SendAsync(req).Result; }))
                {
                    string raw = resp.Content.ReadAsStringAsync().Result;

                    if (!resp.IsSuccessStatusCode)
                    {
                        int status = (int)resp.StatusCode;
                        string reason = resp.ReasonPhrase;
                        return Task.FromResult(new AvailabilityCheckResult(ServiceName, false)
                        {
                            Details = "Graph site probe failed. HTTP " + status + " " + reason + ". Body: " + raw
                        });
                    }

                    JObject site = JObject.Parse(raw);
                    string siteId = site["id"] != null ? (string)site["id"] : null;
                    string webUrl = site["webUrl"] != null ? (string)site["webUrl"] : null;
                    string name = site["displayName"] != null ? (string)site["displayName"] : null;

                    return Task.FromResult(new AvailabilityCheckResult(ServiceName, true)
                    {
                        SupplementaryInfo = "SiteId=" + siteId + "; Name=" + name + "; WebUrl=" + webUrl
                    });
                }
            }
            catch (Exception ex)
            {
                return Task.FromResult(new AvailabilityCheckResult(ServiceName, false) { Details = ex.Message });
            }
        }
        private static HttpResponseMessage ExecuteWithRetry(Func<HttpResponseMessage> action)
        {
            return Policy
                .HandleResult<HttpResponseMessage>(r =>
                    (int)r.StatusCode == 429 || (int)r.StatusCode == 503 || (int)r.StatusCode == 504)
                .WaitAndRetry(
                    retryCount: 3,
                    sleepDurationProvider: attempt => TimeSpan.FromSeconds(Math.Min(10, attempt * 2))
                )
                .Execute(action);
        }

        private static void ParseSharePointUrl(string absoluteSiteUrl, out string hostname, out string sitePath)
        {
            if (string.IsNullOrWhiteSpace(absoluteSiteUrl))
                throw new ArgumentException("AppSetting 'ida:Resource' is missing (expected SharePoint site URL).");

            Uri uri;
            if (!Uri.TryCreate(absoluteSiteUrl, UriKind.Absolute, out uri))
                throw new ArgumentException("ida:Resource must be an absolute SharePoint URL.");

            hostname = uri.Host; // e.g., xxx.sharepoint.com

            // Extract part after "/sites/"
            string localPath = uri.AbsolutePath; // e.g., /sites/fcs-dat or /sites/fcs-dat/sub
            string marker = "/sites/";
            int idx = localPath.IndexOf(marker, StringComparison.OrdinalIgnoreCase);
            if (idx < 0 || idx + marker.Length >= localPath.Length)
                throw new ArgumentException("ida:Resource must point to a path under /sites/{sitePath}.");

            sitePath = localPath.Substring(idx + marker.Length).Trim('/');
        }
    }
}
