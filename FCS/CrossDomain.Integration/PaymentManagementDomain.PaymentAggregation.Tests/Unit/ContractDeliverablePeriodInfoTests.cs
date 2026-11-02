namespace SFA.FCT.PaymentManagementDomain.PaymentAggregation.Tests.Unit
{
    using BusinessLogic.DTOs;
    using CrossDomain.Integration.Entities.CorporatePaymentAggregation;
    using CrossDomain.Integration.Entities.Xrm;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;

    [TestClass]
    public class ContractDeliverablePeriodInfoTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ContractDeliverablePeriodInfo_ShouldReturnTrueIfRelationshipSetToSubnominalSetForThePaymentType()
        {
            // arrange
            sfa_contractdeliverableperiod contractdeliverableperiod = new sfa_contractdeliverableperiod
            {
                sfa_reconciliationsubnominal = new EntityReference(),
                sfa_profilesubnominal = new EntityReference()
            };

            ContractDeliverablePeriodInfo contractDeliverablePeriodInfo = new ContractDeliverablePeriodInfo(null, contractdeliverableperiod, string.Empty, string.Empty);
            
            // act
            bool isRelationshipSet =
                contractDeliverablePeriodInfo.IsRelationShipToSubnominalSet(AggregationPaymentType.RECONCILIATION);

            //assert
            Assert.AreEqual(true, isRelationshipSet, "The cdp is not related to a reconciliation sa");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractDeliverablePeriodInfo_ShouldReturnFalseIfRelationshipNotSetToSubnominalSetForThePaymentType()
        {
            // arrange
            sfa_contractdeliverableperiod contractdeliverableperiod = new sfa_contractdeliverableperiod
            {
                sfa_reconciliationsubnominal = new EntityReference(),
                sfa_profilesubnominal = new EntityReference()
            };

            ContractDeliverablePeriodInfo contractDeliverablePeriodInfo = new ContractDeliverablePeriodInfo(null, contractdeliverableperiod, string.Empty, string.Empty);

            // act
            bool isRelationshipSet =
                contractDeliverablePeriodInfo.IsRelationShipToSubnominalSet(AggregationPaymentType.CAPPING);

            //assert
            Assert.AreEqual(false, isRelationshipSet, "The cdp is related to a capping sa");
        }
    }
}
