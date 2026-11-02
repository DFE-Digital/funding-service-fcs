namespace SFA.FCT.DocumentsDomain.Integration.DocumentGenEndpoint.Tests.Integration
{
    using System.Linq;
    using DataStore;
    using DataStore.Models;
    using DataStore.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class FundingTypeFundingPeriodRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingTypeFundingPeriodRepository_ShouldGet()
        {
            // arrange
            const string fundingTypeCode = "ft";
            const string fundingPeriod = "fp";
            const bool onlyGenerateFundingAgreementForNewOrUpdatedAllocations = true;

            DeleteFundingTypeFundingPeriod(fundingTypeCode, fundingPeriod);
            using (var context = new DocumentsDomainDbContext())
            {
                context.FundingTypeFundingPeriods.Add(new FundingTypeFundingPeriod(fundingTypeCode, fundingPeriod,
                    onlyGenerateFundingAgreementForNewOrUpdatedAllocations));

                context.SaveChanges();
            }

            // act
            using (var context = new DocumentsDomainDbContext())
            {
                FundingTypeFundingPeriodRepository repository = new FundingTypeFundingPeriodRepository(context);

                var ftfp = repository.Get(fundingTypeCode, fundingPeriod);

                // assert
                Assert.AreEqual(onlyGenerateFundingAgreementForNewOrUpdatedAllocations, ftfp.OnlyGenerateFundingAgreementForNewOrUpdatedAllocations);
            }
            DeleteFundingTypeFundingPeriod(fundingTypeCode, fundingPeriod);
        }

        private void DeleteFundingTypeFundingPeriod(string fundingTypeCode, string fundingPeriod)
        {
            using (var context = new DocumentsDomainDbContext())
            {
                context.FundingTypeFundingPeriods.Where(f => f.FundingTypeCode == fundingTypeCode && f.FundingPeriodName == fundingPeriod)
                    .ToList()
                    .ForEach(f => context.FundingTypeFundingPeriods.Remove(f));

                context.SaveChanges();
            }
        }
    }
}
