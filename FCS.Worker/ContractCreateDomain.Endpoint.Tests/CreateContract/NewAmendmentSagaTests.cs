namespace ContractCreateDomain.Endpoint.Tests.CreateContract
{
    using System;
    using System.Linq;
    using System.Threading.Tasks;
    using ContractManagement.DataStore.Dtos;
    using Endpoint.CreateContract;
    using Endpoint.Infrastructure.DTOs;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus.Testing;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;

    [TestClass]
    public class NewAmendmentSagaTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public async Task Handle_DuplicateMessage_DoesNotUploadSagaDataOrSendCommands()
        {
            var fixture = new CreateSagaTestFixture(messageNotYetProcessed: false);
            var context = new TestableMessageHandlerContext();

            await CreateSaga(fixture).Handle(BuildCommand(), context);

            fixture.SagaStorage.Verify(s => s.UploadSagaData(It.IsAny<string>(), It.IsAny<SagaStorageValue>()), Times.Never);
            Assert.AreEqual(0, context.SentMessages.Length);
        }

        [TestMethod, TestCategory("UnitTest")]
        public async Task Handle_InvalidRequest_RepliesWithProcessedCommandAndDoesNotUploadSagaData()
        {
            var fixture = new CreateSagaTestFixture(requestIsValid: false);
            var context = new TestableMessageHandlerContext();

            await CreateSaga(fixture).Handle(BuildCommand(), context);

            Assert.IsTrue(context.SentMessages.Any(m => m.Message is ContractRequestProcessedCommand));
            fixture.SagaStorage.Verify(s => s.UploadSagaData(It.IsAny<string>(), It.IsAny<SagaStorageValue>()), Times.Never);
        }

        [TestMethod, TestCategory("UnitTest")]
        public async Task Handle_ValidRequest_SendsDocGenAndUploadsSagaData()
        {
            var fixture = new CreateSagaTestFixture();
            var context = new TestableMessageHandlerContext();

            await CreateSaga(fixture).Handle(BuildCommand(), context);

            fixture.NumberRequestManager.Verify(n => n.GetContractNumbers(It.IsAny<contractRequestType>(), It.IsAny<SFA.FCT.CrossDomain.Integration.Entities.Data.ConnectionInfo>()), Times.Once);
            Assert.IsTrue(context.SentMessages.Any(m => m.Message is DocumentGenerationCommand));
            fixture.SagaStorage.Verify(
                s => s.UploadSagaData(CreateSagaTestFixture.ProcessId, It.Is<SagaStorageValue>(v => v.Intent == Intent.NewAmendment)),
                Times.Once);
        }

        [TestMethod, TestCategory("UnitTest")]
        public async Task Handle_IsNewAmendmentAllowedFunc_UsesAllowNewAmendmentFromRepository()
        {
            var fixture = new CreateSagaTestFixture(requestIsValid: false);
            var getAllowedFunc = fixture.CaptureNewAmendmentAllowedFunc();

            await CreateSaga(fixture).Handle(BuildCommand(), new TestableMessageHandlerContext());

            Assert.IsNotNull(getAllowedFunc());
            Assert.IsTrue(getAllowedFunc()(new FundingTypeFundingPeriodDto(CreateSagaTestFixture.FundingType, CreateSagaTestFixture.FundingPeriod)));
        }

        private static NewAmendmentRequestCommand BuildCommand()
        {
            return new NewAmendmentRequestCommand
            {
                ContractRequest = CreateSagaTestFixture.BuildRequest(intent.NewAmendment)
            };
        }

        private static NewAmendmentSaga CreateSaga(CreateSagaTestFixture f)
        {
            return new NewAmendmentSaga(
                f.DeliverableEnricher.Object,
                f.Transformer.Object,
                f.ValueAggregator.Object,
                f.Logger.Object,
                f.NumberRequestManager.Object,
                f.OrganisationEnricher.Object,
                f.Validator.Object,
                f.Processed.Object,
                f.Sessions.Object,
                f.Rules.Object,
                f.FundingTypeFundingPeriods.Object,
                f.SagaStorage.Object,
                f.Lookup.Object,
                f.FundingTypeFundingPeriodContractTypes.Object,
                f.SiblingContracts.Object,
                f.RelatedAllocations.Object);
        }
    }
}
