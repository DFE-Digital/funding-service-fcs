namespace DocumentsDomain.Integration.DocumentGenerationEndpointTests
{
    using System;
    using System.Diagnostics;
    using System.Text;
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using Moq;
    using NServiceBus;
    using NServiceBus.AcceptanceTesting;
    using NServiceBusAcceptanceTestingAdditions;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.CrossDomain.Integration.Messages.Messages;
    using SFA.FCT.DocumentsDomain.Common.Commands;
    using SFA.FCT.DocumentsDomain.DocumentGeneration;
    using SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentCreator;
    using SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentDefiner;
    using SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentDefiner.DocumentConfiguration;
    using SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentMerger;
    using SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentSaver;
    using SFA.FCT.DocumentsDomain.Integration;
    using SFA.FCT.DocumentsDomain.Integration.DocumentGenerationEndpoint;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.DocumentsDomain.Common.Models;

    public class DocumentGenerationEndpointMinimalMocks : EndpointConfigurationBuilder
    {
        public DocumentGenerationEndpointMinimalMocks()
        {
            EndpointSetup<DefaultServer>()
                .IncludeType<DocumentGenerationHandler>()
                .IncludeType<DocumentSaveCommand>()
                .IncludeType<DocumentGenerationCommand>()
                .IncludeType<DocumentGenerationComplete>()
                .IncludeType<IDocumentsPublishedEvent>();
        }

        public static Action<BusConfiguration> Configure(Context ctx)
        {
            return configuration =>
            {
                StandardConventions.Configure()(configuration);

                configuration.UseContainer<WindsorBuilder>(
                    container => container.ExistingContainer(new WindsorContainer().Install(new DocumentGenerationEndpointWindsorInstaller(ctx))));
            };
        }

        public class DocumentGenerationEndpointWindsorInstaller : IWindsorInstaller
        {
            private readonly Context _ctx;

            public DocumentGenerationEndpointWindsorInstaller(Context ctx)
            {
                _ctx = ctx;
            }

            public void Install(IWindsorContainer container, IConfigurationStore store)
            {
                var azureStorageMock = new Mock<IAzureStorageWrapper>();
                var office365AdapterMock = new Mock<SFA.FCT.CrossDomain.Integration.Common.Storage.IOffice365Adapter>();
                var loggerMock = new Mock<ILogger>();

                azureStorageMock
                    .Setup(m => m.GetContainerContents(It.Is<string>(s => s == "document-template-dev")))
                    .Returns(new string[]{"DocumentationConfiguration.xml"});

                azureStorageMock
                    .Setup(m => m.GetBlockBlobContents(It.Is<FctFile>(f => f.FileContainer == "document-template-dev" && f.Filename == "DocumentationConfiguration.xml")))
                    .Returns<FctFile>(f =>  Encoding.UTF8.GetBytes(Resources.DocumentationConfiguration));

                loggerMock
                    .Setup(m => m.LogInformation(It.IsAny<string>(), It.IsAny<object[]>()))
                    .Callback<string, object[]>((format, objects) =>
                    {
                        Debug.WriteLine(format, objects);
                    })
                    .Verifiable();

                loggerMock
                    .Setup(m => m.LogVerbose(It.IsAny<string>(), It.IsAny<object[]>()))
                    .Callback<string, object[]>((format, objects) =>
                    {
                        Debug.WriteLine(format, objects);
                    })
                    .Verifiable();

                _ctx.AddMock(azureStorageMock);
                _ctx.AddMock(office365AdapterMock);                
                _ctx.AddMock(loggerMock);

                container.Register(
                    Classes.FromAssemblyContaining<DocumentPartCreator>().BasedOn<DocumentPartCreator>().WithService.FromInterface().LifestyleSingleton(),
                    Classes.FromAssemblyContaining<IDocumentHeaderCreator>().BasedOn<IDocumentHeaderCreator>().WithService.FromInterface().LifestyleSingleton(),

                    Component.For<IDocumentGenerator>().ImplementedBy<DocumentGenerator>().LifestyleSingleton(),
                    Component.For<ICorporateContractValidator>().ImplementedBy<CorporateContractValidator>().LifestyleSingleton(),
                    Component.For<IDocumentDefiner>().ImplementedBy<DocumentDefiner>().LifestyleSingleton(),
                    Component.For<IDocumentCreator>().ImplementedBy<DocumentCreator>().LifestyleSingleton(),
                    Component.For<IDocumentMerger>().ImplementedBy<DocumentMerger>().LifestyleSingleton(),
                    Component.For<IDocumentSaver>().ImplementedBy<DocumentSaver>().LifestyleSingleton(),
                    Component.For<IDocumentPartFinder>().ImplementedBy<DocumentPartFinder>().LifestyleSingleton(),
                    Component.For<ITemplateRepository>().ImplementedBy<TemplateRepository>().LifestyleSingleton(),
                    Component.For<IAsposeWrapper>().ImplementedBy<AsposeWrapper>().LifestyleSingleton(),
                    Component.For<IDocumentRepository>().ImplementedBy<DocumentRepository>().LifestyleSingleton(),
                    Component.For<IDocumentConfigurationSource>().ImplementedBy<DocumentConfigurationSource>().LifestyleSingleton(),

                    Component.For<IAzureStorageWrapper>().Instance(azureStorageMock.Object),
                    Component.For<SFA.FCT.CrossDomain.Integration.Common.Storage.IOffice365Adapter>().Instance(office365AdapterMock.Object),
                    Component.For<ILogger>().Instance(loggerMock.Object));
            }
        }
    }
}
