namespace SFA.FCT.PaymentManagementDomain.PaymentSchedule.Xrm.Integration.Repositories
{
    using System;
    using CrossDomain.Integration.Entities.Xrm;

    public class DeliverablePeriodInfo
    {
        public DeliverablePeriodInfo(string deliverableCode, Guid deliverableId, sfa_contractdeliverableperiod contractDeliverablePeriod)
        {
            DeliverableCode = deliverableCode;
            DeliverableId = deliverableId;
            ContractDeliverablePeriod = contractDeliverablePeriod;
        }

        public string DeliverableCode { get; }

        public Guid DeliverableId { get; }

        public sfa_contractdeliverableperiod ContractDeliverablePeriod { get; }

    }
}
