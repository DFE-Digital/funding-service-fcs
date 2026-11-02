namespace CrossDomain.Integration.ReportRunnerEndpoint.Tests.Unit
{
    using System;
    using System.Collections.Generic;
    using ContractManagement.DataStore.Dtos;
    using ContractManagement.DataStore.Repositories;
    using Handlers;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus.Testing;
    using Services;
    using SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;
    using System.Linq;
    using Castle.Windsor;
    using Ioc;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using SFA.FCT.Framework.Logging;

    [TestClass]
    public class RunReportsAndArchiveExistingCommandHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void RunReportsAndArchiveExistingCommandHandler_ShouldGenerateBothLatestVersionAndLastApprovedVersionReports()
        {
            // arrange
            var cdaReportFundingStreamPeriodQueryRepositoryMock = new Mock<ICdaReportFundingStreamPeriodQueryRepository>();
            cdaReportFundingStreamPeriodQueryRepositoryMock
                .Setup(m => m.GetAllWithinPublicationCloseDate(It.IsAny<DateTime>()))
                .Returns(new List<ReportConfig>
                {
                    new ReportConfig("16-19 Funding", new List<string> { "1619LR1718", "NMF1718", "SSF1718" })
                });

            var handler = new RunReportsAndArchiveExistingCommandHandler(
                Mock.Of<ILogger>(),
                Mock.Of<IArchiveReportService>(),
                cdaReportFundingStreamPeriodQueryRepositoryMock.Object,
                Mock.Of<IDate>());

            var context = new TestableMessageHandlerContext();

            // act
            handler.Handle(new RunReportsAndArchiveExistingCommand(), context).Wait();

            // assert
            var runReportCommandsSent = context.SentMessages.Select(sm => sm.Message).OfType<RunReportCommand>().ToList();

            Assert.AreEqual(2, runReportCommandsSent.Count, "Unexpected number of commands sent");
            Assert.AreEqual(1, runReportCommandsSent.Where(c => c.ReportParameters[1][0] == "IsLatestVersion" && c.ReportParameters[1][1] == "True").Count(), "Latest Version command not sent");
            Assert.AreEqual(1, runReportCommandsSent.Where(c => c.ReportParameters[1][0] == "IsLatestVersion" && c.ReportParameters[1][1] == "False").Count(), "Last Approved Version command not sent");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void RunReportsAndArchiveExistingCommandHandler_ShouldGenerateOnlyLastApprovedVersionReportsWhenSpecifiedInCommand()
        {
            // arrange
            var cdaReportFundingStreamPeriodQueryRepositoryMock = new Mock<ICdaReportFundingStreamPeriodQueryRepository>();
            cdaReportFundingStreamPeriodQueryRepositoryMock
                .Setup(m => m.GetAllWithinPublicationCloseDate(It.IsAny<DateTime>()))
                .Returns(new List<ReportConfig>
                {
                    new ReportConfig("16-19 Funding", new List<string> { "1619LR1718", "NMF1718", "SSF1718" })
                });

            var handler = new RunReportsAndArchiveExistingCommandHandler(
                Mock.Of<ILogger>(),
                Mock.Of<IArchiveReportService>(),
                cdaReportFundingStreamPeriodQueryRepositoryMock.Object,
                Mock.Of<IDate>());

            var context = new TestableMessageHandlerContext();

            // act
            handler.Handle(new RunReportsAndArchiveExistingCommand
            {
                GenerateLastApprovedReportsOnly = true
            }, context).Wait();

            // assert
            var runReportCommandsSent = context.SentMessages.Select(sm => sm.Message).OfType<RunReportCommand>().ToList();

            Assert.AreEqual(1, runReportCommandsSent.Count, "Unexpected number of commands sent");
            Assert.AreEqual(0, runReportCommandsSent.Where(c => c.ReportParameters[1][0] == "IsLatestVersion" && c.ReportParameters[1][1] == "True").Count(), "Unexpected Latest Version command sent");
            Assert.AreEqual(1, runReportCommandsSent.Where(c => c.ReportParameters[1][0] == "IsLatestVersion" && c.ReportParameters[1][1] == "False").Count(), "Last Approved Version command not sent");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void RunReportsAndArchiveExistingCommandHandler_ShouldResolve()
        {
            // arrange
            var container = new WindsorContainer()
                .Install(new WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<RunReportsAndArchiveExistingCommandHandler>().LifestyleScoped());

            container.BeginScope();

            // act
            container.Resolve<RunReportsAndArchiveExistingCommandHandler>();
        }
    }
}
