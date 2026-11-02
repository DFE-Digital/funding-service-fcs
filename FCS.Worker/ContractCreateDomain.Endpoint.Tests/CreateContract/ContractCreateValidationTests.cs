namespace ContractCreateDomain.Endpoint.Tests.CreateContract
{
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using System.Reflection;
    using ContractManagement.DataStore.Model;
    using Endpoint.Infrastructure;
    using Endpoint.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using Newtonsoft.Json;
    using NServiceBus;
    using SFA.FCT.ContractCreateDomain.BusinessLogic;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.DTOs;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence.Entities;
    using SFA.FCT.ContractCreateDomain.Implementation.Services;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.Framework.Logging.NullObjects;
    using ContractOperationRules = Endpoint.Infrastructure.ContractOperationRules;
    using FundingConfigurationDataType = SFA.FCT.CrossDomain.Integration.Entities.ContractRequest.FundingConfigurationDataType;
    using IContractValidationLookupDataCreator = Endpoint.Infrastructure.IContractValidationLookupDataCreator;

    [TestClass]
    public class ContractCreateValidationTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ContractCreate_ShouldReject_NewAmendmentRequestCommand_WhenDatesNotSet()
        {
            // arrange
            NewAmendmentRequestCommand command = new NewAmendmentRequestCommand
            {
                ContractRequest = GetContractRequestTypeFromFile("NewAmendmentRequestCommand.json")
            };

            command.ContractRequest.contract.contracts.First().startDate = null;

            CreateSagaAndHandleMessage(() => command);

            // assert
            Assert.IsTrue(command.ContractRequest.errorInfo.Any(e => e.Value == "The Contract must have a start and end date"));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractCreate_ShouldReject_NewContractRequestCommand_WhenDatesNotSet()
        {
            // arrange
            NewContractRequestCommand command = new NewContractRequestCommand
            {
                ContractRequest = GetContractRequestTypeFromFile("NewAmendmentRequestCommand.json")
            };

            command.ContractRequest.contract.contracts.First().startDate = null;

            CreateSagaAndHandleMessage(() => command);

            // assert
            Assert.IsTrue(command.ContractRequest.errorInfo.Any(e => e.Value == "The Contract must have a start and end date"));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractCreate_ShouldReject_RevisedNewContractRequestCommand_WhenDatesNotSet()
        {
            // arrange
            RevisedNewContractRequestCommand command = new RevisedNewContractRequestCommand
            {
                ContractRequest = GetContractRequestTypeFromFile("NewAmendmentRequestCommand.json")
            };

            command.ContractRequest.contract.contracts.First().startDate = null;

            CreateSagaAndHandleMessage(() => command);

            // assert
            Assert.IsTrue(command.ContractRequest.errorInfo.Any(e => e.Value == "The Contract must have a start and end date"));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractCreate_ShouldReject_NewAmendmentRequestCommand_WhenSiblingContractHasDraftStatus()
        {
            // arrange
            NewAmendmentRequestCommand command = new NewAmendmentRequestCommand
            {
                ContractRequest = GetContractRequestTypeFromFile("NewAmendmentRequestCommand.json")
            };

            command.ContractRequest.contract.contracts.First().startDate = null;

            CreateSagaAndHandleMessageSiblingContractWithDraftStatusRuleReturningTrue(() => command);

            // assert
            Assert.IsTrue(command.ContractRequest.errorInfo.Any(e => e.Value == "This Master Contract cannot have more than one associated Contract in a draft status at the same time"));
        }

        private void CreateSagaAndHandleMessage(Func<CreateContractRequestCommand> getCommand)
        {
            
            IMessageHandlerContext nsbContext = Mock.Of<IMessageHandlerContext>();
            ContractDeliverableEnricher enricher = new ContractDeliverableEnricher(Mock.Of<IFundingStreamConfigService>());
            Mock<IProcessedMessageRepository> processedMessageRepository = new Mock<IProcessedMessageRepository>();
            processedMessageRepository.Setup(r => r.Add(It.IsAny<string>(), It.IsAny<ConnectionInfo>())).Returns(true);

            CreateContractSaga saga = new CreateContractSaga(enricher,
                new ContractRequestTransformer(),
                new ContractValueAggregator(),
                new LoggerNullObject(),
                Mock.Of<INumberRequestManager>(),
                Mock.Of<IOrganisationMessageEnricher>(),
                new Validator
                {
                    Logger = Mock.Of<ILogger>()
                },
                processedMessageRepository.Object,
                Mock.Of<ISessionConnectionFactory>(),
                1,
                Mock.Of<IContractValidationLookupDataCreator>(),
                Mock.Of<ISiblingApprovedContractService>(),
                Mock.Of<IRelatedAllocationEnricher>());

            // act
            saga.Handle(getCommand(), nsbContext,
                new CreateContractSagaData(),
                (p1, p2, p3) => new ContractOperationRules()
                    .GetNewAmendmentContractRules(
                        new List<FundingConfigurationDataType>(),
                        new List<string>(),
                        new List<string>(),
                        new List<UnitOfProcurement>(),
                        new List<string>(),
                        new List<string>(),
                        new List<string>(),
                        new Dictionary<string, FSCDeliverableStructureDefinitionResponse>(),
                        new List<MatchingTenderAwardReferenceItem>(),
                        false,
                        new List<FundingTypePeriodFundingStreamPeriod>(),
                        new List<FundingStreamPeriodLegalDeliverable>(),
                        getCommand().ContractRequest,
                        false,
                        () => new List<FundingTypeFundingPeriodContractTypeDto>(),
                        dto => true,
                        false)
                ).Wait();
        }

        private void CreateSagaAndHandleMessageSiblingContractWithDraftStatusRuleReturningTrue(Func<CreateContractRequestCommand> getCommand)
        {

            IMessageHandlerContext nsbContext = Mock.Of<IMessageHandlerContext>();
            ContractDeliverableEnricher enricher = new ContractDeliverableEnricher(Mock.Of<IFundingStreamConfigService>());
            Mock<IProcessedMessageRepository> processedMessageRepository = new Mock<IProcessedMessageRepository>();
            processedMessageRepository.Setup(r => r.Add(It.IsAny<string>(), It.IsAny<ConnectionInfo>())).Returns(true);

            CreateContractSaga saga = new CreateContractSaga(enricher,
                new ContractRequestTransformer(),
                new ContractValueAggregator(),
                new LoggerNullObject(),
                Mock.Of<INumberRequestManager>(),
                Mock.Of<IOrganisationMessageEnricher>(),
                new Validator
                {
                    Logger = Mock.Of<ILogger>()
                },
                processedMessageRepository.Object,
                Mock.Of<ISessionConnectionFactory>(),
                1,
                Mock.Of<IContractValidationLookupDataCreator>(),
                Mock.Of<ISiblingApprovedContractService>(),
                Mock.Of<IRelatedAllocationEnricher>());

            // act
            saga.Handle(getCommand(), nsbContext,
                new CreateContractSagaData(),
                (p1, p2, p3) => new ContractOperationRules()
                    .GetNewAmendmentContractRules(
                        new List<FundingConfigurationDataType>(),
                        new List<string>(),
                        new List<string>(),
                        new List<UnitOfProcurement>(),
                        new List<string>(),
                        new List<string>(),
                        new List<string>(),
                        new Dictionary<string, FSCDeliverableStructureDefinitionResponse>(),
                        new List<MatchingTenderAwardReferenceItem>(),
                        false,
                        new List<FundingTypePeriodFundingStreamPeriod>(),
                        new List<FundingStreamPeriodLegalDeliverable>(),
                        getCommand().ContractRequest,
                        false,
                        () => new List<FundingTypeFundingPeriodContractTypeDto>(),
                        dto => true,
                        true)
                ).Wait();
        }

        private static contractRequestType GetContractRequestTypeFromFile(string fileName)
        {
            using (Stream stream = Assembly.GetCallingAssembly().GetManifestResourceStream($"ContractCreateDomain.Endpoint.Tests.CreateContractInternal.Resources.{fileName}"))
            using (StreamReader streamReader = new StreamReader(stream))
            {
                return JsonConvert.DeserializeObject<NewAmendmentRequestCommand>(streamReader.ReadToEnd()).ContractRequest;
            }
        }
    }
}
