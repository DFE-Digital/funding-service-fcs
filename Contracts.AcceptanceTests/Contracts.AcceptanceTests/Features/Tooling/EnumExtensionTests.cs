namespace SFA.FCT.Contracts.AcceptanceTests.Features.Tooling
{
    using System.Xml.Serialization;
    using Extensions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class EnumExtensionTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void EnumExtensions_IsEquivalentWithFirstValueEqualityToNull_ShouldCompareNonNullEnumValuesCorrectly()
        {
            Assert.IsTrue(TestEnum.First.IsEquivalentWithFirstValueEqualityToNull(TestEnum.First));
            Assert.IsFalse(TestEnum.First.IsEquivalentWithFirstValueEqualityToNull(TestEnum.Second));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void EnumExtensions_IsEquivalentWithFirstValueEqualityToNull_ShouldCompareNullValuesAsEqualToFirstValueInEnum()
        {
            Assert.IsTrue(TestEnum.First.IsEquivalentWithFirstValueEqualityToNull(null));
            Assert.IsFalse(TestEnum.Second.IsEquivalentWithFirstValueEqualityToNull(null));
        }

        private enum TestEnum
        {
            First,
            Second
        }
    }
}
