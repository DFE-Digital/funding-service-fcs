namespace Operations.Web.Tests.Controller
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data.SqlClient;
    using System.IO;
    using System.IO.Compression;
    using System.Runtime.Serialization.Formatters.Binary;
    using System.Text;
    using Dapper;
    using Helpers;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateSchema.Contract;

    [TestClass]
    public class ContractAtomInfoControllerTests
    {
        private static readonly Uri BaseUrl = new Uri(ConfigurationManager.AppSettings["WebRoleUrl"]);

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractAtomInfoController_ShouldGetOkBack()
        {
            // arrange

            using (var http = HttpClientHelper.GetClientWithAuthorizedSession(BaseUrl))
            {
                // act
                var httpResponse = http.GetAsync("fcs-contract-atom-info?contractNumber=MAIN-123").Result;
                // assert
                Assert.IsTrue(httpResponse.IsSuccessStatusCode);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractAtomInfoController_XmlEndoiint_ShouldGetOkBack()
        {
            // arrange
            const string contractNumber = "MAIN-3456";
            ClearContracts(contractNumber);
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

            using (var http = HttpClientHelper.GetClientWithAuthorizedSession(BaseUrl))
            {
                // act
                var httpResponse = http.GetAsync($"fcs-contract-atom-info/{id}").Result;
                // assert
                Assert.IsTrue(httpResponse.IsSuccessStatusCode, "This has not returned ok");
                var xmlResult= httpResponse.Content.ReadAsStringAsync().Result;
                Assert.IsTrue(xmlResult.Contains(contractNumber), "The xml returned did not contain the right contract number");
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
                    sql, new { contractNumber = $"{contractNumber}%" });
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
                    sql, param: new
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
