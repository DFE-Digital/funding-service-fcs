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
    using Operations.Web.PaymentGenerationDataStore;
    using System.Data.Entity;


    [TestClass]
    public class PaymentBFItemQueryRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void PaymentBFItemQueryRepository_ShouldGetItems()
        {
            // arrange
            const string fundingStreamPeriod = "GSPTEST";
            const string otherFSP = "DAD526TEST";
            ClearContracts(fundingStreamPeriod);
            ClearContracts(otherFSP);

            AddContract(fundingStreamPeriod, "204201", DateTime.Now, 2, "L", DateTime.Now, 49);
            AddContract(fundingStreamPeriod, "2061", DateTime.Now, 2, "LL", DateTime.Now, 4);
            AddContract(fundingStreamPeriod, "2091", DateTime.Now, 6, "GL", DateTime.Now, 48);
            AddContract(otherFSP, "2201", DateTime.Now, 2, "L", DateTime.Now, 45);

            // act
            var contracts = new PaymentBFItemQueryRepository().GetItemByFundingStreamPeriod(fundingStreamPeriod).Result;
            // assert
            Assert.AreEqual(3, contracts.Count);
            var contract2 = contracts.SingleOrDefault(c => c.FundingStreamPeriod == otherFSP);
            //Assert.IsNotNull(contract2, "We have not found contract for version 2");
            //Assert.AreEqual(AtomItemType.DraftContract.ToString(), contract2.ItemTypeString, "The Item Type is not correct");
            //Assert.AreEqual(3, contract2.Id, "The Id is not correct");
            ClearContracts(fundingStreamPeriod);
            ClearContracts(otherFSP);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PaymentBFItemQueryRepository_ShouldGetXmlForContract()
        {
            // arrange
            const string fundingStreamPeriod = "MSPTEST";
            const string otherFSP = "DADTEST";
            ClearContracts(fundingStreamPeriod);
            ClearContracts(otherFSP);
            Contract contract = new Contract
            {
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        contractNumber = fundingStreamPeriod
                    }
                },
                contractNumber = "Master 1"
            };
            string xml = SerializeToXml(contract);
            byte[] bytes = ToZippedBytesFromString(xml);

            int id = AddContract(fundingStreamPeriod, "3456", DateTime.Now, 1, "A1", DateTime.Now, 24, bytes);
            AddContract(fundingStreamPeriod, "3459", DateTime.Now, 7, "A1", DateTime.Now, 24);
            AddContract(fundingStreamPeriod, "346", DateTime.Now, 1, "A1", DateTime.Now, 67);
            AddContract(otherFSP, "20201", DateTime.Now, 2, "L", DateTime.Now, 45);

            // act
            var contractXml = new PaymentBFItemQueryRepository().GetXmlForContract(id).Result;

            // assert
            var namespaceManager = new XmlNamespaceManager(new NameTable());
            namespaceManager.AddNamespace("ns", "urn:sfa:schemas:contract");
            var matchingElements = XDocument.Parse(contractXml).XPathSelectElements("//ns:contractNumber", namespaceManager);
            var doesXmlContainContractNumber = matchingElements.Select(e => e.Value).Contains(fundingStreamPeriod);
            Assert.IsTrue(doesXmlContainContractNumber, "The contract returned is not correct");

            ClearContracts(fundingStreamPeriod);
            ClearContracts(otherFSP);
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

        private static byte[] ConvertObjectToByteArray(string text)
        {
            return Encoding.UTF8.GetBytes(text);
        }

        private void ClearContracts(string fundingStreamPeriod)
        {
            var connectionString = ConfigurationManager.ConnectionStrings["PaymentGenDBContext"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                const string sql = @"delete
                    FROM[PaymentGeneration].[PaymentBatchFeedItem] where fundingStreamPeriod = @fundingStreamPeriod";

                connection.Execute(
                sql, new { fundingStreamPeriod });
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

        private int AddContract(string fundingStreamPeriod, string paymentPeriod, DateTime censusEndDate, int paymentLineCount, string linkCodeSuffix, DateTime createdDate, decimal totalValue, byte[] corporatePaymentBatchBytes = null)
        {
            var connectionString = ConfigurationManager.ConnectionStrings["PaymentGenDBContext"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                const string sql = @"insert into [PaymentGeneration].[PaymentBatchFeedItem]
                                    (identifier, fundingStreamPeriod, paymentPeriod, censusEndDate, paymentLineCount, linkCodeSuffix, corporatePaymentBatchBytes, createdDate, totalValue)
                                    OUTPUT INSERTED.ID
                                    values (@identifier, @fundingStreamPeriod, @paymentPeriod, @censusEndDate, @paymentLineCount, @linkCodeSuffix, @corporatePaymentBatchBytes, @createdDate, @totalValue)";

                return connection.ExecuteScalar<int>(
                    sql, param: new
                    {
                        identifier = Guid.NewGuid().ToString(),
                        fundingStreamPeriod,
                        paymentPeriod,
                        censusEndDate,
                        paymentLineCount,
                        linkCodeSuffix,
                        corporatePaymentBatchBytes,
                        createdDate,
                        totalValue
                    });
            }
        }
    }
}