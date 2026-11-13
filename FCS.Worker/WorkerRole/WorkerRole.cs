using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Configuration;
using NServiceBus;
using WorkerRole;
using System.Diagnostics;
using System.Net;
using System.Threading;
using System.Threading.Tasks;
using SFA.FCT.Framework.Logging;
using SFA.FCT.Framework.Logging.Bespoke;
using SFA.FCT.Framework.Logging.Interfaces;


public class Worker : IHostedService
{
     private readonly IConfiguration _config;
    private ILoggerFactory _loggerFactory;
    private ILogger _logger;

    private IReadOnlyCollection<IEndpointInstance> _endpoints;

    public Worker(ILoggerFactory loggerFactory, IConfiguration config)
    {
        _loggerFactory = loggerFactory  ;
        _config = config;
    }

    public async Task StartAsync(CancellationToken cancellationToken)
    {
        _logger.LogInformation("Starting NServiceBus endpoints...");


        //var customLogger = new LoggerWrapper(_logger);
        _endpoints = await Bootstrapper.Start(_config, GetLogger());
//        Bootstrapper.Start(GetLoggerFactory(), GetLogger()).Wait();
            

        _logger.LogInformation("All endpoints started");
    }
    private ILogger GetLogger()
    {
        return _logger ?? (_logger = _logger = GetLoggerFactory().CreateLogger("WorkerRole"));
    }

    private ILoggerFactory GetLoggerFactory()
    {
        return _loggerFactory ?? (_loggerFactory = new LoggerFactory());
    }


    public async Task StopAsync(CancellationToken cancellationToken)
    {
        _logger.LogInformation("Stopping endpoints");

        foreach (var ep in _endpoints)
        {
            await ep.Stop();
        }
    }
}
