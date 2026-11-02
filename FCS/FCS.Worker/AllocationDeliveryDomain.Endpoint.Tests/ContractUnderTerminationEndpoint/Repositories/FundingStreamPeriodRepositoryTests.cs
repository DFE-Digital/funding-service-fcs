namespace AllocationDeliveryDomain.Endpoint.Tests.ContractUnderTerminationEndpoint
{
    using System;
    using Endpoint.ContractUnderTerminationEndpoint.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    [TestClass]
    public class FundingStreamPeriodRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingStreamPeriodRepository_GetFsp_ShouldGetFsp()
        {
            // arrange
            const string fspCode = "16-18APPS1718";
            DateTime expectedActivityClosedDate = new DateTime(2019, 07, 05);
            IFundingStreamPeriodRepository fundingStreamPeriodRepository = new FundingStreamPeriodRepository();

            FundingStreamPeriod fsp;
            using (var context = new MonitoringDeliverablesDbContext())
            {
                ConnectionInfo connectionInfo = new ConnectionInfo(null, context.Database.Connection);
                // act
                fsp = fundingStreamPeriodRepository.GetFundingStreamPeriod(connectionInfo, fspCode).Result;
            }

            //asset
            Assert.AreEqual(expectedActivityClosedDate, fsp.ActivityCloseDate, "Incorrect FSP Activity Closed Date was returned");
        }
    }
}
