namespace SFA.FCT.Framework.Logging
{
    using System;
    using System.Threading.Tasks;
    using Bespoke;

    public class LoggerFactoryNoRetry : LoggerFactory
    {
        protected async Task CreateRowInAzure(LogEntry logEntry)
        {
            var azureTable = GetCloudTable();

            try
            {
                await AzureTableStore.CreateRowAsync(azureTable, logEntry);
            }
            catch (Exception)
            {
                // do nothing
            }
        }

    }
}
