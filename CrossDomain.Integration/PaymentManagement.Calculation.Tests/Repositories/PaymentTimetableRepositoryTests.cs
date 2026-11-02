namespace PaymentManagement.Calculation.Tests.Repositories
{
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using PaymentManagement.Calculation.Repositories;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model;
    using System;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    [TestClass]
    public class PaymentTimetableRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void PaymentTimetableRepository_GetFundingStreamPeriodCensusPeriodInfos_ShouldReturnCensusPeriodInfos()
        {
            // arrange
            const string fundingStreamPeriod = "fspCensusPeriodInfo";
            var censusEndDate = new DateTime(2020,01,07, 22,00,00);

            ClearDownFspsFromPolicyFundingStreamCensusDates(fundingStreamPeriod);

            CreatePolicyFundingStreamCensusDateForFsp(fundingStreamPeriod, censusEndDate);
            CreatePolicyFundingStreamCensusDateForFsp(fundingStreamPeriod, censusEndDate.AddMonths(1));
            CreatePolicyFundingStreamCensusDateForFsp(fundingStreamPeriod, censusEndDate.AddMonths(2));

            using (var context = new PaymentManagementPolicyContext())
            {
                var repository = new PaymentTimetableRepository();

                // act
                var assertCensusPeriodInfos = repository.GetFundingStreamPeriodCensusPeriodInfos(fundingStreamPeriod,
                    ConnectionInfo.CreateFrom(context.Database.Connection));

                // assert 
                Assert.AreEqual(3, assertCensusPeriodInfos.Count, "Incorrect number of CensusPeriodInfos returned");

                var assertCensusPeriodInfo = assertCensusPeriodInfos.SingleOrDefault(cpi => cpi.CensusEndDate == censusEndDate);
                Assert.IsNotNull(assertCensusPeriodInfo, "Expected censusPeriodInfo was not returned");
                Assert.AreEqual(202001, assertCensusPeriodInfo.GetPeriod(), "Expected CalendarPeriod was not returned");
            }
            ClearDownFspsFromPolicyFundingStreamCensusDates(fundingStreamPeriod);
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void PaymentTimetableRepository_GetFundingStreamPeriodCensusPeriodInfos_ShouldOnlyCallDatabaseOnce()
        {
            // arrange
            const string fundingStreamPeriod = "fspCensusPeriodInfo";
            var censusEndDate = new DateTime(2020, 01, 07, 22, 00, 00);

            ClearDownFspsFromPolicyFundingStreamCensusDates(fundingStreamPeriod);

            CreatePolicyFundingStreamCensusDateForFsp(fundingStreamPeriod, censusEndDate);
            CreatePolicyFundingStreamCensusDateForFsp(fundingStreamPeriod, censusEndDate.AddMonths(1));
            CreatePolicyFundingStreamCensusDateForFsp(fundingStreamPeriod, censusEndDate.AddMonths(2));

            using (var context = new PaymentManagementPolicyContext())
            {
                var repository = new PaymentTimetableRepository();
                var assertCensusPeriodInfosFirstCall = repository.GetFundingStreamPeriodCensusPeriodInfos(fundingStreamPeriod,
                    ConnectionInfo.CreateFrom(context.Database.Connection));

                // act & assert 
                var assertCensusPeriodInfosSecondCall = repository.GetFundingStreamPeriodCensusPeriodInfos(fundingStreamPeriod,
                    ConnectionInfo.CreateFrom(context.Database.Connection));
            }
            ClearDownFspsFromPolicyFundingStreamCensusDates(fundingStreamPeriod);
        }

        private static void ClearDownFspsFromPolicyFundingStreamCensusDates(string fundingStreamPeriod)
        {
            using (var context = new PaymentManagementPolicyContext())
            {
                context.PolicyFundingStreamCensusDates
                    .Where(pfscd => pfscd.FundingStreamPeriod == fundingStreamPeriod).ToList()
                    .ForEach(pfscd => context.PolicyFundingStreamCensusDates.Remove(pfscd));

                context.SaveChanges();
            }
        }

        private static void CreatePolicyFundingStreamCensusDateForFsp(string fundingStreamPeriod, DateTime censusEndDate)
        {
            using (var context = new PaymentManagementPolicyContext())
            {
                context.PolicyFundingStreamCensusDates.Add(
                    new PolicyFundingStreamCensusDate
                    {
                        FundingStreamPeriod = fundingStreamPeriod,
                        CensusDate = censusEndDate,
                        CalendarYear = censusEndDate.Year,
                        CalendarPeriod = censusEndDate.Month
                    }
                );

                context.SaveChanges();
            }
        }
    }
}