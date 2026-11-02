namespace FCT.Operations.Common.Tests.Tools
{
    using System;
    using System.Collections.Generic;
    using System.Data.SqlClient;
    using System.IO;
    using System.Linq;
    using Dapper;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Common;

    [TestClass]
    public class AtomFeedReadingTools
    {
        [TestMethod, TestCategory("Tooling")]
        public void RetrieveContractAtomFeedItemsForContractNumberAndWriteToDisk()
        {
            const string connectionString = "<INSERT CONNECTION STRING>";
            const string contractNumber = "<INSERT CONTRACT NUMBER>";

            string folderName = $"{contractNumber} Atom Feed Events {DateTime.Now:yyyy-MM-dd HH-mm-ss}";
            
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                const string sql = "SELECT Id, BusinessKey, ItemType, AtomFeedItemBytes FROM ContractManagement.AtomFeedItem WHERE BusinessKey LIKE @contractNumber ORDER BY Id";

                List<AtomFeedItemInfo> atomFeedItems = connection.Query<AtomFeedItemInfo>(sql, new { contractNumber = $"{contractNumber}:%" }).ToList();

                atomFeedItems
                    .ForEach(item =>
                    {
                        string fileName = $"{item.Id} {item.ContractNumber} v{item.Version}.{item.SubVersion} {item.BusinessAction}";
                        FileInfo fileInfo = new FileInfo($"{folderName}\\{fileName}.xml");
                        fileInfo.Directory?.Create();
                        File.WriteAllText(fileInfo.FullName, item.Xml);
                    });
            }
        }

        private class AtomFeedItemInfo
        {
            private static readonly string[] BusinessActions =
            {
                "Approved",
                "Draft",
                "Withdrawn",
                "ClosedContract",
                "Termination Initiated",
                "Cancelled Termination",
                "Terminated",
                "Termination Details Updated"
            };

            public AtomFeedItemInfo(int id, string businessKey, int itemType, byte[] atomFeedItemBytes)
            {
                Id = id;
                BusinessKey = businessKey;
                ItemType = itemType;
                AtomFeedItemBytes = atomFeedItemBytes;
            }

            public int Id { get; }

            private string BusinessKey { get; }

            private int ItemType { get; }

            private byte[] AtomFeedItemBytes { get; }

            public string ContractNumber => BusinessKey.Split(':', '.')[0];

            public int Version => int.Parse(BusinessKey.Split(':', '.')[1]);

            public int SubVersion => int.Parse(BusinessKey.Split(':', '.')[2]);

            public string BusinessAction => BusinessActions[ItemType];

            public string Xml => ZipHelper.ToStringFromZippedBytes(AtomFeedItemBytes);
        }
    }
}
