namespace WorkerRole.Tests
{
    using System;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus.Pipeline;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class CustomErrorHandlingBehaviorTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void CustomErrorHandlingBehavior_ShouldLogExpectedErrorMessage()
        {
            string loggedErrorMessage = null;

            // arrange
            Mock<ILogger> loggerMock = new Mock<ILogger>();
            loggerMock
                .Setup(m => m.LogError(It.IsAny<int>(), It.IsAny<string>(), It.IsAny<object[]>()))
                .Callback((int id, string errorMessage, object[] parameters) => { loggedErrorMessage = errorMessage; });

            CustomErrorHandlingBehavior behavior = new CustomErrorHandlingBehavior(loggerMock.Object);

            Exception exceptionToThrow = new Exception("Outer exception", new Exception("Inner exception"));
            
            // act
            try
            {
                behavior.Invoke(Mock.Of<ITransportReceiveContext>(), () => throw exceptionToThrow).Wait();
            }
            catch (Exception)
            {
                // as expected
            }

            // assert
            Assert.IsTrue(loggedErrorMessage.Contains("Exception caught by NSB 7: Error: Outer exception"), "Outer exception was not logged");
            Assert.IsTrue(loggedErrorMessage.Contains("Error: Inner exception"), "Inner exception was not logged");
        }
    }
}
