namespace AllocationDeliveryDomain.Endpoint.Tests.Unit
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using BusinessLogic;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.AllocationDeliveryDomain.Common.Storage;

    [TestClass]
    public class AllocationDeliverablePeriodTransformerTests
    {
        private const string TestAllocationNumber = "TestAllocationNumber";
        private const string TestContractNumber = "TestContractNumber";
        private const string TestFundingStreamPeriodCode = "TestFundingStreamPeriod";
        private const string TestOrgId = "TestOrgId";
        private const string TestUkprn = "TestUkprn";
        private readonly DateTime _allocationStartDate = DateTime.Now;
        private readonly DateTime _allocationEndDate = DateTime.Now.AddDays(1);

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationDeliverablePeriodTransformer_ToEnrichedActuals_ShouldTransformCollectionOfAllocationDeliverablePeriods_ToCollectionOfEnrichedActuals()
        {
            // Arrange
            IEnumerable<AllocationDeliverablePeriod> allocationDeliverablePeriods = CreateCollectionOfAllocationDeliverablePeriods();
            List<EnrichedReportedActual> expectedEnrichedActuals = CreateCollectionOfEnrichedActuals().ToList();

            // Act
            var transformedActuals = AllocationDeliverablePeriodTransformer.ToEnrichedReportedActuals(allocationDeliverablePeriods, expectedEnrichedActuals.First()).ToList();

            // Assert
            expectedEnrichedActuals.ForEach(expected =>
            {
                var matchedTransformed = transformedActuals.FirstOrDefault(e => e.Equals(expected));
                Assert.IsNotNull(matchedTransformed, $"Not found object: {expected}");
                Assert.AreEqual(expected.ContractNumber, matchedTransformed.ContractNumber, "The contract number is not set");
                Assert.AreEqual(expected.AllocationStartDate, matchedTransformed.AllocationStartDate, "The AllocationStartDate is not set");
                Assert.AreEqual(expected.AllocationEndDate, matchedTransformed.AllocationEndDate, "The AllocationEndDate is not set");
                Assert.AreEqual(expected.ContractSubVersion, matchedTransformed.ContractSubVersion, "The ContractSubVersion is not set");
                Assert.AreEqual(expected.ContractVersion, matchedTransformed.ContractVersion, "The ContractVersion is not set");
                Assert.AreEqual(expected.Ukprn, matchedTransformed.Ukprn, "The Ukprn is not set");
                Assert.AreEqual(0, matchedTransformed.ActualVolume, "The ActualVolume is not set");
                Assert.AreEqual(0, matchedTransformed.ActualValue, "The ActualVolume is not set");
            });
        }

        private IEnumerable<EnrichedReportedActual> CreateCollectionOfEnrichedActuals()
        {
            return new List<EnrichedReportedActual>
            {
                new EnrichedReportedActual
                {
                    ContractNumber = TestContractNumber,
                    ContractAllocationNumber = TestAllocationNumber,
                    FundingStreamPeriodCode = TestFundingStreamPeriodCode,
                    OrganisationId = TestOrgId,
                    Ukprn = TestUkprn,
                    AllocationStartDate = _allocationStartDate,
                    AllocationEndDate = _allocationEndDate,
                    ActualValue = 0,
                    ActualVolume = 0,
                    DeliverableCode = "1",
                    EnrichedDeliverableCode = "1",
                    DeliverablePeriodMatch = true,
                    Period = "201508",
                    CollectionReturnCode = "R04",
                    CollectionType = "ILR1516",
                    UoPCode = null,
                    PeriodTypeCode = "PeriodTypeCode",
                    ContractSubVersion = 0,
                    ContractVersion = 1,
                    PartitionKey = "PartitionKey",
                    RowKey = "RowKey"
                },
                new EnrichedReportedActual
                {
                    ContractNumber = TestContractNumber,
                    ContractAllocationNumber = TestAllocationNumber,
                    FundingStreamPeriodCode = TestFundingStreamPeriodCode,
                    OrganisationId = TestOrgId,
                    Ukprn = TestUkprn,
                    AllocationStartDate = _allocationStartDate,
                    AllocationEndDate = _allocationEndDate,
                    ActualValue = 0,
                    ActualVolume = 0,
                    DeliverableCode = "2",
                    EnrichedDeliverableCode = "2",
                    DeliverablePeriodMatch = true,
                    Period = "201509",
                    CollectionReturnCode = "R04",
                    CollectionType = "ILR1516",
                    UoPCode = null,
                    PeriodTypeCode = "PeriodTypeCode",
                    ContractSubVersion = 0,
                    ContractVersion = 1,
                    PartitionKey = "PartitionKey",
                    RowKey = "RowKey"
                },
                new EnrichedReportedActual
                {
                    ContractNumber = TestContractNumber,
                    ContractAllocationNumber = TestAllocationNumber,
                    FundingStreamPeriodCode = TestFundingStreamPeriodCode,
                    OrganisationId = TestOrgId,
                    Ukprn = TestUkprn,
                    AllocationStartDate = _allocationStartDate,
                    AllocationEndDate = _allocationEndDate,
                    ActualValue = 0,
                    ActualVolume = 0,
                    DeliverableCode = "3",
                    EnrichedDeliverableCode = "3",
                    DeliverablePeriodMatch = true,
                    Period = "201509",
                    CollectionReturnCode = "R04",
                    CollectionType = "ILR1516",
                    UoPCode = null,
                    PeriodTypeCode = "PeriodTypeCode",
                    ContractSubVersion = 0,
                    ContractVersion = 1,
                    PartitionKey = "PartitionKey",
                    RowKey = "RowKey"
                }
            };
        }

        private IEnumerable<AllocationDeliverablePeriod> CreateCollectionOfAllocationDeliverablePeriods()
        {
            return new List<AllocationDeliverablePeriod>
            {
                new AllocationDeliverablePeriod
                {
                    AllocationEndDate = _allocationEndDate,
                    AllocationStartDate = _allocationStartDate,
                    ContractAllocationNumber = TestAllocationNumber,
                    ContractNumber = TestContractNumber,
                    ContractSubVersionNumber = 0,
                    ContractVersionNumber = 1,
                    DeliverableCode = 1,
                    FundingStreamPeriodCode = TestFundingStreamPeriodCode,
                    OrganisationId = TestOrgId,
                    Period = "201508",
                    Ukprn = TestUkprn
                },
                new AllocationDeliverablePeriod
                {
                    AllocationEndDate = _allocationEndDate,
                    AllocationStartDate = _allocationStartDate,
                    ContractAllocationNumber = TestAllocationNumber,
                    ContractNumber = TestContractNumber,
                    ContractSubVersionNumber = 0,
                    ContractVersionNumber = 1,
                    DeliverableCode = 2,
                    FundingStreamPeriodCode = TestFundingStreamPeriodCode,
                    OrganisationId = TestOrgId,
                    Period = "201509",
                    Ukprn = TestUkprn
                },
                new AllocationDeliverablePeriod
                {
                    AllocationEndDate = _allocationEndDate,
                    AllocationStartDate = _allocationStartDate,
                    ContractAllocationNumber = TestAllocationNumber,
                    ContractNumber = TestContractNumber,
                    ContractSubVersionNumber = 0,
                    ContractVersionNumber = 1,
                    DeliverableCode = 3,
                    FundingStreamPeriodCode = TestFundingStreamPeriodCode,
                    OrganisationId = TestOrgId,
                    Period = "201509",
                    Ukprn = TestUkprn
                }
            };
        }
    }
}
