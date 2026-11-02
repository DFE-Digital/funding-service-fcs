namespace FCT.Console.Config.Tests.Services
{
    using System.Collections.Generic;
    using System.IO;
    using System.Security.Cryptography;
    using System.Text;
    using Config.Services;
    using Dapper;
    using Dtos;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Newtonsoft.Json;
    using Newtonsoft.Json.Linq;
    using Operations.DataStore;
    using UnitTests.Common;

    [TestClass]
    public class ConfigFileVersionServiceTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void ConfigFileVersionService_HasConfigChanged_ShouldReturnTrueWhenJsonDiffers()
        {
            // arrange
            const string oldVersionNumber = "1";
            const string currentVersionNumber = "2";

            var testVersions = new List<string> { oldVersionNumber, currentVersionNumber };
            RemoveDeployedConfigVersionRows(testVersions);

            var jsonConfig = GetJsonConfig();

            var jsonConfigString = jsonConfig.ToString(Formatting.None);
            var currentChecksum = GetMd5Hash(jsonConfigString);
            List<DeployedConfigVersionInfo> rows = new List<DeployedConfigVersionInfo>
            {
                new DeployedConfigVersionInfo(oldVersionNumber, new byte[0]) // initial one
            };

            AddRowsToDeployedConfigVersionTable(rows);
            rows.Clear();

            const string agencySheetName = "Agency";

            var sheet = jsonConfig[agencySheetName] as JArray;
            sheet[0]["AgencyCode"] = 12;
            var jsonWithChangedValueString = jsonConfig.ToString(Formatting.None);
            var newChecksum = GetMd5Hash(jsonWithChangedValueString);
            rows.Add(new DeployedConfigVersionInfo(currentVersionNumber, newChecksum));
            AddRowsToDeployedConfigVersionTable(rows);

            // act
            var hasConfigChanged = ConfigFileVersionService.HasConfigChanged();

            // assert
            Assert.IsTrue(hasConfigChanged);
            RemoveDeployedConfigVersionRows(testVersions);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ConfigFileVersionService_HasConfigChanged_ShouldReturnFalseWhenJsonIsTheSame()
        {
            // arrange
            const string oldVersionNumber = "1";
            const string currentVersionNumber = "2";

            var testVersions = new List<string> { oldVersionNumber, currentVersionNumber };
            RemoveDeployedConfigVersionRows(testVersions);

            var jsonConfig = GetJsonConfig();

            List<DeployedConfigVersionInfo> rows = new List<DeployedConfigVersionInfo>
            {
                new DeployedConfigVersionInfo(oldVersionNumber, new byte[0]) // initial one
            };

            AddRowsToDeployedConfigVersionTable(rows);
            rows.Clear();

            var jsonWithoutChangeString = jsonConfig.ToString();
            var newChecksum = GetMd5Hash(jsonWithoutChangeString);
            rows.Add(new DeployedConfigVersionInfo(currentVersionNumber, newChecksum));
            AddRowsToDeployedConfigVersionTable(rows);

            // act
            var hasConfigChanged = ConfigFileVersionService.HasConfigChanged();

            // assert
            Assert.IsFalse(hasConfigChanged);
            RemoveDeployedConfigVersionRows(testVersions);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ConfigFileVersionService_WriteConfigInfoToTable_ShouldWriteRowToConfigInfoTable()
        {
            // arrange
            const string oldVersionNumber = "1";
            const string currentVersionNumber = "2";

            var testVersions = new List<string> {oldVersionNumber, currentVersionNumber};
            RemoveDeployedConfigVersionRows(testVersions);

            var jsonConfig = GetJsonConfig();

            var rows = new List<DeployedConfigVersionInfo>
            {
                new DeployedConfigVersionInfo(oldVersionNumber, new byte[0]) // initial one
            };

            AddRowsToDeployedConfigVersionTable(rows);
            rows.Clear();

            var jsonWithoutChangeString = jsonConfig.ToString();
            var newChecksum = GetMd5Hash(jsonWithoutChangeString);
            rows.Add(new DeployedConfigVersionInfo(currentVersionNumber, newChecksum));
            AddRowsToDeployedConfigVersionTable(rows);

            // act
            var hasConfigChanged = ConfigFileVersionService.HasConfigChanged();

            // assert
            Assert.IsFalse(hasConfigChanged);
            RemoveDeployedConfigVersionRows(testVersions);
        }

        private static byte[] GetMd5Hash(string input)
        {
            using (var provider = new MD5CryptoServiceProvider())
            {
                var inputBytes = Encoding.Default.GetBytes(input);

                return provider.ComputeHash(inputBytes);
            }
        }

        private static JObject GetJsonConfig()
        {
            using (var resource = new TestResource("FCT.Console.Config.Tests", @"Resources.Config.json"))
            {
                return JObject.Parse(new StreamReader(resource.Stream).ReadToEnd());
            }
        }

        private static void RemoveDeployedConfigVersionRows(IReadOnlyCollection<string> versions)
        {
            const string sql = @"DELETE FROM [Operations].[DeployedConfigVersion]
                                 WHERE [Version] IN @versions";

            using (var context = new OperationsDbContext())
            {
                context.Database.Connection.Execute(sql, new {versions});
            }
        }

        private static void AddRowsToDeployedConfigVersionTable(List<DeployedConfigVersionInfo> rows)
        {
            const string sql = @"INSERT INTO[Operations].[DeployedConfigVersion]
                                        ([Version], [Checksum])
                                    VALUES
                                        (@Version, @Checksum)";

            using (var context = new OperationsDbContext())
            {
                rows.ForEach(row =>
                {
                    context.Database.Connection.Execute(sql, new { row.Version, row.Checksum });
                });
            }
        }
    }
}
