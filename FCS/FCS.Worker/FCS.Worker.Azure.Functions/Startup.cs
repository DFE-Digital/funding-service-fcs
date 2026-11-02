using Microsoft.Azure.Functions.Extensions.DependencyInjection;
using Microsoft.Extensions.DependencyInjection;
using FCS.Worker.Azure.Functions.Services;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Configuration;
using System.Xml.Linq;
using Microsoft.VisualBasic.FileIO;


[assembly: FunctionsStartup(typeof(FCS.Worker.Azure.Functions.Startup))]
namespace FCS.Worker.Azure.Functions
{
    public class Startup : FunctionsStartup
    {
        public override void Configure(IFunctionsHostBuilder builder)
        {
            builder.Services.AddSingleton<IBlobService, BlobService>();

            builder.Services.AddOptions<FCTOptions>()
    .Configure<IConfiguration>((settings, configuration) =>
    {
        configuration.GetSection("FCTOptions").Bind(settings);
    });

            builder.Services.AddSingleton<Microsoft.Extensions.Logging.ILogger>(provider =>
   provider.GetRequiredService<Microsoft.Extensions.Logging.ILogger<UploadDocumentFun>>());
           


        }
    }
}
