namespace SFA.FCT.Framework.Logging.Bespoke
{
    using System;
    using Microsoft.WindowsAzure.Storage.Table;

    public class LogEntry : TableEntity
    {
        public int EventId { get; set; }

        public string RoleInstance { get; set; }

        public string Message { get; set; }

        public string RowIndex { get; set; }

        public string DeploymentId { get; set; }

        public int Level { get; set; }
    

        public static LogEntry Create(string message, int eventId, string deploymentId, string roleId, string roleName, LogLevel level)
        {
            string rowIndex = Guid.NewGuid().ToString();
            DateTime now = DateTime.UtcNow;
            return new LogEntry
            {
                Message = $" {now:yyyy-MM-dd HH:mm:ss:fff} : {message}",
                EventId = eventId,
                PartitionKey = $"0{now.Ticks.ToString()}",
                RowKey = $"{deploymentId}__{roleName}__{roleId}__{rowIndex}",
                RowIndex = rowIndex,
                RoleInstance = roleId,
                DeploymentId = deploymentId,
                Level = (int)level
            };
        }
    }
}
