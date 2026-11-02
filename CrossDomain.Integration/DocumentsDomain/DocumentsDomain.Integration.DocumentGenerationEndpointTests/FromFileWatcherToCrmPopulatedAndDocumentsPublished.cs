namespace DocumentsDomain.Integration.DocumentGenerationEndpointTests
{
    using System;
    using System.Collections.Generic;
    using System.Runtime.Remoting.Metadata;
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus;
    using NServiceBus.AcceptanceTesting;
    using NServiceBus.Logging;
    using NServiceBusAcceptanceTestingAdditions;
    using SFA.FCT.ContractCreateDomain.BusinessLogic;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Commands;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Events;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation;
    using SFA.FCT.ContractCreateDomain.Common.Messages.Messages;
    using SFA.FCT.ContractCreateDomain.ContractRequest;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence.Entities;
    using SFA.FCT.ContractCreateDomain.XrmServiceHandlers;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.ExcelUpload;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.DocumentsDomain.Common.Commands;
    using SFA.FCT.DocumentsDomain.Integration.DocumentGenerationEndpoint;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.CrossDomain.Integration.Messages.Messages;
    using SFA.FCT.CrossDomain.Integration.Common.Serializers;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.Framework.Logging.NullObjects;
    using contractType = SFA.FCT.CrossDomain.Integration.Entities.ContractRequest.contractType;

    [TestClass]
    public class FromFileWatcherToCrmPopulatedAndDocumentsPublished
    {
        private const string DocumentPublishedFlag = "DocumentPublished";
        private const string ContractRequestProcessedFlag = "ContractRequestProcessed";
        private const string ContractValidationLookupDataResponseFlag = "ContractValidationLookupDataResponse";
        private const string ContractsManagerProcessContractFlag = "ContractsManagerProcessContract";

        [TestMethod, TestCategory("IntegrationTest1")]
        public void SendingNewExcelUploadFileEventShouldResultInCrmPopulatedAndDocumentsPublishedSuccess()
        {
            dataLoadResults uploadedExcelFile = GetInputTestData();
            using (Context ctx = GetInitialContext())
            {
                Scenario
                    .Define(ctx.Data)

                    .WithEndpoint<FileWatcherEndpoint>(builder =>
                        builder
                            .CustomConfig(StandardConventions.Configure())
                            .When(context => ctx.IsReadyToStart,
                                (bus, context) =>
                                    bus.Publish<INewExcelUploadFileEvent>(e => e.DataLoadResultsDatabus = uploadedExcelFile.ConvertObjectToByteArray())))

                    .WithEndpoint<BulkUploadHandlerEndpoint>(
                        builder => builder.CustomConfig(StandardConventions.Configure()))

                    .WithEndpoint<ContractRequestHandlerEndpoint>(
                        builder => builder.CustomConfig(ContractRequestHandlerEndpoint.Configure(ctx)))

                    .WithEndpoint<XrmServiceEndpoint>(
                        builder => builder.CustomConfig(XrmServiceEndpoint.Configure(ctx)))

                    .WithEndpoint<DocumentGenerationEndpoint>(
                        builder => builder.CustomConfig(DocumentGenerationEndpointFullyMocked.Configure(ctx)))

                    .WithEndpoint<DocumentSaverEndpoint>(
                        builder => builder.CustomConfig(DocumentGenerationEndpointFullyMocked.Configure(ctx)))

                    .WithEndpoint<DocumentPublishedEventSubscriberEndpoint>(
                        builder => builder.CustomConfig(StandardConventions.Configure()))

                    .Done(context => ctx.IsAllDone)

                    .Run(new TimeSpan(0, 1, 30));

                ctx.GetMockOf<IContractsManager>().Verify(contractsManager => contractsManager.ProcessContract(It.IsAny<contract>()), Times.Once);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void SendingNewExcelUploadFileEventShouldResultInCrmPopulatedAndDocumentsPublishedExpectedFailDueToDocumentsFailure()
        {
            dataLoadResults uploadedExcelFile = GetInputTestData();
            using (Context ctx = GetInitialContext())
            {
                try
                {
                    Scenario
                        .Define(ctx.Data)

                        .WithEndpoint<FileWatcherEndpoint>(builder =>
                            builder
                                .CustomConfig(StandardConventions.Configure())
                                .When(context => ctx.IsReadyToStart,
                                    (bus, context) =>
                                        bus.Publish<INewExcelUploadFileEvent>(e => e.DataLoadResultsDatabus = uploadedExcelFile.ConvertObjectToByteArray())))

                        .WithEndpoint<BulkUploadHandlerEndpoint>(
                            builder => builder.CustomConfig(StandardConventions.Configure()))

                        .WithEndpoint<ContractRequestHandlerEndpoint>(
                            builder => builder.CustomConfig(ContractRequestHandlerEndpoint.Configure(ctx)))

                        .WithEndpoint<XrmServiceEndpoint>(
                            builder => builder.CustomConfig(XrmServiceEndpoint.Configure(ctx)))

                        .WithEndpoint<DocumentGenerationEndpoint>(
                            builder => builder.CustomConfig(DocumentGenerationEndpointFullyMocked.Configure(ctx)))

                        .WithEndpoint<DocumentSaverEndpoint>(
                            builder => builder.CustomConfig(DocumentGenerationEndpointFullyMocked.Configure(ctx, new TimeSpan(0, 0, 40))))

                        .WithEndpoint<DocumentPublishedEventSubscriberEndpoint>(
                            builder => builder.CustomConfig(StandardConventions.Configure()))

                        .Done(context => ctx.IsAllDone)

                        .Run(new TimeSpan(0, 0, 30));

                    Assert.Fail("This test should have timed out and not reached here");
                }
                catch (AggregateException ex)
                {
                    if (ex.InnerExceptions.Count != 1 || !ex.InnerExceptions[0].Message.StartsWith("The maximum time limit for this test"))
                    {
                        throw;
                    }

                    ctx.GetMockOf<IContractsManager>().Verify(contractsManager => contractsManager.ProcessContract(It.IsAny<contract>()), Times.AtMost(0));
                }
            }
        }

        public dataLoadResults GetInputTestData()
        {
            return new dataLoadResults();
        }

        public Context GetInitialContext()
        {
            return new Context
            {
                ReadyToStart = contextData => contextData.EndpointsStarted
                                              && contextData.EndpointsSubscribed.Contains(typeof(BulkUploadHandlerEndpoint).Name + " - " + typeof(INewExcelUploadFileEvent).AssemblyQualifiedName)
                                              && contextData.EndpointsSubscribed.Contains(typeof(ContractRequestHandlerEndpoint).Name + " - " + typeof(NewContractRequestEvent).AssemblyQualifiedName)
                                              && contextData.EndpointsSubscribed.Contains(typeof(BulkUploadHandlerEndpoint).Name + " - " + typeof(ContractRequestProcessedEvent).AssemblyQualifiedName)
                                              && contextData.EndpointsSubscribed.Contains(typeof(DocumentPublishedEventSubscriberEndpoint).Name + " - " + typeof(IDocumentsPublishedEvent).AssemblyQualifiedName),
                AllDone = contextData =>
                {
                    bool done;
                    return contextData.Flags.TryGetValue(ContractsManagerProcessContractFlag, out done) && done
                           && contextData.Flags.TryGetValue(DocumentPublishedFlag, out done) && done
                           && contextData.Flags.TryGetValue(ContractRequestProcessedFlag, out done) && done;
                }
            };
        }

        public class FileWatcherEndpoint : EndpointConfigurationBuilder
        {
            public FileWatcherEndpoint()
            {
                EndpointSetup<DefaultServer>()
                    .IncludeType<INewExcelUploadFileEvent>();
            }
        }

        public class BulkUploadHandlerEndpoint : EndpointConfigurationBuilder
        {
            public BulkUploadHandlerEndpoint()
            {
                EndpointSetup<DefaultServer>()
                    .IncludeType<Handlers>()

                    .AddMapping<INewExcelUploadFileEvent>(typeof(FileWatcherEndpoint))
                    .AddMapping<ContractRequestProcessedEvent>(typeof(ContractRequestHandlerEndpoint))

                    .IncludeType<INewExcelUploadFileEvent>()
                    .IncludeType<NewContractRequestEvent>()
                    .IncludeType<ContractRequestProcessedEvent>();
            }

            public class Handlers : IHandleMessages<ContractRequestProcessedEvent>, IHandleMessages<INewExcelUploadFileEvent>
            {
                public Context.ContextData ContextData { get; set; }

                public IBus Bus { get; set; }

                public void Handle(INewExcelUploadFileEvent message)
                {
                    Bus.Publish<NewContractRequestEvent>(e => 
                        e.ContractRequest = new contractRequestType
                        {                          
                            contract = new contractType
                            {
                                contracts = new List<contractType>
                                {
                                    new contractType
                                    {
                                        contractAllocations = new List<contractAllocation>
                                        {
                                            new contractAllocation()
                                            {
                                                fundingStreamCode = "OLASS1516",
                                                startDate = new DateTime(2015, 08, 01),
                                                endDate = new DateTime(2016, 07, 31)
                                            }
                                        }
                                    }
                                },
                                fundingTypeCode = "MAIN"
                            },
                            correlationInfo = new correlationInfoType { correlationId = "TestCorrelationId"}
                        });
                }

                public void Handle(ContractRequestProcessedEvent message)
                {
                    new Context(ContextData).AddOrUpdateFlag(ContractRequestProcessedFlag, true);
                }
            }
        }

        public class ContractRequestHandlerEndpoint : EndpointConfigurationBuilder
        {
            public ContractRequestHandlerEndpoint()
            {
                EndpointSetup<DefaultServer>()
                    .IncludeType<ContractRequestHandler>()

                    .AddMapping<NewContractRequestEvent>(typeof(BulkUploadHandlerEndpoint))
                    .AddMapping<GetContractValidationLookupDataCommand>(typeof(XrmServiceEndpoint))
                    .AddMapping<AddContractNumbersCommand>(typeof(XrmServiceEndpoint))
                    .AddMapping<AddContractNumbersResponseEvent>(typeof(XrmServiceEndpoint))
                    .AddMapping<CreateContractCommand>(typeof(XrmServiceEndpoint))
                    .AddMapping<DocumentGenerationCommand>(typeof(DocumentGenerationEndpoint))

                    .IncludeType<NewContractRequestEvent>()
                    .IncludeType<ContractActionRequestedEvent>()
                    .IncludeType<GetContractValidationLookupDataCommand>()
                    .IncludeType<AddContractNumbersCommand>()
                    .IncludeType<ContractValidationLookupDataResponse>()
                    .IncludeType<AddContractNumbersComplete>()
                    .IncludeType<CreateContractCommand>()
                    .IncludeType<NewContractCreated>()
                    .IncludeType<ContractRequestProcessedEvent>()
                    .IncludeType<DocumentGenerationComplete>()
                    .IncludeType<DocumentGenerationCommand>()
                    .IncludeType<NewContractSagaTimeout>();
            }

            public static Action<BusConfiguration> Configure(Context ctx)
            {
                return configuration =>
                {
                    StandardConventions.Configure()(configuration);

                    configuration.UseContainer<WindsorBuilder>(
                        container => container.ExistingContainer(new WindsorContainer().Install(new Installer(ctx))));
                };
            }

            public class Installer : IWindsorInstaller
            {
                private Context _ctx;

                public Installer(Context ctx)
                {
                    _ctx = ctx;
                }

                public void Install(IWindsorContainer container, IConfigurationStore store)
                {
                    Mock<IContractRequestTransformer> contractRequestTransformerMock = new Mock<IContractRequestTransformer>();
                    contractRequestTransformerMock
                        .Setup(m => m.TransformToCorpContract(It.IsAny<contractRequestType>()))
                        .Returns(new contract());


                    Mock<IOrganisationMessageEnricher> organisationMessageEnricherMock = new Mock<IOrganisationMessageEnricher>();
                    Mock<IContractValueAggregator> contractValueAggregatorMock = new Mock<IContractValueAggregator>();
                    Mock<IContractDeliverableEnricher> contractDeliverableEnricherMock = new Mock<IContractDeliverableEnricher>();
                    Mock<IContractOperationRules> contractOperationRulesMock = new Mock<IContractOperationRules>();
                    Mock<IValidator> validatorMock = new Mock<IValidator>();
                    validatorMock.Setup(m => m.Validate(It.IsAny<contractRequestType>(), It.IsAny<IEnumerable<IRule<contractRequestType>>>())).Returns(true);

                    _ctx.AddMock(contractRequestTransformerMock);
                    _ctx.AddMock(organisationMessageEnricherMock);
                    _ctx.AddMock(contractValueAggregatorMock);
                    _ctx.AddMock(contractDeliverableEnricherMock);
                    _ctx.AddMock(contractOperationRulesMock);
                    _ctx.AddMock(validatorMock);

                    container.Register(
                        Component.For<IContractRequestTransformer>().Instance(contractRequestTransformerMock.Object),
                        Component.For<IOrganisationMessageEnricher>().Instance(organisationMessageEnricherMock.Object),
                        Component.For<IContractValueAggregator>().Instance(contractValueAggregatorMock.Object),
                        Component.For<IContractDeliverableEnricher>().Instance(contractDeliverableEnricherMock.Object),
                        Component.For<IContractOperationRules>().Instance(contractOperationRulesMock.Object),
                        Component.For<IValidator>().Instance(validatorMock.Object));
                }
            }
        }

        public class XrmServiceEndpoint : EndpointConfigurationBuilder
        {
            public XrmServiceEndpoint()
            {
                EndpointSetup<DefaultServer>()
                    .IncludeType<XrmService>()

                    .IncludeType<GetContractValidationLookupDataCommand>()
                    .IncludeType<AddContractNumbersCommand>()
                    .IncludeType<ContractValidationLookupDataResponse>()
                    .IncludeType<AddContractNumbersComplete>()
                    .IncludeType<CreateContractCommand>()
                    .IncludeType<NewContractCreated>()
                    .IncludeType<ContractRequestHandlerEndpoint>()

                    .AddMapping<ContractValidationLookupDataResponse>(typeof(ContractRequestHandlerEndpoint))
                    .AddMapping<AddContractNumbersComplete>(typeof(ContractRequestHandlerEndpoint));
            }

            public static Action<BusConfiguration> Configure(Context ctx)
            {
                return configuration =>
                {
                    StandardConventions.Configure()(configuration);

                    configuration.UseContainer<WindsorBuilder>(
                        container => container.ExistingContainer(new WindsorContainer().Install(new Installer(ctx))));
                };
            }

            public class Installer : IWindsorInstaller
            {
                private readonly Context _ctx;

                public Installer(Context ctx)
                {
                    _ctx = ctx;
                }

                public void Install(IWindsorContainer container, IConfigurationStore store)
                {
                    Mock<IContractValidationLookupDataCreator> contractValidationLookupDataCreatorMock = new Mock<IContractValidationLookupDataCreator>();
                    contractValidationLookupDataCreatorMock.Setup(m => m.CreateLookupData(It.IsAny<contractRequestType>())).Returns(new ContractValidationLookupData());

                    Mock<INumberRequestManager> numberRequestManagerMock = new Mock<INumberRequestManager>();
                    numberRequestManagerMock.Setup(m => m.GetContractNumbers(It.IsAny<contractRequestType>()))
                        .Returns<contractRequestType>(c => c)
                        .Callback<contractRequestType>(r =>
                        {
                            var contractId = 1;
                            foreach (var ct in r.GetSubContracts())
                            {
                                ct.contractNumber = "CONTRACT-" + (contractId++).ToString();

                                foreach (var ca in ct.contractAllocations)
                                {
                                    ca.contractAllocationNumber = "ALLOCATION-" + (contractId++).ToString();
                                }
                            }

                        });

                    Mock<IContractsManager> contractsManagerMock = new Mock<IContractsManager>();
                    contractsManagerMock
                        .Setup(m => m.ProcessContract(It.IsAny<contract>()))
                        .Callback(() => _ctx.AddOrUpdateFlag(ContractsManagerProcessContractFlag, true));

                    Mock<ILookupManager> lookupManager = new Mock<ILookupManager>();

                    _ctx.AddMock(contractValidationLookupDataCreatorMock);
                    _ctx.AddMock(numberRequestManagerMock);
                    _ctx.AddMock(contractsManagerMock);
                    _ctx.AddMock(lookupManager);

                    container.Register(
                        Component.For<IContractValidationLookupDataCreator>().Instance(contractValidationLookupDataCreatorMock.Object),
                        Component.For<INumberRequestManager>().Instance(numberRequestManagerMock.Object),
                        Component.For<IContractsManager>().Instance(contractsManagerMock.Object),
                        Component.For<ILookupManager>().Instance(lookupManager.Object),
                        Component.For<ILog>().Instance(LogManager.GetLogger(typeof(XrmService))).LifeStyle.Singleton);
                }
            }
        }

        public class DocumentGenerationEndpoint : EndpointConfigurationBuilder
        {
            public DocumentGenerationEndpoint()
            {
                EndpointSetup<DefaultServer>()
                    .IncludeType<DocumentGenerationHandler>()
                    .IncludeType<DocumentSaveCommand>()
                    .IncludeType<DocumentGenerationCommand>()
                    .AddMapping<DocumentSaveCommand>(typeof(DocumentSaverEndpoint));
            }
        }

        public class DocumentSaverEndpoint : EndpointConfigurationBuilder
        {
            public DocumentSaverEndpoint()
            {
                EndpointSetup<DefaultServer>()
                    .IncludeType<DocumentSaverHandler>()
                    .IncludeType<DocumentSaveCommand>()
                    .IncludeType<IDocumentsPublishedEvent>()
                    .IncludeType<DocumentGenerationComplete>();
            }
        }

        public class DocumentPublishedEventSubscriberEndpoint : EndpointConfigurationBuilder
        {
            public DocumentPublishedEventSubscriberEndpoint()
            {
                EndpointSetup<DefaultServer>()
                    .IncludeType<Handlers>()
                    .AddMapping<IDocumentsPublishedEvent>(typeof(DocumentSaverEndpoint))
                    .IncludeType<IDocumentsPublishedEvent>();
            }

            public class Handlers : IHandleMessages<IDocumentsPublishedEvent>
            {
                public Context.ContextData ContextData { get; set; }

                public IBus Bus { get; set; }

                public void Handle(IDocumentsPublishedEvent message)
                {
                    new Context(ContextData).AddOrUpdateFlag(DocumentPublishedFlag, true);
                }
            }
        }
    }
}