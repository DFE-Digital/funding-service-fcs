namespace FCT.Operations.MessageReplay.Endpoint.Tests
{
    using System.Collections.Generic;
    using System.IO;
    using System.Text;
    using Castle.Core.Internal;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using PaymentGenerationDomain.Integration.DataStore;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.ContractManagementService.Common.Commands;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Operations.Common.Serializers;
    using SFA.FCT.Operations.Common.Services;
    using UnitTests.Common;

    [TestClass]
    public class MessageReplayServiceTests
    {
        [TestMethod, TestCategory("DataFix_R14")]
        public void MessageReplayService_ShouldSetPaymentPostedFlagToPosted()
        {
            UpdatePaymentPostedFlags(isPosted: true);
        }
        [TestMethod, TestCategory("DataFix_R14B")]
        public void MessageReplayBus_ShouldSendFailingFundingClaimReconciliationPublishedEvents()
        {
            string[] fundingClaimReconciliationPublishedEventFiles =
            {
                @"Resources.FundingClaimReconciliationPublishedEvent.1516_Final_Adult Skills15_16_10000256.json",
                @"Resources.FundingClaimReconciliationPublishedEvent.1516_Final_DLSandAdvancedLearnerLoansBursary15_16_10000256.json"
            };

            IMessageReplayBus messageReplayBus = new MessageReplayBus();

            foreach (var fileName in fundingClaimReconciliationPublishedEventFiles)
            {
                var eventObj = GetObjectFromJsonFile<FundingClaimReconciliationPublishedEvent>(
                    "FCT.Operations.MessageReplay.Endpoint.Tests",
                    fileName);

                messageReplayBus.Publish("PerformanceManagementDomain.ReconciliationPublication", eventObj);
            }



        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void MessageReplayBus_ShouldPublishPaymentAggregatedEvent()
        {
            string[] eventFiles =
            {
                @"Resources.PaymentAggregatedEvent.json"
            };

            IMessageReplayBus messageReplayBus = new MessageReplayBus();

            foreach (var fileName in eventFiles)
            {
                var eventObj = GetObjectFromJsonFile<PaymentAggregatedEvent>(
                    "FCT.Operations.MessageReplay.Endpoint.Tests",
                    fileName);

                messageReplayBus.Publish("PaymentManagementDomain.PaymentAggregation", eventObj);
            }
        }

        [TestMethod, TestCategory("DataFix_R34")]
        public void MessageReplayService_ShouldApproveContractsDuringR34()
        {
            // Arrange
            List<InitiateContractApprovalCommand> failingMessages = new List<InitiateContractApprovalCommand>
            {
                new InitiateContractApprovalCommand
                {
                    ContractNumber = "MAIN-5331",
                    MasterContractNumber = "SFA-3693",
                    RequestSource = ApprovalRequestSource.External,
                    ContractVersionNumber = 2
                },
                new InitiateContractApprovalCommand
                {
                    ContractNumber = "MAIN-5342",
                    MasterContractNumber = "SFA-3733",
                    RequestSource = ApprovalRequestSource.External,
                    ContractVersionNumber = 2
                },
                new InitiateContractApprovalCommand
                {
                    ContractNumber = "MAIN-5332",
                    MasterContractNumber = "SFA-3656",
                    RequestSource = ApprovalRequestSource.External,
                    ContractVersionNumber = 3
                }
            };

            // act

            IMessageReplayBus bus = new MessageReplayBus();

            failingMessages.ForEach(m =>
            {
                bus.Send<InitiateContractApprovalCommand>("ContractManagementDomain.InitiateContractApproval", c =>
                {
                    c.MasterContractNumber = m.MasterContractNumber;
                    c.ContractNumber = m.ContractNumber;
                    c.ContractVersionNumber = m.ContractVersionNumber;
                    c.RequestSource = m.RequestSource;
                });
            });
        }

        private static T GetObjectFromJsonFile<T>(string rootNamespace, string fileName)
        {
            using (var resource = new TestResource(rootNamespace, fileName))
            {
                string jsonText = ReadFromStream(resource.Stream);
                OperationsJsonSerializer operationsJsonSerializer = new OperationsJsonSerializer();
                return (T) operationsJsonSerializer.DeserializeJsonToObject(jsonText, typeof (T));
            }
        }

        private static string ReadFromStream(Stream stream)
        {
            stream.Position = 0;
            using (StreamReader reader = new StreamReader(stream, Encoding.UTF8))
            {
                return reader.ReadToEnd();
            }
        }

        private static void UpdatePaymentPostedFlags(bool isPosted)
        {
            string isPostedStr = (isPosted) ? "1" : "0";
            using (var context = new PaymentGenerationDbContext())
            {
                context.Database.ExecuteSqlCommand(
                    $@"update [PaymentGeneration].[SubnominalAggregation] set [PostedFlag] = {isPostedStr}
  where[AllocationNumber] in ('16AP-3418', 'ALLB-2233', 'ASTO-2761')
  and DATEADD(dd, 0, DATEDIFF(dd, 0, [LastModifiedDate])) = '2016-10-25'");

            }
        }

        private class PaymentScheduleEventFile
        {
            public PaymentScheduleEventFile(string fileName, string allocationNumber)
            {
                FileName = fileName;
                AllocationNumber = allocationNumber;
            }

            public string FileName { get;}

            public string AllocationNumber { get; }
        }
    }
}
