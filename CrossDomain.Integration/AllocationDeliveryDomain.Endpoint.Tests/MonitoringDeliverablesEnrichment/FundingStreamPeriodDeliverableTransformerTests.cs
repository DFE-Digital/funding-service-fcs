namespace AllocationDeliveryDomain.Endpoint.Tests.MonitoringDeliverablesEnrichment
{
    using System.Collections.Generic;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.AllocationDeliveryDomain.MDEnrich.BusinessLogic;
    using SFA.FCT.CrossDomain.Integration.Entities.DeliveryAllocation;

    [TestClass]
    public class FundingStreamPeriodDeliverableTransformerTests
    {
        private const string DeliverableName = "Some Deliverable";
        private const int DeliverableCode = 1;
        private const int DisplayOrder = 1;

        [TestMethod, TestCategory("UnitTest")]
        public void FundingStreamPeriodDeliverableTransformer_TransformToContractDeliverableType_ShouldTransformToContractDeliverableType()
        {
            // arrange
            const string fundingStreamPeriodCode = "TT";
            const int numPeriods = 12;
            List<contractDeliverablePeriodsTypeContractDeliverablePeriod> contractDeliverablePeriods = CreateContractDeliverablePeriods(numPeriods);
            FundingStreamPeriodDeliverable fundingStreamPeriodDeliverable =
                CreateFundingStreamPeriodDeliverable(fundingStreamPeriodCode);
            
            // act
            contractDeliverableType contractDeliverableType = FundingStreamPeriodDeliverableTransformer.TransformToContractDeliverableType(
                fundingStreamPeriodDeliverable, contractDeliverablePeriods);
            
            // assert
            Assert.IsTrue(contractDeliverableType.deliverable.deliverableCode == DeliverableCode, "The DeliverableCode property has not been transformed");
            Assert.IsTrue(contractDeliverableType.deliverable.deliverableName == DeliverableName, "The DeliverableName property has not been transformed");
            Assert.IsTrue(contractDeliverableType.deliverable.isMonitoring, "The isMonitoring property has not been set");
            Assert.IsTrue(contractDeliverableType.deliverable.DisplayOrder == DisplayOrder, "The DisplayOrder property has not been set");
            Assert.IsTrue(contractDeliverableType.contractDeliverablePeriods.Count == numPeriods, "The number of periods is not correct");
        }

        private FundingStreamPeriodDeliverable CreateFundingStreamPeriodDeliverable(string fundingStreamPeriodCode)
        {
            return new FundingStreamPeriodDeliverable
            {
                AllowActuals = true,
                FundingStreamPeriodCode = fundingStreamPeriodCode,
                DeliverableCode = DeliverableCode,
                DeliverableName = DeliverableName,
                DisplayOrder = DisplayOrder
            };
        }

        private List<contractDeliverablePeriodsTypeContractDeliverablePeriod> CreateContractDeliverablePeriods(int numPeriods)
        {
            List<contractDeliverablePeriodsTypeContractDeliverablePeriod> contractDeliverablePeriods = new List<contractDeliverablePeriodsTypeContractDeliverablePeriod>();

            for (int i = 0; i < numPeriods; i++)
            {
                contractDeliverablePeriods.Add(new contractDeliverablePeriodsTypeContractDeliverablePeriod());
            }

            return contractDeliverablePeriods;
        }
    }        
}
