namespace OrganisationDomain.Integration.MainEndpoint.Tests
{
    using System.Collections.Generic;
    using System.Linq;
    using Entities;
    using Extensions;
    using Handlers;
    using Implementation.Services;
    using Messages.Commands;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus.Testing;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class UpdateSupplementaryDataChangesCommandHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void UpdateSupplementaryDataChangesCommandHandler_ShouldSendTheCorrectNumberOfCommands()
        {
            // arrange
            ILogger logger = Mock.Of<ILogger>();
            const int totalDataChanges = 401;
            Mock<IOrgSupplementaryDataService> orgSupplementaryDataServiceMock = new Mock<IOrgSupplementaryDataService>();
            orgSupplementaryDataServiceMock.Setup(s => s.GetSupplementaryDataChanges(-7))
                .ReturnsAsync(GetOrgSupplementaryDataCollection(totalDataChanges));


            TestableMessageHandlerContext context = new TestableMessageHandlerContext();
            UpdateSupplementaryDataChangesCommandHandler handler = new UpdateSupplementaryDataChangesCommandHandler(logger, orgSupplementaryDataServiceMock.Object);

            // act
            handler.Handle(new UpdateSupplementaryDataChangesCommand(), context).Wait();

            // assert
            Assert.AreEqual(3, context.SentMessages.Count(), "The number of command sent is incorrect");
            Assert.AreEqual(totalDataChanges, context.SentMessages.Select(m => m.Message).CastWhere<UpdateSupplementaryBatchOfDataCommand>().Sum(c => c.OrgSupplementaryDataCollection.Count()), "The number of OrgSupplementaryData items sent is incorrect");
        }

        private IReadOnlyCollection<OrgSupplementaryData> GetOrgSupplementaryDataCollection(int size)
        {
            return Enumerable.Range(0, size).Select(i => new OrgSupplementaryData(1, "2", null, new OrgSupplementaryAddress())).ToList();
        }
    }
}
