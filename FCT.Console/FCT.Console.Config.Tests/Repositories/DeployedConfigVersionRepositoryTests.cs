namespace FCT.Console.Config.Tests.Repositories
{
    using Config.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Operations.DataStore;
    using Dapper;
    using System;
    using System.Linq;
    using Dtos;
    using System.Collections.Generic;

    [TestClass]
    public class DeployedConfigVersionRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void DeployedConfigVersionRepository_GetLatestDeployedConfigVersionInfo_ShouldGetLatestDeployedConfigVersionInfo()
        {
            // arrange 
            const string testVersion = "test version";
            const string hexString = "D86B904FB55CA79CBD469D057DFA549C";
            var testChecksum = StringToByteArray(hexString);

            var oldRecords = new List<DeployedConfigVersionInfo>
            {
                new DeployedConfigVersionInfo("oldversion1", new byte[16]),
                new DeployedConfigVersionInfo("oldversion2", new byte[16])
            }.ToList();

            var assertRecord = new List<DeployedConfigVersionInfo>
            {
                new DeployedConfigVersionInfo(testVersion, testChecksum)
            }.ToList();
            
            RemoveRowsFromDeployedConfigVersionTable(oldRecords);
            RemoveRowsFromDeployedConfigVersionTable(assertRecord);

            AddRowsToDeployedConfigVersionTable(oldRecords);
            AddRowsToDeployedConfigVersionTable(assertRecord);

            // act
            var assertDeployedConfigVersionInfo = DeployedConfigVersionRepository.GetLatestDeployedConfigVersionInfo();

            // assert
            Assert.AreEqual(testVersion, assertDeployedConfigVersionInfo.Version, "The returned version is incorrect");
            Assert.IsTrue(testChecksum.SequenceEqual(assertDeployedConfigVersionInfo.Checksum), "The returned checksum is incorrect");

            RemoveRowsFromDeployedConfigVersionTable(oldRecords);
            RemoveRowsFromDeployedConfigVersionTable(assertRecord);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void DeployedConfigVersionRepository_AddDeployedConfigVersion_ShouldAddDeployedConfigVersion()
        {
            // arrange 
            const string testVersion = "test version";
            const string hexString = "D86B904FB55CA79CBD469D057DFA549C";
            var testChecksum = StringToByteArray(hexString);

            var oldRecords = new List<DeployedConfigVersionInfo>
            {
                new DeployedConfigVersionInfo("oldversion1", new byte[16]),
                new DeployedConfigVersionInfo("oldversion2", new byte[16])
            }.ToList();

            var assertRecord = new List<DeployedConfigVersionInfo>
            {
                new DeployedConfigVersionInfo(testVersion, testChecksum)
            }.ToList();

            RemoveRowsFromDeployedConfigVersionTable(oldRecords);
            RemoveRowsFromDeployedConfigVersionTable(assertRecord);

            AddRowsToDeployedConfigVersionTable(oldRecords);

            // act
            DeployedConfigVersionRepository.AddDeployedConfigVersion(new DeployedConfigVersionInfo(testVersion, testChecksum));

            // assert
            using (var context = new OperationsDbContext())
            {
                var assertDeployedConfigVersion = context.DeployedConfigVersions
                        .OrderByDescending(dcv => dcv.Id)
                        .FirstOrDefault(dcv => dcv.Version == testVersion);

                Assert.IsNotNull(assertDeployedConfigVersion, "DeployedConfigVersion was not added");
                Assert.IsTrue(testChecksum.SequenceEqual(assertDeployedConfigVersion.Checksum), "The returned checksum is incorrect");
            }

            RemoveRowsFromDeployedConfigVersionTable(oldRecords);
            RemoveRowsFromDeployedConfigVersionTable(assertRecord);
        }

        private static byte[] StringToByteArray(string hex)
        {
            return Enumerable.Range(0, hex.Length)
                .Where(x => x % 2 == 0)
                .Select(x => Convert.ToByte(hex.Substring(x, 2), 16))
                .ToArray();
        }

        private static void RemoveRowsFromDeployedConfigVersionTable(List<DeployedConfigVersionInfo> rowsToRemove)
        {
            const string sql = @"DELETE FROM [Operations].[DeployedConfigVersion]
                                     WHERE [Version] = @version";

            using (var context = new OperationsDbContext())
            {
                rowsToRemove.ForEach(row => 
                {
                    context.Database.Connection.Execute(sql, new { row.Version });
                });
            }
        }

        private static void AddRowsToDeployedConfigVersionTable(List<DeployedConfigVersionInfo> rowsToRAdd)
        {
            const string sql = @"INSERT INTO[Operations].[DeployedConfigVersion]
                                        ([Version], [Checksum])
                                    VALUES
                                        (@Version, @Checksum)";

            using (var context = new OperationsDbContext())
            {
                rowsToRAdd.ForEach(row =>
                {
                    context.Database.Connection.Execute(sql, new { row.Version, row.Checksum });
                });
            }
        }
    }
}