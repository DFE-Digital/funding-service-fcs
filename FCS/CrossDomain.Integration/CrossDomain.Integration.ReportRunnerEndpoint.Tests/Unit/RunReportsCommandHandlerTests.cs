namespace CrossDomain.Integration.ReportRunnerEndpoint.Tests.Unit
{
    using Handlers;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using SFA.FCT.Framework.Logging;
    using Moq;
    using ContractManagement.DataStore.Repositories;
    using System;
    using System.Collections.Generic;
    using ContractManagement.DataStore.Dtos;
    using SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;
    using NServiceBus.Testing;
    using System.Linq;
    using Ioc;

    [TestClass]
    public class RunReportsCommandHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void RunReportsCommandHandler_ShouldResolve()
        {
            // arrange
            var container = new WindsorContainer()
                .Install(new WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<RunReportsCommandHandler>().LifestyleScoped());

            container.BeginScope();

            // act
            container.Resolve<RunReportsCommandHandler>();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void RunReportsCommandHandler_ShouldGenerateRunReportsCommandCorrectNumberOfTimes()
        {
            // arrange

            var cdaReportFundingStreamPeriodQueryRepositoryMock = new Mock<ICdaReportFundingStreamPeriodQueryRepository>();
            cdaReportFundingStreamPeriodQueryRepositoryMock
                .Setup(m => m.GetAllWithinPublicationCloseDate(It.IsAny<DateTime>()))
                .Returns(new List<ReportConfig>
                {
                    new ReportConfig("16-19 Funding", new List<string> { "1619LR1718", "NMF1718", "SSF1718" }),
                    new ReportConfig("16-19 Funding", new List<string> { "1619LR1718", "NMF1718", "SSF1718" })
                });

            var handler = new RunReportsCommandHandler(
                Mock.Of<ILogger>(),
                cdaReportFundingStreamPeriodQueryRepositoryMock.Object,
                Mock.Of<IDate>());

            var context = new TestableMessageHandlerContext();

            // act
            handler.Handle(new RunReportsCommand(), context).Wait();

            // assert
            Assert.AreEqual(4, context.SentMessages.Select(sm => sm.Message).OfType<RunReportCommand>().Count(), "Unexpected number of commands sent");
        }
    }
}