namespace FundingAllocation.Tests.Extensions
{
    using FluentAssertions;
    using FundingAllocation.Extensions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class StringExtensionsTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void StringExtensions_ToMd5Hash_ShouldReturnMd5Hash()
        {
            // arrange
            var strings = new[]
            {
                "PSG-AY-2021-Payment-AcademyTrust-10083351-1_0",
                "PSG-AY-2021-Payment-AcademyTrust-10087895-2_0",
                "PSG-AY-2021-Payment-AcademyTrust-10097854-3_0",
                "PSG-AY-2021-Payment-AcademyTrust-10097895-1_0"
            };

            // act
            string hashHex = strings.ToMd5Hash();

            // assert
            hashHex.Should().Be("54-7A-F4-62-38-7F-4C-91-D8-29-0C-12-5B-81-C4-5C");
        }
    }
}