namespace SFA.FCT.ContractManagementService
{
    using Framework.Logging;
    using Framework.Logging.Bespoke;
    using Framework.Logging.Interfaces;
    using global::ContractManagementService;
    using global::ContractManagementService.AtomFeed;
    using global::ContractManagementService.Infrastructure;
    using IoC;
    using Microsoft.AspNetCore.Authentication;
    using Microsoft.AspNetCore.Authentication.AzureAD.UI;
    using Microsoft.AspNetCore.Authorization;
    using Microsoft.AspNetCore.Builder;
    using Microsoft.AspNetCore.Diagnostics;
    using Microsoft.AspNetCore.Hosting;
    using Microsoft.AspNetCore.Http;
    using Microsoft.AspNetCore.Http.Extensions;
    using Microsoft.AspNetCore.Mvc;
    using Microsoft.AspNetCore.Mvc.Authorization;
    using Microsoft.Extensions.Configuration;
    using Microsoft.Extensions.DependencyInjection;
    using Microsoft.Extensions.Hosting;
    using Microsoft.Extensions.Primitives;
    using Polly;
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Net;
    using System.Threading.Tasks;

    public class Startup
    {
        private readonly IConfiguration _configuration;
        private ILogger _logger;

        public Startup(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        public void ConfigureServices(IServiceCollection services)
        {
            var logger = GetLogger();

            logger.LogInformation("Starting ContractManagement Web Service Core");
            
            try
            {
                services.AddAuthentication(AzureADDefaults.JwtBearerAuthenticationScheme)
                    .AddAzureADBearer(options => _configuration.Bind("AzureAd", options));

                services.AddControllersWithViews(options =>
                {
                    var policy = new AuthorizationPolicyBuilder()
                        .RequireAuthenticatedUser()
                        .Build();
                    options.Filters.Add(new AuthorizeFilter(policy));
                });

                new IoCSetup(logger).Register(services, _configuration);

                services.AddControllers(options =>
                    {
                        options.OutputFormatters.Add(new AtomOutputFormatter());
                    })
                    .AddXmlSerializerFormatters()
                    .SetCompatibilityVersion(CompatibilityVersion.Latest)
                    .AddXmlDataContractSerializerFormatters();
            }
            catch (Exception e)
            {
                logger.LogInformation(1, $"Failed to start ContractManagement Web Service - {e.Message}, {e.StackTrace}");
                throw;
            }
            
            logger.LogInformation("Started ContractManagement Web Service");
        }

        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
                var debugConfigView = (_configuration as IConfigurationRoot).GetDebugView();
                var logger = GetLogger();
                logger.LogInformation($"Config: {debugConfigView}");
            }

            app.UseAuthentication();
            app.UseRouting();
            app.UseAuthorization();
            AtomMediaTypeFilterHandler.AtomUrlPortions.ToList().ForEach(atomUrl =>
            {
                app.MapWhen(IsAtomUrlWithoutAtomHeader, RejectAtomUrlCall);
            });
            app.UseExceptionHandler(exceptionHandlerApp =>
            {
                exceptionHandlerApp.Run(async context =>
                {
                    context.Response.StatusCode = StatusCodes.Status500InternalServerError;

                    await context.Response.WriteAsync("An exception was thrown.");

                    var exceptionHandlerPathFeature =
                        context.Features.Get<IExceptionHandlerPathFeature>();
                    GetLogger().LogError(1, $"FctServices exception, path: {exceptionHandlerPathFeature.Path}, message: {exceptionHandlerPathFeature.Error.Message}, stack: {exceptionHandlerPathFeature.Error.StackTrace}");
                });
            });

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();
                endpoints.MapGet("/", async context =>
                {
                    await context.Response.WriteAsync("Hello World!");
                });
            });

        }

        private void RejectAtomUrlCall(IApplicationBuilder applicationBuilder)
        {
            applicationBuilder.Run( context =>
            {
                context.Response.StatusCode = (int) HttpStatusCode.UnsupportedMediaType;

                return Task.CompletedTask;
            });
        }

        private static bool IsAtomUrlWithoutAtomHeader(HttpContext context)
        {
            var url = context.Request.GetEncodedUrl();
            var isAtomUrl = AtomMediaTypeFilterHandler.AtomUrlPortions.ToList()
                .Any(atomUrl => url.ToLower().Contains(atomUrl.ToLower()));
            
            if (isAtomUrl)
            {
                var isAtomHeaderPresent = context.Request.Headers["Accept"].Any(acceptHeaderValue =>
                    AtomMediaTypeFilterHandler.SupportedMediaTypes.Contains(acceptHeaderValue.ToUpper()));

                return !isAtomHeaderPresent;
            }

            return false;
        }

        private ILoggerFactory GetLoggerFactory()
        {
            return new LoggerFactory(
                new AppServiceEnvironment(
                    Environment.GetEnvironmentVariable("WEBSITE_SITE_NAME"),
                    Environment.GetEnvironmentVariable("WEBSITE_INSTANCE_ID")?.Substring(0, 6),
                    _configuration["DeploymentId"]));
        }

        private ILogger GetLogger()
        {
            if (_logger == null)
            {
                var storageConnectionString = _configuration["ConnectionStrings:StorageConnectionString"];
                _logger = GetLoggerFactory().CreateDefaultLogger(
                    storageConnectionString,
                    new NetCoreCloudEnvironment(new ConfigRoot(_configuration), GetRoleId()), le =>
                    {
                        try
                        {
                            Policy.Handle<Exception>()
                                .WaitAndRetry(1, count => TimeSpan.FromSeconds(1))
                                .Execute(() => AzureStorageTable.CreateRowInAzure(le, storageConnectionString));
                        }
                        catch (Exception e)
                        {
                            Console.WriteLine($"CreateRowInAzure - error: {e.Message}, {e.StackTrace}");
                        }
                    });
            }

            return _logger;
        }

        private static string GetRoleId()
        {
            string roleId = Environment.GetEnvironmentVariable("WEBSITE_INSTANCE_ID")?.Substring(0, 6);

            if (string.IsNullOrEmpty(roleId))
            {
                return "local_machine";
            }

            return roleId;
        }

        private class ConfigRoot : IConfigurationRoot
        {
            private readonly IConfiguration _configuration;

            public ConfigRoot(IConfiguration configuration)
            {
                _configuration = configuration;
            }


            public IConfigurationSection GetSection(string key)
            {
                throw new NotImplementedException();
            }

            public IEnumerable<IConfigurationSection> GetChildren()
            {
                throw new NotImplementedException();
            }

            public IChangeToken GetReloadToken()
            {
                throw new NotImplementedException();
            }

            public string this[string key]
            {
                get => _configuration[key];
                set => throw new NotImplementedException();
            }

            public void Reload()
            {
                throw new NotImplementedException();
            }

            public IEnumerable<IConfigurationProvider> Providers { get; }
        }
    }
}