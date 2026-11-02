namespace FCT.Operations.Integrity.Tests.Repositories
{
    using System;
    using System.Configuration;
    using System.Data.SqlClient;
    using Dapper;
    using FluentAssertions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.Operations.Integrity.Repositories;

    [TestClass]
    public class OperationsAllocationsUnderTerminationQueryRepositoryTests
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void OperationsAllocationsUnderTerminationQueryRepository_GetTerminationDate_ShouldReturnValue()
        {
            // arrange
            OperationsAllocationsUnderTerminationQueryRepository repository = new OperationsAllocationsUnderTerminationQueryRepository(DbConnection);
            const string allocationNumber = "Some AN";
            DateTime date = DateTime.Now.Date;
            ClearTerminationDateForAllocation(allocationNumber);
            InsertTerminationDateForAllocation(allocationNumber, date);
            // act
            var dateReturned = repository.GetTerminationDate(allocationNumber, null);

            // assert
            dateReturned.Should().Be(date);
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void OperationsAllocationsUnderTerminationQueryRepository_GetTerminationDate_ShouldReturnNull()
        {
            // arrange
            OperationsAllocationsUnderTerminationQueryRepository repository = new OperationsAllocationsUnderTerminationQueryRepository(DbConnection);
            const string allocationNumber = "Some AN";
            
            ClearTerminationDateForAllocation(allocationNumber);
            // act
            var dateReturned = repository.GetTerminationDate(allocationNumber, null);

            // assert
            dateReturned.Should().BeNull();
        }

        private void ClearTerminationDateForAllocation(string allocationNumber)
        {
            const string sql = @"delete
                                 from [MonitoringDeliverables].[AllocationUnderTermination]
                                 where ContractAllocationNumber = @allocationNumber";

            DbConnection.Execute(sql, param: new { allocationNumber });
        }

        private void InsertTerminationDateForAllocation(string allocationNumber, DateTime date)
        {
            const string sql = @"Insert into
                                 [MonitoringDeliverables].[AllocationUnderTermination]
                                 ([ContractAllocationNumber]
                                 ,[TerminationDate]
                                 ,[ContractNumber])
                                 values
                                 (@allocationNumber, @date, 'Test')";

            DbConnection.Execute(sql, param: new { allocationNumber, date });
        }

        private SqlConnection DbConnection => new SqlConnection(ConfigurationManager.ConnectionStrings["NServiceBus/Persistence"].ConnectionString);
    }
}
