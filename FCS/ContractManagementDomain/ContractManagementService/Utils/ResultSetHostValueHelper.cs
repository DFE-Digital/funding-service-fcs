namespace SFA.FCT.ContractManagementService.Utils
{
    using System.Linq;
    using Microsoft.AspNetCore.Http;

    public static class ResultSetHostValueHelper
    {
        private const string RequestHostHeader = "X-Request-Host";
        private const string RequestSchemeHeader = "X-Request-Scheme";

        /// <summary>
        /// If the request has been forwarded by a correctly configured reverse proxy the above two headers will have been added
        /// to the request and will host the scheme and host from the original request.  This allows a single instance of fct-services
        /// to appear as multiple instances using different hostnames.  This is being used for the migration between different hosts to
        /// avoid the longer term issue of having multiple instances running causing issues with the build.
        /// </summary>
        public static string SchemeAndHostValue(HttpRequest request, string configValue)
        {
            string schemeAndHost;
           
            if (ShouldUseValuesFromHeaders(request))
            {
                var scheme = request.Headers[RequestSchemeHeader].First();
                var hostname = request.Headers[RequestHostHeader].First();

                schemeAndHost = scheme + "://" + hostname;
            }
            else
            {
                schemeAndHost = configValue;
            }

            return schemeAndHost;
        }

        private static bool ShouldUseValuesFromHeaders(HttpRequest request)
        {
            return 
                request?.Headers != null &&
                request.Headers.Keys.Contains(RequestHostHeader) &&
                request.Headers.Keys.Contains(RequestSchemeHeader);
        }
    }
}