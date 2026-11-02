namespace SFA.FCT.DocumentsDomain.DocumentGeneration.Tests
{
    using System;
    using DataStore.Models;
    using DocumentDefiner.DocumentConfiguration;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using FundingStreamPeriod = DataStore.Models.FundingStreamPeriod;

    [TestClass]
    public class DocumentConfigurationCacheTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void DocumentConfigurationCache_ShouldOnlyCallGetFundingStreamPeriodDelegateOnceForAGivenKey()
        {
            // arrange
            const string testFspKey = "TESTCODE";
            int countOfCalls = 0;

            FundingStreamPeriod fspToGet = new FundingStreamPeriod(testFspKey, string.Empty, 0, false, false, string.Empty, string.Empty, string.Empty, string.Empty);

            Func<string, FundingStreamPeriod> getFspDelegate = s =>
            {
                countOfCalls++;
                return fspToGet;
            };

            // act
            FundingStreamPeriod firstFsp = DocumentConfigurationCache.GetFundingStreamPeriod(testFspKey, getFspDelegate);
            DocumentConfigurationCache.GetFundingStreamPeriod(testFspKey, getFspDelegate);
            DocumentConfigurationCache.GetFundingStreamPeriod(testFspKey, getFspDelegate);
            FundingStreamPeriod lastFsp = DocumentConfigurationCache.GetFundingStreamPeriod(testFspKey, getFspDelegate);

            // assert
            Assert.AreEqual(1, countOfCalls, "The value was not cached");

            // since we are returning the same object, reference equals is fine
            Assert.AreEqual(firstFsp, lastFsp, "Calls did not return the same object");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DocumentConfigurationCache_ShouldOnlyCallGetFundingStreamPeriodDeliverableDelegateOnceForAGivenKey()
        {
            // arrange
            FspDeliverableKey fspDeliverableKey = new FspDeliverableKey("TESTCODE", 1);
            int countOfCalls = 0;

            FSPDeliverable fspDeliverableToGet = new FSPDeliverable(1, "ABC123", false, false, false, 1, false, false,
                false, string.Empty, string.Empty, false);

            Func<FspDeliverableKey, FSPDeliverable> getFspDeliverable = s =>
            {
                countOfCalls++;
                return fspDeliverableToGet;
            };

            // act
            FSPDeliverable firstFspDeliverable =
                DocumentConfigurationCache.GetFspDeliverable(fspDeliverableKey, getFspDeliverable);
            DocumentConfigurationCache.GetFspDeliverable(fspDeliverableKey, getFspDeliverable);
            DocumentConfigurationCache.GetFspDeliverable(fspDeliverableKey, getFspDeliverable);
            FSPDeliverable lastFspDeliverable =
                DocumentConfigurationCache.GetFspDeliverable(fspDeliverableKey, getFspDeliverable);

            // assert
            Assert.AreEqual(1, countOfCalls, "The value was not cached");

            // since we are returning the same object, reference equals is fine
            Assert.AreEqual(firstFspDeliverable, lastFspDeliverable, "Calls did not return the same object");
        }
    }
}