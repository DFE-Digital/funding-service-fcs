namespace FCT.Operations.Integrity.Tests.Extensions
{
    using FluentAssertions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.AllocationDeliveryDomain.Common.Storage;
    using SFA.FCT.Operations.Integrity.Extensions;

    [TestClass]
    public class ReportedActualExtensionsTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ReportedActualExtensions_ShouldReturnEnrichedReportedActual()
        {
            // arrange
            ReportedActual reportedActual = new ReportedActual
            {
                ActualValue = 10d,
                ActualVolume = 11l,
                CollectionReturnCode = "CRC",
                CollectionType = "CT",
                ContractAllocationNumber = "CAN1",
                DeliverableCode = "DC",
                FundingStreamPeriodCode = "FSP1",
                OrganisationId = "ORG1",
                UoPCode = "Uop1",
                PeriodTypeCode = "PT1",
                Period = "P"
            };

            // act
            var enriched = reportedActual.ToEnrichedReportedActualFromReportedActual();

            // assert
            enriched.ActualValue.Should().Be(reportedActual.ActualValue);
            enriched.ActualVolume.Should().Be(reportedActual.ActualVolume);
            enriched.CollectionReturnCode.Should().Be(reportedActual.CollectionReturnCode);
            enriched.CollectionType.Should().Be(reportedActual.CollectionType);
            enriched.ContractAllocationNumber.Should().Be(reportedActual.ContractAllocationNumber);
            enriched.DeliverableCode.Should().Be(reportedActual.DeliverableCode);
            enriched.FundingStreamPeriodCode.Should().Be(reportedActual.FundingStreamPeriodCode);
            enriched.OrganisationId.Should().Be(reportedActual.OrganisationId);
            enriched.UoPCode.Should().Be(reportedActual.UoPCode);
            enriched.PeriodTypeCode.Should().Be(reportedActual.PeriodTypeCode);
            enriched.Period.Should().Be(reportedActual.Period);
        }
    }
}
