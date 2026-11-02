namespace AllocationDeliveryDomain.Endpoint.Tests.PaymentInstructionValidation.Repositories
{
    using System;
    using System.Collections.Generic;
    using AllocationDelivery.Messages.DTOs;
    using Endpoint.PaymentInstructionValidation.Repositories;
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
        public void MultiSourceActualRepository_ShouldReturnExpectedRowsWhenActualsHeldInAzureTableStorage()
        {
            ReportedActual[] reportedActualsInAzureTableStorage =
            {
                new ReportedActual { PartitionKey = "PK1" },
                new ReportedActual { PartitionKey = "PK1" }
            };
            SummarisedActual[] summarisedActualsInAzureSql =
            {
                new SummarisedActual { CollectionType = "CT1", CollectionReturnCode = "CR1", OrganisationId = "ORG1", FundingStreamPeriodCode = "FSP1", UopCode = "UOP1" },
                new SummarisedActual { CollectionType = "CT1", CollectionReturnCode = "CR1", OrganisationId = "ORG1", FundingStreamPeriodCode = "FSP1", UopCode = "UOP1" },
                new SummarisedActual { CollectionType = "CT1", CollectionReturnCode = "CR1", OrganisationId = "ORG1", FundingStreamPeriodCode = "FSP1", UopCode = "UOP1" }
            };

            // arrange
            Mock<IAzureRepository<ReportedActual>> reportedActualRepositoryMock = new Mock<IAzureRepository<ReportedActual>>();
            reportedActualRepositoryMock
                .Setup(m => m.GetRows(It.IsAny<string>()))
                .Returns(reportedActualsInAzureTableStorage);

            Mock<ISummarisedActualsQueryRepository> summarisedActualRepositoryMock = new Mock<ISummarisedActualsQueryRepository>();
            summarisedActualRepositoryMock
                .Setup(m => m.GetSummarisedActuals(It.IsAny<SummarisedActualOrgFspGroupKey>(), It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(summarisedActualsInAzureSql);

            MultiSourceActualRepository repository = new MultiSourceActualRepository(reportedActualRepositoryMock.Object, summarisedActualRepositoryMock.Object);

            // act
            IReadOnlyCollection<ReportedActual> reportedActuals = repository.GetReportedActuals(
                "PK1",
                null,
                ConnectionInfo.CreateDefault()
                ).Result;

            // assert
            Assert.AreEqual(2, reportedActuals.Count);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MultiSourceActualRepository_ShouldReturnExpectedRowsWhenActualsHeldInAzureSql()
        {
            ReportedActual[] reportedActualsInAzureTableStorage =
            {
                new ReportedActual { PartitionKey = "PK1" },
                new ReportedActual { PartitionKey = "PK1" }
            };
            SummarisedActual[] summarisedActualsInAzureSql =
            {
                new SummarisedActual { CollectionType = "CT1", CollectionReturnCode = "CR1", OrganisationId = "ORG1", FundingStreamPeriodCode = "FSP1", UopCode = "UOP1" },
                new SummarisedActual { CollectionType = "CT1", CollectionReturnCode = "CR1", OrganisationId = "ORG1", FundingStreamPeriodCode = "FSP1", UopCode = "UOP1" },
                new SummarisedActual { CollectionType = "CT1", CollectionReturnCode = "CR1", OrganisationId = "ORG1", FundingStreamPeriodCode = "FSP1", UopCode = "UOP1" }
            };

            // arrange
            Mock<IAzureRepository<ReportedActual>> reportedActualRepositoryMock = new Mock<IAzureRepository<ReportedActual>>();
            reportedActualRepositoryMock
                .Setup(m => m.GetRows(It.IsAny<string>()))
                .Returns(reportedActualsInAzureTableStorage);

            Mock<ISummarisedActualsQueryRepository> summarisedActualRepositoryMock = new Mock<ISummarisedActualsQueryRepository>();
            summarisedActualRepositoryMock
                .Setup(m => m.GetSummarisedActuals(It.IsAny<SummarisedActualOrgFspGroupKey>(), It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(summarisedActualsInAzureSql);

            MultiSourceActualRepository repository = new MultiSourceActualRepository(reportedActualRepositoryMock.Object, summarisedActualRepositoryMock.Object);

            // act
            IReadOnlyCollection<ReportedActual> reportedActuals = repository.GetReportedActuals(
                null,
                new SummarisedActualOrgFspGroupKey { CollectionType = "CT1", CollectionReturnCode = "CR1", OrganisationId = "ORG1", FundingStreamPeriodCode = "FSP1", UopCode = "UOP1" },
                ConnectionInfo.CreateDefault()
                ).Result;

            // assert
            Assert.AreEqual(3, reportedActuals.Count);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MultiSourceActualRepository_ShouldThrowInvalidOperationExceptionWhenOnlyNullParametersArePassed()
        {
            // arrange
            MultiSourceActualRepository repository = new MultiSourceActualRepository(
                Mock.Of<IAzureRepository<ReportedActual>>(), Mock.Of<ISummarisedActualsQueryRepository>());

            bool hasThrownExpectedException = false;

            // act
            try
            {
                IReadOnlyCollection<ReportedActual> reportedActuals = repository.GetReportedActuals(null, null, ConnectionInfo.CreateDefault()).Result;
            }
            catch (AggregateException ex) when (ex.InnerException is InvalidOperationException)
            {
                hasThrownExpectedException = true;
            }

            // assert
            Assert.IsTrue(hasThrownExpectedException);
        }
    }
}
