namespace ContractCreateDomain.Endpoint.Tests
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using ContractCreateDomain.Endpoint.Tests.CreateContract;
    using Endpoint.Infrastructure.Extensions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus.Testing;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Services;
    using SFA.FCT.ContractCreateDomain.Common.Messages.Commands;
    using SFA.FCT.ContractCreateDomain.Common.Messages.Messages;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.CrossDomain.Integration.Messages.Messages;
    using Corporate = SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;

    [TestClass]
    public class ModifyContractSagaFlowTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public async Task Handle_DuplicateMessage_CompletesWithoutSending()
        {
            var fixture = new ModifySagaTestFixture(messageNotYetProcessed: false);
            var context = new TestableMessageHandlerContext();

            SagaMethodResult result = await Handle(fixture, context, BuildCommand(), new ModifyContractSagaData());

            Assert.IsTrue(result.IsSagaComplete);
            Assert.AreEqual(0, context.SentMessages.Length);
            fixture.Merger.Verify(m => m.MergeOptionalFieldsFromPreviousContract(It.IsAny<contractRequestType>()), Times.Never);
        }

        [TestMethod, TestCategory("UnitTest")]
        public async Task Handle_PreviousContractNotFound_RepliesAndCompletes()
        {
            var fixture = new ModifySagaTestFixture(mergeResult: PreviousContractMergeResult.PreviousContractNotFound);
            var context = new TestableMessageHandlerContext();

            SagaMethodResult result = await Handle(fixture, context, BuildCommand(), new ModifyContractSagaData());

            Assert.IsTrue(result.IsSagaComplete);
            Assert.IsTrue(context.SentMessages.Any(m => m.Message is ContractRequestProcessedCommand));
            fixture.Lookup.Verify(l => l.CreateLookupDataAndSetContractPresence(It.IsAny<contractRequestType>(), It.IsAny<ConnectionInfo>()), Times.Never);
        }

        [TestMethod, TestCategory("UnitTest")]
        public async Task Handle_FirstLevelInvalid_RepliesAndCompletes()
        {
            var fixture = new ModifySagaTestFixture(firstLevelValid: false);
            var context = new TestableMessageHandlerContext();

            SagaMethodResult result = await Handle(fixture, context, BuildCommand(), new ModifyContractSagaData());

            Assert.IsTrue(result.IsSagaComplete);
            Assert.IsTrue(context.SentMessages.Any(m => m.Message is ContractRequestProcessedCommand));
            fixture.ContractsManager.Verify(c => c.GetLatestContract(It.IsAny<string>(), It.IsAny<IEnumerable<string>>()), Times.Never);
        }

        [TestMethod, TestCategory("UnitTest")]
        public async Task Handle_AddsApprovedAllocationValuesWhenProvided()
        {
            var fixture = new ModifySagaTestFixture(firstLevelValid: false);
            var invoked = false;

            await fixture.CreateModifySaga().Handle(
                BuildCommand(),
                new TestableMessageHandlerContext(),
                new ModifyContractSagaData(),
                fixture.GetFirstLevelRules,
                fixture.GetSecondLevelRules,
                request => invoked = true);

            Assert.IsTrue(invoked);
        }

        [TestMethod, TestCategory("UnitTest")]
        public async Task Handle_SecondLevelInvalid_RepliesAndCompletes()
        {
            var fixture = new ModifySagaTestFixture(secondLevelValid: false);
            var context = new TestableMessageHandlerContext();

            SagaMethodResult result = await Handle(fixture, context, BuildCommand(), new ModifyContractSagaData());

            Assert.IsTrue(result.IsSagaComplete);
            Assert.IsTrue(context.SentMessages.Any(m => m.Message is ContractRequestProcessedCommand));
            Assert.AreEqual(0, fixture.IncrementedContracts.Count);
        }

        [TestMethod, TestCategory("UnitTest")]
        public async Task Handle_ValidAmendment_IncrementsVersionAndSendsDocumentGeneration()
        {
            var fixture = new ModifySagaTestFixture();
            var context = new TestableMessageHandlerContext();
            var data = new ModifyContractSagaData();

            SagaMethodResult result = await Handle(fixture, context, BuildCommand(intent.Amendment), data);

            Assert.IsFalse(result.IsSagaComplete);
            Assert.AreEqual(1, fixture.IncrementedContracts.Count);
            DocumentGenerationCommand sent = context.SentMessages.Select(m => m.Message).OfType<DocumentGenerationCommand>().Single();
            Assert.AreEqual(CreateSagaTestFixture.ProcessId, sent.CorrelationId);
            Assert.AreEqual("MASTER-0001", sent.MasterContractNumber);
            Assert.IsTrue(sent.CorporateContract.IsAmendment);
            Assert.IsFalse(sent.CorporateContract.IsNewRevisedNewOrUpdateDraft);
            Assert.IsNotNull(data.MashedContractRequest);
            Assert.IsNotNull(data.ExtendedCorporateContract);
            fixture.CheckForChange.Verify(c => c.UpdateAllocationsThatHaveBeenAddedOrChangedService(It.IsAny<contractType>()), Times.Once);
            fixture.ContractsManager.Verify(c => c.GetSubStatusOfLastApproved(ModifySagaTestFixture.ChildContractNumber), Times.Once);
        }

        [TestMethod, TestCategory("UnitTest")]
        public async Task Handle_ValidNonAmendmentIntent_SkipsAmendmentChangeCheck()
        {
            var fixture = new ModifySagaTestFixture();
            var context = new TestableMessageHandlerContext();

            await Handle(fixture, context, BuildCommand(intent.New), new ModifyContractSagaData());

            fixture.CheckForChange.Verify(c => c.UpdateAllocationsThatHaveBeenAddedOrChangedService(It.IsAny<contractType>()), Times.Never);
            DocumentGenerationCommand sent = context.SentMessages.Select(m => m.Message).OfType<DocumentGenerationCommand>().Single();
            Assert.IsTrue(sent.CorporateContract.IsNewRevisedNewOrUpdateDraft);
            Assert.IsFalse(sent.CorporateContract.IsAmendment);
        }

        [TestMethod, TestCategory("UnitTest")]
        public async Task Handle_ValueVarianceRequired_UpdatesValueVariance()
        {
            var fixture = new ModifySagaTestFixture();
            var data = new ModifyContractSagaData { UpdateValueVarianceRequired = true };

            await Handle(fixture, new TestableMessageHandlerContext(), BuildCommand(), data);

            fixture.ValueAggregator.Verify(v => v.UpdateValueVariance(It.IsAny<Corporate.ExtendedContractType>(), It.IsAny<contractType>()), Times.Once);
        }

        [TestMethod, TestCategory("UnitTest")]
        public async Task Handle_ValueVarianceNotRequired_DoesNotUpdateValueVariance()
        {
            var fixture = new ModifySagaTestFixture();
            var data = new ModifyContractSagaData { UpdateValueVarianceRequired = false };

            await Handle(fixture, new TestableMessageHandlerContext(), BuildCommand(), data);

            fixture.ValueAggregator.Verify(v => v.UpdateValueVariance(It.IsAny<Corporate.ExtendedContractType>(), It.IsAny<contractType>()), Times.Never);
        }

        [TestMethod, TestCategory("UnitTest")]
        public async Task Handle_WithdrawnContractWithHigherVersionInCrm_UsesMaxWithdrawnVersion()
        {
            var fixture = new ModifySagaTestFixture();
            fixture.ContractsManager.Setup(c => c.GetMaxWithdrawnContractVersion(ModifySagaTestFixture.ChildContractNumber)).Returns(7);
            ModifyContractRequestCommand command = BuildCommand();
            contractType child = command.ContractRequest.contract.contracts.First();
            child.IsWithdrawnContractWithContractNumberPresentInCrm = true;
            child.contractVersionNumber = 2;

            await Handle(fixture, new TestableMessageHandlerContext(), command, new ModifyContractSagaData());

            Assert.AreEqual(7, child.contractVersionNumber);
        }

        [TestMethod, TestCategory("UnitTest")]
        public async Task Handle_WithdrawnContractWithLowerVersionInCrm_KeepsRequestedVersion()
        {
            var fixture = new ModifySagaTestFixture();
            fixture.ContractsManager.Setup(c => c.GetMaxWithdrawnContractVersion(ModifySagaTestFixture.ChildContractNumber)).Returns(1);
            ModifyContractRequestCommand command = BuildCommand();
            contractType child = command.ContractRequest.contract.contracts.First();
            child.IsWithdrawnContractWithContractNumberPresentInCrm = true;
            child.contractVersionNumber = 5;

            await Handle(fixture, new TestableMessageHandlerContext(), command, new ModifyContractSagaData());

            Assert.AreEqual(5, child.contractVersionNumber);
        }

        [TestMethod, TestCategory("UnitTest")]
        public async Task Handle_LastApprovedIdentityInfoFound_PassedToSecondLevelRules()
        {
            var fixture = new ModifySagaTestFixture();
            var identity = new ContractIdentityInfo(ModifySagaTestFixture.ChildContractNumber, new List<AllocationIdentityInfo>());
            fixture.ContractsManager.Setup(c => c.GetLastApprovedContractIdentityInfo(ModifySagaTestFixture.ChildContractNumber)).Returns(identity);
            IReadOnlyCollection<ContractIdentityInfo> received = null;

            await fixture.CreateModifySaga().Handle(
                BuildCommand(),
                new TestableMessageHandlerContext(),
                new ModifyContractSagaData(),
                fixture.GetFirstLevelRules,
                (request, lookup, identities, connection) =>
                {
                    received = identities;
                    return fixture.SecondLevelRules;
                });

            Assert.AreEqual(1, received.Count);
            Assert.AreSame(identity, received.Single());
        }

        [TestMethod, TestCategory("UnitTest")]
        public async Task Handle_UnnumberedAllocations_RequestsContractNumbers()
        {
            var fixture = new ModifySagaTestFixture();
            ModifyContractRequestCommand command = BuildCommand();
            command.ContractRequest.contract.contracts.First().contractAllocations.Add(new contractAllocation());

            await Handle(fixture, new TestableMessageHandlerContext(), command, new ModifyContractSagaData());

            fixture.NumberRequestManager.Verify(n => n.GetContractNumbers(It.IsAny<contractRequestType>(), It.IsAny<ConnectionInfo>()), Times.Once);
        }

        [TestMethod, TestCategory("UnitTest")]
        public async Task HandleDocumentGenerationComplete_OutstandingContracts_DoesNotSendCommand()
        {
            var context = new TestableMessageHandlerContext();
            ModifyContractSagaData data = BuildSagaDataWithContracts("C1", "C2");

            await ModifyContractSaga.Handle(
                new DocumentGenerationComplete { ContractNumber = "C1" },
                context,
                data,
                new ContractRequestProcessedCommand(),
                Mock.Of<SFA.FCT.Framework.Logging.Interfaces.ILogger>(),
                Mock.Of<Endpoint.Infrastructure.IFundingTypeFundingPeriodQueryRepository>(),
                Mock.Of<Endpoint.Infrastructure.IFundingTypePeriodService>(),
                Mock.Of<Endpoint.Infrastructure.ISessionConnectionFactory>());

            Assert.AreEqual(0, context.SentMessages.Length);
            var stored = data.ContractsToProcessHashSet.ConvertByteArrayToObject<HashSet<ContractCorrelationData>>();
            Assert.IsTrue(stored.Single(c => c.ContractNumber == "C1").IsCompleteDocGen);
            Assert.IsFalse(stored.Single(c => c.ContractNumber == "C2").IsCompleteDocGen);
        }

        [TestMethod, TestCategory("UnitTest")]
        public async Task HandleDocumentGenerationComplete_AllComplete_SendsCommandUnchangedWhenNotModifyCommand()
        {
            var context = new TestableMessageHandlerContext();
            var command = new ContractRequestProcessedCommand();
            var fundingPeriodService = new Mock<Endpoint.Infrastructure.IFundingTypePeriodService>();

            await ModifyContractSaga.Handle(
                new DocumentGenerationComplete { ContractNumber = "C1" },
                context,
                BuildSagaDataWithContracts("C1"),
                command,
                Mock.Of<SFA.FCT.Framework.Logging.Interfaces.ILogger>(),
                Mock.Of<Endpoint.Infrastructure.IFundingTypeFundingPeriodQueryRepository>(),
                fundingPeriodService.Object,
                Mock.Of<Endpoint.Infrastructure.ISessionConnectionFactory>());

            Assert.AreSame(command, context.SentMessages.Single().Message);
            fundingPeriodService.Verify(
                f => f.EnrichContract(It.IsAny<Corporate.ExtendedContractType>(), It.IsAny<ContractManagement.DataStore.Model.FundingTypeFundingPeriod>()),
                Times.Never);
        }

        [TestMethod, TestCategory("UnitTest")]
        public async Task HandleDocumentGenerationComplete_AllCompleteWithModifyCommand_EnrichesContractAndCopiesTerminationDetails()
        {
            var context = new TestableMessageHandlerContext();
            var terminationDate = new DateTime(2020, 1, 31);
            var child = new Corporate.ExtendedContractType
            {
                fundingType = new Corporate.fundingType { fundingTypeCode = "LEVY" },
                period = new Corporate.period
                {
                    period1 = "1617",
                    periodType = new Corporate.periodTypeType { periodTypeCode = Corporate.periodTypeCodeType.AY }
                },
                TerminationDate = terminationDate
            };
            var command = new ModifyContractInCrmCommand
            {
                Contract = new Corporate.ExtendedContractType { contracts = new List<Corporate.ExtendedContractType> { child } }
            };
            var fundingTypeFundingPeriod = new ContractManagement.DataStore.Model.FundingTypeFundingPeriod();
            var repository = new Mock<Endpoint.Infrastructure.IFundingTypeFundingPeriodQueryRepository>();
            repository.Setup(r => r.Get("LEVY", "AY1617", It.IsAny<ConnectionInfo>())).Returns(fundingTypeFundingPeriod);
            var fundingPeriodService = new Mock<Endpoint.Infrastructure.IFundingTypePeriodService>();

            await ModifyContractSaga.Handle(
                new DocumentGenerationComplete { ContractNumber = "C1" },
                context,
                BuildSagaDataWithContracts("C1"),
                command,
                Mock.Of<SFA.FCT.Framework.Logging.Interfaces.ILogger>(),
                repository.Object,
                fundingPeriodService.Object,
                Mock.Of<Endpoint.Infrastructure.ISessionConnectionFactory>());

            fundingPeriodService.Verify(f => f.EnrichContract(command.Contract, fundingTypeFundingPeriod), Times.Once);
            Assert.AreEqual(terminationDate, child.InflightTerminationDate);
            Assert.AreSame(command, context.SentMessages.Single().Message);
        }

        [TestMethod, TestCategory("UnitTest")]
        public async Task HandleContractAmended_SendsProcessedCommandWithMashedRequest()
        {
            var context = new TestableMessageHandlerContext();

            await ModifyContractSaga.Handle(
                new ContractAmended(),
                context,
                BuildSagaDataWithMashedRequest(),
                Mock.Of<SFA.FCT.Framework.Logging.Interfaces.ILogger>());

            var sent = (ContractRequestProcessedCommand)context.SentMessages.Single().Message;
            Assert.AreEqual(ModifySagaTestFixture.ChildContractNumber, sent.ContractRequest.contract.contracts.Single().contractNumber);
        }

        [TestMethod, TestCategory("UnitTest")]
        public async Task HandleAmendContractUnsuccessful_WithError_AddsErrorToMashedRequest()
        {
            var context = new TestableMessageHandlerContext();
            var error = new errorInfoType { Value = "boom" };

            await ModifyContractSaga.Handle(
                new AmendContractUnsuccessful { Error = error },
                context,
                BuildSagaDataWithMashedRequest(),
                Mock.Of<SFA.FCT.Framework.Logging.Interfaces.ILogger>());

            var sent = (ContractRequestProcessedCommand)context.SentMessages.Single().Message;
            Assert.AreSame(error.Value, sent.ContractRequest.errorInfo.Single().Value);
        }

        [TestMethod, TestCategory("UnitTest")]
        public async Task HandleAmendContractUnsuccessful_WithoutErrorButWithRequest_SendsMessageRequestUnchanged()
        {
            var context = new TestableMessageHandlerContext();
            contractRequestType messageRequest = CreateSagaTestFixture.BuildRequest();

            await ModifyContractSaga.Handle(
                new AmendContractUnsuccessful { ContractRequest = messageRequest },
                context,
                BuildSagaDataWithMashedRequest(),
                Mock.Of<SFA.FCT.Framework.Logging.Interfaces.ILogger>());

            var sent = (ContractRequestProcessedCommand)context.SentMessages.Single().Message;
            Assert.AreSame(messageRequest, sent.ContractRequest);
            Assert.AreEqual(0, sent.ContractRequest.errorInfo.Count);
        }

        private static Task<SagaMethodResult> Handle(
            ModifySagaTestFixture fixture,
            TestableMessageHandlerContext context,
            ModifyContractRequestCommand command,
            ModifyContractSagaData data)
        {
            return fixture.CreateModifySaga().Handle(command, context, data, fixture.GetFirstLevelRules, fixture.GetSecondLevelRules);
        }

        private static ModifyContractRequestCommand BuildCommand(intent crmIntent = intent.UpdateDraftAmendment)
        {
            contractRequestType request = CreateSagaTestFixture.BuildRequest(crmIntent);
            request.contract.CRMIntent = crmIntent;
            request.contract.contracts.First().contractNumber = ModifySagaTestFixture.ChildContractNumber;
            return new UpdateDraftContractAmendmentRequestCommand { ContractRequest = request };
        }

        private static ModifyContractSagaData BuildSagaDataWithContracts(params string[] contractNumbers)
        {
            var correlationData = new HashSet<ContractCorrelationData>(
                contractNumbers.Select(n => new ContractCorrelationData(n)));
            return new ModifyContractSagaData
            {
                ProcessId = "P1",
                ContractsToProcessHashSet = correlationData.ConvertObjectToByteArray()
            };
        }

        private static ModifyContractSagaData BuildSagaDataWithMashedRequest()
        {
            contractRequestType request = CreateSagaTestFixture.BuildRequest();
            request.contract.contracts.First().contractNumber = ModifySagaTestFixture.ChildContractNumber;
            return new ModifyContractSagaData
            {
                ProcessId = "P1",
                MashedContractRequest = request.ConvertObjectToByteArray()
            };
        }
    }
}
