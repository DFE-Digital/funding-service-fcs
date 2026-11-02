namespace FCT.Operations.Integrity.Tests
{
    using System.Collections.Generic;
    using System.Configuration;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus.Testing;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.Operations.Integrity.Handlers;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using NServiceBus;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.Operations.Integrity.IoC;

    [TestClass]
    public class MonthEndCompletedHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void CheckForDuplicateContractsHandler_ShouldResolve()
        {
            IWindsorContainer container = new WindsorContainer().Install(new WindsorInstaller(Mock.Of<ILogger>(), Mock.Of<IFcsConfiguration>()));
            container.Register(Component.For<IHandleMessages<MonthEndCompletedEvent>>()
                .ImplementedBy<MonthEndCompletedHandler>());
            using (container.BeginScope())
            {
                container.Resolve<IHandleMessages<MonthEndCompletedEvent>>();
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MonthEndCompletedHandler_ShouldSendInitiateCheckersCommandWithCorrectPostMonthEndCheckersInExpectedBatchesWhenConfigured()
        {
            // arrange
            ConfigurationManager.AppSettings["MonthEnd:CompletionShouldInitiateIntegrityCheckers"] = "true";

            TestableMessageHandlerContext context = new TestableMessageHandlerContext();

            MonthEndCompletedHandler handler = new MonthEndCompletedHandler(Mock.Of<ILogger>(), new LocalConfig());

            // act
            handler.Handle(Mock.Of<MonthEndCompletedEvent>(), context)
                .Wait();

            // assert
            IReadOnlyCollection<InitiateCheckersCommand> sentCommands =
                context.SentMessages
                    .Select(sm => sm.Message)
                    .OfType<InitiateCheckersCommand>()
                    .ToList();

            Assert.AreEqual(2, sentCommands.Count, "Unexpected number of InitiateCheckersCommands sent");

            CollectionAssert.AreEqual(
                InitiateCheckersCommand.CreatePostMonthEndImmediateBatchIntegrityChecksCommand().ChecksToRun.ToList(),
                sentCommands.First().ChecksToRun.ToList(),
                "First batch of checkers not initiated as expected");

            CollectionAssert.AreEqual(
                InitiateCheckersCommand.CreatePostMonthEndDelayedBatchIntegrityChecksCommand().ChecksToRun.ToList(),
                sentCommands.Last().ChecksToRun.ToList(),
                "Last batch of checkers not initiated as expected");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MonthEndCompletedHandler_ShouldNotSendInitiateCheckersCommandWhenNotConfigured()
        {
            // arrange
            ConfigurationManager.AppSettings["MonthEnd:CompletionShouldInitiateIntegrityCheckers"] = "false";

            TestableMessageHandlerContext context = new TestableMessageHandlerContext();
            
            MonthEndCompletedHandler handler = new MonthEndCompletedHandler(Mock.Of<ILogger>(), new LocalConfig());

            // act
            handler.Handle(Mock.Of<MonthEndCompletedEvent>(), context)
                .Wait();

            // assert
            Assert.IsTrue(!context.SentMessages.Select(m => m.Message).Cast<InitiateCheckersCommand>().Any());
        }
    }
}
