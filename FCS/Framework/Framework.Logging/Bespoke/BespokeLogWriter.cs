namespace SFA.FCT.Framework.Logging.Bespoke
{
    using System;
    using System.Globalization;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class BespokeLogWriter : ILogger
    {
        private readonly ICloudLogQueue _cloudLogQueue;
        private readonly LogLevel _logLevel;

        public BespokeLogWriter(ICloudLogQueue cloudLogQueue, LogLevel logLevel)
        {
            _cloudLogQueue = cloudLogQueue;
            _logLevel = logLevel;
        }

        public void LogVerbose(string format, params object[] args)
        {
            if (IsVerboseEnabled())
            {
                AddLogEntry(1, format, LogLevel.Verbose, args);
            }
        }

        public void LogVerbose(int id, string format, params object[] args)
        {
            if (IsVerboseEnabled())
            {
                AddLogEntry(id, format, LogLevel.Verbose, args);
            }
        }

        public void LogVerbose(Exception exception, string format, params object[] args)
        {
            if (IsVerboseEnabled())
            {
                AddLogEntry(1, format, LogLevel.Verbose, args, exception.Message, exception.StackTrace);
            }
        }

        public void LogInformation(string format, params object[] args)
        {
            if (IsInformationEnabled())
            {
                LogInformation(1, format, args);
            }
        }

        public void LogInformation(int id, string format, params object[] args)
        {
            if (IsInformationEnabled())
            {
                AddLogEntry(id, format, LogLevel.Information, args);
            }
        }

        public void LogInformation(Exception exception, string format, params object[] args)
        {
            if (IsInformationEnabled())
            {
                LogInformation(1, format, args, exception.Message, exception.StackTrace);
            }
        }

        public bool IsInformationEnabled()
        {
            return _logLevel >= LogLevel.Information;
        }

        public bool IsWarningEnabled()
        {
            return true;
        }
   
        public bool IsCriticalEnabled()
        {
            return true;
        }

        public bool IsVerboseEnabled()
        {
            return _logLevel == LogLevel.Verbose;
        }

        public bool IsErrorEnabled()
        {
            return true;
        }

        public void LogWarning(string format, params object[] args)
        {
            if (IsWarningEnabled())
            {
                AddLogEntry(1, format, LogLevel.Warning, args);
            }
        }

        public void LogWarning(int id, string format, params object[] args)
        {
            if (IsWarningEnabled())
            {
                AddLogEntry(id, format, LogLevel.Warning, args);
            }
        }

        public void LogWarning(Exception exception, string format, params object[] args)
        {
            if (IsWarningEnabled())
            {
                AddLogEntry(1, format, LogLevel.Warning, args, exception.Message, exception.StackTrace);
            }
        }

        public void LogError(int id, string format, params object[] args)
        {
            if (IsErrorEnabled())
            {
                AddLogEntry(1, format, LogLevel.Error, args);
            }
        }

        public void LogError(int id, Exception exception, string format, params object[] args)
        {
            if (IsErrorEnabled())
            {
                AddLogEntry(1, format, LogLevel.Error, args, exception.Message, exception.StackTrace);
            }
        }

        public void LogCritical(int id, string format, params object[] args)
        {
            AddLogEntry(id, format, LogLevel.Critical, args); 
        }

        public void LogCritical(int id, Exception exception, string format, params object[] args)
        {
            AddLogEntry(id, format, LogLevel.Critical, args, exception.Message, exception.StackTrace);
        }

        private void AddLogEntry(int id, string format, LogLevel level, params object[] args)
        {
            if (args != null && args.Length > 0)
            {
                if (format.Contains("{"))
                {
                    format = string.Format(CultureInfo.InvariantCulture, format, args);
                }
                else
                {
                    format += string.Join(",", args);
                }
                
            }

            _cloudLogQueue.AddEntry(id, format, level);
        }
    }
}
