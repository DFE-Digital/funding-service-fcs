namespace FCT.Operations.Tests.Connectivity
{
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.Framework.Logging.Interfaces;
    using FCT.Operations.Connectivity;
    using System.Collections.Generic;
    using SFA.FCT.CrossDomain.Integration.Messages.Messages;

    [TestClass]
    public class CheckConnectivityReplyHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void CheckConnectivityReplyHandler_ShouldResolve()
        {
            // arrange
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(Mock.Of<ILogger>(), Mock.Of<IFcsConfiguration>()))
                .Register(Component.For<CheckConnectivityReplyHandler>());

            container.BeginScope();

            // act
            container.Resolve<CheckConnectivityReplyHandler>();
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void CheckConnectivityReplyHandler_TechnicalExploration()
        {
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(Mock.Of<ILogger>(), Mock.Of<IFcsConfiguration>()))
                .Register(Component.For<CheckConnectivityReplyHandler>());

            container.BeginScope();

            var first = new CheckConnectivityReply.Result("service1", true, "errinfo1", "supInfo1");
            var second = new CheckConnectivityReply.Result("service2", true, "errinfo2", "supInfo2");
            var results = new List<CheckConnectivityReply.Result> { first, second };

            // act
            var handler = container.Resolve<CheckConnectivityReplyHandler>();
            handler.Handle(new CheckConnectivityReply(results), null).Wait();
        }
    }
}