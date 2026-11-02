using Microsoft.Owin;

[assembly: OwinStartup(typeof(OrganisationDomain.Web.Startup))]
namespace OrganisationDomain.Web
{
    using System.Configuration;
    using System.IdentityModel.Tokens;
    using Microsoft.Owin.Security.ActiveDirectory;
    using Owin;

    public class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            app.UseWindowsAzureActiveDirectoryBearerAuthentication(new WindowsAzureActiveDirectoryBearerAuthenticationOptions
            {
                Tenant = ConfigurationManager.AppSettings["ida:Tenant"],
                TokenValidationParameters = new TokenValidationParameters
                {
                    ValidAudience = ConfigurationManager.AppSettings["ida:Audience"]
                }
            });
        }
    }
}
