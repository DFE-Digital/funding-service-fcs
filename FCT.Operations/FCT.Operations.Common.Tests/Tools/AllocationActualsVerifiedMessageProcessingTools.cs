namespace FCT.Operations.Common.Tests.Tools
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data.SqlClient;
    using System.Globalization;
    using System.Linq;
    using System.Text;
    using Dapper;
    using global::Operations.DataStore.Model;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Newtonsoft.Json;
    using NServiceBus;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;
    using SFA.FCT.CrossDomain.Integration.Events;

    [TestClass]
    public class AllocationActualsVerifiedMessageProcessingTools
    {
        private const string BlobFolderName = "28920-testing";

        [TestMethod]
        public void RetrieveMessagesFromMessageAuditAndWriteToBlobStorage()
        {
            AzureStorageWrapper.CreateIfNotExists(BlobFolderName);

            AzureStorageWrapper.GetBlobsInContainer(BlobFolderName)
                .ToList()
                .ForEach(blobname => AzureStorageWrapper.DeleteBlockBlob(new FctFile(BlobFolderName, blobname)));

            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["OperationsDbContext"].ConnectionString))
            {
                const string sql = @"
                    SELECT
	                    *
                    FROM
	                    Operations.AuditMessage
                    WHERE
	                     MessageType = 'SFA.FCT.CrossDomain.Integration.Events.AllocationActualsVerified'
	                     AND ProcessingEndpoint = 'PaymentManagementDomain.PaymentSchedule'
	                     AND SentTime >= '2020-03-09 09:30'
	                     AND SentTime <= '2020-03-09 13:15'
                    ";

                connection.Query<AuditMessage>(sql)
                    .Select(am => Encoding.ASCII.GetBytes(am.GetMessageAsJson()))
                    .ToList()
                    .ForEach(bytes => AzureStorageWrapper.PutBlockBlob(new FctFile(BlobFolderName, Guid.NewGuid().ToString()), bytes));
            }
        }

        [TestMethod]
        public void CalculateAveragePayCalcProcessingTimesForSpecificFspsFromMessageAudit()
        {
            string[] fsps = { "16-18NLAP2018", "ANLAP2018", "APPS1819", "APPS1920" };
            const string wireDateTimeFormat = "yyyy-MM-dd HH:mm:ss:ffffff Z";

            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["OperationsDbContext"].ConnectionString))
            {
                const string sql = @"
                    SELECT
	                    *
                    FROM
	                    Operations.AuditMessage
                    WHERE
	                     MessageType = 'SFA.FCT.CrossDomain.Integration.Events.AllocationActualsVerified'
	                     AND ProcessingEndpoint = 'PaymentManagementDomain.PaymentSchedule'
	                     AND SentTime >= '2020-04-07 07:00'
	                     AND SentTime <= '2020-04-07 07:15'
                    ";

                IReadOnlyCollection<AuditMessage> relevantFspMessages = connection.Query<AuditMessage>(sql)
                    .Where(am => fsps.Contains(JsonConvert.DeserializeObject<AllocationActualsVerified>(am.GetMessageAsJson()).AllocationActuals.FundingStreamPeriodCode))
                    .ToList();

                double totalMillisecondsOfProcessing = relevantFspMessages.Sum(am =>
                {
                    var messageProperties = am.GetPropertiesDictionary();

                    DateTime processingStartTime =
                        DateTime.ParseExact(messageProperties["NServiceBus.ProcessingStarted"].ToString(), wireDateTimeFormat, CultureInfo.InvariantCulture);
                    DateTime processingEndTime =
                        DateTime.ParseExact(messageProperties["NServiceBus.ProcessingEnded"].ToString(), wireDateTimeFormat, CultureInfo.InvariantCulture);

                    return processingEndTime.Subtract(processingStartTime).TotalMilliseconds;
                });

                double averageMessageProcessingTimeInMilliseconds = totalMillisecondsOfProcessing / relevantFspMessages.Count;

                Console.WriteLine($@"Average time for {string.Join(",", fsps)}: {averageMessageProcessingTimeInMilliseconds}");

                // FIGURES USING OPA
                // -----------------
                // 16-18NLAP2018 : 2595.58893174603
                // ANLAP2018     : 2625.69591225416
                // APPS1819      : No data
                // APPS1920      : 9239.89354850747

                // FIGURES USING C#
                // ----------------
                // 16-18NLAP2018 : 101.381666666667
                // ANLAP2018     : 93.0538819969743
                // APPS1819      : No data
                // APPS1920      : 284.080048507463
            }
        }

        //[TestMethod]
        //public void RetrieveMessagesFromBlobStorageAndSendToPayCalc()
        //{
        //    using (ISendOnlyBus bus = CreateBus())
        //    {
        //        AzureStorageWrapper.GetBlobsInContainer(BlobFolderName)
        //            .Select(blobname => AzureStorageWrapper.GetBlobContents(new FctFile(BlobFolderName, blobname)).Contents)
        //            .Select(Encoding.ASCII.GetString)
        //            .Select(JsonConvert.DeserializeObject<AllocationActualsVerified>)
        //            .ToList()
        //            .ForEach(msg => bus.Send("PaymentManagementDomain.PaymentSchedule", msg));
        //    }
        //}

        //private static ISendOnlyBus CreateBus()
        //{
        //    BusConfiguration configuration = new BusConfiguration();
        //    configuration.UseSerialization<NServiceBus.JsonSerializer>();
        //    configuration.UseTransport<AzureServiceBusTransport>();
        //    configuration.Conventions().DefiningCommandsAs(t => t == typeof(AllocationActualsVerified));

        //    return Bus.CreateSendOnly(configuration);
        //}
    }
}
