namespace ContractRequestDomain.DataStore.Tests
{
    using System;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using MoreLinq;
    using SFA.FCT.ContractRequestDomain.DataStore;
    using SFA.FCT.ContractRequestDomain.DataStore.Model;
    using SFA.FCT.ContractRequestDomain.DataStore.Repositories;

    [TestClass]
    public class FundingTypeFundingPeriodRepositoryTests
    { 
        private readonly DateTime _expectedDate = new DateTime(2018, 5, 1);

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingTypeFundingPeriodRepository_GetActivityCloseDate_ReturnsCorrectDate()
        {
            const string fundingTypeCode = "TESTCODE";
            const string fundingPeriodCode = "TEST1516";

            // arrange
            RemoveFundingTypePeriod(fundingTypeCode: fundingTypeCode, fundingPeriodName: fundingPeriodCode);

            using (var context = new ContractRequestDbContext())
            {
                context.FundingTypeFundingPeriods.Add(
                    new FundingTypeFundingPeriod(fundingTypeCode, fundingPeriodCode, _expectedDate, isAllowedToHaveDeliveryOrg: false));

                context.SaveChanges();
            }

            using (var context = new ContractRequestDbContext())
            {
                var repository = new FundingTypeFundingPeriodRepository(context);

                // act
                var actualDate = repository.GetActivityCloseDate(fundingTypeCode, fundingPeriodCode);

                // assert
                Assert.AreEqual(_expectedDate, actualDate);
            }
            RemoveFundingTypePeriod(fundingTypeCode: fundingTypeCode, fundingPeriodName: fundingPeriodCode);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingTypeFundingPeriodRepository_GetActivityCloseDate_ReturnsCorrectNull()
        {
            const string fundingTypeCode = "TESTCODE";
            const string fundingPeriodCode = "TEST1516";

            // arrange
            RemoveFundingTypePeriod(fundingTypeCode: fundingTypeCode, fundingPeriodName: fundingPeriodCode);

            using (var context = new ContractRequestDbContext())
            {
                context.FundingTypeFundingPeriods.Add(
                    new FundingTypeFundingPeriod(fundingTypeCode, fundingPeriodCode, null, isAllowedToHaveDeliveryOrg: false));

                context.SaveChanges();
            }

            using (var context = new ContractRequestDbContext())
            {
                var repository = new FundingTypeFundingPeriodRepository(context);

                // act
                var actualDate = repository.GetActivityCloseDate(fundingTypeCode, fundingPeriodCode);

                // assert
                Assert.IsNull(actualDate);
            }
            RemoveFundingTypePeriod(fundingTypeCode: fundingTypeCode, fundingPeriodName: fundingPeriodCode);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingTypeFundingPeriodRepository_IsFundingTypeFundingPeriodAllowedToHaveDeliveryOrg_ShouldReturnTrue_WhenAllowedToHaveDeliveryOrg()
        {
            const string fundingTypeCode = "TESTCODE";
            const string fundingPeriodCode = "TEST1516";

            // arrange
            RemoveFundingTypePeriod(fundingTypeCode: fundingTypeCode, fundingPeriodName: fundingPeriodCode);

            using (var context = new ContractRequestDbContext())
            {
                context.FundingTypeFundingPeriods.Add(
                    new FundingTypeFundingPeriod(fundingTypeCode, fundingPeriodCode, null, isAllowedToHaveDeliveryOrg: true));

                context.SaveChanges();
            }

            using (var context = new ContractRequestDbContext())
            {
                var repository = new FundingTypeFundingPeriodRepository(context);

                // act
                bool isAllowedToHaveDeliveryOrg = repository.IsFundingTypeFundingPeriodAllowedToHaveDeliveryOrg(fundingTypeCode, fundingPeriodCode);

                // assert
                Assert.IsTrue(isAllowedToHaveDeliveryOrg);
            }
            RemoveFundingTypePeriod(fundingTypeCode: fundingTypeCode, fundingPeriodName: fundingPeriodCode);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingTypeFundingPeriodRepository_IsFundingTypeFundingPeriodAllowedToHaveDeliveryOrg_ShouldReturnFalse_WhenNotAllowedToHaveDeliveryOrg()
        {
            const string fundingTypeCode = "TESTCODE";
            const string fundingPeriodCode = "TEST1516";

            // arrange
            RemoveFundingTypePeriod(fundingTypeCode: fundingTypeCode, fundingPeriodName: fundingPeriodCode);

            using (var context = new ContractRequestDbContext())
            {
                context.FundingTypeFundingPeriods.Add(
                    new FundingTypeFundingPeriod(fundingTypeCode, fundingPeriodCode, null, isAllowedToHaveDeliveryOrg: false));

                context.SaveChanges();
            }

            using (var context = new ContractRequestDbContext())
            {
                var repository = new FundingTypeFundingPeriodRepository(context);

                // act
                bool isAllowedToHaveDeliveryOrg = repository.IsFundingTypeFundingPeriodAllowedToHaveDeliveryOrg(fundingTypeCode, fundingPeriodCode);

                // assert
                Assert.IsFalse(isAllowedToHaveDeliveryOrg);
            }
            RemoveFundingTypePeriod(fundingTypeCode: fundingTypeCode, fundingPeriodName: fundingPeriodCode);
        }

        private static void RemoveFundingTypePeriod(string fundingTypeCode, string fundingPeriodName)
        {
            using (var context = new ContractRequestDbContext())
            {

                context.FundingTypeFundingPeriods.Where(
                    ftfp =>
                        ftfp.FundingPeriodName == fundingPeriodName && ftfp.FundingTypeCode == fundingTypeCode)
                    .ForEach(ftfp => context.FundingTypeFundingPeriods.Remove(ftfp));

                context.SaveChanges();
            }
        }
    }
}
