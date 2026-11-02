namespace ContractRequestDomain.Cfs.Tests.Release
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using Cfs.Release.Repositories;
    using Cfs.Release.Services;
    using Common.Dtos;
    using Dto;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using MoreLinq;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    [TestClass]
    public class AllocationReleaseServiceTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void AllocationReleaseService_ShouldTransformAllocationIntoPersistableContractType()
        {
            // arrange
            ExtendedContractType generatedContract = null;
            Task ContractGenerated(ContractCfsAllocation contractCfsAllocation)
            {
                generatedContract = contractCfsAllocation.Contract;
                return Task.CompletedTask;
            }

            Mock<IAllocationRepository> allocationRepositoryMock = new Mock<IAllocationRepository>();
            allocationRepositoryMock
                .Setup(m => m.GetAllocationsForRelease(It.IsAny<string>(), It.IsAny<string>()))
                .Returns(new List<Allocation>
                {
                    new Allocation
                    {
                        Id = "ALLOC-ID",
                        FundingStreamPeriodCode = "ALLF1819",
                        DeliverableCode = 5,
                        FundingTypeCode = "LOANS",
                        FundingPeriod = "AY1819",
                        Ukprn = 12345,
                        MajorVersion = 1,
                        MinorVersion = 2,
                        StartDate = new DateTime(2018, 08, 01, 0, 0, 0, DateTimeKind.Utc),
                        EndDate = new DateTime(2019, 07, 31, 0, 0, 0, DateTimeKind.Utc),
                        CrmEntityId = Guid.NewGuid(),
                        AllocationPeriods = new List<AllocationPeriod>
                        {
                            new AllocationPeriod { Month = 08, Year = 2018, Period = "Aug-18", ProfileValue = 1000m },
                            new AllocationPeriod { Month = 09, Year = 2018, Period = "Sep-18", ProfileValue = 1000m },
                            new AllocationPeriod { Month = 10, Year = 2018, Period = "Oct-18", ProfileValue = 1000m },
                            new AllocationPeriod { Month = 11, Year = 2018, Period = "Nov-18", ProfileValue = 1000m },
                            new AllocationPeriod { Month = 12, Year = 2018, Period = "Dec-18", ProfileValue = 1000m },
                            new AllocationPeriod { Month = 01, Year = 2019, Period = "Jan-19", ProfileValue = 1000m },
                            new AllocationPeriod { Month = 02, Year = 2019, Period = "Feb-19", ProfileValue = 1000m },
                            new AllocationPeriod { Month = 03, Year = 2019, Period = "Mar-19", ProfileValue = 1000m },
                            new AllocationPeriod { Month = 04, Year = 2019, Period = "Apr-19", ProfileValue = 1000m },
                            new AllocationPeriod { Month = 05, Year = 2019, Period = "May-19", ProfileValue = 1000m },
                            new AllocationPeriod { Month = 06, Year = 2019, Period = "Jun-19", ProfileValue = 1000m },
                            new AllocationPeriod { Month = 07, Year = 2019, Period = "Jul-19", ProfileValue = 1000m },
                        }
                    }
                });

            Mock<IContractNumberEnricher> contractNumberEnricherMock = new Mock<IContractNumberEnricher>();
            contractNumberEnricherMock
                .Setup(m => m.EnrichWithContractAndAllocationNumbers(It.IsAny<ExtendedContractType>(), It.IsAny<ConnectionInfo>()))
                .Callback((ExtendedContractType m, ConnectionInfo ci) =>
                {
                    m.contractNumber = "MASTER";
                    m.contracts.ForEach(c => c.contractNumber = "CHILD");
                    m.contracts.SelectMany(c => c.contractAllocations).ForEach(a => a.contractAllocationNumber = "ALLOCATION");
                });

            AllocationReleaseService allocationReleaseService = new AllocationReleaseService(allocationRepositoryMock.Object, contractNumberEnricherMock.Object);

            // act
            allocationReleaseService.ReleaseAllocations("LOANS", "AY1819", ContractGenerated, ConnectionInfo.CreateDefault()).Wait();

            // assert
            Assert.IsNotNull(generatedContract, "Contract was not generated");

            // master contract
            ExtendedContractType masterContract = generatedContract;
            Assert.IsFalse(string.IsNullOrEmpty(masterContract.contractNumber), "Master contract contractNumber not set");
            Assert.AreEqual(1, masterContract.contractVersionNumber, "Master contract contractVersionNumber incorrect");
            Assert.AreEqual(0, masterContract.contractSubVersionNumber, "Master contract contractSubVersionNumber incorrect");
            Assert.AreEqual(hierarchyType.MASTERCONTRACT, masterContract.hierarchyType, "Master contract hierarchyType incorrect");
            Assert.AreEqual(new DateTime(2018, 08, 01, 0, 0, 0, DateTimeKind.Utc), masterContract.startDate, "Master contract startDate incorrect");
            Assert.AreEqual(new DateTime(2019, 07, 31, 0, 0, 0, DateTimeKind.Utc), masterContract.endDate, "Master contract endDate incorrect");
            Assert.AreEqual("None", masterContract.amendmentType, "Master contract amendmentType incorrect");

            Assert.IsNotNull(masterContract.contractor, "Master contract contractor not set");
            Assert.AreEqual(12345, masterContract.contractor.ukprn, "Master contract contractor ukprn incorrect");

            Assert.IsNotNull(masterContract.fundingType, "Master contract fundingType not set");
            Assert.AreEqual("LOANS", masterContract.fundingType.fundingTypeCode, "Master contract fundingType fundingTypeCode incorrect");

            Assert.IsNotNull(masterContract.fundingStream, "Master contract fundingStream not set");
            Assert.AreEqual("ALLF", masterContract.fundingStream.fundingStreamCode, "Master contract fundingStream fundingStreamCode incorrect");

            // child contract
            Assert.IsNotNull(masterContract.contracts, "Child contracts not set");
            Assert.AreEqual(1, masterContract.contracts.Count, "Unexpected number of child contracts");
            ExtendedContractType childContract = masterContract.contracts.SingleOrDefault();
            Assert.IsFalse(string.IsNullOrEmpty(childContract.contractNumber), "Child contract contractNumber not set");
            Assert.AreEqual(1, childContract.contractVersionNumber, "Child contract contractVersionNumber incorrect");
            Assert.AreEqual(0, childContract.contractSubVersionNumber, "Child contract contractSubVersionNumber incorrect");
            Assert.IsTrue(childContract.DocumentationRequired != null && childContract.DocumentationRequired.Value, "Child contract DocumentationRequired incorrect");
            Assert.IsFalse(childContract.SkipCaseloadAssignment != null && childContract.SkipCaseloadAssignment.Value, "Child contract SkipCaseloadAssignment incorrect");
            Assert.IsFalse(childContract.SkipReviewAndInternalApproval != null && childContract.SkipReviewAndInternalApproval.Value, "Child contract SkipReviewAndInternalApproval incorrect");
            Assert.IsFalse(childContract.SkipDocumentMerge, "Child contract SkipDocumentMerge incorrect");
            Assert.IsNull(childContract.IsNonFinancialAmendment, "Child contract IsNonFinancialAmendment incorrect");
            Assert.AreEqual(hierarchyType.CONTRACT, childContract.hierarchyType, "Child contract hierarchyType incorrect");
            Assert.AreEqual("Contract for Services", childContract.contractType1, "Child contract contractType1 incorrect");
            Assert.AreEqual(new DateTime(2018, 08, 01, 0, 0, 0, DateTimeKind.Utc), childContract.startDate, "Child contract startDate incorrect");
            Assert.AreEqual(new DateTime(2019, 07, 31, 0, 0, 0, DateTimeKind.Utc), childContract.endDate, "Child contract endDate incorrect");
            Assert.AreEqual(12000m, childContract.contractValue, "Child contract contractValue incorrect");
            Assert.AreEqual("New", childContract.amendmentType, "Child contract amendmentType incorrect");

            Assert.IsNotNull(childContract.contractor, "Child contract contractor not set");
            Assert.AreEqual(12345, childContract.contractor.ukprn, "Child contract contractor ukprn incorrect");

            Assert.IsNotNull(childContract.fundingType, "Child contract fundingType not set");
            Assert.AreEqual("LOANS", childContract.fundingType.fundingTypeCode, "Child contract fundingType fundingTypeCode incorrect");

            Assert.IsNotNull(childContract.fundingStream, "Child contract fundingStream not set");
            Assert.AreEqual("ALLF", childContract.fundingStream.fundingStreamCode, "Child contract fundingStream fundingStreamCode incorrect");

            Assert.IsNotNull(childContract.period, "Child contract period not set");
            Assert.AreEqual("1819", childContract.period.period1, "Child contract period period1 incorrect");
            Assert.IsNotNull(childContract.period.periodType, "Child contract period periodType not set");
            Assert.AreEqual(periodTypeCodeType.AY, childContract.period.periodType.periodTypeCode, "Child contract period periodType periodTypeCode incorrect");
            Assert.AreEqual(periodTypeNameType.ACADEMICYEAR, childContract.period.periodType.periodTypeName, "Child contract period periodType periodTypeName incorrect");

            // contract allocations
            Assert.IsNotNull(childContract.contractAllocations, "Contract allocations not set");
            Assert.AreEqual(1, childContract.contractAllocations.Count, "Unexpected number of contract allocations");
            ExtendedContractAllocation contractAllocation = childContract.contractAllocations.Single();
            Assert.IsFalse(string.IsNullOrEmpty(contractAllocation.contractAllocationNumber), "Contract allocation contractAllocationNumber not set");
            Assert.AreEqual("ALLF1819", contractAllocation.fundingStreamPeriodCode, "Contract allocation fundingStreamPeriodCode incorrect");
            Assert.AreEqual(new DateTime(2018, 08, 01, 0, 0, 0, DateTimeKind.Utc), contractAllocation.startDate, "Contract allocation startDate incorrect");
            Assert.AreEqual(new DateTime(2019, 07, 31, 0, 0, 0, DateTimeKind.Utc), contractAllocation.endDate, "Contract allocation endDate incorrect");
            Assert.AreEqual(12000m, contractAllocation.maximumContractValue, "Contract allocation maximumContractValue incorrect");

            Assert.IsNotNull(contractAllocation.period, "Contract allocation period not set");
            Assert.AreEqual("1819", contractAllocation.period.period1, "Contract allocation period period1 incorrect");
            Assert.IsNotNull(contractAllocation.period.periodType, "Contract allocation period periodType not set");
            Assert.AreEqual(periodTypeCodeType.AY, contractAllocation.period.periodType.periodTypeCode, "Contract allocation period periodType periodTypeCode incorrect");
            Assert.AreEqual(periodTypeNameType.ACADEMICYEAR, contractAllocation.period.periodType.periodTypeName, "Contract allocation period periodType periodTypeName incorrect");

            // contract deliverables
            Assert.AreEqual(1, contractAllocation.contractDeliverables.Count, "Unexpected number of contract deliverables");
            contractDeliverablesTypeContractDeliverable contractDeliverable = contractAllocation.contractDeliverables.Single();
            Assert.IsNull(contractDeliverable.ParentDeliverableCode, "Deliverable ParentDeliverableCode incorrect");
            Assert.AreEqual(12000m, contractDeliverable.plannedValue, "Deliverable plannedValue incorrect");
            Assert.AreEqual(1, contractDeliverable.DisplayOrder, "Deliverable DisplayOrder incorrect");

            Assert.IsNotNull(contractDeliverable.deliverable, "Deliverable deliverable not set");
            Assert.AreEqual("ALLF", contractDeliverable.deliverable.fundingStreamCode, "Deliverable deliverable fundingStreamCode incorrect");
            Assert.AreEqual(5, contractDeliverable.deliverable.deliverableCode, "Deliverable deliverable deliverableCode incorrect");
            Assert.AreEqual("Advanced Learner Loans Facility", contractDeliverable.deliverable.deliverableName, "Deliverable deliverable deliverableName incorrect");

            // deliverable periods
            Assert.AreEqual(12, contractDeliverable.contractDeliverablePeriods.Count, "Unexpected number of deliverable periods");
            contractDeliverablePeriodsTypeContractDeliverablePeriod sampleDeliverablePeriod = contractDeliverable.contractDeliverablePeriods.SingleOrDefault(dp => dp.periodName == "Aug-18");
            Assert.IsNotNull(sampleDeliverablePeriod, "Expected deliverable period not found");
            Assert.AreEqual(8, sampleDeliverablePeriod.period, "Deliverable Period period incorrect");
            Assert.AreEqual(2018, sampleDeliverablePeriod.year, "Deliverable Period year incorrect");
            Assert.AreEqual(1000m, sampleDeliverablePeriod.plannedValue, "Deliverable Period plannedValue incorrect");
            Assert.AreEqual("Aug-18", sampleDeliverablePeriod.periodName, "Deliverable Period periodName incorrect");
            Assert.AreEqual(201808, sampleDeliverablePeriod.displayOrder, "Deliverable Period displayOrder incorrect");
            Assert.IsFalse(sampleDeliverablePeriod.aggregate, "Deliverable Period aggregate incorrect");

            Assert.IsNotNull(sampleDeliverablePeriod.periodType, "Deliverable Period periodType not set");
            Assert.AreEqual(periodTypeCodeType.CM, sampleDeliverablePeriod.periodType.periodTypeCode, "Deliverable Period periodType periodTypeCode incorrect");
            Assert.AreEqual(periodTypeNameType.CALENDARMONTH, sampleDeliverablePeriod.periodType.periodTypeName, "Deliverable Period periodType periodTypeName incorrect");
        }
    }
}
