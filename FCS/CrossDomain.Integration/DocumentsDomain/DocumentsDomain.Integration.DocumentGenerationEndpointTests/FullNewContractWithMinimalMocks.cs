namespace DocumentsDomain.Integration.DocumentGenerationEndpointTests
{
    using System;
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
    using SFA.FCT.ContractCreateDomain.Common.Messages.Messages;
    using SFA.FCT.ContractCreateDomain.ContractRequest;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence.Entities;
    using SFA.FCT.ContractCreateDomain.XrmServiceHandlers;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.ExcelUpload;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.CrossDomain.Integration.Messages.Messages;
    using SFA.FCT.DocumentsDomain.Common.Commands;
    using SFA.FCT.DocumentsDomain.Integration.DocumentGenerationEndpoint;
    using SFA.FCT.CrossDomain.Integration.Common.Serializers;

    [TestClass]
    public class FullNewContractWithMinimalMocks
    {
        private const string DocumentPublishedFlag = "DocumentPublished";
        private const string ContractRequestProcessedFlag = "ContractRequestProcessed";
        private const string ContractValidationLookupDataResponseFlag = "ContractValidationLookupDataResponse";
        private const string ContractsManagerProcessContractFlag = "ContractsManagerProcessContract";

        /// <summary>
        /// 
        /// THIS IS WORK IN PROGRESS - DON'T BELIEVE THE CLASS NAME QUITE YET
        /// 
        /// </summary>
        [TestMethod, TestCategory("IntegrationTest1"), Ignore]
        public void SendingNewExcelUploadFileEventShouldResultInCrmPopulatedAndDocumentsPublished()
        {
            dataLoadResults uploadedExcelFile = GetInputTestData();
            using (Context ctx = GetInitialContext())
            {
                Scenario
                    .Define(ctx.Data)

                    .WithEndpoint<FileWatcherEndpoint>(builder =>
                        builder
                            .CustomConfig(StandardConventions.Configure())
                            .When(context => ctx.IsReadyToStart, (bus, context) => bus.Publish<INewExcelUploadFileEvent>(e => e.DataLoadResultsDatabus = uploadedExcelFile.ConvertObjectToByteArray())))

                    .WithEndpoint<BulkUploadHandlerEndpoint>(builder => builder.CustomConfig(StandardConventions.Configure()))

                    .WithEndpoint<ContractRequestHandlerEndpoint>(builder => builder.CustomConfig(ContractRequestHandlerEndpoint.Configure(ctx)))

                    .WithEndpoint<XrmServiceEndpoint>(builder => builder.CustomConfig(XrmServiceEndpoint.Configure(ctx)))

                    .WithEndpoint<DocumentGenerationEndpointMinimalMocks>(builder => builder.CustomConfig(DocumentGenerationEndpointMinimalMocks.Configure(ctx)))

                    .WithEndpoint<DocumentPublishedEventSubscriberEndpoint>(builder => builder.CustomConfig(StandardConventions.Configure()))

                    .Done(context => ctx.IsAllDone)

                    .Run(new TimeSpan(0, 10, 0));
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
                           && contextData.Flags.TryGetValue(ContractRequestProcessedFlag, out done) && done
                           && contextData.Flags.TryGetValue(ContractValidationLookupDataResponseFlag, out done) && done;
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
                    Bus.Publish<NewContractRequestEvent>(e => e.ContractRequest = new contractRequestType());
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
                    .IncludeType<Handlers>()
                    .IncludeType<ContractRequestHandler>()

                    .AddMapping<NewContractRequestEvent>(typeof(BulkUploadHandlerEndpoint))
                    .AddMapping<GetContractValidationLookupDataCommand>(typeof(XrmServiceEndpoint))
                    .AddMapping<AddContractNumbersCommand>(typeof(XrmServiceEndpoint))
                    .AddMapping<AddContractNumbersResponseEvent>(typeof(XrmServiceEndpoint))
                    .AddMapping<CreateContractCommand>(typeof(XrmServiceEndpoint))
                    .AddMapping<DocumentGenerationCommand>(typeof(DocumentGenerationEndpointMinimalMocks))

                    .IncludeType<NewContractRequestEvent>()
                    .IncludeType<GetContractValidationLookupDataCommand>()
                    .IncludeType<AddContractNumbersCommand>()
                    .IncludeType<ContractValidationLookupDataResponse>()
                    .IncludeType<AddContractNumbersComplete>()
                    .IncludeType<CreateContractCommand>()
                    .IncludeType<ContractRequestProcessedEvent>()
                    .IncludeType<DocumentGenerationCommand>()
                    .IncludeType<DocumentGenerationComplete>();
            }

            public class Handlers : IHandleMessages<ContractValidationLookupDataResponse>
            {
                public Context.ContextData ContextData { get; set; }

                public IBus Bus { get; set; }

                public void Handle(ContractValidationLookupDataResponse message)
                {
                    new Context(ContextData).AddOrUpdateFlag(ContractValidationLookupDataResponseFlag, true);
                }

                
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
                    Mock<IOrganisationMessageEnricher> organisationMessageEnricherMock = new Mock<IOrganisationMessageEnricher>();
                    Mock<IContractValueAggregator> contractValueAggregator = new Mock<IContractValueAggregator>();
                    Mock<IContractDeliverableEnricher> contractDeliverableEnricher = new Mock<IContractDeliverableEnricher>();

                    _ctx.AddMock(contractRequestTransformerMock);
                    _ctx.AddMock(organisationMessageEnricherMock);
                    _ctx.AddMock(contractValueAggregator);
                    _ctx.AddMock(contractDeliverableEnricher);

                    container.Register(
                        Component.For<IContractRequestTransformer>().Instance(contractRequestTransformerMock.Object),
                        Component.For<IOrganisationMessageEnricher>().Instance(organisationMessageEnricherMock.Object),
                        Component.For<IContractValueAggregator>().Instance(contractValueAggregator.Object),
                        Component.For<IContractDeliverableEnricher>().Instance(contractDeliverableEnricher.Object));
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
                    .IncludeType<IDocumentsPublishedEvent>();
            }
        }

        public class DocumentPublishedEventSubscriberEndpoint : EndpointConfigurationBuilder
        {
            public DocumentPublishedEventSubscriberEndpoint()
            {
                EndpointSetup<DefaultServer>()
                    .IncludeType<Handlers>()
                    .AddMapping<IDocumentsPublishedEvent>(typeof(DocumentGenerationEndpointMinimalMocks))
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