namespace CrossDomain.Integration.Entities.Tests.Messages
{
    using System;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Dtos;

    [TestClass]
    public class ContractItemsMappingResultTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void Equals_SameValues_AreEqualWithSameHashCode()
        {
            var a = new ContractItemsMappingResult("ESF", "AY1819", "GRP", "TYPE");
            var b = new ContractItemsMappingResult("ESF", "AY1819", "GRP", "TYPE");

            Assert.IsTrue(a.Equals(b));
            Assert.IsTrue(a.Equals((object)b));
            Assert.AreEqual(a.GetHashCode(), b.GetHashCode());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Equals_DifferentValues_AreNotEqual()
        {
            var a = new ContractItemsMappingResult("ESF", "AY1819", "GRP", "TYPE");

            Assert.IsFalse(a.Equals(new ContractItemsMappingResult("X", "AY1819", "GRP", "TYPE")));
            Assert.IsFalse(a.Equals(new ContractItemsMappingResult("ESF", "X", "GRP", "TYPE")));
            Assert.IsFalse(a.Equals(new ContractItemsMappingResult("ESF", "AY1819", "X", "TYPE")));
            Assert.IsFalse(a.Equals(new ContractItemsMappingResult("ESF", "AY1819", "GRP", "X")));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Equals_NullSameReferenceAndOtherType()
        {
            var a = new ContractItemsMappingResult("ESF", "AY1819", "GRP", "TYPE");

            Assert.IsFalse(a.Equals((ContractItemsMappingResult)null));
            Assert.IsFalse(a.Equals((object)null));
            Assert.IsTrue(a.Equals((object)a));
            Assert.IsFalse(a.Equals("not a mapping result"));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ToString_IncludesAllValues()
        {
            var text = new ContractItemsMappingResult("ESF", "AY1819", "GRP", "TYPE").ToString();

            Assert.AreEqual("FundingTypeCode: ESF, FundingPeriodCode: AY1819, FSPGroupCode: GRP, ContractType: TYPE", text);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetPeriodTypeCode_AllowedPrefix_ReturnsEnum()
        {
            Assert.AreEqual(periodTypeCodeType.AY, new ContractItemsMappingResult("ESF", "AY1819", "GRP", "TYPE").GetPeriodTypeCode());
            Assert.AreEqual(periodTypeCodeType.FY, new ContractItemsMappingResult("ESF", "FY1819", "GRP", "TYPE").GetPeriodTypeCode());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetPeriodTypeCode_UnsupportedPrefix_Throws()
        {
            try
            {
                new ContractItemsMappingResult("ESF", "CY1819", "GRP", "TYPE").GetPeriodTypeCode();
                Assert.Fail("Expected exception");
            }
            catch (InvalidOperationException)
            {
            }
        }
    }
}
