namespace PaymentsGateway.Framework
{
    public enum LoggingLevel
    {
        Unspecified = 0,

        Info = 1,

        Warn = 2,

        Error = 3,

        Critical = 4
    }

    public interface ILogger
    {
        void Log(string message, LoggingLevel level = LoggingLevel.Unspecified);
    }
}
