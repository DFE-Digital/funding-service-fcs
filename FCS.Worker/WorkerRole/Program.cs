using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using System.Net;
  

public class Program
{
    public static async Task Main(string[] args)
    {
        ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12;

        var builder = Host.CreateApplicationBuilder(args);

        builder.Services.AddHostedService<Worker>();

        builder.Logging.ClearProviders();
        builder.Logging.AddConsole();
        builder.Logging.AddDebug();

        var host = builder.Build();

        await host.RunAsync();
    }
}
