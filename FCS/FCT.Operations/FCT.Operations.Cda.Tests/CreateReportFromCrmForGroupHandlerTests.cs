namespace FCT.Operations.Cda.Tests
{
    using System.Collections.Generic;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Cda.Dtos;
    using Cda.ReportUpload;
    using Cda.Repositories;
    using Infrastructure;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using NServiceBus;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using ReportGeneration;
    using SFA.FCT.Framework.Logging.Interfaces;
    using Moq;
    using NServiceBus.Testing;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.CrossDomain.Integration.Messages.Dtos;
    using ConnectionInfo = SFA.FCT.CrossDomain.Integration.Entities.Data.ConnectionInfo;
    using WindsorInstaller = ReportGeneration.WindsorInstaller;

    [TestClass]
    public class CreateReportFromCrmForGroupHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void CreateReportFromCrmForGroupHandler_ShouldResolve()
        {
            IWindsorContainer container = new WindsorContainer().Install(new WindsorInstaller(Mock.Of<ILogger>(), Mock.Of<IFcsConfiguration>()));
            container.Register(Component.For<IHandleMessages<CreateReportFromCrmForGroupCommand>>()
                .ImplementedBy<CreateReportFromCrmForGroupHandler>());
            using (container.BeginScope())
            {
                container.Resolve<IHandleMessages<CreateReportFromCrmForGroupCommand>>();
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CreateReportFromCrmForGroupHandler_ShouldUploadArchiveWhenShouldArchiveSet()
        {
            // arrange
            Mock<ICrmCdaRepository> crmCdaRepositoryMock = new Mock<ICrmCdaRepository>();
            crmCdaRepositoryMock.Setup(r => r.GetRows(It.IsAny<IEnumerable<string>>(), It.IsAny<bool>()))
                .ReturnsAsync(new List<CdaRow>
                {
                    new CdaRow()
                });
            Mock<IReportUploadService> reportUploadServiceMock = new Mock<IReportUploadService>();
            Mock<IProcessedMessageRepository> processedMessageRepositoryMock = new Mock<IProcessedMessageRepository>();
            processedMessageRepositoryMock.Setup(r => r.Add(
                It.IsAny<string>(), It.IsAny<string>(), It.IsAny<ConnectionInfo>())).Returns(true);
            Mock<IClosedReportService> closedReportServiceMock = new Mock<IClosedReportService>();

            CreateReportFromCrmForGroupHandler handler = new CreateReportFromCrmForGroupHandler(
                Mock.Of<ILogger>(),
                Mock.Of<IArchiveFolderCreator>(),
                processedMessageRepositoryMock.Object,
                Mock.Of<ISessionConnectionFactory>(),
                reportUploadServiceMock.Object,
                crmCdaRepositoryMock.Object,
                new ReportCreationService( Mock.Of<IClosedContractRepository>(),
                    Mock.Of<IOverrideDateRepository>()),
                closedReportServiceMock.Object);

            // act
            CreateReportFromCrmForGroupCommand command = new CreateReportFromCrmForGroupCommand
            {
                ShouldArchive = true,
                ExtractGroups = new List<ReportExtractGroup>
                {
                    new ReportExtractGroup
                    {
                        FspCodes = new List<string>()
                    }
                },
                IsLatest = true
            };
            TestableMessageHandlerContext context = new TestableMessageHandlerContext();
            handler.Handle(command, context).Wait();

            // assert
            reportUploadServiceMock.Verify(s => s.WriteFileToArchiveFolder
                (It.IsAny<string>(), It.IsAny<string>()), Times.Once, "We have not called archive");
        }
    }
}
