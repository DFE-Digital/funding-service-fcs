namespace SFA.FCT.Framework.Logging.Bespoke
{
    public enum LogLevel
    {
        Critical = 1,
        Error = 2,
        Warning = 3,
        Information = 4,
        Verbose = 5
    }

    public interface ICloudLogQueue
    {
        void AddEntry(int eventId, string message, LogLevel level);
    }
}
