namespace PerformanceManagementDomain.Tests.ReconciliationCalculationEndpoint.Repositories
{
    using System.Collections.Generic;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using PerformanceManagementDomain.ReconciliationCalculationEndpoint.Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model;

    [TestClass]
    public class PolicyDeliverableRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void PolicyDeliverableRepository_GetPolicyDeliverables_ShouldGetAllPolicyDeliverablesForFspUsingTheUnderlyingCacheCorrectly()
        {
            // arrange
            PaymentManagementPolicyContext context = new PaymentManagementPolicyContext();
            ConnectionInfo paymentManagementPolicyConnectionInfo = new ConnectionInfo(null, context.Database.Connection);
            PolicyDeliverableRepository policyDeliverableRepository = new PolicyDeliverableRepository();
            string fundingStreamPeriodCodeFirst = "AEBC1819";
            string fundingStreamPeriodCodeSecond = "1619LR1819";

            // act 1
            IReadOnlyCollection<PolicyDeliverable> policyDeliverablesFirst 
                = policyDeliverableRepository.GetPolicyDeliverables(fundingStreamPeriodCodeFirst, paymentManagementPolicyConnectionInfo).Result;

            // assert 1
            Assert.IsNotNull(policyDeliverablesFirst, $"Unexpected null result returned for {fundingStreamPeriodCodeFirst}");
            Assert.AreEqual(12, policyDeliverablesFirst.Count, $"Unexpected number of policy deliverables returned for {fundingStreamPeriodCodeFirst}");

            // act 2
            IReadOnlyCollection<PolicyDeliverable> policyDeliverablesSecond
                = policyDeliverableRepository.GetPolicyDeliverables(fundingStreamPeriodCodeSecond, paymentManagementPolicyConnectionInfo).Result;

            // assert 2
            Assert.IsNotNull(policyDeliverablesSecond, $"Unexpected null result returned  for {fundingStreamPeriodCodeSecond}");
            Assert.AreEqual(18, policyDeliverablesSecond.Count, $"Unexpected number of policy deliverables returned for {fundingStreamPeriodCodeSecond}");
        }
    }
}
