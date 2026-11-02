namespace FCT.Operations.Cda.Tests.Handlers
{
    using System;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Cda.Repositories;
    using ContractManagement.DataStore;
    using Infrastructure;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using NServiceBus;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using ReportGeneration;
    using SFA.FCT.Framework.Logging.Interfaces;
    using Moq;
    using NServiceBus.Testing;
    using System.Linq;
    using SFA.FCS.Worker.Common;
    using ConnectionInfo = SFA.FCT.CrossDomain.Integration.Entities.Data.ConnectionInfo;

    [TestClass]
    public class RunReportsCommandHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void RunReportsCommandHandler_ShouldResolve()
        {
            IWindsorContainer container = new WindsorContainer().Install(new WindsorInstaller(Mock.Of<ILogger>(), Mock.Of<IFcsConfiguration>()));
            container.Register(Component.For<IHandleMessages<RunReportsCommand>>()
                .ImplementedBy<RunReportsCommandHandler>());
            using (container.BeginScope())
            {
                container.Resolve<IHandleMessages<RunReportsCommand>>();
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void RunReportsCommandHandler_Handle_ShouldSendExpectedCommand()
        {
            // Arrange
            DateTime todayDate = DateTime.Now.Date;
            int cdaExtractRecordCount;

            using (var context = new ContractManagementDbContext())
            {
                cdaExtractRecordCount = context.CdaExtracts.Count(e => !e.ReportingCloseDate.HasValue || e.ReportingCloseDate >= todayDate);
            }

            using (var context = new ContractManagementDbContext())
            {
                Mock<ISessionConnectionFactory> mockSessionConnectionFactory = new Mock<ISessionConnectionFactory>();
                mockSessionConnectionFactory.Setup(s => s.GetConnection(It.IsAny<IMessageHandlerContext>()))
                    .Returns(new ConnectionInfo(null, context.Database.Connection));

                Mock<IOverrideDateRepository> dateProvider = new Mock<IOverrideDateRepository>();
                dateProvider.Setup(m => m.GetDate(It.IsAny<ConnectionInfo>())).ReturnsAsync(todayDate);

                var cdaConfigRepository = new CdaConfigRepository(dateProvider.Object);

                var handler = new RunReportsCommandHandler(Mock.Of<ILogger>(), cdaConfigRepository, mockSessionConnectionFactory.Object);
                TestableMessageHandlerContext testableContext = new TestableMessageHandlerContext();

                // Act 
                handler.Handle(new RunReportsCommand(), testableContext).Wait();

                // Assert
                var numMessages = 0;
                var remainder = cdaExtractRecordCount % handler.BatchSize;
                if (remainder > 0)
                {
                    numMessages =  cdaExtractRecordCount / handler.BatchSize * 2 + handler.BatchSize;
                }
                else
                {
                    numMessages = cdaExtractRecordCount / handler.BatchSize * 2;
                }
                Assert.AreEqual(numMessages, testableContext.SentMessages.Count(m => m.Message is CreateReportFromCrmForGroupCommand),
                    $"{nameof(CreateReportFromCrmForGroupCommand)} was not sent");
            }
        }
    }
}