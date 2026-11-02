using Microsoft.VisualStudio.TestTools.UnitTesting;
using OrganisationDomain.Integration.Messages.Messages.Expires;
using Moq;
using OrganisationDomain.Implementation.BusinessLogic;
using OrganisationDomain.Integration.Messages.Messages;

namespace OrganisationDomain.Integration.MainEndpoint.Tests
{
    using System.Linq;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Handlers;
    using NServiceBus.Logging;
    using NServiceBus.Testing;
    using SFA.FCT.Framework.Logging.Interfaces;
    using ILoggerFactory = SFA.FCT.Framework.Logging.Interfaces.ILoggerFactory;

    [TestClass]
    public class GetOrganisationHandlerTests
    {
        #region Additional test attributes
        //
        // You can use the following additional attributes as you write your tests:
        //
        // Use ClassInitialize to run code before running the first test in the class
        // [ClassInitialize()]
        // public static void MyClassInitialize(TestContext testContext) { }
        //
        // Use ClassCleanup to run code after all tests in a class have run
        // [ClassCleanup()]
        // public static void MyClassCleanup() { }
        //
        // Use TestInitialize to run code before running each test 
        // [TestInitialize()]
        // public void MyTestInitialize() { }
        //
        // Use TestCleanup to run code after each test has run
        // [TestCleanup()]
        // public void MyTestCleanup() { }
        //
        #endregion

        //[TestMethod,TestCategory("UnitTest")]
        //public void Handle_GetORganisationRequest_ShouldCallResolverGetByUkprn_WhenUkprnHasValue()
        //{
        //    var resolverMock = new Mock<IProviderResolver>();
        //    var message = new GetOrganisationRequest() 
        //    {
        //        Ukprn=1
        //    };
        //    var handler = new GetOrganisationHandler() 
        //    {
        //        Resolver=resolverMock.Object
        //    };

        //    TestableMessageHandlerContext context = new TestableMessageHandlerContext();
            
        //    //act
        //    handler.Handle(message, context).Wait();

        //    resolverMock.Verify(x => x.GetByUkprn(1), Times.Once(), "Handle_GetORganisationRequest didn't call GetByUkprn");
        //}

        //[TestMethod, TestCategory("UnitTest")]
        //public void Handle_GetORganisationRequest_ShouldCallResolverGetByOrgID_WhenUkprnHasNoValue()
        //{
        //    var resolverMock = new Mock<IProviderResolver>();
        //    var loggerMock = new Mock<ILog>();
        //    var message = new GetOrganisationRequest()
        //    {
        //        OrganisationId ="1"
        //    };
        //    var handler = new GetOrganisationHandler()
        //    {
        //        Resolver = resolverMock.Object
        //    };

        //    TestableMessageHandlerContext context = new TestableMessageHandlerContext();

        //    // act
        //    handler.Handle(message, context).Wait();

        //    resolverMock.Verify(x => x.GetByOrgId("1"), Times.Once(), "Handle_GetORganisationRequest didn't call GetByOrgId");
    
        //}

        //[TestMethod, TestCategory("UnitTest")]
        //public void Handle_GetOrganisationRequest_ShouldCallBusReply_WithTheReturnedOrg()
        //{
        //    var resolverMock = new Mock<IProviderResolver>();
        //    var loggerMock = new Mock<ILog>();
        //    var message = new GetOrganisationRequest()
        //    {
        //        OrganisationId = "1"
        //    };
        //    var handler = new GetOrganisationHandler()
        //    {
        //        Resolver = resolverMock.Object
        //    };

        //    TestableMessageHandlerContext context = new TestableMessageHandlerContext();

        //    // act
        //    handler.Handle(message, context).Wait();

        //    Assert.AreEqual(1, context.RepliedMessages.Length, "we have not sent a message" );
        //    Assert.IsNotNull(context.RepliedMessages.First().Message as GetOrganisationResponse, "the msg is the wrong type");
        //}

        [TestMethod, TestCategory("UnitTest")]
        public void Handle_GetOrganisationRequest_ShouldResolve()
        {
            Mock<ILoggerFactory> loggerFactoryMock = new Mock<ILoggerFactory>();
            loggerFactoryMock.Setup(l => l.CreateLogger(It.IsAny<string>())).Returns(Mock.Of<ILogger>());

            var container = OrganisationDomain.Integration.MainEndpoint.Ioc.Bootstrapper
                .CreateContainer(loggerFactoryMock.Object)
                .Register(Component.For<GetOrganisationHandler>().LifestyleScoped());
            container.BeginScope();

            var getOrganisationHandler = container.Resolve<GetOrganisationHandler>();

            Assert.IsNotNull(getOrganisationHandler, "Could not resolve");
        }
    }
}
