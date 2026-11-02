namespace FundingAllocation.Tests.Extensions
{
    using System.Linq;
    using FluentAssertions;
    using FundingAllocation.Extensions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class EnumerableExtensionsTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void EnumerableExtensions_Unanimous_ShouldReturnTrueWhenAllPropertiesTheSame()
        {
            // arrange
            var items = new[]
            {
                new TestType("a"),
                new TestType("a"),
                new TestType("a")
            };

            // act
            bool areValuesUnanimous = items.Unanimous(i => i.TestProperty);

            // assert
            areValuesUnanimous.Should().BeTrue();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void EnumerableExtensions_Unanimous_ShouldReturnFalseWhenAllPropertiesNotTheSame()
        {
            // arrange
            var items = new[]
            {
                new TestType("a"),
                new TestType("a"),
                new TestType("b")
            };

            // act
            bool areValuesUnanimous = items.Unanimous(i => i.TestProperty);

            // assert
            areValuesUnanimous.Should().BeFalse();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void EnumerableExtensions_GetValueOrEmpty_ShouldReturnValueWhenInputHasValue()
        {
            var input = new[]
            {
                "Alpha",
                "Beta",
                "Gamma"
            };

            // act
            var result = input.GetValueOrEmpty();

            // assert
            result.Should().BeEquivalentTo(input);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void EnumerableExtensions_GetValueOrEmpty_ShouldReturnEmptyWhenInputIsNull()
        {
            string[] input = null;

            // act
            var result = input.GetValueOrEmpty();

            // assert
            result.Should().BeEquivalentTo(Enumerable.Empty<string>());
        }

        private class TestType
        {
            public TestType(string value)
            {
                TestProperty = value;
            }

            public string TestProperty { get; }
        }
    }
}
