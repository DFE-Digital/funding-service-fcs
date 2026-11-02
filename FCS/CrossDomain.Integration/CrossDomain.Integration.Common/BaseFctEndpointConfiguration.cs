namespace SFA.FCT.CrossDomain.Integration.Common
{
    using System.Diagnostics.Contracts;
    using System.Linq;
    using Framework.Logging.Interfaces;
    using NServiceBus;

    /// <summary>
    /// Provides a base abstract implementation of the <see cref="AsA_FctEndpoint"/> interface.
    /// Use this if you want some plumbing work done for you, implement the interface <see cref="AsA_FctEndpoint"/>
    /// directly if you want full control.
    /// </summary>
    public abstract class BaseFctEndpointConfiguration : AsA_FctEndpoint
    {
        private string _endointName;

        /// <summary>
        /// Gets the endpoint name for this endpoint configuration.
        /// </summary>
        public string EndpointName
        {
            get
            {
                return EndpointNameWithContract;
            }
        }

        /// <summary>
        /// I can't have a code contract on an interface implementation, and I want to do a contract validation
        /// on the endpoint name to make sure that we didn't had a scrub writing a class inheriting from this
        /// without a namespace, so this is a private non-interface implementation wrapper of the public one.
        /// </summary>
        private string EndpointNameWithContract
        {
            get
            {
                Contract.Requires(GetType().Namespace != null, "Do not write classes without namespaces.");

                return _endointName ??
                       (_endointName = GetType().Namespace.Split('.').Last());
            }
        }

        /// <summary>
        /// Allows to override default NServiceBus FCT settings.
        /// 
        /// </summary>
        /// <param name="configuration">Endpoint configuration builder.</param>
        /// <param name="loggerFactory"></param>
        /// <remarks>
        /// The Azure Worker role in this solution is overriding some of the settings defined here.
        /// You need to check which ones so that you know once deployed what actually is overriden or not.
        /// </remarks>
        public virtual void Customize(BusConfiguration configuration, ILoggerFactory loggerFactory)
        {
            configuration.EndpointName(EndpointName);

            configuration.Conventions()
                         .DefiningCommandsAs(t => t.Namespace != null && t.Namespace.Contains(EndpointName))
                         .DefiningEventsAs(t => t.Namespace != null && t.Namespace.Contains(EndpointName))
                         .DefiningMessagesAs(t => t.Namespace != null && t.Namespace.Contains(EndpointName));
        }
    }
}
