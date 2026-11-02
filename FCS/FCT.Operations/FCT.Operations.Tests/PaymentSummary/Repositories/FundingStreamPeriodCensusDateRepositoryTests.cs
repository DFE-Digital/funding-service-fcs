namespace FCT.Operations.Tests.PaymentSummary.Repositories
{
    using System;
    using System.Data.SqlClient;
    using FluentAssertions;
    using Microsoft.Extensions.Configuration;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Operations.PaymentSummary.Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    [TestClass]
    public class FundingStreamPeriodCensusDateRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingStreamPeriodCensusDateRepository_HaveCensusDatesForPaidFspsPassedForCensusPeriod_ShouldDetermineWhenAllPaidCensusDatesHavePassed()
        {
            // arrange
            var currentTime = new DateTime(2020, 10, 08, 22, 0, 0, DateTimeKind.Utc);
            IConfigurationRoot configuration = AppConfiguration.Configuration();
            var connectionInfo = ConnectionInfo.CreateFrom(new SqlConnection(configuration["ConnectionStrings:NServiceBus/Persistence"]));

            var repository = new FundingStreamPeriodCensusDateRepository();

            // act
            bool haveAllPaidCensusDatesPassedForCensusPeriod = repository.HaveAllPaidCensusDatesPassedForCensusPeriod(currentTime, connectionInfo).Result;

            // assert
            haveAllPaidCensusDatesPassedForCensusPeriod.Should().BeTrue();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingStreamPeriodCensusDateRepository_HaveCensusDatesForPaidFspsPassedForCensusPeriod_ShouldDetermineWhenAllPaidCensusDatesHaveNotPassed()
        {
            // arrange
            var currentTime = new DateTime(2020, 10, 07, 22, 0, 0, DateTimeKind.Utc);
            IConfigurationRoot configuration = AppConfiguration.Configuration();
            var connectionInfo = ConnectionInfo.CreateFrom(new SqlConnection(configuration["ConnectionStrings:NServiceBus/Persistence"]));

            var repository = new FundingStreamPeriodCensusDateRepository();

            // act
            bool haveAllPaidCensusDatesPassedForCensusPeriod = repository.HaveAllPaidCensusDatesPassedForCensusPeriod(currentTime, connectionInfo).Result;

            // assert
            haveAllPaidCensusDatesPassedForCensusPeriod.Should().BeFalse();
        }
    }
}
