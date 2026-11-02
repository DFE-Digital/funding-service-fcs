namespace FundingAllocation.Tests.Infrastructure
{
    using System;
    using System.Threading.Tasks;
    using FundingAllocation.Infrastructure;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class UnhandledErrorLoggerTests
    {

        [TestMethod, TestCategory("UnitTest")]
        public void UnhandledActionErrorLogger_ShouldLogErrors()
        {
            // Arrange
            const string expectedError = "expectedError";

            var logger = new Mock<ILogger>();

            Func<bool> errorRaiser = () => throw new ArgumentException();

            // Act
            try
            {
                Task.Factory.StartNew(errorRaiser)
                    .CatchLogRethrowAsync(logger.Object, () =>expectedError).Wait();

                // Assert
                Assert.Fail("Exception should have been thrown after logging");
            }
            catch
            {
                logger.Verify(l => l.LogInformation(It.IsAny<int>(), expectedError, It.IsAny<object[]>()));
            }
        }
    }
}
