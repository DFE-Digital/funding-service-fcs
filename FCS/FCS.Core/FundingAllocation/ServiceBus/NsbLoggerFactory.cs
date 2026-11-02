namespace FundingAllocation.ServiceBus
{
    using System;
    using NServiceBus.Logging;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class NsbLoggerFactory : NServiceBus.Logging.ILoggerFactory
    {
        private readonly ILogger _logger;

        public NsbLoggerFactory(ILogger logger)
        {
            _logger = logger;
        }

        public ILog GetLogger(string name)
        {
            return new NsbLogger(_logger);
        }

        public ILog GetLogger(Type type)
        {
            return new NsbLogger(_logger);
        }
    }
}
