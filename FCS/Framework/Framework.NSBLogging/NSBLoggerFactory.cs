namespace SFA.FCT.Framework.NSBLogging
{
    using System;
    using Logging.Interfaces;
    using NServiceBus.Logging;
    using ILoggerFactory = NServiceBus.Logging.ILoggerFactory;

    public class NSBLoggerFactory : ILoggerFactory
    {
        private static string[] _traceSources;

        private readonly ILogger _logger;

        public NSBLoggerFactory(ILogger logger)
        {
            _logger = logger;
        }

        public ILog GetLogger(string name)
        {
            return new NSBLogger(_logger);  
        }

        public ILog GetLogger(Type type)
        {
            return new NSBLogger(_logger);
        }
    }
}
