namespace ContractCreateDomain.Endpoint.Tests.AmendContract
{
    using System.Linq;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Model;
    using Endpoint.Infrastructure;
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
                FundingTypeFundingPeriod fundingTypeFundingPeriod = repository.Get( fundingTypeForTest,
                    fundingPeriodForTest, new ConnectionInfo(null, context.Database.Connection));

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
