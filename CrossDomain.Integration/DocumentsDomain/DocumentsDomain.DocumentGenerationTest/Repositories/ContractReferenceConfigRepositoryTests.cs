namespace SFA.FCT.DocumentsDomain.DocumentGeneration.Tests.Repositories
{
    using DataStore;
    using DataStore.Models;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.DocumentsDomain.DocumentGeneration.Repositories;
    using UnitTests.Common;

    [TestClass]
    public class ContractReferenceConfigRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractReferenceConfigRepository_FindByUkprn_WhenEntityExists_ShouldReturnOptionOfSomeWithExpectedEntity()
        {
            // arrange
            const int ukprn = 12345;
            const string fspCode = "fspCode";
            const decimal financialEnvelope1Funding = 1.1m;
            const decimal financialEnvelope2Funding = 2.21m;

            TearDown(ukprn, fspCode);
            using (var context = new DocumentsDomainDbContext())
            {
                context.ContractReferenceConfigs.Add(new ContractReferenceConfig(ukprn, fspCode, financialEnvelope1Funding, financialEnvelope2Funding));
                context.SaveChanges();
            }

            var repository = new ContractReferenceConfigRepository(new DocumentsDomainDbContext());

            // act
            var option = repository.GetContractReferenceConfig(ukprn, fspCode);

            // assert
            option.Match(
                some: entity =>
                {
                    Assert.AreEqual(ukprn, entity.Ukprn);
                    Assert.AreEqual(fspCode, entity.FundingStreamPeriodCode);
                    Assert.AreEqual(financialEnvelope1Funding, entity.FinancialEnvelope1Funding);
                    Assert.AreEqual(financialEnvelope2Funding, entity.FinancialEnvelope2Funding);
                },
                none: () =>
                {
                    Assert.Fail("No value returned");
                });

            TearDown(ukprn, fspCode);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractReferenceConfigRepository_FindByUkprn_WhenEntityDoesNotExists_ShouldReturnOptionOfNone()
        {
            // arrange
            const int ukprn = 12345;
            const string fspCode = "fspCode";

            TearDown(ukprn, fspCode);

            var repository = new ContractReferenceConfigRepository(new DocumentsDomainDbContext());

            // act
            var option = repository.GetContractReferenceConfig(ukprn, fspCode);

            // assert
            option.MatchSome(_ => Assert.Fail("Value returned"));
        }

        public void TearDown(int ukprn, string fspCode)
        {
            using (var context = new DocumentsDomainDbContext())
            {
                context.ContractReferenceConfigs.RemoveWhere(crc =>
                    crc.Ukprn == ukprn && crc.FundingStreamPeriodCode == fspCode);
                context.SaveChanges();
            }
        }
    }
}