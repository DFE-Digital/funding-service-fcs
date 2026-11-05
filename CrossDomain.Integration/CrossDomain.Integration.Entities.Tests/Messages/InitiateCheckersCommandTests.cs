namespace CrossDomain.Integration.Entities.Tests.Messages
{
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;

    [TestClass]
    public class InitiateCheckersCommandTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void CreatePostMonthEndIntegrityChecksCommand_ContainsAllChecks()
        {
            var checks = InitiateCheckersCommand.CreatePostMonthEndIntegrityChecksCommand().ChecksToRun.ToList();

            Assert.AreEqual(7, checks.Count);
            Assert.IsTrue(checks.Contains("PAYCALC_VS_PAYGEN_CHECK"));
            Assert.IsTrue(checks.Contains("DELIVERABLE_PAYMENT_POSITIVE_CAP_CHECKER"));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CreatePostMonthEndImmediateBatchIntegrityChecksCommand_ContainsImmediateChecks()
        {
            var checks = InitiateCheckersCommand.CreatePostMonthEndImmediateBatchIntegrityChecksCommand().ChecksToRun.ToList();

            Assert.AreEqual(4, checks.Count);
            Assert.IsTrue(checks.Contains("ANITA_PAAS_EXTRACT"));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CreatePostMonthEndDelayedBatchIntegrityChecksCommand_ContainsDelayedChecks()
        {
            var checks = InitiateCheckersCommand.CreatePostMonthEndDelayedBatchIntegrityChecksCommand().ChecksToRun.ToList();

            Assert.AreEqual(3, checks.Count);
            Assert.IsTrue(checks.Contains("CRM_TO_PAAS_CHECK_SUBNOMINAL_AGGREGATION"));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CreateNightlyIntegrityChecksCommand_ContainsNightlyCheck()
        {
            var checks = InitiateCheckersCommand.CreateNightlyIntegrityChecksCommand().ChecksToRun.ToList();

            CollectionAssert.AreEqual(new[] { "PAAS_TO_CRM_CHECK_DELIVERABLE_PAYMENT" }, checks);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ImmediateAndDelayedChecks_TogetherCoverPostMonthEndChecks()
        {
            var all = InitiateCheckersCommand.CreatePostMonthEndIntegrityChecksCommand().ChecksToRun;
            var split = InitiateCheckersCommand.CreatePostMonthEndImmediateBatchIntegrityChecksCommand().ChecksToRun
                .Union(InitiateCheckersCommand.CreatePostMonthEndDelayedBatchIntegrityChecksCommand().ChecksToRun);

            CollectionAssert.AreEquivalent(all.ToList(), split.ToList());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ChangeTrackingCurrentVersionOverride_DefaultsToNullAndCanBeSet()
        {
            var command = new InitiateCheckersCommand();
            Assert.IsNull(command.ChangeTrackingCurrentVersionOverride);

            command.ChangeTrackingCurrentVersionOverride = 5;
            Assert.AreEqual(5L, command.ChangeTrackingCurrentVersionOverride);
        }
    }
}
