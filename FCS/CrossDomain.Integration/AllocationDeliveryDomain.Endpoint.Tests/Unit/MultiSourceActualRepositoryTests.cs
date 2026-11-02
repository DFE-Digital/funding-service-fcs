namespace AllocationDeliveryDomain.Endpoint.Tests.Unit
{
    using System.Collections.Generic;
    using System.Linq;
    using AllocationDelivery.Messages.DTOs;
    using Endpoint.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.AllocationDeliveryDomain.Common.Storage;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    [TestClass]
    public class MultiSourceActualRepositoryTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void MultiSourceActualRepository_ShouldReturnExpectedRowsWhenActualsOnlyHeldInAzureTableStorage()
        {
            ReportedActual[] reportedActualsInAzureTableStorage =
            {
                new ReportedActual { PartitionKey = "PK1" },
                new ReportedActual { PartitionKey = "PK1" },
                new ReportedActual { PartitionKey = "PK2" },
                new ReportedActual { PartitionKey = "PK2" }
            };

            // arrange
            Mock<IAzureRepository<ReportedActual>> reportedActualRepositoryMock = new Mock<IAzureRepository<ReportedActual>>();
            reportedActualRepositoryMock
                .Setup(m => m.GetRows(It.IsAny<string>()))
                .Returns((string partitionKey) => reportedActualsInAzureTableStorage.Where(ra => ra.PartitionKey == partitionKey).ToList());

            MultiSourceActualRepository repository = new MultiSourceActualRepository(
                reportedActualRepositoryMock.Object, Mock.Of<ISummarisedActualRepository>());

            // act
            IReadOnlyCollection<ReportedActual> reportedActuals = repository.GetReportedActuals(new[] { "PK1", "PK2" }, null, ConnectionInfo.CreateDefault());
            
            // assert
            Assert.AreEqual(4, reportedActuals.Count);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MultiSourceActualRepository_ShouldReturnExpectedRowsWhenActualsOnlyHeldInAzureSql()
        {
            SummarisedActual[] summarisedActualsInAzureSql =
            {
                new SummarisedActual { CollectionType = "CT1", CollectionReturnCode = "CR1", OrganisationId = "ORG1", FundingStreamPeriodCode = "FSP1", UopCode = "UOP1" },
                new SummarisedActual { CollectionType = "CT1", CollectionReturnCode = "CR1", OrganisationId = "ORG1", FundingStreamPeriodCode = "FSP1", UopCode = "UOP1" },
                new SummarisedActual { CollectionType = "CT1", CollectionReturnCode = "CR1", OrganisationId = "ORG1", FundingStreamPeriodCode = "FSP1", UopCode = "UOP1" },
                new SummarisedActual { CollectionType = "CT2", CollectionReturnCode = "CR2", OrganisationId = "ORG2", FundingStreamPeriodCode = "FSP2", UopCode = "UOP2" },
                new SummarisedActual { CollectionType = "CT2", CollectionReturnCode = "CR2", OrganisationId = "ORG2", FundingStreamPeriodCode = "FSP2", UopCode = "UOP2" },
                new SummarisedActual { CollectionType = "CT2", CollectionReturnCode = "CR2", OrganisationId = "ORG2", FundingStreamPeriodCode = "FSP2", UopCode = "UOP2" }
            };

            // arrange
            Mock<ISummarisedActualRepository> summarisedActualRepositoryMock = new Mock<ISummarisedActualRepository>();
            summarisedActualRepositoryMock
                .Setup(m => m.GetSummarisedActuals(It.IsAny<SummarisedActualOrgFspGroupKey>(), It.IsAny<ConnectionInfo>()))
                .Returns((SummarisedActualOrgFspGroupKey groupKey, ConnectionInfo ci) =>
                    summarisedActualsInAzureSql
                        .Where(sa =>
                            sa.CollectionType == groupKey.CollectionType &&
                            sa.CollectionReturnCode == groupKey.CollectionReturnCode &&
                            sa.OrganisationId == groupKey.OrganisationId &&
                            sa.FundingStreamPeriodCode == groupKey.FundingStreamPeriodCode &&
                            sa.UopCode == groupKey.UopCode)
                        .ToList());

            MultiSourceActualRepository repository = new MultiSourceActualRepository(
                Mock.Of<IAzureRepository<ReportedActual>>(), summarisedActualRepositoryMock.Object);

            // act
            IReadOnlyCollection<ReportedActual> reportedActuals = repository.GetReportedActuals(null, new[]
            {
                new SummarisedActualOrgFspGroupKey { CollectionType = "CT1", CollectionReturnCode = "CR1", OrganisationId = "ORG1", FundingStreamPeriodCode = "FSP1", UopCode = "UOP1" },
                new SummarisedActualOrgFspGroupKey { CollectionType = "CT2", CollectionReturnCode = "CR2", OrganisationId = "ORG2", FundingStreamPeriodCode = "FSP2", UopCode = "UOP2" }
            }, ConnectionInfo.CreateDefault());

            // assert
            Assert.AreEqual(6, reportedActuals.Count);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MultiSourceActualRepository_ShouldReturnExpectedRowsWhenActualsHeldInBothAzureTableStorageAndAzureSql()
        {
            ReportedActual[] reportedActualsInAzureTableStorage =
            {
                new ReportedActual { PartitionKey = "PK1" },
                new ReportedActual { PartitionKey = "PK1" },
                new ReportedActual { PartitionKey = "PK2" },
                new ReportedActual { PartitionKey = "PK2" }
            };
            SummarisedActual[] summarisedActualsInAzureSql =
            {
                new SummarisedActual { CollectionType = "CT1", CollectionReturnCode = "CR1", OrganisationId = "ORG1", FundingStreamPeriodCode = "FSP1", UopCode = "UOP1" },
                new SummarisedActual { CollectionType = "CT1", CollectionReturnCode = "CR1", OrganisationId = "ORG1", FundingStreamPeriodCode = "FSP1", UopCode = "UOP1" },
                new SummarisedActual { CollectionType = "CT1", CollectionReturnCode = "CR1", OrganisationId = "ORG1", FundingStreamPeriodCode = "FSP1", UopCode = "UOP1" },
                new SummarisedActual { CollectionType = "CT2", CollectionReturnCode = "CR2", OrganisationId = "ORG2", FundingStreamPeriodCode = "FSP2", UopCode = "UOP2" },
                new SummarisedActual { CollectionType = "CT2", CollectionReturnCode = "CR2", OrganisationId = "ORG2", FundingStreamPeriodCode = "FSP2", UopCode = "UOP2" },
                new SummarisedActual { CollectionType = "CT2", CollectionReturnCode = "CR2", OrganisationId = "ORG2", FundingStreamPeriodCode = "FSP2", UopCode = "UOP2" }
            };

            // arrange
            Mock<IAzureRepository<ReportedActual>> reportedActualRepositoryMock = new Mock<IAzureRepository<ReportedActual>>();
            reportedActualRepositoryMock
                .Setup(m => m.GetRows(It.IsAny<string>()))
                .Returns((string partitionKey) => reportedActualsInAzureTableStorage.Where(ra => ra.PartitionKey == partitionKey).ToList());

            Mock<ISummarisedActualRepository> summarisedActualRepositoryMock = new Mock<ISummarisedActualRepository>();
            summarisedActualRepositoryMock
                .Setup(m => m.GetSummarisedActuals(It.IsAny<SummarisedActualOrgFspGroupKey>(), It.IsAny<ConnectionInfo>()))
                .Returns((SummarisedActualOrgFspGroupKey groupKey, ConnectionInfo connectionInfo) =>
                    summarisedActualsInAzureSql
                        .Where(sa =>
                            sa.CollectionType == groupKey.CollectionType &&
                            sa.CollectionReturnCode == groupKey.CollectionReturnCode &&
                            sa.OrganisationId == groupKey.OrganisationId &&
                            sa.FundingStreamPeriodCode == groupKey.FundingStreamPeriodCode &&
                            sa.UopCode == groupKey.UopCode)
                        .ToList());

            MultiSourceActualRepository repository = new MultiSourceActualRepository(
                reportedActualRepositoryMock.Object, summarisedActualRepositoryMock.Object);

            // act
            IReadOnlyCollection<ReportedActual> reportedActuals = repository.GetReportedActuals(
                new[] { "PK1", "PK2" },
                new[]
                {
                    new SummarisedActualOrgFspGroupKey { CollectionType = "CT1", CollectionReturnCode = "CR1", OrganisationId = "ORG1", FundingStreamPeriodCode = "FSP1", UopCode = "UOP1" },
                    new SummarisedActualOrgFspGroupKey { CollectionType = "CT2", CollectionReturnCode = "CR2", OrganisationId = "ORG2", FundingStreamPeriodCode = "FSP2", UopCode = "UOP2" }
                }, ConnectionInfo.CreateDefault());

            // assert
            Assert.AreEqual(10, reportedActuals.Count);
        }
    }
}
