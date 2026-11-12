
using System.Diagnostics.Contracts;
using SFA.FCT.Framework.Logging.Interfaces;

namespace SFA.FCT.CrossDomain.Integration.Common
{
    /// <summary>
    /// Provides a base abstract implementation of the <see cref="AsA_FctEndpoint"/> interface.
    /// Use this if you want some plumbing work done for you, implement the interface <see cref="AsA_FctEndpoint"/>
    /// directly if you want full control.
    /// </summary>
    public abstract class BaseFctEndpointConfiguration : AsA_FctEndpoint
    {
        private string _endpointName;

        /// <summary>
        /// Gets the endpoint name for this endpoint configuration.
        /// </summary>
        public string EndpointName => EndpointNameWithContract;

        private string EndpointNameWithContract
        {
            get
            {
                Contract.Requires(GetType().Namespace != null, "Do not write classes without namespaces.");
                return _endpointName ?? (_endpointName = GetType().Namespace.Split('.').Last());
            }
        }

        public EndpointConfiguration Customize(ILoggerFactory loggerFactory)
        {
            var endpointConfiguration = new EndpointConfiguration(EndpointName);

            // Example transport and persistence setup (replace with actual transport/persistence)
            var transport = new LearningTransport();
            var routing = endpointConfiguration.UseTransport(transport);
            endpointConfiguration.UsePersistence<LearningPersistence>();

            // Convention definitions
            var conventions = endpointConfiguration.Conventions();
            conventions.DefiningCommandsAs(t => t.Namespace != null && t.Namespace.Contains(EndpointName));
            conventions.DefiningEventsAs(t => t.Namespace != null && t.Namespace.Contains(EndpointName));
            conventions.DefiningMessagesAs(t => t.Namespace != null && t.Namespace.Contains(EndpointName));

            // Additional configuration
            endpointConfiguration.SendFailedMessagesTo("error");
            endpointConfiguration.AuditProcessedMessagesTo("audit");
            endpointConfiguration.EnableInstallers();

            var recoverability = endpointConfiguration.Recoverability();


            recoverability.CustomPolicy((config, errorContext) =>
            {
                // Your custom logic here
                return RecoverabilityAction.MoveToError(config.Failed.ErrorQueue);
            });

            recoverability.CustomPolicy((config, errorContext) =>
            {              
                // Log or inspect headers, then decide what to do
                return RecoverabilityAction.MoveToError(config.Failed.ErrorQueue);
            });

            return endpointConfiguration;
        }

    }
}
