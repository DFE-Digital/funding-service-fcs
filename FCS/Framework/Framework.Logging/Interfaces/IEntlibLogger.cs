namespace SFA.FCT.Framework.Logging.Interfaces
{
    
    public interface ILogger
    {
        void Log(string message, LoggingLevel level = LoggingLevel.Unspecified);
    }
    public enum LoggingLevel
    {
        Unspecified = 0,
        Info = 1,
        Warn = 2,
        Error = 3,
        Critical = 4
    }
}
