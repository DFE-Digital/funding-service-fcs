namespace OrganisationDomain.Integration.MainEndpoint.Tests
{
    using System.Linq;
    using DataStore.Repositories;
    using Handlers;
    using Messages.Commands;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus.Testing;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class InitiateOrgSupplementaryDataPopulationCommandHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void InitiateOrgSupplementaryDataPopulationCommandHandler_ShouldSendBatchedUkprns()
        {
            // arrange
            const int startUkprn = 10000000;
            const int ukprnCount = 35;

            Mock<IOrganisationRepository> orgRepositoryMock = new Mock<IOrganisationRepository>();
            orgRepositoryMock.Setup(m => m.GetUkprnsForOrgsWithNoUkrlpData()).Returns(Enumerable.Range(startUkprn, ukprnCount).ToList());


            InitiateOrgSupplementaryDataPopulationCommandHandler handler = 
                new InitiateOrgSupplementaryDataPopulationCommandHandler(orgRepositoryMock.Object, Mock.Of<ILogger>());
            TestableMessageHandlerContext context = new TestableMessageHandlerContext();
            
            // act
            handler.Handle(new InitiateOrgSupplementaryDataPopulationCommand(), context).Wait();

            // assert
            Assert.AreEqual(4, context.SentMessages.Length);
            Assert.IsTrue(context.SentMessages.All(m => m.Message.GetType() == typeof(PopulateSupplementaryDataForUkprnBatchCommand)));
        }
    }
}