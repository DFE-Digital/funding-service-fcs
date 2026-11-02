namespace ContractRequestDomain.Tests
{
    using System;
    using System.Threading.Tasks;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.ContractRequestDomain.Integration.FileWatcher;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class RestrictedPollerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void RestrictedPoller_ShouldNotPollIfNotAllowed()
        {
            // arrange
            bool hasCalledPoll = false;
            void PollTest() => hasCalledPoll = true;
            bool NotAllowed(ConnectionInfo c) => false;

            // act
            RestrictedPoller.StartPolling(PollTest, NotAllowed, ()=> null, timerIntervalSeconds: 1, logger: Mock.Of<ILogger>());

            // assert
            Task.Delay(TimeSpan.FromSeconds(2)).Wait();

            Assert.AreEqual(false, hasCalledPoll);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void RestrictedPoller_ShouldPollIfAllowed()
        {
            // arrange
            bool hasCalledPoll = false;
            void PollTest() => hasCalledPoll = true;
            bool NotAllowed(ConnectionInfo c) => true;

            // act
            RestrictedPoller.StartPolling(PollTest, NotAllowed, () => null, timerIntervalSeconds: 1, logger: Mock.Of<ILogger>());

            // assert
            Task.Delay(TimeSpan.FromSeconds(2)).Wait();

            Assert.AreEqual(true, hasCalledPoll);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void RestrictedPoller_ShouldPollIfAllowed_IntegrationTest()
        {
            // arrange
            bool hasCalledPoll = false;
            void PollTest() => hasCalledPoll = true;
            bool NotAllowed(ConnectionInfo c) => true;

            // act
            RestrictedPoller.StartPolling(PollTest, NotAllowed, ()=> null, timerIntervalSeconds: 1, logger: Mock.Of<ILogger>());

            // assert
            Task.Delay(TimeSpan.FromSeconds(2)).Wait();

            Assert.AreEqual(true, hasCalledPoll);
        }

    }
}
