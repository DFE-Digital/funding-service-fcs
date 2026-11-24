using Microsoft.VisualStudio.TestTools.UnitTesting;
using Operations.Web.Tests.Helpers;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.IO.Compression;
using System.IO;
using System.Runtime.Serialization.Formatters.Binary;
using System.Text;
using Dapper;
using SFA.FCT.CrossDomain.Integration.Entities.CorporateSchema.Contract;
using SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentGeneration;

namespace Operations.Web.Tests.Controller
{
    [TestClass]
    public class PaymentBFControllerTests
    {
        private static readonly Uri BaseUrl = new Uri(ConfigurationManager.AppSettings["WebRoleUrl"]);

        [TestMethod, TestCategory("IntegrationTest")]
        public void PaymentBFController_ShouldGetOkBack()
        {
            // arrange

            using (var http = HttpClientHelper.GetClientWithAuthorizedSession(BaseUrl))
            {
                // act
                var httpResponse = http.GetAsync("fcs-payment-batch-feed-info?fundingStreamPeriod=FSP").Result;
                // assert
                Assert.IsTrue(httpResponse.IsSuccessStatusCode, DescribeFailure(httpResponse));
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PaymentBFController_XmlEndpoint_ShouldGetOkBack()
        {
            // arrange
            const string fundingStreamPeriod = "TSPTEST";
            ClearContracts(fundingStreamPeriod);
            contract contract = new contract
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
            AddContract(fundingStreamPeriod, "20201", DateTime.Now, 2, "L", DateTime.Now, 45);

            using (var http = HttpClientHelper.GetClientWithAuthorizedSession(BaseUrl))
            {
                // act
                var httpResponse = http.GetAsync($"fcs-payment-batch-feed-info/{id}").Result;
                // assert
                Assert.IsTrue(httpResponse.IsSuccessStatusCode, "This has not returned ok. " + DescribeFailure(httpResponse));
                var xmlResult = httpResponse.Content.ReadAsStringAsync().Result;
                Assert.IsTrue(xmlResult.Contains(fundingStreamPeriod), "The xml returned did not contain the right contract number");
            }
            ClearContracts(fundingStreamPeriod);
        }

        private static string DescribeFailure(System.Net.Http.HttpResponseMessage response)
        {
            var body = response.Content.ReadAsStringAsync().Result ?? string.Empty;
            if (body.Length > 500)
            {
                body = body.Substring(0, 500);
            }

            return $"Request {response.RequestMessage?.RequestUri} returned {(int)response.StatusCode} {response.ReasonPhrase}. Body: {body}";
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

        private void ClearContracts(string fundingStreamPeriod)
        {
            var connectionString = ConfigurationManager.ConnectionStrings["PaymentGenDBContext"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                const string sql = @"delete
                    FROM[PaymentGeneration].[PaymentBatchFeedItem] where FundingStreamPeriod = @fundingStreamPeriod";

                connection.Execute(
                    sql, new { fundingStreamPeriod });
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