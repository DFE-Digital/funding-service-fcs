namespace SFA.FCT.Framework.Logging
{
    using System;
    using Bespoke;

    public class LoggerFactoryNoRetry : LoggerFactory
    {
        protected void CreateRowInAzure(LogEntry logEntry)
        {
            var azureTable = GetCloudTable();

            try
            {
                AzureTableStore.CreateRow(azureTable, logEntry);
            }
            catch (Exception)
            {
                // do nothing
            }
        }
    }
}
