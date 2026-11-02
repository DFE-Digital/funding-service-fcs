namespace PerformanceManagementDomain.Tests.ReconciliationCalculationEndpoint.Services
{
    using UnitTests.Common;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using PerformanceManagementDomain.ReconciliationCalculationEndpoint.Repositories;
    using PerformanceManagementDomain.ReconciliationCalculationEndpoint.Services;
    using SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaim;
    using SFA.FCT.PerformanceManagementDomain.DataStore;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    [TestClass]
    public class CalculationServiceIntegrationTests
    {
        [TestMethod, TestCategory("DataDependent")]
        public void CalculationService_ShouldCalculate()
        {
            // arrange
            DebatchedFundingClaim debatchedFundingClaim = GetDebatchedFundingClaim();

            using (var policyContext = new PaymentManagementPolicyContext())
            using (var context = new PerformanceManagementDbContext())
            {
                CalculationService calculationService = new CalculationService(
                    new ClaimReconciliationBehaviourRepository(),
                    new FspDeliverableClaimRepository(),
                    new ContractAllocationRepository(),
                    new ClaimReconciliationAllocationGroupRepository(),
                    new ClaimTypeRepository(),
                    new DeliverableGroupAmountSummaryCreator(new ClaimReferenceProfileRepository()));

                var connectionInfo = new ConnectionInfo(null, context.Database.Connection);

                FundingClaimEnrichmentService fundingClaimEnrichmentService =
                    new FundingClaimEnrichmentService(new ContractAllocationDeliverableRepository(),
                        new PolicyDeliverableRepository(),
                        new FspDeliverableClaimRepository(),
                        new ParentDeliverableResolver());

                fundingClaimEnrichmentService.Enrich(debatchedFundingClaim, connectionInfo).Wait();

                // act
                var result = calculationService.Calculate(debatchedFundingClaim, connectionInfo).Result;
            }
        }

        private DebatchedFundingClaim GetDebatchedFundingClaim()
        {
            return TestResource.FromJson<DebatchedFundingClaim>("PerformanceManagementDomain.Tests.ReconciliationCalculationEndpoint.TestResources",
                "DebatchedFundingClaim.json");
        }
    }
}