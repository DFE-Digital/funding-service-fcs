namespace ContractRequestDomain.EngagementWatcher.Tests.Handlers
{
    using System;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using EngagementWatcher.Handlers;
    using IoC;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus.Testing;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.CrossDomain.Integration.Messages.Messages;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;
    using SFA.FCT.Framework.Logging;
    using ContractRequestDomain.EngagementWatcher.Services;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class DasCheckConnectivityHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void DasCheckConnectivityHandler_ShouldResolve()
        {
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<IAzureTableStore>().Instance(Mock.Of<IAzureTableStore>()).IsDefault())
                .Register(Component.For<DasCheckConnectivityHandler>());

                using (container.BeginScope())

                // act
                container.Resolve<DasCheckConnectivityHandler>();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Handle_WhenDasApiResponds_ShouldReplyWithSuccessfulConnectivity()
        {
            var adapter = new Mock<IDasEventsApiAdapter>();
            adapter.SetupGet(x => x.BaseUrl).Returns("https://das.example");
            adapter.Setup(x => x.GetEngagementEventsAfterId(1, 1))
                .Returns(new ContractManagement.DataStore.Model.EngagementEvent[0]);
            var context = new TestableMessageHandlerContext();
            var handler = new DasCheckConnectivityHandler(adapter.Object, Mock.Of<ILogger>());

            handler.Handle(new CheckConnectivityCommand(), context).Wait();

            var reply = (CheckConnectivityReply)context.RepliedMessages[0].Message;
            var result = System.Linq.Enumerable.Single(reply.Results);
            Assert.AreEqual("DAS", result.Service);
            Assert.IsTrue(result.CanConnect);
            Assert.AreEqual(string.Empty, result.ErrorInfo);
            Assert.AreEqual("https://das.example", result.SupplementaryInfo);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Handle_WhenDasApiThrows_ShouldReplyWithFailureAndError()
        {
            var adapter = new Mock<IDasEventsApiAdapter>();
            adapter.SetupGet(x => x.BaseUrl).Returns("https://das.example");
            adapter.Setup(x => x.GetEngagementEventsAfterId(1, 1)).Throws(new InvalidOperationException("DAS unavailable"));
            var context = new TestableMessageHandlerContext();
            var handler = new DasCheckConnectivityHandler(adapter.Object, Mock.Of<ILogger>());

            handler.Handle(new CheckConnectivityCommand(), context).Wait();

            var reply = (CheckConnectivityReply)context.RepliedMessages[0].Message;
            var result = System.Linq.Enumerable.Single(reply.Results);
            Assert.IsFalse(result.CanConnect);
            Assert.AreEqual("DAS unavailable", result.ErrorInfo);
        }
    }
}
