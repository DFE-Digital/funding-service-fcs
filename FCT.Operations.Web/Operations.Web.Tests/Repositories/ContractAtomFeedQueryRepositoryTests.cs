namespace Operations.Web.Tests.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data.SqlClient;
    using System.IO;
    using System.IO.Compression;
    using System.Linq;
    using System.Runtime.Serialization.Formatters.Binary;
    using System.Text;
    using System.Xml;
    using System.Xml.Linq;
    using System.Xml.XPath;
    using ContractManagement.DataStore.Model;
    using Dapper;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateSchema.Contract;
    using Web.Repositories;

    [TestClass]
    public class ContractAtomFeedQueryRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractAtomFeedQueryRepository_ShouldGetContracts()
        {
            // arrange
            const string contractNumber = "MAIN-1234";
            const string otherContractNumber = "OTHER-1234";
            ClearContracts(contractNumber);
            ClearContracts(otherContractNumber);

            AddContract($"{contractNumber}:1.0", 0);
            AddContract($"{contractNumber}:2.3", 1);
            AddContract($"{contractNumber}:3.0", 2);
            AddContract($"{otherContractNumber}:1.0", 0);

            // act
            var contracts = new ContractAtomFeedQueryRepository().GetContracts(contractNumber).Result;
            // assert
            Assert.AreEqual(3, contracts.Count);
            var contract2 = contracts.SingleOrDefault(c => c.ContractNumber == contractNumber && c.Version == 2);
            Assert.IsNotNull(contract2, "We have not found contract for version 2");
            Assert.AreEqual(AtomItemType.DraftContract.ToString(), contract2.ItemTypeString, "The Item Type is not correct");
            Assert.AreEqual(3, contract2.SubVersion, "The SubVersion is not correct");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractAtomFeedQueryRepository_ShouldGetXmlForContract()
        {
            // arrange
            const string contractNumber = "MAIN-2345";
            const string otherContractNumber = "OTHER-2345";
            ClearContracts(contractNumber);
            ClearContracts(otherContractNumber);
            contract contract = new contract
            {
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        contractNumber = contractNumber
                    }
                },
                contractNumber = "Master 1"
            };
            string xml = SerializeToXml(contract);
            byte[] bytes = ToZippedBytesFromString(xml);

            int id = AddContract($"{contractNumber}:1.0", 0, bytes);
            AddContract($"{contractNumber}:2.3", 1);
            AddContract($"{contractNumber}:3.0", 2);
            AddContract($"{otherContractNumber}:1.0", 0);

            // act
            var contractXml = new ContractAtomFeedQueryRepository().GetXmlForContract(id).Result;

            // assert
            var namespaceManager = new XmlNamespaceManager(new NameTable());
            namespaceManager.AddNamespace("ns", "urn:sfa:schemas:contract");
            var matchingElements = XDocument.Parse(contractXml).XPathSelectElements("//ns:contractNumber", namespaceManager);
            var doesXmlContainContractNumber = matchingElements.Select(e => e.Value).Contains(contractNumber);
            Assert.IsTrue(doesXmlContainContractNumber, "The contract returned is not correct");
        }

        private static byte[] ToZippedBytesFromString(string str)
        {
            MemoryStream memoryStream = new MemoryStream(ConvertObjectToByteArray(str));
            MemoryStream outStream = new MemoryStream();

            using (GZipStream tinyStream = new GZipStream(outStream, CompressionMode.Compress))
            {
                memoryStream.CopyTo(tinyStream);
            }

            return outStream.ToArray();
        }

        private static byte[] ConvertObjectToByteArray<T>(T objectToSerialize)
        {
            MemoryStream memorystream = new MemoryStream();
            BinaryFormatter bf = new BinaryFormatter();
            bf.Serialize(memorystream, objectToSerialize);

            byte[] serializedResult = memorystream.ToArray();

            return serializedResult;
        }

        private void ClearContracts(string contractNumber)
        {
            var connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                const string sql = @"delete
                    FROM[ContractManagement].[AtomFeedItem] where businessKey like @contractNumber";

                connection.Execute(
                    sql, new {contractNumber = $"{contractNumber}%"});
            }
        }

        private static string SerializeToXml<T>(T objectToSerialize) where T : class
        {
            if (objectToSerialize == null)
                return null;

            using (var stream = new MemoryStream())
            {
                var serializer = new System.Xml.Serialization.XmlSerializer(typeof(T));
                serializer.Serialize(stream, objectToSerialize);
                return new UTF8Encoding().GetString((stream).ToArray());
            }
        }

        private int AddContract(string businessKey, int itemType, byte[] itemBytes = null)
        {
            var connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                const string sql = @"insert into [ContractManagement].[AtomFeedItem]
                                    (identifier, itemType, businessKey, duplicateIdentifier, atomFeedItemBytes)
                                    OUTPUT INSERTED.ID
                                    values (@identifier, @itemType, @businessKey, @duplicateId, @itemBytes)";

                return connection.ExecuteScalar<int>(
                    sql, param:new
                    {
                        identifier = Guid.NewGuid().ToString(),
                        itemType,
                        businessKey,
                        duplicateId = Guid.NewGuid().ToString(),
                        itemBytes
                    });
            }
        }
    }
}
