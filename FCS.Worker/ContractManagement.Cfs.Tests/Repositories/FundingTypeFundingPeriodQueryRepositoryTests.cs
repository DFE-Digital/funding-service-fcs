namespace ContractManagement.Cfs.Tests.Repositories
{
    using System.Linq;
    using Cfs.Repositories;
    using DataStore;
    using DataStore.Model;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using MoreLinq;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    [TestClass]
    public class FundingTypeFundingPeriodQueryRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingTypeFundingPeriodQueryRepository_ShouldGet()
        {
            // arrange
            const string fundingTypeForTest = "FT";
            const string fundingPeriodForTest = "1819";

            RemoveFundingTypeFundingPeriod(fundingType: fundingTypeForTest, fundingPeriod: fundingPeriodForTest);

            using (var context = new ContractManagementDbContext())
            {
                context.FundingTypeFundingPeriodItems.Add(new FundingTypeFundingPeriod
                {
                    FundingTypeCode = fundingTypeForTest,
                    FundingPeriodName = fundingPeriodForTest
                });

                context.SaveChanges();
            }
            FundingTypeFundingPeriodQueryRepository repository = new FundingTypeFundingPeriodQueryRepository();

            // act
            using (var context = new ContractManagementDbContext())
            {
                FundingTypeFundingPeriod fundingTypeFundingPeriod = repository.Get(new ConnectionInfo(null, context.Database.Connection), fundingTypeForTest,
                    fundingPeriodForTest);

                // assert
                Assert.IsNotNull(fundingTypeFundingPeriod);
            }
        }

        private void RemoveFundingTypeFundingPeriod(string fundingType, string fundingPeriod)
        {
            using (var context = new ContractManagementDbContext())
            {
                context.FundingTypeFundingPeriodItems.Where(f => f.FundingTypeCode == fundingType && f.FundingPeriodName == fundingPeriod)
                    .ForEach(f => context.FundingTypeFundingPeriodItems.Remove(f));

                context.SaveChanges();
            }
        }
    }
}
