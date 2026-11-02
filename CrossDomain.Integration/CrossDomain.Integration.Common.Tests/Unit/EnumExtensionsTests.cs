namespace CrossDomain.Integration.Common.Tests.Unit
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Common.Extensions;

    [TestClass]
    public class EnumExtensionsTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void EnumExtensions_ShouldGetDescriptionWhenPresent()
        {
            ClaimTypeName claimTypeNameYearEnd = ClaimTypeName.YEAREND;

            Assert.AreEqual("YEAR END", claimTypeNameYearEnd.GetDescription());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void EnumExtensions_ShouldGetEnumAsStringWhenDescriptionIsNotPresent()
        {
            ClaimTypeName claimTypeNameFinal = ClaimTypeName.FINAL;

            Assert.AreEqual("FINAL", claimTypeNameFinal.GetDescription());
        }

        private enum ClaimTypeName
        {
            [System.ComponentModel.Description("MID YEAR")]
            MIDYEAR,

            [System.ComponentModel.Description("YEAR END")]
            YEAREND,

            FINAL
        }
    }
}
