namespace FCT.Operations.Integrity.Tests
{
    using System;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.Operations.Integrity.Services;

    [TestClass]
    public class IntegrityCheckResultTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void IntegrityCheckResult_IsChangeTrackingUsedAndNoIssues_ShouldReturnTrueWhen_TrackingOnAndNoIssues()
        {
            // arrange
            IntegrityCheckResult result = new IntegrityCheckResult(foundIssues:false, String.Empty, 1);

            // act
            var isCtAndNoIssues = result.IsChangeTrackingUsedAndNoIssues;

            // assert
            Assert.AreEqual(true, isCtAndNoIssues);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void IntegrityCheckResult_IsChangeTrackingUsedAndNoIssues_ShouldReturnFalseWhen_TrackingOnAndIssues()
        {
            // arrange
            IntegrityCheckResult result = new IntegrityCheckResult(foundIssues: true, String.Empty, 1);

            // act
            var isCtAndNoIssues = result.IsChangeTrackingUsedAndNoIssues;

            // assert
            Assert.AreEqual(false, isCtAndNoIssues);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void IntegrityCheckResult_IsChangeTrackingUsedAndNoIssues_ShouldReturnFalseWhen_TrackingOffAndIssues()
        {
            // arrange
            IntegrityCheckResult result = new IntegrityCheckResult(foundIssues: true, String.Empty);

            // act
            var isCtAndNoIssues = result.IsChangeTrackingUsedAndNoIssues;

            // assert
            Assert.AreEqual(false, isCtAndNoIssues);
        }
    }
}
