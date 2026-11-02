namespace PaymentsGateway.Framework
{
    using System.Collections.Generic;
    using System.Diagnostics;
    using Microsoft.Practices.EnterpriseLibrary.Logging;

    public class EntLibLogger : ILogger      
    {
        public void Log(string message, LoggingLevel level = LoggingLevel.Unspecified)
        {
            // Logger.Writer(new LogEntry(){Message = "Something wrong"})
            // if (Logger.IsLoggingEnabled())
            // {
                switch (level)
                {
                    case LoggingLevel.Info:
                        Logger.Write(message, new List<string> { "General" }, 1, 100, TraceEventType.Information);
                        break;
                    case LoggingLevel.Warn:
                        Logger.Write(message, new List<string> { "General" }, 1, 100, TraceEventType.Warning);
                        break;
                    case LoggingLevel.Error:
                        Logger.Write(message, new List<string> { "General" }, 1, 100, TraceEventType.Error);
                        break;
                    case LoggingLevel.Critical:
                        Logger.Write(message, new List<string> { "General" }, 1, 100, TraceEventType.Critical);
                        break;
                    default:
                        Logger.Write(message, new List<string> { "General" }, 1, 100, TraceEventType.Verbose);
                        break;
                }

         // }
        }
    }
}