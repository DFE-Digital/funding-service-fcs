namespace SFA.FCT.CrossDomain.Integration.Common
{
    using System.Diagnostics.CodeAnalysis;
    using Framework.Logging.Interfaces;
    using NServiceBus;

    /// <summary>
    /// Provides a class contract that defines a NServiceBus endpoint in the FCT world.
    /// </summary>
    [SuppressMessage("StyleCop.CSharp.NamingRules", "SA1302:InterfaceNamesMustBeginWithI", Justification = "Follows NServiceBus standards.")]
    public interface AsA_FctEndpoint
    {
        /// <summary>
        /// Allows to override default NServiceBus FCT settings.
        /// 
        /// </summary>
        /// <param name="configuration">Endpoint configuration builder.</param>
        /// <param name="loggerFactory">ILoggerFactory implementation</param>
        /// <remarks>
        /// The Azure Worker role in this solution is overriding some of the settings defined here.
        /// You need to check which ones so that you know once deployed what actually is overriden or not.
        /// </remarks>
        void Customize(BusConfiguration configuration, ILoggerFactory loggerFactory);
    }
}
