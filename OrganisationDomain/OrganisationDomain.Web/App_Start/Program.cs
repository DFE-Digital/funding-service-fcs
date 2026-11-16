using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Builder;
using Microsoft.IdentityModel.Tokens;
using Microsoft.Extensions.DependencyInjection;

namespace OrganisationDomain.Web.App_Start
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);

            builder.Services.AddControllers();

            builder.Services
                .AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
                .AddJwtBearer(options =>
                {
                    options.Authority =
                        $"https://login.microsoftonline.com/{builder.Configuration["AzureAd:TenantId"]}/v2.0";

                    options.TokenValidationParameters =
                        new TokenValidationParameters
                        {
                            ValidateAudience = true,
                            ValidAudience = builder.Configuration["AzureAd:Audience"]
                        };
                });

            builder.Services.AddAuthorization();

            var app = builder.Build();

            app.UseAuthentication();
            app.UseAuthorization();

            app.MapControllers();

            app.Run();
        }
    }
}
