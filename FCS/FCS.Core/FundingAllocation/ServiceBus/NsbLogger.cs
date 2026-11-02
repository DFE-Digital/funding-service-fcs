namespace FundingAllocation.ServiceBus
{
    using System;
    using NServiceBus.Logging;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class NsbLogger : ILog
    {
        private readonly ILogger _logger;

        public NsbLogger(ILogger logger)
        {
            _logger = logger;
        }

        public bool IsDebugEnabled => _logger.IsVerboseEnabled();

        public bool IsErrorEnabled => _logger.IsErrorEnabled();

        public bool IsFatalEnabled => _logger.IsCriticalEnabled();

        public bool IsInfoEnabled => _logger.IsInformationEnabled();

        public bool IsWarnEnabled => _logger.IsWarningEnabled();

        public void Debug(string message, Exception exception) => _logger.LogVerbose(exception, message);

        public void Debug(string message) => _logger.LogVerbose(message);

        public void DebugFormat(string format, params object[] args) => _logger.LogVerbose(format, args);

        public void Error(string message, Exception exception) => _logger.LogError(1, exception, message);

        public void Error(string message) => _logger.LogError(1, message);

        public void ErrorFormat(string format, params object[] args) => _logger.LogError(1, format, args);

        public void Fatal(string message, Exception exception) => _logger.LogCritical(1, exception, message);

        public void Fatal(string message) => _logger.LogCritical(1, message);

        public void FatalFormat(string format, params object[] args) => _logger.LogCritical(1, format, args);

        public void Info(string message, Exception exception) => _logger.LogInformation(exception, message);

        public void Info(string message) => _logger.LogInformation(message);

        public void Warn(string message, Exception exception) => _logger.LogWarning(exception, message);
        
        public void Warn(string message) => _logger.LogWarning(message);

        public void WarnFormat(string format, params object[] args) => _logger.LogWarning(format, args);

        public void InfoFormat(string format, params object[] args) => _logger.LogInformation(format, args);
    }
}
