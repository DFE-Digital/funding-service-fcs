namespace SFA.FCT.ContractRequestDomain.Common.Utils
{
    using System;
    using System.Configuration;

    public static class ConfigurationHelper
    {
        public const string FileWatcherDropFolder = "FileWatcher.DropFolder";
        public const string FileWatcherProcessedFolder = "FileWatcher.ProcessedFolder";
        public const string FileWatcherFileSearchInterval = "FileWatcher.FileSearchInterval";
        public const string BulkUpdateContractProcessingTimeoutMinimumMins = "BulkUpdate.ContractProcessingTimeoutMinimumMins";
        public const string BulkUpdateContractProcessingTimeoutPer100Mins = "BulkUpdate.ContractProcessingTimeoutPer100Mins";
        public const string ProcessingTableConfigEntryKey = "FileWatcher.ProcessingTable";
        public const string ProcessedTableConfigEntryKey = "FileWatcher.ProcessedTable";
        public const string BulkUpdateProcessingTableConfigEntryKey = "BulkUpdate.ProcessingTable";
        public const string BulkUpdateLocationMappingTableConfigEntryKey = "BulkUpdate.LocationMappingTable";

        public static int GetSetting(string key, int defaultValue)
        {
            int i;
            string value = ConfigurationManager.AppSettings[key];
            if (value != null && int.TryParse(value, out i))
            {
                return i;
            }

            return defaultValue;
        }

        public static string GetSetting(string key)
        {
            return ConfigurationManager.AppSettings[key];
        }

        public static string GetSetting(string key, string defaultValue)
        {
            return ConfigurationManager.AppSettings[key] ?? defaultValue;
        }
    }
}
