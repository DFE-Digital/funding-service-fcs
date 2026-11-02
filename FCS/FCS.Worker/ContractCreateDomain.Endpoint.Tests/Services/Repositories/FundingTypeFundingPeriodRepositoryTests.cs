namespace ContractCreateDomain.Endpoint.Tests.Services.Repositories
{
    using System.Linq;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Model;
    using Endpoint.Services.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    [TestClass]
    public class FundingTypeFundingPeriodRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingTypeFundingPeriodRepository_ShouldIncludeAllContractsOnSummaryOfFunding_ShouldReturnTrue()
        {
            // arrange
            const string fundingTypeCode = "ftc_ShouldIncludeAllContractsOnSummaryOfFunding_true";
            const string fundingPeriod = "fp_ShouldIncludeAllContractsOnSummaryOfFunding_true";

            ClearDownFundingTypeFundingPeriod(fundingTypeCode, fundingPeriod);
            CreateFundingTypeFundingPeriod(fundingTypeCode, fundingPeriod, includeAllContractsOnSummaryOfFunding: true);

            using (var context = new ContractManagementDbContext())
            {
                ConnectionInfo connectionInfo = new ConnectionInfo(context.Database.CurrentTransaction?.UnderlyingTransaction, context.Database.Connection);
                var repository = new FundingTypeFundingPeriodRepository();

                // act 
                var includeAllContractsOnSummaryOfFunding = repository.ShouldIncludeAllContractsOnSummaryOfFunding(fundingTypeCode, fundingPeriod, connectionInfo).Result;

                // assert
                Assert.IsTrue(includeAllContractsOnSummaryOfFunding);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingTypeFundingPeriodRepository_ShouldIncludeAllContractsOnSummaryOfFunding_ShouldReturnFalse()
        {
            // arrange
            const string fundingTypeCode = "ftc_ShouldIncludeAllContractsOnSummaryOfFunding_false";
            const string fundingPeriod = "fp_ShouldIncludeAllContractsOnSummaryOfFunding_false";

            ClearDownFundingTypeFundingPeriod(fundingTypeCode, fundingPeriod);
            CreateFundingTypeFundingPeriod(fundingTypeCode, fundingPeriod, includeAllContractsOnSummaryOfFunding: false);

            using (var context = new ContractManagementDbContext())
            {
                ConnectionInfo connectionInfo = new ConnectionInfo(context.Database.CurrentTransaction?.UnderlyingTransaction, context.Database.Connection);
                var repository = new FundingTypeFundingPeriodRepository();

                // act 
                var includeAllContractsOnSummaryOfFunding = 
                    repository.ShouldIncludeAllContractsOnSummaryOfFunding(fundingTypeCode, fundingPeriod, connectionInfo).Result;

                // assert
                Assert.IsFalse(includeAllContractsOnSummaryOfFunding);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingTypeFundingPeriodRepository_ShouldIncludeAllContractsOnSummaryOfFunding_EnsureCacheIsCalled()
        {
            // arrange
            const string fundingTypeCode = "ftc_ShouldIncludeAllContractsOnSummaryOfFunding_checkCache";
            const string fundingPeriod = "fp_ShouldIncludeAllContractsOnSummaryOfFunding_checkCache";

            ClearDownFundingTypeFundingPeriod(fundingTypeCode, fundingPeriod);
            CreateFundingTypeFundingPeriod(fundingTypeCode, fundingPeriod, includeAllContractsOnSummaryOfFunding: true);

            using (var context = new ContractManagementDbContext())
            {
                ConnectionInfo connectionInfo = new ConnectionInfo(context.Database.CurrentTransaction?.UnderlyingTransaction, context.Database.Connection);
                var repository = new FundingTypeFundingPeriodRepository();

                // populate cache
                var result = repository.ShouldIncludeAllContractsOnSummaryOfFunding(fundingTypeCode, fundingPeriod, connectionInfo).Result;
            }

            // change value on database
            ClearDownFundingTypeFundingPeriod(fundingTypeCode, fundingPeriod);
            CreateFundingTypeFundingPeriod(fundingTypeCode, fundingPeriod, includeAllContractsOnSummaryOfFunding: false);

            using (var context = new ContractManagementDbContext())
            {
                ConnectionInfo connectionInfo = new ConnectionInfo(context.Database.CurrentTransaction?.UnderlyingTransaction, context.Database.Connection);
                var repository = new FundingTypeFundingPeriodRepository();

                // act 
                var includeAllContractsOnSummaryOfFunding = repository.ShouldIncludeAllContractsOnSummaryOfFunding(fundingTypeCode, fundingPeriod, connectionInfo).Result;

                // assert
                Assert.IsTrue(includeAllContractsOnSummaryOfFunding, "IncludeAllContractsOnSummaryOfFunding value was not retrieved from the cache");
            }
        }

        private static void ClearDownFundingTypeFundingPeriod(string fundingTypeCode, string fundingPeriod)
        {
            using (var context = new ContractManagementDbContext())
            {
                context.FundingTypeFundingPeriodItems
                    .Where(ftfp => ftfp.FundingTypeCode == fundingTypeCode && ftfp.FundingPeriodName == fundingPeriod).ToList()
                    .ForEach(ftfp => context.FundingTypeFundingPeriodItems.Remove(ftfp));

                context.SaveChanges();
            }
        }

        private static void CreateFundingTypeFundingPeriod(string fundingTypeCode, string fundingPeriod, bool includeAllContractsOnSummaryOfFunding)
        {
            using (var context = new ContractManagementDbContext())
            {
                context.FundingTypeFundingPeriodItems.Add(new FundingTypeFundingPeriod
                {
                    FundingTypeCode = fundingTypeCode,
                    FundingPeriodName = fundingPeriod,
                    IncludeAllContractsOnSummaryOfFunding = includeAllContractsOnSummaryOfFunding
                });

                context.SaveChanges();
            }
        }
    }
}