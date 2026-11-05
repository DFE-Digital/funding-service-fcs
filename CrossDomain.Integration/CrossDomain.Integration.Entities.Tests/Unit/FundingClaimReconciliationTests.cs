namespace CrossDomain.Integration.Entities.Tests.Unit
{
    using System;
    using System.Collections.Generic;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation;
    using SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation.Infos;

    [TestClass]
    public class FundingClaimReconciliationTests
    {
        private static ContractAllocation Allocation(string number, decimal value) =>
            new ContractAllocation
            {
                ContractAllocationNumber = number,
                FundingstreamPeriodCode = "FSP",
                AllocationStartDate = new DateTime(2020, 1, 1),
                AllocationEndDate = new DateTime(2021, 1, 1),
                Amounts = new AmountSummary { ReconciliationValue = value },
                Contract = new Contract { ContractNumber = "C1", ContractVersionNumber = 3 }
            };

        [TestMethod, TestCategory("UnitTest")]
        public void ToContractInfo_MapsAllocationsAndFirstContract()
        {
            var claim = new FundingClaimReconciliation();
            claim.ContractAllocations.Add(Allocation("A1", 10m));
            claim.ContractAllocations.Add(Allocation("A2", 20m));

            var info = claim.ToContractInfo();

            Assert.AreEqual("C1", info.ContractNumber);
            Assert.AreEqual(3, info.ContractVersion);
            Assert.AreEqual(2, info.AllocationInfos.Count);
            Assert.AreEqual(20m, info.FindAllocationInfo("A2").ReconciliationValue);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetClaimCollectionCode_And_GetFundingPeriod_Format()
        {
            var claim = new FundingClaimReconciliation();
            claim.Period.PeriodYear = "2021";
            claim.Period.PeriodTypeCode = PeriodTypeCode.AY;
            claim.ClaimType.ClaimTypeName = "Final Claim";

            Assert.AreEqual("2021-FinalClaim", claim.GetClaimCollectionCode());
            Assert.AreEqual("AY2021", claim.GetFundingPeriod());
        }

        [TestMethod, TestCategory("UnitTest")]
        [ExpectedException(typeof(ArgumentException))]
        public void ContractInfo_NoAllocations_Throws()
        {
            new ContractInfo(new List<AllocationInfo>(), "C1", 1);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractInfo_ToString_ContainsNumberAndVersion()
        {
            var info = new ContractInfo(new List<AllocationInfo> { new AllocationInfo("A", 1m, DateTime.Today, DateTime.Today, "F") }, "C9", 4);

            Assert.AreEqual("ContractNumber: C9, ContractVersion: 4", info.ToString());
        }

        [TestMethod, TestCategory("UnitTest")]
        [ExpectedException(typeof(InvalidOperationException))]
        public void ContractInfo_FindAllocationInfo_Unknown_Throws()
        {
            var info = new ContractInfo(new List<AllocationInfo> { new AllocationInfo("A", 1m, DateTime.Today, DateTime.Today, "F") }, "C9", 4);

            info.FindAllocationInfo("missing");
        }
    }
}
