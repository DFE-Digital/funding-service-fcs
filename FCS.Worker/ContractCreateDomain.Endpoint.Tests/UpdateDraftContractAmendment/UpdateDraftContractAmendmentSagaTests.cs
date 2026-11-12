namespace ContractCreateDomain.Endpoint.Tests.UpdateDraftContractAmendment
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using ContractCreateDomain.Endpoint.Tests.CreateContract;
    using ContractManagement.DataStore.Dtos;
    using ContractManagement.DataStore.Model;
    using ContractManagement.DataStore.Repositories;
    using Endpoint.Infrastructure.DTOs;
    using Endpoint.UpdateDraftContractAmendment;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus.Testing;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.DTOs;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence.Entities;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using contractor = SFA.FCT.CrossDomain.Integration.Entities.ContractRequest.contractor;
    using contractType = SFA.FCT.CrossDomain.Integration.Entities.ContractRequest.contractType;

    [TestClass]
    public class UpdateDraftContractAmendmentSagaTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public async Task Handle_DuplicateMessage_DoesNotUploadSagaData()
        {
            var setup = new SagaSetup(new ModifySagaTestFixture(messageNotYetProcessed: false));

            await setup.Saga.Handle(BuildCommand(), new TestableMessageHandlerContext());

            setup.SagaStorage.Verify(s => s.UploadSagaData(It.IsAny<string>(), It.IsAny<SagaStorageValue>()), Times.Never);
        }

        [TestMethod, TestCategory("UnitTest")]
        public async Task Handle_ValidRequest_UploadsSagaDataWithUpdateAmendmentIntent()
        {
            var setup = new SagaSetup(new ModifySagaTestFixture());
            setup.AllValidationPasses();

            await setup.Saga.Handle(BuildCommand(), new TestableMessageHandlerContext());

            setup.SagaStorage.Verify(
                s => s.UploadSagaData(CreateSagaTestFixture.ProcessId, It.Is<SagaStorageValue>(v => v.Intent == Intent.UpdateAmendment)),
                Times.Once);
        }

        [TestMethod, TestCategory("UnitTest")]
        public async Task Handle_ValidRequest_IncrementsSubVersionOfSubContract()
        {
            var setup = new SagaSetup(new ModifySagaTestFixture());
            setup.AllValidationPasses();
            UpdateDraftContractAmendmentRequestCommand command = BuildCommand();
            contractType child = command.ContractRequest.contract.contracts.Single();
            child.contractSubVersionNumber = 3;

            await setup.Saga.Handle(command, new TestableMessageHandlerContext());

            Assert.AreEqual(4, child.contractSubVersionNumber);
        }

        [TestMethod, TestCategory("UnitTest")]
        public async Task Handle_ValidRequest_LoadsApprovedAllocationsForSubContract()
        {
            var setup = new SagaSetup(new ModifySagaTestFixture());
            setup.AllValidationPasses();

            await setup.Saga.Handle(BuildCommand(), new TestableMessageHandlerContext());

            setup.LookupManager.Verify(l => l.GetAllocationsForApprovedContract(ModifySagaTestFixture.ChildContractNumber), Times.AtLeastOnce);
        }

        [TestMethod, TestCategory("UnitTest")]
        public async Task Handle_ValidRequest_LooksUpFundingTypeFundingPeriod()
        {
            var setup = new SagaSetup(new ModifySagaTestFixture());
            setup.AllValidationPasses();

            await setup.Saga.Handle(BuildCommand(), new TestableMessageHandlerContext());

            setup.FundingTypeFundingPeriods.Verify(
                r => r.Get(CreateSagaTestFixture.FundingType, CreateSagaTestFixture.FundingPeriod, It.IsAny<ConnectionInfo>()),
                Times.Once);
        }

        private static UpdateDraftContractAmendmentRequestCommand BuildCommand()
        {
            contractRequestType request = CreateSagaTestFixture.BuildRequest(intent.UpdateDraftAmendment);
            contractType child = request.contract.contracts.Single();
            child.contractNumber = ModifySagaTestFixture.ChildContractNumber;
            child.contractor = new contractor { ukprn = 10000001, organisationIdentifier = "ORG1" };
            return new UpdateDraftContractAmendmentRequestCommand { ContractRequest = request };
        }

        private class SagaSetup
        {
            public SagaSetup(ModifySagaTestFixture fixture)
            {
                Fixture = fixture;
                FundingTypeFundingPeriods.Setup(r => r.Get(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                    .Returns(new FundingTypeFundingPeriod());

                Saga = new UpdateDraftContractAmendmentSaga(
                    fixture.Logger.Object,
                    Rules.Object,
                    fixture.Lookup.Object,
                    fixture.Validator.Object,
                    fixture.OrganisationEnricher.Object,
                    fixture.Masher.Object,
                    fixture.Transformer.Object,
                    fixture.DeliverableEnricher.Object,
                    fixture.ValueAggregator.Object,
                    fixture.ContractsManager.Object,
                    fixture.NumberRequestManager.Object,
                    LookupManager.Object,
                    fixture.Processed.Object,
                    fixture.Merger.Object,
                    fixture.Sessions.Object,
                    FundingTypeFundingPeriods.Object,
                    fixture.LegalDeliverables.Object,
                    SagaStorage.Object,
                    ContractTypeRepository.Object,
                    fixture.CheckForChange.Object,
                    fixture.Sibling.Object,
                    fixture.Related.Object,
                    fixture.LastApproved.Object);
            }

            public ModifySagaTestFixture Fixture { get; }

            public UpdateDraftContractAmendmentSaga Saga { get; }

            public Mock<Endpoint.Infrastructure.IContractOperationRules> Rules { get; } = new Mock<Endpoint.Infrastructure.IContractOperationRules>();

            public Mock<ILookupManager> LookupManager { get; } = new Mock<ILookupManager>();

            public Mock<Endpoint.Infrastructure.ISagaDataStorage> SagaStorage { get; } = new Mock<Endpoint.Infrastructure.ISagaDataStorage>();

            public Mock<Endpoint.Infrastructure.IFundingTypeFundingPeriodQueryRepository> FundingTypeFundingPeriods { get; } = new Mock<Endpoint.Infrastructure.IFundingTypeFundingPeriodQueryRepository>();

            public Mock<IFundingTypeFundingPeriodContractTypeQueryRepository> ContractTypeRepository { get; } = new Mock<IFundingTypeFundingPeriodContractTypeQueryRepository>();

            public void AllValidationPasses()
            {
                Fixture.Validator.Setup(v => v.Validate(It.IsAny<contractRequestType>(), It.IsAny<IEnumerable<SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.IRule<contractRequestType>>>())).Returns(true);
                Fixture.Transformer.Setup(t => t.TransformAllocationsToContractRequestContract(It.IsAny<IEnumerable<AllocationValueData>>(), It.IsAny<string>(), It.IsAny<int>())).Returns(new contractType { contracts = new List<contractType>() });
            }
        }
    }
}
