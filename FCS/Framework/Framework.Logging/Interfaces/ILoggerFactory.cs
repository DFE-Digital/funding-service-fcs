namespace SFA.FCT.Framework.Logging.Interfaces
{
    using System;
    using SFA.FCT.Framework.Logging.Bespoke;

    public interface ILoggerFactory
    {
        ILogger CreateLogger(string source);

        ILogger CreateDefaultLogger(LogLevel logLevel = LogLevel.Verbose);

        ILogger CreateDefaultLogger(string storageConnectionString, ICloudEnvironment cloudEnvironment, Action<LogEntry> createRowInAzure);

        ILogger CreateDefaultLogger(LogLevel logLevel, ICloudEnvironment cloudEnvironment);

        ILogger CreateDefaultLogger(LogLevel logLevel, Func<ICloudEnvironment> getCloudEnvironment);

        ILogger CreateCoreLogger();
    }
}
