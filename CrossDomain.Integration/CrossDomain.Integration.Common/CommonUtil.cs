namespace SFA.FCT.CrossDomain.Integration.Common
{
    using System.Configuration;

    public class CommonUtil
    {
        #region Properties

        public static string InputFolderName => GetConfigValue("FileWatcher.InputFolderO365", "Input");

        public static string ProcessingFolderName => GetConfigValue("FileWatcher.ProcessingFolderO365", "Processing");

        public static string ProcessedFolderName => GetConfigValue("FileWatcher.ProcessedFolderO365", "Processed");

        public static string ReportsFolderName => GetConfigValue("FileWatcher.ReportsFolderO365", "Reports");

        public static string ContractAppendicesFolderName => GetConfigValue("ContractDocumentation.ContractAppendicesFolderO365", "{FundingType}-{Period}-Input-Appendices");

        public static string ContractTermsAndConditionsFolderName => GetConfigValue("ContractDocumentation.ContractTermsAndConditionsFolderO365", "{FundingType}-{Period}-Input-Terms And Conditions");

        public static string ContractMergedDocumentFolderName => GetConfigValue("ContractDocumentation.ContractMergedDocumentFolderO365", "{FundingType}-{Period}-Output-Merged Document");

        public static string ContractPublishedDocumentFolderName => GetConfigValue("ContractDocumentation.ContractPublishedDocumentFolderO365", "{FundingType}-{Period}-Output-Documents for Publication");

        #endregion

        #region Private Methods

        private static string GetConfigValue(string configName, string defaultValue)
        {
            return string.IsNullOrEmpty(GetConfigValue(configName)) ? defaultValue : GetConfigValue(configName);
        }

        private static string GetConfigValue(string configName)
        {
            return ConfigurationManager.AppSettings[configName];
        }

        #endregion
    }
}