namespace Operations.Web.Tests
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using Dtos;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using Services;

    [TestClass]
    public class AvailabilityCheckerServiceTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void AvailabilityCheckerService_GetAvailabilityCheckerServiceNames_ShouldGetAllServiceNames()
        {
            // arrange
            Dictionary<string, Func<Task<AvailabilityCheckResult>>> testCheckerDict = 
                new Dictionary<string, Func<Task<AvailabilityCheckResult>>>
                {
                    {"Service1", () => Task.FromResult(new AvailabilityCheckResult("Service1", true))},
                    {"Service2", () => Task.FromResult(new AvailabilityCheckResult("Service2", false))},
                    {"Service3", () => Task.FromResult(new AvailabilityCheckResult("Service3", true))}
                };

            Mock<ICheckerFactory> checkerFactoryMock = new Mock<ICheckerFactory>();
            checkerFactoryMock.Setup(m => m.GetAvailabilityCheckerDictionary())
                .Returns(testCheckerDict);

            AvailabilityCheckerService service = new AvailabilityCheckerService(checkerFactoryMock.Object);
            
            // act
            var actualServiceNames = service.GetAvailabilityCheckerServiceNames();

            // assert 
            Assert.AreEqual(3, actualServiceNames.Count, "Number of Service Names returned was incorrect");
            Assert.IsTrue(actualServiceNames.Contains("Service1"), "Service1 was not found in Service Names");
            Assert.IsTrue(actualServiceNames.Contains("Service2"), "Service2 was not found in Service Names");
            Assert.IsTrue(actualServiceNames.Contains("Service3"), "Service3 was not found in Service Names");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AvailabilityCheckerService_GetAvailabilityCheckResultForService_ShouldGetIndividualCheckResult()
        {
            // arrange
            string failingDetails = "Service2 404";

            Dictionary<string, Func<Task<AvailabilityCheckResult>>> testCheckerDict =
                new Dictionary<string, Func<Task<AvailabilityCheckResult>>>
                {
                    {"Service1", () => Task.FromResult(new AvailabilityCheckResult("Service1", true))},
                    {"Service2", () => Task.FromResult(new AvailabilityCheckResult("Service2", false) { Details = failingDetails })},
                    {"Service3", () => Task.FromResult(new AvailabilityCheckResult("Service3", true))}
                };

            Mock<ICheckerFactory> checkerFactoryMock = new Mock<ICheckerFactory>();
            checkerFactoryMock.Setup(m => m.GetAvailabilityCheckerDictionary())
                .Returns(testCheckerDict);

            AvailabilityCheckerService service = new AvailabilityCheckerService(checkerFactoryMock.Object);

            // act
            var passingResult = service.GetAvailabilityCheckResultForService("Service1").Result;
            var failingResult = service.GetAvailabilityCheckResultForService("Service2").Result;

            // assert
            Assert.IsTrue(passingResult.IsAvailable, "IsAvailable was incorrect for passing result");
            Assert.IsFalse(failingResult.IsAvailable, "IsAvailable was incorrect for failing result");
            Assert.AreEqual(failingDetails, failingResult.Details, "Failing result details were incorrect");
            Assert.AreEqual("Service1", passingResult.ServiceName, "Passing result Service Name was incorrect");
            Assert.AreEqual("Service2", failingResult.ServiceName, "Failing result Service Name was incorrect");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AvailabilityCheckerService_GetAvailabilityCheckerForService_ShouldReturnNullIfServiceNameIsInvalid()
        {
            Dictionary<string, Func<Task<AvailabilityCheckResult>>> testCheckerDict =
                new Dictionary<string, Func<Task<AvailabilityCheckResult>>>
                {
                    {"Service1", () => Task.FromResult(new AvailabilityCheckResult("Service1", true))},
                    {"Service2", () => Task.FromResult(new AvailabilityCheckResult("Service2", false) { Details = "Service2 has an error"})},
                    {"Service3", () => Task.FromResult(new AvailabilityCheckResult("Service3", true))}
                };

            Mock<ICheckerFactory> checkerFactoryMock = new Mock<ICheckerFactory>();
            checkerFactoryMock.Setup(m => m.GetAvailabilityCheckerDictionary())
                .Returns(testCheckerDict);

            AvailabilityCheckerService service = new AvailabilityCheckerService(checkerFactoryMock.Object);

            // act & assert
            Assert.IsNull(service.GetAvailabilityCheckResultForService("NotARealService").Result, "Did not return null for an invalid service name");
        }
    }
}
