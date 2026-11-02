namespace ContractCreateDomain.Endpoint.Tests.CreateContract
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using ContractManagement.DataStore.Model;
    using Endpoint.CreateContract;
    using Endpoint.CreateContractInternal;
    using Endpoint.Infrastructure;
    using Endpoint.Infrastructure.DTOs;
    using Endpoint.Infrastructure.Extensions;
    using Endpoint.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using Newtonsoft.Json;
    using NServiceBus;
    using NServiceBus.Testing;
    using SFA.FCT.ContractCreateDomain.BusinessLogic;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.DTOs;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence.Entities;
    using SFA.FCT.ContractCreateDomain.Implementation.Services;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.CrossDomain.Integration.Messages.Messages;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.Framework.Logging.NullObjects;
    using contractor = SFA.FCT.CrossDomain.Integration.Entities.ContractRequest.contractor;
    using contractType = SFA.FCT.CrossDomain.Integration.Entities.ContractRequest.contractType;
    using ContractOperationRules = Endpoint.Infrastructure.ContractOperationRules;
    using hierarchyType = SFA.FCT.CrossDomain.Integration.Entities.ContractRequest.hierarchyType;
    using IContractValidationLookupDataCreator = Endpoint.Infrastructure.IContractValidationLookupDataCreator;
    using periodTypeType = SFA.FCT.CrossDomain.Integration.Entities.ContractRequest.periodTypeType;
    using SFA.FCT.CrossDomain.Integration.Events;

    [TestClass]
    public class NewContractSagaTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void NewContractSaga_ShouldResolve()
        {
            // arrange
            IWindsorContainer container = new WindsorContainer()
                .Install(new ContractCreateDomain.Endpoint.WindsorInstallerForSagas(new LoggerFactory()))
                .Register(Component.For<NewContractSaga>());

            container.BeginScope();            

            // act, assert
            container.Resolve<NewContractSaga>();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DocumentGenerationCompleteHandler_ShouldResolve()
        {
            // arrange
            IWindsorContainer container = new WindsorContainer()
                .Install(new ContractCreateDomain.Endpoint.WindsorInstallerForSagas(new LoggerFactory()))
                .Register(Component.For<DocumentGenerationCompleteHandler>());

            container.BeginScope();

            // act, assert
            container.Resolve<DocumentGenerationCompleteHandler>();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void NewContractSaga_CreateNewLevyContract_ShouldNotReply()
        {
            // Arrange
            TestableMessageHandlerContext context = new TestableMessageHandlerContext();
            var message = new NewContractRequestCommand
            {
                ContractRequest = DasRequestTransformer.Transform(new DasRequest
                {
                    StartDate = new DateTime(2017, 1, 1),
                    FundingType = "LEVY",
                    Ukprn = 10095678
                })
            };

            CreateContractSagaData sagaData = new CreateContractSagaData
            {
                ShouldReply = false
            };

            // Act
            CreateSagaAndHandleMessage(() => message, context, sagaData);

            // Verify
            Assert.IsFalse(
                context.SentMessages.Any(m => m.Message.GetType() == typeof(ContractRequestProcessedCommand)));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void NewContractSaga_CreateNewNonLevyContract_ShouldReply()
        {
            TestableMessageHandlerContext context = new TestableMessageHandlerContext();
            var message = new NewContractRequestCommand
            {
                ContractRequest = DasRequestTransformer.Transform(new DasRequest
                {
                    StartDate = new DateTime(2017, 1, 1),
                    FundingType = "LEVY",
                    Ukprn = 10095678
                })
            };

            CreateContractSagaData sagaData = new CreateContractSagaData
            {
                ShouldReply = true
            };

            // Act
            CreateSagaAndHandleMessage(() => message, context, sagaData);

            // Verify
            Assert.IsTrue(
                context.SentMessages.Any(m => m.Message.GetType() == typeof(ContractRequestProcessedCommand)));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DocumentGenerationCompleteHandler_ShouldSetAdditionalPropertiesONExtendedContractTypeWhenGetCommandToSaveToCrmIsCalled()
        {
            // arrange
            var msg = new DocumentGenerationComplete
            {
                Contract = new contract
                {
                    contracts = new List<SFA.FCT.CrossDomain.Integration.Entities.CorporateContract.contractType>
                    {
                        new SFA.FCT.CrossDomain.Integration.Entities.CorporateContract.contractType
                        {
                            fundingType = new fundingType
                            {
                                fundingTypeCode = "LEVY"
                            },
                            period = new period
                            {
                                periodType =
                                    new SFA.FCT.CrossDomain.Integration.Entities.CorporateContract.periodTypeType
                                    {
                                        periodTypeCode = periodTypeCodeType.LEVY
                                    },
                                period1 = "1799"
                            }
                        }
                    }
                }
            };
            ExtendedContractType contractType = new ExtendedContractType
            {
                contracts = new List<ExtendedContractType>
                {
                    new ExtendedContractType
                    {
                        fundingType = new fundingType
                        {
                            fundingTypeCode = "LEVY"
                        },
                        period = new period
                        {
                            periodType =
                                new SFA.FCT.CrossDomain.Integration.Entities.CorporateContract.periodTypeType
                                {
                                    periodTypeCode = periodTypeCodeType.LEVY
                                },
                            period1 = "1799"
                        }
                    }
                }
            };

            CreateContractSagaData sagaData = new CreateContractSagaData
            {
                ExtendedContractType = contractType.ConvertObjectToByteArray(),
                ContractRequestContract = new contractRequestType
                {
                    correlationInfo = new correlationInfoType()
                }.ConvertObjectToByteArray()
            };

            Mock<ISagaDataStorage> sagaDataStorageMock = new Mock<ISagaDataStorage>();
            sagaDataStorageMock.Setup(r => r.GetSagaData<SagaStorageValue>(It.IsAny<string>())).Returns(
                new SagaStorageValue
                (
                    JsonConvert.SerializeObject(sagaData),
                    Intent.New
                ));

            Mock<IFundingTypeFundingPeriodQueryRepository> fundingTypeFundingPeriodQueryRepositoryMock = new Mock<IFundingTypeFundingPeriodQueryRepository>();
            fundingTypeFundingPeriodQueryRepositoryMock
                .Setup(r => r.Get(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<ConnectionInfo>())).Returns(
                    new FundingTypeFundingPeriod
                    {
                        DocumentsRequired = true,
                        SkipDocumentMerge = true
                    });

            DocumentGenerationCompleteHandler handler = new DocumentGenerationCompleteHandler(
                sagaDataStorageMock.Object,
                new LoggerNullObject(),
                fundingTypeFundingPeriodQueryRepositoryMock.Object,
                new FundingTypePeriodService(), 
                Mock.Of<ISessionConnectionFactory>());
            var nsbContext = new TestableInvokeHandlerContext();

            // act 
            handler.Handle(msg, nsbContext).Wait();

            // assert
            Assert.AreEqual(1, nsbContext.SentMessages.Length, "The number of commands created is incorrect");
            CreateContractCommand command = nsbContext.SentMessages.Select(m => m.Message).Cast<CreateContractCommand>().First();
            ExtendedContractType childContract = command.CorporateContract.contracts.First();

            Assert.AreEqual(true, childContract.DocumentationRequired, "IsDocumentationRequired should be set to true");
            Assert.AreEqual(true, childContract.SkipDocumentMerge, "SkipDocumentMerge should be set to true");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void NewContractSaga_CreateNewLevyContract_ShouldLogErrorIfSevereErrorPresent()
        {
            // Arrange
            var message = new NewContractRequestCommand
            {
                ContractRequest = DasRequestTransformer.Transform(new DasRequest
                {
                    StartDate = new DateTime(2017, 1, 1),
                    FundingType = "LEVY",
                    Ukprn = 10095678,
                    DasEngagementEventId = 1
                }),
                DasEngagementEventId = 1,
                ShouldReply = false
            };

            message.ContractRequest.errorInfo.Add(new errorInfoType
            {
                Severity = ErrorSeverity.Severe
            });
            var nsbContext = new TestableMessageHandlerContext();

            Mock<ILogger> loggerMock = new Mock<ILogger>();
            CreateContractSagaData sagaData = new CreateContractSagaData
            {
                ShouldReply = false
            };

            // Act
            CreateSagaAndHandleMessage(() => message, nsbContext, sagaData, loggerMock.Object);

            // Assert
            loggerMock.Verify(l => l.LogError(It.IsAny<int>(), It.IsAny<string>(), It.IsAny<object[]>()), Times.Once, "Severe errors should result in an error being logged");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void NewContractSaga_CreateNewLevyContract_ShouldSendMarkDasEngagementAsRejectedCommandOnFailure()
        {
            // Arrange
            var message = new NewContractRequestCommand
            {
                ContractRequest = DasRequestTransformer.Transform(new DasRequest
                {
                    StartDate = new DateTime(2017, 1, 1),
                    FundingType = "LEVY",
                    Ukprn = 10095678,
                    DasEngagementEventId = 1
                }),
                DasEngagementEventId = 1,
                ShouldReply = false
            };

            message.ContractRequest.errorInfo.Add(new errorInfoType
            {
                Severity = ErrorSeverity.Severe
            });


            message.ContractRequest.contract.contractor.organisationIdentifier = "10095678";

            Mock<IValidator> validatorMock = new Mock<IValidator>();
            validatorMock.Setup(v =>
                    v.Validate(It.IsAny<contractRequestType>(), It.IsAny<IEnumerable<IRule<contractRequestType>>>()))
                .Returns(false);
            
            Mock<ILogger> loggerMock = new Mock<ILogger>();
            var nsbContext = new TestableMessageHandlerContext();
            CreateContractSagaData sagaData = new CreateContractSagaData
            {
                ShouldReply = false,
                DasEngagementEventId = 1
            };

            // Act
            CreateSagaAndHandleMessage(() => message, nsbContext, sagaData, loggerMock.Object, validatorMock.Object);

            // Assert
            Assert.IsTrue(nsbContext.PublishedMessages.Select(pm => pm.Message).Cast<DasContractRequestRejectedEvent>().Count() == 1);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void NewContractSaga_Handle_ShouldNotProcessIfWeHaveAlreadyProcessed()
        {
            // arrange
            var message = new NewContractRequestCommand
            {
                ContractRequest = DasRequestTransformer.Transform(new DasRequest
                {
                    StartDate = new DateTime(2017, 1, 1),
                    FundingType = "LEVY",
                    Ukprn = 10095678,
                    DasEngagementEventId = 1
                }),
                DasEngagementEventId = 1,
                ShouldReply = false
            };

            Mock<IProcessedMessageRepository> processedMessageRepositoryMock = new Mock<IProcessedMessageRepository>();
            processedMessageRepositoryMock.Setup(r => r.Add(It.IsAny<string>(), It.IsAny<ConnectionInfo>())).Returns(false);
            var nsbContext = new TestableMessageHandlerContext();
            CreateContractSagaData sagaData = new CreateContractSagaData
            {
                ShouldReply = false,
                DasEngagementEventId = 1
            };

            Mock<IOrganisationMessageEnricher> mockOrganisationMessageEnricher = new Mock<IOrganisationMessageEnricher>();

            // act
            CreateSagaAndHandleMessage(() => message, nsbContext, sagaData, new LoggerNullObject(), null, processedMessageRepositoryMock.Object, mockOrganisationMessageEnricher.Object);

            // assert
            mockOrganisationMessageEnricher.Verify(c => c.Enrich(It.IsAny<contractRequestType>()), Times.Never);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void NewContractSaga_Handle_ShouldProcessIfWeHaveNotAlreadyProcessed()
        {
            // arrange
            var message = new NewContractRequestCommand
            {
                ContractRequest = DasRequestTransformer.Transform(new DasRequest
                {
                    StartDate = new DateTime(2017, 1, 1),
                    FundingType = "LEVY",
                    Ukprn = 10095678,
                    DasEngagementEventId = 1
                }),
                DasEngagementEventId = 1,
                ShouldReply = false
            };

            Mock<IProcessedMessageRepository> processedMessageRepositoryMock = new Mock<IProcessedMessageRepository>();
            processedMessageRepositoryMock.Setup(r => r.Add(It.IsAny<string>(), It.IsAny<ConnectionInfo>())).Returns(true);
            var nsbContext = new TestableMessageHandlerContext();
            CreateContractSagaData sagaData = new CreateContractSagaData
            {
                ShouldReply = false,
                DasEngagementEventId = 1
            };

            Mock<IOrganisationMessageEnricher> mockOrganisationMessageEnricher = new Mock<IOrganisationMessageEnricher>();

            // act
            CreateSagaAndHandleMessage(() => message, nsbContext, sagaData, new LoggerNullObject(), null, processedMessageRepositoryMock.Object, mockOrganisationMessageEnricher.Object);

            // assert
            mockOrganisationMessageEnricher.Verify(c => c.Enrich(It.IsAny<contractRequestType>()), Times.AtLeastOnce);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void NewContractSaga_Handle_ShouldSetProcessIdToNonNullForSuccessfulStorageOfSagaDataIfWeHaveAlreadyProcessedMessage()
        {
            // arrange
            var message = new NewContractRequestCommand
            {
                ContractRequest = DasRequestTransformer.Transform(new DasRequest
                {
                    StartDate = new DateTime(2017, 1, 1),
                    FundingType = "LEVY",
                    Ukprn = 10095678,
                    DasEngagementEventId = 1
                }),
                DasEngagementEventId = 1,
                ShouldReply = false
            };

            Mock<IProcessedMessageRepository> processedMessageRepositoryMock = new Mock<IProcessedMessageRepository>();
            processedMessageRepositoryMock.Setup(r => r.Add(It.IsAny<string>(), It.IsAny<ConnectionInfo>())).Returns(false);
            var nsbContext = new TestableMessageHandlerContext();
            CreateContractSagaData sagaData = new CreateContractSagaData
            {
                ShouldReply = false,
                DasEngagementEventId = 1
            };

            Mock<IOrganisationMessageEnricher> mockOrganisationMessageEnricher = new Mock<IOrganisationMessageEnricher>();

            // act
            CreateSagaAndHandleMessage(() => message, nsbContext, sagaData, new LoggerNullObject(), null, processedMessageRepositoryMock.Object, mockOrganisationMessageEnricher.Object);

            // assert
            Assert.IsNotNull(sagaData.ProcessId);
        }

        private void CreateSagaAndHandleMessage(
            Func<CreateContractRequestCommand> getCommand,
            IMessageHandlerContext context,
            CreateContractSagaData sagaData,
            ILogger logger = null,
            IValidator validator = null,
            IProcessedMessageRepository processedMessageRepository = null,
            IOrganisationMessageEnricher organisationMessageEnricher = null)
        {
            ContractDeliverableEnricher enricher = new ContractDeliverableEnricher(Mock.Of<IFundingStreamConfigService>());
            Mock<IContractDeliverableEnricher> enricherMock = new Mock<IContractDeliverableEnricher>();
            Mock<IProcessedMessageRepository> processedMessageRepositoryMock = new Mock<IProcessedMessageRepository>();
            processedMessageRepositoryMock.Setup(r => r.Add(It.IsAny<string>(), It.IsAny<ConnectionInfo>())).Returns(true);

            IProcessedMessageRepository processedMessageRepositoryToUse =
                processedMessageRepository ?? processedMessageRepositoryMock.Object;
            Mock<INumberRequestManager> numberRequestManagerMock = new Mock<INumberRequestManager>();
            numberRequestManagerMock.Setup(r => r.GetContractNumbers(It.IsAny<contractRequestType>(), It.IsAny<ConnectionInfo>()))
                .Returns((contractRequestType cr) => cr);

            CreateContractSaga saga = new CreateContractSaga(enricherMock.Object,
                new ContractRequestTransformer(),
                new ContractValueAggregator(),
                logger ?? new LoggerNullObject(),
                numberRequestManagerMock.Object,
                organisationMessageEnricher ?? Mock.Of<IOrganisationMessageEnricher>(),
                validator ?? new Validator
                {
                    Logger = Mock.Of<ILogger>()
                },
                processedMessageRepositoryToUse,
                Mock.Of<ISessionConnectionFactory>(),
                1,
                Mock.Of<IContractValidationLookupDataCreator>(),
                Mock.Of<ISiblingApprovedContractService>(),
                Mock.Of<IRelatedAllocationEnricher>());

            // act
            saga.Handle(getCommand(), context,
                sagaData,
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

        private static class DasRequestTransformer
        {
            private const string Period = "1799";
            private const string PeriodTypeCode = "LEVY";
            private const string FundingStreamCode = "LEVY";
            private const string PeriodTypeName = "";
            private const decimal MaximumContractValue = 0.0m;
            private const string FundingStreamPeriodCode = "LEVY1799";
            private const intent NewIntent = intent.New;
            private const string ContractType = "Provider Agreement";
            private const int AmendmentType = 0;
            private const int VersionNumber = 1;

            public static contractRequestType Transform(DasRequest request)
            {
                contractAllocation allocation = new contractAllocation
                {
                    period = new periodType
                    {
                        period = Period,
                        startDate = DateTime.MinValue,
                        endDate = DateTime.MinValue,
                        periodType1 = new periodTypeType
                        {
                            periodTypeCode = PeriodTypeCode,
                            periodTypeName = PeriodTypeName
                        }
                    },
                    ukprn = request.Ukprn,
                    fundingStreamCode = FundingStreamCode,
                    startDate = request.StartDate,
                    maximumContractValue = MaximumContractValue,
                    fundingStreamPeriodCode = FundingStreamPeriodCode,
                    contractDeliverables = new List<contractDeliverable>(),
                    correlationId = Guid.NewGuid().ToString("D")
                };

                contractType contract = new contractType
                {
                    ApprovedAllocationValues = new List<AllocationValueData>(),
                    contracts = new List<contractType>(),
                    fundingTypeCode = request.FundingType,
                    period = new periodType
                    {
                        period = Period,
                        startDate = DateTime.MinValue,
                        endDate = DateTime.MinValue,
                        periodType1 = new periodTypeType
                        {
                            periodTypeName = PeriodTypeName,
                            periodTypeCode = PeriodTypeCode
                        }
                    },
                    contractAllocations = new List<contractAllocation> { allocation },
                    contractVersionNumber = VersionNumber,
                    contractor = new contractor
                    {
                        ukprn = request.Ukprn
                    },
                    hierarchyType = hierarchyType.CONTRACT,
                    contractType1 = ContractType,
                    startDate = request.StartDate.ToUniversalTime(),
                    amendmentType = AmendmentType,
                    correlationId = Guid.NewGuid().ToString("D")
                };

                contractType masterContract = new contractType
                {
                    ApprovedAllocationValues = new List<AllocationValueData>(),
                    contracts = new List<contractType> { contract },
                    fundingTypeCode = request.FundingType,
                    contractAllocations = new List<contractAllocation>(),
                    contractVersionNumber = VersionNumber,
                    contractor = new contractor
                    {
                        ukprn = request.Ukprn
                    },
                    hierarchyType = 0,
                    startDate = request.StartDate.ToUniversalTime(),
                    CRMIntent = NewIntent,
                    amendmentType = AmendmentType,
                    correlationId = contract.correlationId,
                    period = null
                };

                contractRequestType transformedRequest = new contractRequestType
                {
                    contract = masterContract,
                    errorInfo = new List<errorInfoType>(),
                    FundingConfiguration = GetFundingConfiguration(),
                    correlationInfo = new correlationInfoType
                    {
                        correlationId = Guid.NewGuid().ToString("D"),
                        batchId = ""
                    }
                };

                return transformedRequest;
            }

            private static List<FundingConfigurationDataType> GetFundingConfiguration()
            {
                return new List<FundingConfigurationDataType>
                       {
                           new FundingConfigurationDataType
                               {
                                   FundingTypeCode = "LEVY", // Not using constant, in case FSC/PTC changes - not using request data
                                   FundingStreamCode = FundingStreamCode,
                                   FundingStreamPeriodCode = FundingStreamPeriodCode,
                                   Period = Period,
                                   PeriodTypeCode = PeriodTypeCode
                               }
                       };
            }
        }
    }
}
