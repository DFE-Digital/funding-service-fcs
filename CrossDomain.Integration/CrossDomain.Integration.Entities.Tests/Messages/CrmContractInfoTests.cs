namespace CrossDomain.Integration.Entities.Tests.Messages
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Dtos;

    [TestClass]
    public class CrmContractInfoTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ToCrmContractIdentity_CopiesIdentityFields()
        {
            var info = CreateInfo();

            var identity = info.ToCrmContractIdentity();

            Assert.AreEqual("ABC-1", identity.Number);
            Assert.AreEqual(2, identity.Version);
            Assert.AreEqual(3, identity.SubVersion);
            Assert.AreEqual("crm-id", identity.CrmEntityId);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Constructor_ExposesAllValues()
        {
            var info = CreateInfo();

            Assert.AreEqual(1000, info.ContractingUkprn);
            Assert.AreEqual("MASTER-1", info.MasterContractNumber);
            Assert.AreEqual("Type", info.AmendmentType);
            Assert.AreEqual(9, info.LatestOverallVersionNumber);
            Assert.AreEqual(3, info.CrmAllocationInfos.Count);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetExistingAllocationNumber_MatchingDeliveryOrg_ReturnsNumber()
        {
            var result = CreateInfo().GetExistingAllocationNumber("FS1", 2000);

            Assert.IsTrue(result.IsSome);
            Assert.AreEqual(7, result.IfNone(-1));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetExistingAllocationNumber_NoDeliveryOrgOnAllocation_FallsBackToContractingUkprn()
        {
            var result = CreateInfo().GetExistingAllocationNumber("FS2", 1000);

            Assert.IsTrue(result.IsSome);
            Assert.AreEqual(8, result.IfNone(-1));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetExistingAllocationNumber_NoMatch_ReturnsNone()
        {
            var info = CreateInfo();

            Assert.IsTrue(info.GetExistingAllocationNumber("FS1", 1234).IsNone);
            Assert.IsTrue(info.GetExistingAllocationNumber("OTHER", 2000).IsNone);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ToString_IncludesKeyValuesAndAllocations()
        {
            var text = CreateInfo().ToString();

            StringAssert.Contains(text, "Number: ABC-1");
            StringAssert.Contains(text, "CrmEntityId: crm-id");
            StringAssert.Contains(text, "Master: MASTER-1");
            StringAssert.Contains(text, "AllocationNumber: ALLOC-7");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CrmAllocationInfo_ToString_IncludesValues()
        {
            var text = new CrmAllocationInfo("FS1", "2000", "ALLOC-7").ToString();

            Assert.AreEqual("{FundingStreamCode: FS1, DeliveryOrgUkprn: 2000, AllocationNumber: ALLOC-7}", text);
        }

        private static CrmContractInfo CreateInfo()
        {
            return new CrmContractInfo(
                "ABC-1",
                2,
                3,
                1000,
                "crm-id",
                "MASTER-1",
                "Type",
                new[]
                {
                    new CrmAllocationInfo("FS1", "2000", "ALLOC-7"),
                    new CrmAllocationInfo("FS2", null, "ALLOC-8"),
                    new CrmAllocationInfo("FS3", "3000", "ALLOC-9")
                },
                9);
        }
    }
}
