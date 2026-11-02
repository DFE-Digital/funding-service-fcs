namespace PerformanceManagement.DataStore.Tests
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.PerformanceManagementDomain.DataStore;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Repositories;

    [TestClass]
    public class FundingStreamPeriodQueryRepositoryTests
    {
        private const string TestFspCode = "TESTCD1920";

        [TestCleanup]
        public void Cleanup()
        {
            using (var context = new PerformanceManagementDbContext())
            {
                var fspToRemove = context.FundingStreamPeriods.Find(TestFspCode);

                if (fspToRemove != null)
                {
                    context.FundingStreamPeriods.Remove(fspToRemove);
                    context.SaveChanges();
                }
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingStreamPeriodQueryRepository_IsFundingStreamPayOnProfile_ShouldReturnTrueForAPayOnProfileFsp()
        {
            // arrange
            Cleanup();
            SetUpTestData(isPoP: true);

            var repository = new FundingStreamPeriodQueryRepository(new PerformanceManagementDbContext());

            // act
            var isTestCodePoP = repository.IsFundingStreamPeriodPayOnProfile(TestFspCode);

            // assert
            Assert.IsTrue(isTestCodePoP);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingStreamPeriodQueryRepository_IsFundingStreamPayOnProfile_ShouldReturnFalseForANonPayOnProfileFsp()
        {
            // arrange
            Cleanup();
            SetUpTestData(isPoP: false);

            var repository = new FundingStreamPeriodQueryRepository(new PerformanceManagementDbContext());

            // act
            var isTestCodePoP = repository.IsFundingStreamPeriodPayOnProfile(TestFspCode);

            // assert
            Assert.IsFalse(isTestCodePoP);
        }

        private void SetUpTestData(bool isPoP)
        {
            using (var context = new PerformanceManagementDbContext())
            {
                context.FundingStreamPeriods.Add(new FundingStreamPeriod(TestFspCode, isPoP));
                context.SaveChanges();
            }
        }
    }
}