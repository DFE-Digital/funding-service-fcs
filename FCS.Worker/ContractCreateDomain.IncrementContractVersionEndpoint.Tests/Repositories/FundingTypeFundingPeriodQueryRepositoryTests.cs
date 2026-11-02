namespace ContractCreateDomain.IncrementContractVersionEndpoint.Tests.Repositories
{
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Model;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using System;
    using FundingTypeFundingPeriodQueryRepository = IncrementContractVersionEndpoint.Repositories.FundingTypeFundingPeriodQueryRepository;

    [TestClass]
    public class FundingTypeFundingPeriodQueryRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingTypeFundingPeriodQueryRepository_Get_ShouldReturnCorrectFundingTypeFundingPeriodForMainstream()
        {
            // arrange 
            const string fundingTypeCode = "AGE";
            const string fundingPeriodName = "FY1516";
            FundingTypeFundingPeriodQueryRepository repository = new FundingTypeFundingPeriodQueryRepository();

            using (var context = new ContractManagementDbContext())
            {
                // act
                var fundingTypeFundingPeriod = repository.Get(fundingTypeCode,
                    fundingPeriodName, new ConnectionInfo(null, context.Database.Connection)).Result;

                // assert
                Assert.IsNotNull(fundingTypeFundingPeriod, "Returned entity is null.");
                Assert.AreEqual(fundingTypeCode, fundingTypeFundingPeriod.FundingTypeCode, "Incorrect FundingTypeCode value returned.");
                Assert.AreEqual(fundingPeriodName, fundingTypeFundingPeriod.FundingPeriodName, "Incorrect FundingPeriodName value returned.");
                Assert.AreEqual(false, fundingTypeFundingPeriod.SkipCaseloadAssignment, "Incorrect SkipCaseloadAssignment value returned.");
                Assert.AreEqual(false, fundingTypeFundingPeriod.SkipReviewAndInternalApproval, "Incorrect SkipReviewAndInternalApproval value returned.");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingTypeFundingPeriodQueryRepository_Get_ShouldReturnCorrectIndividualFundingTypeFundingPeriodsWhenFundingTypeCodeIsSame()
        {
            const string fundingTypeCode = "MAIN";
            const string fundingPeriodName1 = "AY1516";
            const string fundingPeriodName2 = "AY1617";

            FundingTypeFundingPeriodQueryRepository repository = new FundingTypeFundingPeriodQueryRepository();

            using (var context = new ContractManagementDbContext())
            {
                // act
                var fundingTypeFundingPeriod1 = repository.Get(fundingTypeCode, fundingPeriodName1, new ConnectionInfo(null, context.Database.Connection)).Result;
                var fundingTypeFundingPeriod2 = repository.Get(fundingTypeCode, fundingPeriodName2, new ConnectionInfo(null, context.Database.Connection)).Result;

                // assert
                Assert.AreEqual(fundingPeriodName1, fundingTypeFundingPeriod1.FundingPeriodName, "Incorrect FundingPeriodName value returned.");
                Assert.AreEqual(fundingPeriodName2, fundingTypeFundingPeriod2.FundingPeriodName, "Incorrect FundingPeriodName value returned.");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingTypeFundingPeriodQueryRepository_Get_ShouldReturnCorrectFundingTypeFundingPeriodForLevy()
        {
            const string fundingTypeCode = "LEVY";
            const string fundingPeriodName = "LEVY1799";

            FundingTypeFundingPeriodQueryRepository repository = new FundingTypeFundingPeriodQueryRepository();

            using (var context = new ContractManagementDbContext())
            {
                // act
                var fundingTypeFundingPeriod = repository.Get(fundingTypeCode, fundingPeriodName, 
                    new ConnectionInfo(null, context.Database.Connection)).Result;

                // assert
                Assert.IsNotNull(fundingTypeFundingPeriod, "Returned entity is null.");
                Assert.AreEqual(fundingTypeCode, fundingTypeFundingPeriod.FundingTypeCode, "Incorrect FundingTypeCode value returned.");
                Assert.AreEqual(fundingPeriodName, fundingTypeFundingPeriod.FundingPeriodName, "Incorrect FundingPeriodName value returned.");
                Assert.AreEqual(true, fundingTypeFundingPeriod.SkipCaseloadAssignment, "Incorrect SkipCaseloadAssignment value returned.");
                Assert.AreEqual(true, fundingTypeFundingPeriod.SkipReviewAndInternalApproval, "Incorrect SkipReviewAndInternalApproval value returned.");
                Assert.IsTrue(fundingTypeFundingPeriod.DocumentsRequired, "Incorrect DocumentsRequired value returned.");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingTypeFundingPeriodQueryRepository_Get_ShouldReturnSameObjectInstanceWhenCalledTwiceWithSameBusinessKey()
        {
            const string fundingTypeCode = "MAIN";
            const string fundingPeriodName = "AY1516";

            FundingTypeFundingPeriodQueryRepository repository = new FundingTypeFundingPeriodQueryRepository();

            using (var context = new ContractManagementDbContext())
            {
                // act
                var first = repository.Get(fundingTypeCode, fundingPeriodName, new ConnectionInfo(null, context.Database.Connection)).Result;
                var second = repository.Get(fundingTypeCode, fundingPeriodName, new ConnectionInfo(null, context.Database.Connection)).Result;

                // assert
                Assert.AreSame(first, second, "Different object instances were returned from cache.");
            }
        }
        
        [TestMethod, TestCategory("UnitTest")]
        public void FundingTypeFundingPeriod_ShouldReturnTrueWhenDateIsGreaterThanFundingTypePeriodContractActivityDate()
        {
            // arrange
            FundingTypeFundingPeriod fundingTypeFundingPeriod = new FundingTypeFundingPeriod
            {
                ContractingActivityCloseDate = new DateTime(2017, 6, 1, 0, 0, 0, DateTimeKind.Utc)
            };

            // act and assert
            Assert.AreEqual(true, fundingTypeFundingPeriod.IsDateAfterContractActivityClose(new DateTime(2017, 6, 2, 0, 0, 0, DateTimeKind.Utc)));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FundingTypeFundingPeriod_ShouldReturnFalseWhenDateIsLessThanFundingTypePeriodContractActivityDate()
        {
            // arrange
            FundingTypeFundingPeriod fundingTypeFundingPeriod = new FundingTypeFundingPeriod
            {
                ContractingActivityCloseDate = new DateTime(2017, 6, 1, 0, 0, 0, DateTimeKind.Utc)
            };

            // act and assert
            Assert.AreEqual(false, fundingTypeFundingPeriod.IsDateAfterContractActivityClose(new DateTime(2017, 5, 2, 0, 0, 0, DateTimeKind.Utc)));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FundingTypeFundingPeriod_ShouldReturnFalseWhenContractActivityDateIsNotSet()
        {
            // arrange
            var fundingTypeFundingPeriod = new FundingTypeFundingPeriod();

            // act and assert
            Assert.AreEqual(false, fundingTypeFundingPeriod.IsDateAfterContractActivityClose(new DateTime(2017, 5, 2, 0, 0, 0, DateTimeKind.Utc)));
        }
    }
}