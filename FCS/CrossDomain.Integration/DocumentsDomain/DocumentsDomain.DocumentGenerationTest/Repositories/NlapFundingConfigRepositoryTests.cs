namespace SFA.FCT.DocumentsDomain.DocumentGeneration.Tests.Repositories
{
    using DataStore;
    using DataStore.Models;
    using DataStore.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Optional;
    using UnitTests.Common;

    [TestClass]
    public class NlapFundingConfigRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void NlapFundingConfigRepository_FindByUkprn_WhenEntityExists_ShouldReturnOptionOfSomeWithExpectedEntity()
        {
            const int ukprn = 12345;

            // arrange
            using (DocumentsDomainDbContext context = new DocumentsDomainDbContext())
            {
                context.NlapFundingConfigs.RemoveWhere(n => n.Ukprn == ukprn);
                context.NlapFundingConfigs.Add(new NlapFundingConfig(ukprn, 1, 2, 3, 4));
                context.SaveChanges();
            }

            NlapFundingConfigRepository repository = new NlapFundingConfigRepository(new DocumentsDomainDbContext());

            // act
            Option<NlapFundingConfig> option = repository.FindByUkprn(ukprn);

            // assert
            option.Match(
                some: entity =>
                {
                    Assert.AreEqual(ukprn, entity.Ukprn);
                    Assert.AreEqual(1m, entity.NewStarts2021Funding1618);
                    Assert.AreEqual(2m, entity.NewStarts2021FundingAdult);
                    Assert.AreEqual(3m, entity.NewStartsEstimatedFutureFunding1618);
                    Assert.AreEqual(4m, entity.NewStartsEstimatedFutureFundingAdult);
                },
                none: () => 
                {
                    Assert.Fail("No value returned");
                });
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void NlapFundingConfigRepository_FindByUkprn_WhenEntityDoesNotExists_ShouldReturnOptionOfNone()
        {
            const int ukprn = 12345;

            // arrange
            using (DocumentsDomainDbContext context = new DocumentsDomainDbContext())
            {
                context.NlapFundingConfigs.RemoveWhere(n => n.Ukprn == ukprn);
                context.SaveChanges();
            }

            NlapFundingConfigRepository repository = new NlapFundingConfigRepository(new DocumentsDomainDbContext());

            // act
            Option<NlapFundingConfig> option = repository.FindByUkprn(ukprn);

            // assert
            option.MatchSome(_ => Assert.Fail("Value returned"));
        }
    }
}
