namespace PerformanceManagementDomain.Tests.ReconciliationCalculationEndpoint.Services
{
    using System.Collections.Generic;
    using System.Configuration;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Client;
    using Microsoft.Xrm.Client.Services;
    using Microsoft.Xrm.Sdk;
    using PerformanceManagementDomain.ReconciliationCalculationEndpoint.CrmRepositories;
    using PerformanceManagementDomain.ReconciliationCalculationEndpoint.Services;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.PerformanceManagementDomain.DataStore;
    using UnitTests.Common;

    [TestClass]
    public class FcrRecalculationRequiredChecker_TechnicalExploration
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void FcrRecalculationRequiredChecker_CheckIfRecalculationRequired()
        {
            // arrange
            const string allocationNumber = "AEBL-552";
            const decimal newPlannedValue = 10;
            decimal? existingValue = 13130;

            IReadOnlyCollection<PerformanceManagementDomain.ReconciliationCalculationEndpoint.DTOs.AllocationInfo> allocationsPlannedValue =
                new List<PerformanceManagementDomain.ReconciliationCalculationEndpoint.DTOs.AllocationInfo>
                {
                    new PerformanceManagementDomain.ReconciliationCalculationEndpoint.DTOs.AllocationInfo(allocationNumber, existingValue)
                };

            RecalculationCheckResult result = null;

            using (var context = new PerformanceManagementDbContext())
            {
                FcrRecalculationRequiredChecker checker =
                    new FcrRecalculationRequiredChecker(new CrmFundingClaimReconciliationRepository(GetConnection()));

                ConnectionInfo connectionInfo = new ConnectionInfo(null, context.Database.Connection);

                // act
                result = checker.CheckIfRecalculationRequired(allocationsPlannedValue, allocationNumber, newPlannedValue);
            }

            // assert
            Assert.AreEqual(true, result.IsCalculationRequired, "A Calculation is not required");
        }

        private static IOrganizationService GetConnection()
        {
            var xrmConnection =
                CrmConnection.Parse(ConfigurationManager.ConnectionStrings["CrmConnectionString"].ConnectionString);

            return new OrganizationService(xrmConnection);
        }

        private ContractApprovedEvent GetContractApprovedEventFromFile()
        {
            return TestResource.FromJson<ContractApprovedEvent>(
                "PerformanceManagementDomain.Tests.ReconciliationCalculationEndpoint.TestResources",
                "RecalculateFundingClaimReconciliationCommand.json");
        }
    }
}
