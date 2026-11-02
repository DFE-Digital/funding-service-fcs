namespace AllocationDeliveryDomain.Endpoint.Tests.Unit
{
    using System;
    using BusinessLogic.Extensions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.CrossDomain.Integration.Common;

    [TestClass]
    public class DateProviderExtensionsTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void DateProviderExtensions_ShouldGetCorrectCurrentPeriod()
        {
            // arrange
            Mock<IDate> dateProviderMock = new Mock<IDate>();
            DateTime testDate = new DateTime(2016, 8, 1);
            dateProviderMock.Setup(dp => dp.GetCalculationDate()).Returns(testDate);
            
            // act
            string currentPeriodString = dateProviderMock.Object.GetCurrentPeriod();

            // assert
            Assert.AreEqual("201607", currentPeriodString);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DateProviderExtensions_ShouldGetCorrectCurrentPeriodWhenWePassInADate()
        {
            // arrange
            Mock<IDate> dateProviderMock = new Mock<IDate>();
            DateTime testDate = new DateTime(2016, 8, 1);
            
            // act
            string currentPeriodString = dateProviderMock.Object.GetCurrentPeriod(testDate);

            // assert
            Assert.AreEqual("201607", currentPeriodString);
        }
    }
}
