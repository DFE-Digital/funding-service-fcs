namespace CrossDomain.Integration.ReportRunnerEndpoint.Tests.Unit
{
    using System.Configuration;
    using Handlers;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus.Testing;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;
    using System.Linq;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using SFA.FCT.Framework.Logging;
    using Ioc;

    [TestClass]
    public class MonthEndCompletionHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void MonthEndCompletedHandler_ShouldSendRunReportsAndArchiveExistingCommandForLastApprovedReportsOnlyWhenConfigured()
        {
            // arrange
            ConfigurationManager.AppSettings["MonthEnd:CompletionShouldInitiateCdaReports"] = "true";
            var handler = new MonthEndCompletedHandler(Mock.Of<ILogger>());
            var context = new TestableMessageHandlerContext();

            // act
            handler.Handle(Mock.Of<MonthEndCompletedEvent>(), context).Wait();

            // assert
            var runReportsAndArchiveExistingCommandsSent = context.SentMessages.Select(sm => sm.Message).OfType<RunReportsAndArchiveExistingCommand>().ToList();

            Assert.AreEqual(1, runReportsAndArchiveExistingCommandsSent.Count, "Failed to send RunReportsAndArchiveExistingCommand");
            Assert.AreEqual(1, runReportsAndArchiveExistingCommandsSent.Select(cmd => cmd.GenerateLastApprovedReportsOnly).ToList().Count(), "Failed to send RunReportsAndArchiveExistingCommand");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MonthEndCompletedHandler_ShouldNotSendRunReportsAndArchiveExistingCommandWhenNotConfigured()
        {
            // arrange
            ConfigurationManager.AppSettings["MonthEnd:CompletionShouldInitiateCdaReports"] = "false";
            var handler = new MonthEndCompletedHandler(Mock.Of<ILogger>());
            var context = new TestableMessageHandlerContext();

            // act
            handler.Handle(Mock.Of<MonthEndCompletedEvent>(), context).Wait();

            // assert
            var runReportsAndArchiveExistingCommandsSent = context.SentMessages.Select(sm => sm.Message).OfType<RunReportsAndArchiveExistingCommand>().ToList();
            Assert.AreEqual(0, runReportsAndArchiveExistingCommandsSent.Count, "Incorrectly sent RunReportsAndArchiveExistingCommand");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MonthEndCompletedHandler_ShouldResolve()
        {
            // arrange
            var container = new WindsorContainer()
                .Install(new WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<MonthEndCompletedHandler>().LifestyleScoped());

            container.BeginScope();

            // act
            container.Resolve<MonthEndCompletedHandler>();
        }
    }
}
