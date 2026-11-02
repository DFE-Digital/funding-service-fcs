namespace FCT.Operations.Integrity.Tests.Repositories
{
    using System.Linq;
    using System.Configuration;
    using System.Data.SqlClient;
    using FluentAssertions;
    using Dapper;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.Operations.Integrity.Repositories;

    [TestClass]
    public class AllocationDeliverablePeriodRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void AllocationDeliverablePeriodRepository_GetActiveAllocationDeliverablePeriods_ShouldGetAllocationDeliverablePeriod()
        {
            // arrange 
            const string organisationId = "orgId";
            const string fundingStreamPeriodCode = "fspCode";
            const string uopCode = "";

            ClearAllocationDeliverablePeriodTable();
            AddAllocationDeliverablePeriod(organisationId, fundingStreamPeriodCode, uopCode, 1);
            AddAllocationDeliverablePeriod(organisationId, fundingStreamPeriodCode, uopCode, 2);

            var repository = new AllocationDeliverablePeriodRepository(new SqlConnection(ConfigurationManager.ConnectionStrings["MonitoringDeliverablesDbContext"].ConnectionString));

            // act
            var allocationDeliverablePeriods = repository.GetActiveAllocationDeliverablePeriods(organisationId, fundingStreamPeriodCode, uopCode);

            // assert
            allocationDeliverablePeriods.Count.Should().Be(2);
            var firstAllocationDeliverablePeriods = allocationDeliverablePeriods.First();
            firstAllocationDeliverablePeriods.OrganisationId.Should().Be(organisationId);
            firstAllocationDeliverablePeriods.FundingStreamPeriodCode.Should().Be(fundingStreamPeriodCode);
            firstAllocationDeliverablePeriods.UopCode.Should().Be(uopCode);
        }

        private void ClearAllocationDeliverablePeriodTable()
        {
            var connectionString = ConfigurationManager.ConnectionStrings["MonitoringDeliverablesDbContext"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                const string sql = @"DELETE FROM [MonitoringDeliverables].[AllocationDeliverablePeriod]";
                connection.Execute(sql);
            }
        }

        public void AddAllocationDeliverablePeriod(string organisationId, string fundingStreamPeriodCode, string uopCode, int deliverableCode)
        {
            var connectionString = ConfigurationManager.ConnectionStrings["MonitoringDeliverablesDbContext"].ConnectionString;

            const string sql = @"INSERT INTO [MonitoringDeliverables].[AllocationDeliverablePeriod]
                                               ([OrganisationId]
                                               ,[FundingStreamPeriodCode]
                                               ,[UopCode]
                                               ,[DeliverableCode]
                                               ,[Period]
                                               ,[ContractAllocationNumber]
                                               ,[ContractNumber]
                                               ,[ContractVersionNumber]
                                               ,[ContractSubVersionNumber]
                                               ,[AllocationStartDate]
                                               ,[AllocationEndDate]
                                               ,[Ukprn]
                                               ,[CreatedDate])
                                         VALUES
                                               (@organisationId
                                               ,@fundingStreamPeriodCode
                                               ,@uopCode
                                               ,@deliverableCode
                                               ,'201508','ALLOCATION-001','CONTRACT-001',1,0,'01-Nov-2021','01-Nov-2021',12345678,'01-Nov-2021')";

            using (var connection = new SqlConnection(connectionString))
            {
                connection.Execute(sql, new { organisationId, fundingStreamPeriodCode, uopCode, deliverableCode });
            }
        }

    }
}