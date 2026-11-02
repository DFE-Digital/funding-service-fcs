namespace ContractRequestDomain.EngagementWatcher.Tests.Services
{
    using System.Collections.Generic;
    using System.Linq;
    using ContractManagement.DataStore.Model;
    using ContractRequestDomain.EngagementWatcher.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class EngagementEventValidatorTests
    {
        private const string DasRsr001Message = "UKPRN is not specified";
        private const string DasRsr002Message = "UKPRN is not valid";

        [TestMethod, TestCategory("UnitTest")]
        public void EngagementEventValidator_GetValidationFailures_UkprnAbsent_ShouldReturnFailureWithCorrespondingId()
        {
            // arrange
			var events = new List<EngagementEvent>
			{
			    new EngagementEvent(1, "INITIATED", null)
            };

            var expectedMessage = $"{DasRsr001Message} for DAS Engagement Event ID {events[0].EventId}";

            // act 
            EngagementEventValidator.Validate(events);

            // assert
			Assert.AreEqual(1, events.Count(e => !e.IsValid), "The is an incorrect number of validation errors");
            Assert.AreEqual(expectedMessage, events[0].ValidationError, "The error message is not correct");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void EngagementEventValidator_GetValidationFailures_UkprnNotAnInteger_ShouldReturnFailureWithCorrespondingId()
        {
            // arrange
            var events = new List<EngagementEvent>
            {
                new EngagementEvent(1, "INITIATED", "abc123")
            };

            var expectedMessage = $"{DasRsr002Message} for DAS Engagement Event ID {events[0].EventId}";

            // act 
            EngagementEventValidator.Validate(events);

            // assert
            Assert.AreEqual(1, events.Count(e => !e.IsValid));
            Assert.AreEqual(expectedMessage, events[0].ValidationError);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void EngagementEventValidator_GetValidationFailures_MultipleFailures_ShouldOnlyReturnFailingItems()
        {
            // arrange
            var events = new List<EngagementEvent>
            {
                new EngagementEvent(1, "INITIATED", "abc123"),
				new EngagementEvent(2, "INITIATED", null),
                new EngagementEvent(3, "INITIATED", "0"),
                new EngagementEvent(2, "INITIATED", "10002748")
            };

            // act 
            EngagementEventValidator.Validate(events);

            // assert
            Assert.AreEqual(2, events.Count(e=>  !e.IsValid));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void EngagementEventValidator_GetValidationFailures_NoFailures_ShouldReturnEmptyCollection()
        {
            // arrange
            var events = new List<EngagementEvent>
            {
                new EngagementEvent(1, "INITIATED", "12345678"),
                new EngagementEvent(2, "INITIATED", "87654321"),
                new EngagementEvent(3, "INITIATED", "0"),
                new EngagementEvent(2, "INITIATED", "10002748")
            };

            // act 
            EngagementEventValidator.Validate(events);

            // assert
            Assert.AreEqual(0, events.Count(e => !e.IsValid));
        }
    }
}