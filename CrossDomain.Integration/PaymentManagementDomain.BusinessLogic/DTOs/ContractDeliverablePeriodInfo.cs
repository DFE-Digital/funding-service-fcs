namespace SFA.FCT.PaymentManagementDomain.BusinessLogic.DTOs
{
    using System;
    using CrossDomain.Integration.Entities.CorporatePaymentAggregation;
    using CrossDomain.Integration.Entities.Xrm;
    using Microsoft.Xrm.Sdk;

    public class ContractDeliverablePeriodInfo
    {
        public ContractDeliverablePeriodInfo(sfa_contractallocation ca, sfa_contractdeliverableperiod cdp, string periodName, string deliverableCode)
        {
            Contractallocation = ca;
            Contractdeliverableperiod = cdp;
            PeriodName = periodName;
            DeliverableCode = deliverableCode;
        }

        public sfa_contractallocation Contractallocation { get; set; }

        public sfa_contractdeliverableperiod Contractdeliverableperiod { get; set; }

        public string PeriodName { get; }

        public string DeliverableCode { get; }

        public bool IsRelationShipToSubnominalSet(AggregationPaymentType paymentType)
        {
            EntityReference foreignKeyToSubnominal = null; 
            if (paymentType == AggregationPaymentType.RECONCILIATION)
            {
                foreignKeyToSubnominal = Contractdeliverableperiod.sfa_reconciliationsubnominal;
            }
            else if (paymentType == AggregationPaymentType.CAPPING)
            {
                foreignKeyToSubnominal = Contractdeliverableperiod.sfa_CappingSubnominal;
            }
            else if (paymentType == AggregationPaymentType.PROFILE)
            {
                foreignKeyToSubnominal = Contractdeliverableperiod.sfa_profilesubnominal;
            }
            else
            {
                throw new ArgumentException($"The paymentType {paymentType} is not supported");
            }

            return foreignKeyToSubnominal != null;
        }
    }
}
