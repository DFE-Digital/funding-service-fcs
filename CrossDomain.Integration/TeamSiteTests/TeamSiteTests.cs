namespace TeamSiteTests
{
    using System;
    using System.Configuration;
    using System.IO;
    using System.Net;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;

    [TestClass]
    public class TeamSiteTests
    {
        [TestMethod, TestCategory("Tooling")]
        public void RemoveOldFilesFromTeamSiteFolders()
        {
            Console.WriteLine("===== CONFIG DIAGNOSTICS =====");

            Console.WriteLine($"BaseDirectory = {AppContext.BaseDirectory}");

            Console.WriteLine($"AppSettings Count = {ConfigurationManager.AppSettings.Count}");

            foreach (string key in ConfigurationManager.AppSettings.AllKeys)
            {
                Console.WriteLine($"{key} = {ConfigurationManager.AppSettings[key]}");
            }

            var configPath = Path.Combine(
                AppContext.BaseDirectory,
                "TeamSiteTests.dll.config");

            Console.WriteLine($"ConfigPath = {configPath}");
            Console.WriteLine($"Config Exists = {File.Exists(configPath)}");

            if (File.Exists(configPath))
            {
                Console.WriteLine("===== CONFIG FILE CONTENTS =====");
                Console.WriteLine(File.ReadAllText(configPath));
            }

            var map = new ExeConfigurationFileMap
            {
                ExeConfigFilename = Path.Combine(
        AppContext.BaseDirectory,
        "TeamSiteTests.dll.config")
            };

            var config = ConfigurationManager.OpenMappedExeConfiguration(
                map,
                ConfigurationUserLevel.None);

            Console.WriteLine(
                config.AppSettings.Settings["Sharepoint:Oauth:Tenant"]?.Value);

            Console.WriteLine("===== END CONFIG DIAGNOSTICS =====");

            ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12;

            const int olderThanNumberOfDays = 0;

            var office365StorageWrapper = new Office365StorageWrapper();

            office365StorageWrapper.RemoveOldFilesFromFolder(
                ConfigurationManager.AppSettings["FileWatcher.ReportsFolderO365"],
                olderThanNumberOfDays);

            office365StorageWrapper.RemoveOldFilesFromFolder(
                "24+LOANS-1516-Input-Appendices",
                olderThanNumberOfDays);

            office365StorageWrapper.RemoveOldFilesFromFolder(
                "ESF-1420-Input-Appendices",
                olderThanNumberOfDays);

            office365StorageWrapper.RemoveOldFilesFromFolder(
                "MAIN-1516-Input-Appendices",
                olderThanNumberOfDays);

            office365StorageWrapper.RemoveOldFilesFromFolder(
                "Main-1516-Input-Terms And Conditions",
                olderThanNumberOfDays);

            office365StorageWrapper.RemoveOldFilesFromFolder(
                "MAIN-1617-Input-Appendices",
                olderThanNumberOfDays);

            office365StorageWrapper.RemoveOldFilesFromFolder(
                "Processed",
                olderThanNumberOfDays);

            office365StorageWrapper.RemoveOldFilesFromFolder(
                "MAIN-1617-Input-Appendices",
                olderThanNumberOfDays);

            office365StorageWrapper.RemoveOldFilesFromFolder(
                "NCS-1718-Input-Appendices",
                olderThanNumberOfDays);

            office365StorageWrapper.RemoveOldFilesFromFolder(
                "LEVY-1799-Output-Documents for Publication",
                olderThanNumberOfDays);
        }
    }
}