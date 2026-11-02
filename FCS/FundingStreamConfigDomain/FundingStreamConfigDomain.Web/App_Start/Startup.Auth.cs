using Microsoft.Owin;

[assembly: OwinStartup(typeof(SFA.FCT.FundingPolicyDomain.Startup))]

namespace SFA.FCT.FundingPolicyDomain
{
    using System.IdentityModel.Tokens;
    using System.Configuration;
    using Microsoft.Owin.Security.ActiveDirectory;
    using Owin;

    public class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            // For more information on how to configure your application, visit http://go.microsoft.com/fwlink/?LinkID=316888
            AddBearerAuthenticationOptions(app);
        }

        // For more information on configuring authentication, please visit http://go.microsoft.com/fwlink/?LinkId=301864
        private static void AddBearerAuthenticationOptions(IAppBuilder app)
        {
            app.UseWindowsAzureActiveDirectoryBearerAuthentication(
                new WindowsAzureActiveDirectoryBearerAuthenticationOptions
                {
                    TokenValidationParameters = new TokenValidationParameters
                    {
                        ValidAudience = ConfigurationManager.AppSettings["ida:Audience"]
                    },
                    Tenant = ConfigurationManager.AppSettings["ida:Tenant"]
                });
        }
    }
}