namespace SFA.FCT.FCTDebugHost.Tests
{
    using System;
    using CrossDomain.Integration.Common;
    using Framework.Logging.Interfaces;
    using NServiceBus;

    public class EndpointForScannerTestToFind :  AsA_FctEndpoint
    {
        public void Customize(BusConfiguration configuration, ILoggerFactory loggerFactory)
        {
            throw new NotImplementedException();
        }
    }
}
