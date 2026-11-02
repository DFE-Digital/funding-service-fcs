namespace AllocationDeliveryDomain.Endpoint.Tests.ActualsPull.Extensions
{
    using Endpoint.ActualsPull.Extensions;
    using FluentAssertions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class StringExtensionsTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void StringExtensions_GetValueOrDefault_ShouldReturnValueWhenPresent()
        {
            // arrange
            const string inputValue = "Value";
            const string defaultValue = "Default";

            // act
            string returnValue = inputValue.GetValueOrDefault(defaultValue);

            // assert
            returnValue.Should().Be(inputValue);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void StringExtensions_GetValueOrDefault_ShouldReturnDefaultWhenValueIsEmpty()
        {
            // arrange
            string inputValue = string.Empty;
            const string defaultValue = "Default";

            // act
            string returnValue = inputValue.GetValueOrDefault(defaultValue);

            // assert
            returnValue.Should().Be(defaultValue);
        }
    }
}
