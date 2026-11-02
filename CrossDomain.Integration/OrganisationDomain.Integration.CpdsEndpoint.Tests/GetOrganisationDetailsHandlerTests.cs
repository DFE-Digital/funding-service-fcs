namespace OrganisationDomain.Integration.CpdsEndpoint.Tests
{
    using System.Linq;
    using System.Xml.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus;
    using NServiceBus.Testing;
    using Implementation.BusinessLogic;
    using Messages.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class GetOrganisationDetailsHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void Handle_ShouldCallGetProviderByUkprnAndUpin()
        {
            //arrange
            var cpdsOrgRetrieverMock = new Mock<ICpdsOrganisationRetriever>();
            cpdsOrgRetrieverMock.Setup(x => x.GetProviderByUkprn(It.IsAny<int>()))
                .Returns(new XDocument());
          
            var handler = new GetOrganisationDetailsHandler(cpdsOrgRetrieverMock.Object, Mock.Of<ILogger>());

            var message = new GetOrganisationDetails { ProcessId = "123", Ukprn = 12345678, Upin = 197856 };

            //act
            handler.Handle(message, new TestableMessageHandlerContext()).Wait();

            //assert
            cpdsOrgRetrieverMock.Verify(x => x.GetProviderByUkprnAndUpin(12345678, 197856), Times.Once, "Handle didn't call GetProviderByUkprn once with 12345678 as the UKPRN.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Handle_ShouldCallBusSendWithAProcessOrganisationDetailsCommand()
        {
            //arrange
            var cpdsOrgRetrieverMock = new Mock<ICpdsOrganisationRetriever>();
            
            var provider = new XDocument();

            cpdsOrgRetrieverMock.Setup(x => x.GetProviderByUkprnAndUpin(It.IsAny<int>(),It.IsAny<int>()))
                .Returns(provider);

            var handler = new GetOrganisationDetailsHandler(cpdsOrgRetrieverMock.Object, Mock.Of<ILogger>());

            var message = new GetOrganisationDetails { ProcessId = "123", Ukprn = 12345678, Upin = 98765};

            var context = new TestableMessageHandlerContext();

            //act
            handler.Handle(message, context).Wait();

            //assert
            Assert.AreEqual(1, context.SentMessages.Count(m => m.Message is ProcessOrganisationDetails),
                $"Unexpected number of ProcessOrganisationDetails messages sent");

            var assertMessage = (ProcessOrganisationDetails)context.SentMessages[0].Message;
            Assert.AreEqual(provider, assertMessage.ChangedProvider, "Incorrect ProcessOrganisationDetails message sent");
        }
    }
}
