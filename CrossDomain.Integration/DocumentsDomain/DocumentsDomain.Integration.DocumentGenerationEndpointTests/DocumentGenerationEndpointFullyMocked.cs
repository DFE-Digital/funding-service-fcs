namespace DocumentsDomain.Integration.DocumentGenerationEndpointTests
{
    using System;
    using System.Diagnostics;
    using System.Threading.Tasks;
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using Moq;
    using NServiceBus;
    using NServiceBus.AcceptanceTesting;
    using NServiceBusAcceptanceTestingAdditions;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.CrossDomain.Integration.Messages.Messages;
    using SFA.FCT.DocumentsDomain.Common.Commands;
    using SFA.FCT.DocumentsDomain.Common.Models;
    using SFA.FCT.DocumentsDomain.DocumentGeneration;
    using SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentDeleter;
    using SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentSaver;
    using SFA.FCT.DocumentsDomain.Integration.DocumentGenerationEndpoint;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class DocumentGenerationEndpointFullyMocked : EndpointConfigurationBuilder
    {
        public DocumentGenerationEndpointFullyMocked()
        {
            EndpointSetup<DefaultServer>()
                .IncludeType<DocumentGenerationHandler>()
                .IncludeType<DocumentSaverHandler>()
                .IncludeType<DocumentSaveCommand>()
                .IncludeType<DocumentGenerationCommand>()
                .IncludeType<DocumentGenerationComplete>()
                .IncludeType<IDocumentsPublishedEvent>()
                .AddMapping<DocumentSaveCommand>(typeof(DocumentGenerationEndpointFullyMocked));
        }

        public static Action<BusConfiguration> Configure(Context ctx, TimeSpan? documentSaverDelay = null)
        {
            return configuration =>
            {
                StandardConventions.Configure()(configuration);

                configuration.UseContainer<WindsorBuilder>(
                    container => container.ExistingContainer(new WindsorContainer().Install(new DocumentGenerationEndpointWindsorInstaller(ctx, documentSaverDelay ))));
            };
        }

        public class DocumentGenerationEndpointWindsorInstaller : IWindsorInstaller
        {
            private readonly Context _ctx;
            private TimeSpan? _documentSaverDelay;

            public DocumentGenerationEndpointWindsorInstaller(Context ctx, TimeSpan? documentSaverDelay = null)
            {
                _ctx = ctx;
                _documentSaverDelay = documentSaverDelay;
            }

            public void Install(IWindsorContainer container, IConfigurationStore store)
            {
                var documentGeneratorMock = new Mock<IDocumentGenerator>();
                documentGeneratorMock
                    .Setup(m => m.GenerateDocument(It.IsAny<string>(), It.IsAny<contract>()))
                    .Returns<string, contract>((id, c) => new DocumentSaveCommand
                    {
                        ContractNumber = "CONTRACT-1234",
                        ContractVersionNumber = 99,
                        FCTDocumentDatabus = new byte[100],
                        TargetFileName = "SaveItHere.pdf",
                        UKPRN = "12345678",
                        CorrelationId = id
                    })
                    .Callback<string, contract>((id, c) => { Debug.WriteLine("DocumentGeneratorMock.GenerateDocument called"); })
                    .Verifiable();

                var documentSaverMock = new Mock<IDocumentSaver>();
                documentSaverMock
                    .Setup(m => m.SaveDocument(It.IsAny<DocumentSaveCommand>()))
                    .Callback<DocumentSaveCommand>(c => 
                    { 
                        Debug.WriteLine("DocumentSaverMock.SaveDocument called"); 
                        if (_documentSaverDelay.HasValue)
                        {
                            Task.Delay(_documentSaverDelay.Value).Wait();
                        }
                    })
                    .Verifiable();

                var documentDeleterMock = new Mock<IDocumentDeleter>();
                documentDeleterMock
                    .Setup(m => m.DeleteDocument(It.IsAny<DocumentDeleteRequest>()))
                    .Callback<DocumentDeleteRequest>(c =>
                    {
                        Debug.WriteLine("DocumentDeleterMock.DeleteDocument called");
                    })
                    .Verifiable();

                var loggerMock = new Mock<ILogger>();
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


                _ctx.AddMock(documentGeneratorMock);
                _ctx.AddMock(documentSaverMock);
                _ctx.AddMock(loggerMock);

                container.Register(
                    Component.For<IDocumentGenerator>().Instance(documentGeneratorMock.Object),
                    Component.For<IDocumentSaver>().Instance(documentSaverMock.Object),
                    Component.For<IDocumentDeleter>().Instance(documentDeleterMock.Object),
                    Component.For<ILogger>().Instance(loggerMock.Object));
            }
        }
    }
}
