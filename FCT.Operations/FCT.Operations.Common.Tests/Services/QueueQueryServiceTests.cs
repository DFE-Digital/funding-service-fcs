namespace FCT.Operations.Common.Tests.Services
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using MoreLinq;
    using SFA.FCT.Operations.Common.DTOs;
    using SFA.FCT.Operations.Common.Services;

    [TestClass]
    public class QueueQueryServiceTests
    {
        [TestMethod, TestCategory("DataDependent")]
        public void QueueQueryService_GetMessageDetail_ShouldGetMessageWhenValidIdPassedIn()
        {
            // arrange
            IQueueQueryService queueQueryService = new QueueService();

            // act
            MessageDetail messageDetail = queueQueryService.GetMessageDetail("error", "953f0b08-1dd2-4a9f-b3ad-a8cf00347810");

            // assert
            Assert.IsNotNull(messageDetail);
            Assert.IsNotNull(messageDetail.MessageBody, "The message body is not set");
            Assert.AreEqual("PaymentManagementDomain.PaymentSchedule", messageDetail.EndpointName, "The endpointName is not correct");
            Assert.AreEqual("SFA.FCT.CrossDomain.Integration.Events.PaymentScheduleEvent", messageDetail.MessageType, "The message type is not correct");
        }

        [TestMethod, TestCategory("DataDependent")]
        public void QueueQueryService_GetMessageDetails_ShouldGetMatchingMessagesWhenQueryParametersPassedIn()
        {
            // arrange
            IQueueQueryService queueQueryService = new QueueService();

            // act
            IList<MessageDetail> messageDetails = queueQueryService.GetMessageDetails(
                queueName: "audit.log",
                messageType: "PaymentScheduleEvent",
                timeRangeStartUtc: new DateTime(2018, 02, 08, 10, 50, 0, DateTimeKind.Utc),
                timeRangeEndUtc: new DateTime(2018, 02, 08, 11, 05, 0, DateTimeKind.Utc),
                fromSequenceNo: 318324000,
                matchMessage: m => m.MessageBody.Contains("ANL-1857"));

            // assert
            Assert.IsNotNull(messageDetails, "The return value was null.");
            Assert.IsTrue(messageDetails.Count > 0, "No messages returned.");
            Assert.IsNotNull(messageDetails.SingleOrDefault(m => m.MessageId == "f604d5b9-6aa5-4013-a1e6-a6c4018529b5"), "Matching message not found.");
        }

        [TestMethod, TestCategory("DataDependent")]
        public void QueueQueryService_GetMessageDetails_ShouldGetAllocationDeliveryCommencedEvent_ThenWriteToFile()
        {
            // arrange
            IQueueQueryService queueQueryService = new QueueService();

            string[] allocationNumbersToFind = { "APPS-2371" };
            // 2901085
            // act
            IList<MessageDetail> messageDetails = queueQueryService.GetMessageDetails(
                queueName: "audit",
                messageType: "IPaymentAggregatedEvent",
                timeRangeStartUtc: new DateTime(2019, 08, 30, 07, 00, 0, DateTimeKind.Utc),
                timeRangeEndUtc: new DateTime(2019, 08, 30, 08, 00, 0, DateTimeKind.Utc),
                fromSequenceNo: 3832085, // represents 2019-02-20 05:01:59 in Prod "audit" queue
                matchMessage: m => allocationNumbersToFind.Any(m.MessageBody.Contains));

            messageDetails.Select(m => m.MessageBody).ForEach(WriteStringToNewFile);
        }

        [TestMethod, TestCategory("DataDependent")]
        public void QueueQueryService_GetQueueSizeInBytes_ShouldGetExpectedQueueSize()
        {
            // arrange
            IQueueQueryService queueQueryService = new QueueService();

            // act
            long queueSizeInBytes = queueQueryService.GetQueueSizeInBytes("audit");

            // assert
            Assert.IsTrue(queueSizeInBytes > 0);
        }

        private void WriteStringToNewFile(string data)
        {
            using (var file = new System.IO.StreamWriter($"RetrievedMessages/{Guid.NewGuid()}.json"))
            {
                file.WriteLine(data);
            }
        }
    }
}
