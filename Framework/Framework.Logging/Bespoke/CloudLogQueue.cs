namespace SFA.FCT.Framework.Logging.Bespoke
{
    using System.Collections.Concurrent;

    public class CloudLogQueue : ICloudLogQueue
    {
        private readonly ConcurrentQueue<LogEntry> _logEntries;
        private readonly ICloudEnvironment _cloudEnvironment;

        public CloudLogQueue(ConcurrentQueue<LogEntry> logEntries, ICloudEnvironment cloudEnvironment)
        {
            _logEntries = logEntries;
            _cloudEnvironment = cloudEnvironment;
        }

        public void AddEntry(int eventId, string message, LogLevel level)
        {
            _logEntries.Enqueue(LogEntry.Create(
                message: message,
                eventId: eventId,
                deploymentId: _cloudEnvironment.GetDeploymentId(),
                roleId: _cloudEnvironment.GetRoleId(),
                roleName: _cloudEnvironment.GetRoleName(),
                level: level));
        }
    }
}
