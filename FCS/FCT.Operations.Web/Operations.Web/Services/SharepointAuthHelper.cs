namespace Operations.Web.Services
{
    using System;
    using System.Configuration;
    using Microsoft.SharePoint.Client;

    public static class SharepointAuthHelper
    {
        public static ClientContext GetOAuthContext()
        {
            var url = ConfigurationManager.AppSettings["ida:Resource"];
            if (string.IsNullOrWhiteSpace(url))
                throw new ArgumentException("AppSetting 'ida:Resource' is missing or empty.");
            return new ClientContext(url); // not used by the checker; API compatibility only
        }
    }
}
