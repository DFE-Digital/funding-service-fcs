
namespace ADMonitoringDomain.Endpoint
{
    using System;
    using System.Threading;
    using System.Threading.Tasks;
    using Castle.Windsor;
    using Castle.Windsor.MsDependencyInjection;
    using Microsoft.Extensions.DependencyInjection;
    using Microsoft.Extensions.Logging;
    using NServiceBus;

    public static class EndpointRunner
    {
        public static async Task<IEndpointInstance> StartAsync(
            EndpointConfig endpointConfig,
            ILoggerFactory loggerFactory,
            CancellationToken cancellationToken = default)
        {
            var endpointConfiguration =
                endpointConfig.GetEndpointConfiguration(loggerFactory);

            var services = new ServiceCollection();

            var startable =
                EndpointWithExternallyManagedContainer.Create(endpointConfiguration, services);

            var windsor = new WindsorContainer()
                .Install(new ADMonitoringDomain.Endpoint.Ioc.WindsorInstaller(loggerFactory));

            IServiceProvider serviceProvider =
                WindsorRegistrationHelper.CreateServiceProvider(windsor, services);

            var endpoint =
                await startable.Start(serviceProvider).ConfigureAwait(false);

            if (cancellationToken.CanBeCanceled)
            {
                cancellationToken.Register(async () =>
                {
                    try { await endpoint.Stop().ConfigureAwait(false); }
                    finally { windsor.Dispose(); }
                });
            }

            return endpoint;
        }

        public static async Task StopAsync(IEndpointInstance endpoint, IWindsorContainer windsor)
        {
            try { await endpoint.Stop().ConfigureAwait(false); }
            finally { windsor?.Dispose(); }
        }
    }
}
