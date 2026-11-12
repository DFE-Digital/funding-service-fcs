namespace ContractCreateDomain.Endpoint.Tests.CreateContract
{
    using System.Linq;
    using System.Threading.Tasks;
    using Endpoint.CreateContract;
    using Endpoint.Infrastructure.DTOs;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus.Testing;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;

    [TestClass]
    public class RevisedNewContractSagaTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public async Task Handle_DuplicateMessage_DoesNotUploadSagaDataOrSendCommands()
        {
            var fixture = new CreateSagaTestFixture(messageNotYetProcessed: false);
            var context = new TestableMessageHandlerContext();

            await CreateSaga(fixture, latestVersion: null).Handle(BuildCommand(), context);

            fixture.SagaStorage.Verify(s => s.UploadSagaData(It.IsAny<string>(), It.IsAny<SagaStorageValue>()), Times.Never);
            Assert.AreEqual(0, context.SentMessages.Length);
        }

        [TestMethod, TestCategory("UnitTest")]
        public async Task Handle_NoPreviousVersion_SetsVersionToOne()
        {
            var fixture = new CreateSagaTestFixture(messageNotYetProcessed: false);
            RevisedNewContractRequestCommand command = BuildCommand();

            await CreateSaga(fixture, latestVersion: null).Handle(command, new TestableMessageHandlerContext());

            Assert.AreEqual(1, command.ContractRequest.contract.contracts.First().contractVersionNumber);
        }

        [TestMethod, TestCategory("UnitTest")]
        public async Task Handle_PreviousVersionExists_IncrementsVersion()
        {
            var fixture = new CreateSagaTestFixture(messageNotYetProcessed: false);
            RevisedNewContractRequestCommand command = BuildCommand();

            await CreateSaga(fixture, latestVersion: 4).Handle(command, new TestableMessageHandlerContext());

            Assert.AreEqual(5, command.ContractRequest.contract.contracts.First().contractVersionNumber);
        }

        [TestMethod, TestCategory("UnitTest")]
        public async Task Handle_InvalidRequest_RepliesWithProcessedCommandAndBuildsRevisedNewRules()
        {
            var fixture = new CreateSagaTestFixture(requestIsValid: false);
            var context = new TestableMessageHandlerContext();

            await CreateSaga(fixture, latestVersion: 1).Handle(BuildCommand(), context);

            Assert.IsTrue(context.SentMessages.Any(m => m.Message is ContractRequestProcessedCommand));
            fixture.VerifyRevisedNewRulesRequested();
            fixture.SagaStorage.Verify(s => s.UploadSagaData(It.IsAny<string>(), It.IsAny<SagaStorageValue>()), Times.Never);
        }

        [TestMethod, TestCategory("UnitTest")]
        public async Task Handle_ValidRequest_AddsAllocationNumbersOnlySendsDocGenAndUploadsSagaData()
        {
            var fixture = new CreateSagaTestFixture();
            var context = new TestableMessageHandlerContext();

            await CreateSaga(fixture, latestVersion: 1).Handle(BuildCommand(), context);

            fixture.NumberRequestManager.Verify(n => n.PopulateContractAllocationNumbers(It.IsAny<contractRequestType>(), It.IsAny<ConnectionInfo>()), Times.Once);
            fixture.NumberRequestManager.Verify(n => n.GetContractNumbers(It.IsAny<contractRequestType>(), It.IsAny<ConnectionInfo>()), Times.Never);
            Assert.IsTrue(context.SentMessages.Any(m => m.Message is DocumentGenerationCommand));
            fixture.SagaStorage.Verify(
                s => s.UploadSagaData(CreateSagaTestFixture.ProcessId, It.Is<SagaStorageValue>(v => v.Intent == Intent.RevisedNew)),
                Times.Once);
        }

        private static RevisedNewContractRequestCommand BuildCommand()
        {
            return new RevisedNewContractRequestCommand
            {
                ContractRequest = CreateSagaTestFixture.BuildRequest()
            };
        }

        private static RevisedNewContractSaga CreateSaga(CreateSagaTestFixture f, int? latestVersion)
        {
            var lookupManager = new Mock<ILookupManager>();
            lookupManager.Setup(l => l.GetLatestContractVersionNumberForContract(It.IsAny<string>())).Returns(latestVersion);

            return new RevisedNewContractSaga(
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
                lookupManager.Object,
                f.FundingTypeFundingPeriodContractTypes.Object,
                f.SiblingContracts.Object,
                f.RelatedAllocations.Object);
        }
    }
}
