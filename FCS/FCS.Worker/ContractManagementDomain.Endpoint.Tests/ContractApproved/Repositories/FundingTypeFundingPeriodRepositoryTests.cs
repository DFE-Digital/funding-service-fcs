namespace ContractManagementDomain.Endpoint.Tests.ContractApproved.Repositories
{
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Model;
    using Endpoint.ContractApproved.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    [TestClass]
    public class FundingTypeFundingPeriodRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingTypeFundingPeriodQueryRepository_Get_ShouldReturnCorrectFundingTypeFundingPeriodForMainstream()
        {
            const string fundingTypeCode = "AGE";
            const string fundingPeriodName = "FY1516";

            // arrange
            ContractManagementDbContext context = new ContractManagementDbContext();
            ConnectionInfo connectionInfo = new ConnectionInfo(null, context.Database.Connection);
            FundingTypeFundingPeriodRepository fundingTypeFundingPeriodRepository = new FundingTypeFundingPeriodRepository();

            // act
            FundingTypeFundingPeriod fundingTypeFundingPeriod = fundingTypeFundingPeriodRepository.Get(fundingTypeCode, fundingPeriodName, connectionInfo).Result;

            // assert
            Assert.IsNotNull(fundingTypeFundingPeriod, "Returned entity is null.");
            Assert.AreEqual(fundingTypeCode, fundingTypeFundingPeriod.FundingTypeCode, "Incorrect FundingTypeCode value returned.");
            Assert.AreEqual(fundingPeriodName, fundingTypeFundingPeriod.FundingPeriodName, "Incorrect FundingPeriodName value returned.");
            Assert.AreEqual(false, fundingTypeFundingPeriod.SkipCaseloadAssignment, "Incorrect SkipCaseloadAssignment value returned.");
            Assert.AreEqual(false, fundingTypeFundingPeriod.SkipReviewAndInternalApproval, "Incorrect SkipReviewAndInternalApproval value returned.");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingTypeFundingPeriodQueryRepository_Get_ShouldReturnCorrectIndividualFundingTypeFundingPeriodsWhenFundingTypeCodeIsSame()
        {
            const string fundingTypeCode = "MAIN";
            const string fundingPeriodName1 = "AY1516";
            const string fundingPeriodName2 = "AY1617";

            // arrange
            ContractManagementDbContext context = new ContractManagementDbContext();
            ConnectionInfo connectionInfo = new ConnectionInfo(null, context.Database.Connection);
            FundingTypeFundingPeriodRepository fundingTypeFundingPeriodRepository = new FundingTypeFundingPeriodRepository();

            // act
            FundingTypeFundingPeriod fundingTypeFundingPeriod1 = fundingTypeFundingPeriodRepository.Get(fundingTypeCode, fundingPeriodName1, connectionInfo).Result;
            FundingTypeFundingPeriod fundingTypeFundingPeriod2 = fundingTypeFundingPeriodRepository.Get(fundingTypeCode, fundingPeriodName2, connectionInfo).Result;

            // assert
            Assert.AreEqual(fundingPeriodName1, fundingTypeFundingPeriod1.FundingPeriodName, "Incorrect FundingPeriodName value returned.");
            Assert.AreEqual(fundingPeriodName2, fundingTypeFundingPeriod2.FundingPeriodName, "Incorrect FundingPeriodName value returned.");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingTypeFundingPeriodQueryRepository_Get_ShouldReturnCorrectFundingTypeFundingPeriodForLevy()
        {
            const string fundingTypeCode = "LEVY";
            const string fundingPeriodName = "LEVY1799";

            // arrange
            ContractManagementDbContext context = new ContractManagementDbContext();
            ConnectionInfo connectionInfo = new ConnectionInfo(null, context.Database.Connection);
            FundingTypeFundingPeriodRepository fundingTypeFundingPeriodRepository = new FundingTypeFundingPeriodRepository();

            // act
            FundingTypeFundingPeriod fundingTypeFundingPeriod = fundingTypeFundingPeriodRepository.Get(fundingTypeCode, fundingPeriodName, connectionInfo).Result;

            // assert
            Assert.IsNotNull(fundingTypeFundingPeriod, "Returned entity is null.");
            Assert.AreEqual(fundingTypeCode, fundingTypeFundingPeriod.FundingTypeCode, "Incorrect FundingTypeCode value returned.");
            Assert.AreEqual(fundingPeriodName, fundingTypeFundingPeriod.FundingPeriodName, "Incorrect FundingPeriodName value returned.");
            Assert.AreEqual(true, fundingTypeFundingPeriod.SkipCaseloadAssignment, "Incorrect SkipCaseloadAssignment value returned.");
            Assert.AreEqual(true, fundingTypeFundingPeriod.SkipReviewAndInternalApproval, "Incorrect SkipReviewAndInternalApproval value returned.");
            Assert.IsTrue(fundingTypeFundingPeriod.DocumentsRequired, "Incorrect DocumentsRequired value returned.");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingTypeFundingPeriodQueryRepository_Get_ShouldReturnNullWhenInvalidFundingTypeFundingPeriodRequested()
        {
            const string fundingTypeCode = "INVALID";
            const string fundingPeriodName = "INVALID1516";

            // arrange
            ContractManagementDbContext context = new ContractManagementDbContext();
            ConnectionInfo connectionInfo = new ConnectionInfo(null, context.Database.Connection);
            FundingTypeFundingPeriodRepository fundingTypeFundingPeriodRepository = new FundingTypeFundingPeriodRepository();

            // act
            FundingTypeFundingPeriod fundingTypeFundingPeriod = fundingTypeFundingPeriodRepository.Get(fundingTypeCode, fundingPeriodName, connectionInfo).Result;

            // assert
            Assert.IsNull(fundingTypeFundingPeriod, "Returned entity is not null.");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingTypeFundingPeriodQueryRepository_Get_ShouldReturnSameObjectInstanceWhenCalledTwiceWithSameBusinessKey()
        {
            const string fundingTypeCode = "MAIN";
            const string fundingPeriodName = "AY1516";

            // arrange
            ContractManagementDbContext context = new ContractManagementDbContext();
            ConnectionInfo connectionInfo = new ConnectionInfo(null, context.Database.Connection);
            FundingTypeFundingPeriodRepository fundingTypeFundingPeriodRepository = new FundingTypeFundingPeriodRepository();

            // act
            FundingTypeFundingPeriod first = fundingTypeFundingPeriodRepository.Get(fundingTypeCode, fundingPeriodName, connectionInfo).Result;
            FundingTypeFundingPeriod second = fundingTypeFundingPeriodRepository.Get(fundingTypeCode, fundingPeriodName, connectionInfo).Result;

            // assert
            Assert.AreSame(first, second, "Different object instances were returned from cache.");
        }
    }
}
