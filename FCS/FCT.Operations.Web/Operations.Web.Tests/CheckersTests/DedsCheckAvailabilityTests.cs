namespace Operations.Web.Tests.CheckersTests
{
    using System;
    using System.Threading.Tasks;
    using Checkers;
    using DedsSearchService;
    using Dtos;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;

    [TestClass]
    public class DedsCheckAvailabilityTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void DedsCheckAvailability_ShouldReturnNotAvailableIfExceptionIsThrown()
        {
            // arrange
            Guid dataSetVersionId = Guid.NewGuid();
            Guid queryGuid = Guid.NewGuid();
            string exceptionMessage = "This is the expected exception message";

            Mock<IDedsSearchServiceChannel> mockChannel = new Mock<IDedsSearchServiceChannel>();
            mockChannel.Setup(m => m.GetLatestPublishedDataSetVersionAsync(It.IsAny<string>()))
                       .Returns(Task.FromResult(new DataSetVersionDescriptor {Id = dataSetVersionId }));

            mockChannel.Setup(m => m.DiscoverQueriesAsync(It.Is<DiscoverQueriesCriteria>(c => c.DataSetVersionId == dataSetVersionId)))
                       .Returns(Task.FromResult(new[] {new QueryDescriptor {Code = "GetClosedCollectionEvents", Id = queryGuid, FilterDescriptors = new FilterDescriptor[0] }}));

            mockChannel.Setup(m => m.ExecuteQueryAsync(It.Is<Guid>(id => id == queryGuid), It.IsAny<QueryExecution>()))
                       .Throws(new Exception(exceptionMessage));

            DedsCheckAvailability checker = new DedsCheckAvailability(mockChannel.Object);

            // act
            AvailabilityCheckResult actual = checker.GetCheckResult().GetAwaiter().GetResult();

            // assert
            Assert.IsFalse(actual.IsAvailable);
            Assert.AreEqual(exceptionMessage, actual.Details);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DedsCheckAvailability_ShouldReturnAvailableIfCanQueryDedsSearchService()
        {
            Guid dataSetVersionId = Guid.NewGuid();
            Guid queryGuid = Guid.NewGuid();

            Mock<IDedsSearchServiceChannel> mockChannel = new Mock<IDedsSearchServiceChannel>();
            mockChannel.Setup(m => m.GetLatestPublishedDataSetVersionAsync(It.IsAny<string>()))
                       .Returns(Task.FromResult(new DataSetVersionDescriptor { Id = dataSetVersionId }));

            mockChannel.Setup(m => m.DiscoverQueriesAsync(It.Is<DiscoverQueriesCriteria>(c => c.DataSetVersionId == dataSetVersionId)))
                       .Returns(Task.FromResult(new[] { new QueryDescriptor { Code = "GetClosedCollectionEvents", Id = queryGuid, FilterDescriptors = new FilterDescriptor[0] } }));

            mockChannel.Setup(m => m.ExecuteQueryAsync(It.Is<Guid>(id => id == queryGuid), It.IsAny<QueryExecution>()))
                       .Returns(Task.FromResult(new QueryResults[0]));

            DedsCheckAvailability checker = new DedsCheckAvailability(mockChannel.Object);

            // act
            AvailabilityCheckResult actual = checker.GetCheckResult().GetAwaiter().GetResult();

            // assert
            Assert.IsTrue(actual.IsAvailable);
        }
    }
}