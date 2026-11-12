namespace SFA.FCT.CrossDomain.Integration.Common
{
    using System.Diagnostics.CodeAnalysis;
    using Framework.Logging.Interfaces;
    using Microsoft.IdentityModel.Tokens;
    using NServiceBus;

    /// <summary>
    /// Provides a class contract that defines a NServiceBus endpoint in the FCT world.
    /// </summary>

    [SuppressMessage("StyleCop.CSharp.NamingRules", "SA1302:InterfaceNamesMustBeginWithI", Justification = "Follows NServiceBus standards.")]
    public interface AsA_FctEndpoint
    {
        /// <summary>
        /// Allows overriding default NServiceBus FCT settings.
        /// </summary>
        /// <param name="loggerFactory">ILoggerFactory implementation</param>
        /// <returns>Configured EndpointConfiguration instance</returns>
        EndpointConfiguration Customize(ILoggerFactory loggerFactory);
    }

}
