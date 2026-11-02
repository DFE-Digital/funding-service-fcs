namespace ContractCreateDomain.IncrementContractVersionEndpoint.Tests.Services.Unit_Tests
{
    using System;
    using System.Collections.Generic;
    using System.Data;
    using System.Linq;
    using ContractManagement.DataStore.Model;
    using IncrementContractVersionEndpoint.Repositories;
    using IncrementContractVersionEndpoint.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.ContractCreateDomain.Implementation.Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    [TestClass]
    public class LevyContractAllocationServiceTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void LevyContractAllocationService_AddPayableNonLevyContractAllocationIfNotPresent_ShouldAddPaymentNonLevyAllocationIfNotPresent()
        {
            const string payableNonLevyFundingStreamPeriodCode = "NONLEVY2019";
            DateTime fspStartDate = new DateTime(2019, 08, 01, 0, 0, 0, DateTimeKind.Utc);

            // arrange
            Mock<IFundingStreamPeriodRepository> fundingStreamPeriodRepositoryMock = new Mock<IFundingStreamPeriodRepository>();
            fundingStreamPeriodRepositoryMock
                .Setup(m => m.Find(It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(new FundingStreamPeriod(payableNonLevyFundingStreamPeriodCode, fspStartDate)
                {
                    LegalDeliverables = new List<FundingStreamPeriodLegalDeliverable>
                    {
                        new FundingStreamPeriodLegalDeliverable(payableNonLevyFundingStreamPeriodCode, 1, false, "Total 16-18 Non-Levy Apprenticeships", 1),
                        new FundingStreamPeriodLegalDeliverable(payableNonLevyFundingStreamPeriodCode, 8, false, "Total Adult Non-Levy Apprenticeships", 8)
                    }
                });

            Mock<IAllocationNumberRepository> allocationNumberRepositoryMock = new Mock<IAllocationNumberRepository>();
            
            allocationNumberRepositoryMock
                .Setup(m => m.GetAllocationNumberPrefix(It.IsAny<string>()))
                .Returns("NLA");

            Mock<ISequenceRepository> sequenceRepositoryMock = new Mock<ISequenceRepository>();
            sequenceRepositoryMock
                .Setup(r => r.GetNextNumber(SequenceType.Allocation, "NLA", It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(1234);

            LevyContractAllocationService levyContractAllocationService = new LevyContractAllocationService(
                fundingStreamPeriodRepositoryMock.Object,
                allocationNumberRepositoryMock.Object,
                sequenceRepositoryMock.Object);

            ExtendedContractType childContract = new ExtendedContractType
            {
                contractAllocations = new List<ExtendedContractAllocation>
                {
                    new ExtendedContractAllocation { fundingStreamPeriodCode = "LEVY1799" }
                }
            };
            var mockConnectionInfo = new Mock<ConnectionInfo>(null, Mock.Of<IDbConnection>());

            // act
            levyContractAllocationService.AddPayableNonLevyContractAllocationIfNotPresent(childContract, mockConnectionInfo.Object).Wait();

            // assert
            ExtendedContractAllocation payableNonLevyAllocation = childContract.contractAllocations.SingleOrDefault(a => a.fundingStreamPeriodCode == "NONLEVY2019");
            Assert.IsNotNull(payableNonLevyAllocation, "Payable Non-Levy allocation was not added to the contract");
            Assert.IsTrue(!string.IsNullOrEmpty(payableNonLevyAllocation.contractAllocationNumber), "Allocation added without allocation number");
            Assert.AreEqual("NONLEVY", payableNonLevyAllocation.fundingStream.fundingStreamCode, "Allocation added with incorrect Funding Stream");
            Assert.AreEqual(payableNonLevyFundingStreamPeriodCode, payableNonLevyAllocation.fundingStreamPeriodCode, "Allocation added with incorrect Funding Stream Period");
            Assert.AreEqual(fspStartDate, payableNonLevyAllocation.startDate, "Allocation added with incorrect start date");
            Assert.AreEqual("1799", payableNonLevyAllocation.period.period1, "Allocation added with incorrect period");
            Assert.AreEqual(periodTypeCodeType.LEVY, payableNonLevyAllocation.period.periodType.periodTypeCode, "Allocation added with incorrect period type");
            Assert.AreEqual(2, payableNonLevyAllocation.contractDeliverables.Count, "Allocation added with incorrect number of deliverables");

            contractDeliverablesTypeContractDeliverable firstDeliverable = payableNonLevyAllocation.contractDeliverables.First();
            Assert.AreEqual(1, firstDeliverable.deliverable.deliverableCode, "Deliverable added with incorrect deliverable code");
            Assert.AreEqual("Total 16-18 Non-Levy Apprenticeships", firstDeliverable.deliverable.deliverableName, "Deliverable added with incorrect deliverable name");
            Assert.AreEqual(1, firstDeliverable.DisplayOrder, "Deliverable added with incorrect display order");
            Assert.AreEqual(1, firstDeliverable.contractDeliverablePeriods.Count, "Deliverable added with incorrect number of deliverable periods");

            contractDeliverablePeriodsTypeContractDeliverablePeriod deliverablePeriod = firstDeliverable.contractDeliverablePeriods.Single();
            Assert.AreEqual(2019, deliverablePeriod.year, "Deliverable Period added with incorrect year");
            Assert.AreEqual(08, deliverablePeriod.period, "Deliverable Period added with incorrect period (month)");
            Assert.AreEqual("Aug-19", deliverablePeriod.periodName, "Deliverable Period added with incorrect period name");
            Assert.AreEqual(201908, deliverablePeriod.displayOrder, "Deliverable Period added with incorrect display order");
            Assert.AreEqual(periodTypeCodeType.CM, deliverablePeriod.periodType.periodTypeCode, "Deliverable Period added with incorrect period type code");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void LevyContractAllocationService_AddPayableNonLevyContractAllocationIfNotPresent_ShouldNotAddPaymentNonLevyAllocationIfAlreadyPresent()
        {
            // arrange
            LevyContractAllocationService levyContractAllocationService = new LevyContractAllocationService(
                Mock.Of<IFundingStreamPeriodRepository>(),
                Mock.Of<IAllocationNumberRepository>(),
                Mock.Of<ISequenceRepository>());

            ExtendedContractType childContract = new ExtendedContractType
            {
                contractAllocations = new List<ExtendedContractAllocation>
                {
                    new ExtendedContractAllocation { fundingStreamPeriodCode = "LEVY1799" },
                    new ExtendedContractAllocation { fundingStreamPeriodCode = "NONLEVY2019" }
                }
            };
            var mockConnectionInfo = new Mock<ConnectionInfo>(null, Mock.Of<IDbConnection>());

            // act
            levyContractAllocationService.AddPayableNonLevyContractAllocationIfNotPresent(childContract, mockConnectionInfo.Object).Wait();

            // assert
            ExtendedContractAllocation[] payableNonLevyAllocations =
                childContract.contractAllocations.Where(a => a.fundingStreamPeriodCode == "NONLEVY2019").ToArray();

            Assert.AreEqual(1, payableNonLevyAllocations.Length, "Additional payable Non-Levy allocation was added to the contract");
        }
    }
}