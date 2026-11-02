namespace FCT.Operations.Integrity.Tests.Repositories
{
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data.SqlClient;
    using FluentAssertions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.Operations.Integrity.Repositories;

    [TestClass]
    public class OperationsMonitoringDeliverableStoreTests
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void OperationsMonitoringDeliverableStore_GetActiveAllocationDeliverablePeriods_ForOrgs_ShouldReturnData()
        {
            // arrange
            OperationsMonitoringDeliverableStore repository = new OperationsMonitoringDeliverableStore(Mock.Of<ILogger>());
            var connectionString = ConfigurationManager.ConnectionStrings["NServiceBus/Persistence"].ConnectionString;
            SqlConnection connection = new SqlConnection(connectionString);

            // act
            var periods = repository.GetActiveAllocationDeliverablePeriods(
                organisationId: "ORG0017000",
                fundingStreamPeriodCode: "1619ED2021", uopCode: "",
                connectionInfo: ConnectionInfo.CreateFrom(connection));

            periods.Count.Should().Be(0);
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void OperationsMonitoringDeliverableStore_GetActiveAllocationDeliverablePeriods_ForAllocationNumbers_ShouldReturnData()
        {
            // arrange
            OperationsMonitoringDeliverableStore repository = new OperationsMonitoringDeliverableStore(Mock.Of<ILogger>());
            var connectionString = ConfigurationManager.ConnectionStrings["NServiceBus/Persistence"].ConnectionString;
            SqlConnection connection = new SqlConnection(connectionString);

            // act
            var periods = repository.GetActiveAllocationDeliverablePeriods(
                allocationNumbers: new List<string> { "16ED-3004" },
                connectionInfo: ConnectionInfo.CreateFrom(connection));

            periods.Count.Should().Be(0);
        }
    }
}
