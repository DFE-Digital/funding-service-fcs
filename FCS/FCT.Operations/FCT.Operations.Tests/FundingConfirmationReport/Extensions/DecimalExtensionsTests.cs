namespace FCT.Operations.Tests.FundingConfirmationReport.Extensions
{
    using System.Collections.Generic;
    using FluentAssertions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Operations.FundingConfirmationReport.Extensions;

    [TestClass]
    public class DecimalExtensionsTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void DecimalExtensions_ShouldRoundToNearestPound()
        {
            // arrange
            List<(decimal val, decimal roundedVal)> inputsAndResult = new List<(decimal val, decimal roundedVal)>
            {
                (10.50M, 11M),
                (10.49M, 10M)
            };

            inputsAndResult.ForEach(i =>
            {
                // act and assert
                i.val.RoundToNearestPound().Should().Be(i.roundedVal);
            });
        }
    }
}
