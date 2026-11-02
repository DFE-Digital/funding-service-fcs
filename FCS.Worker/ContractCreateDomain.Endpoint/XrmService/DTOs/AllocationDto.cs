namespace ContractCreateDomain.Endpoint.XrmService.DTOs
{
    using System;
    using System.Collections.Generic;

    public class AllocationDto
    {
        public AllocationDto()
        {
            Deliverables = new List<Deliverable>();
        }

        public Guid CrmGuid { get; set; }

        public List<Deliverable> Deliverables { get; set; }
    }

    public class Deliverable
    {
        public Deliverable()
        {
            DeliverablePeriods = new List<DeliverablePeriod>();
        }

        public Guid Id { get; set; }

        public Guid? ParentDeliverableId { get; set; }

        public decimal? ActualValue { get; set; }

        public string DeliverableCode { get; set; }

        public IList<DeliverablePeriod> DeliverablePeriods { get; set; }

        public bool IsLegal { get; set; }

        public bool IsMonitoring { get; set; }
    }

    public class DeliverablePeriod
    {
        public Guid Id { get; set; }

        public int? Year { get; set; }

        public int? PeriodNumber { get; set; }

        public decimal? ActualValue { get; set; }

        public int? ActualVolume { get; set; }

        public decimal? NetPaymentValue { get; set; }

        public decimal? BalancingPaymentValue { get; set; }

        public decimal? CappedPaymentValue { get; set; }

        public decimal? ProfilePaymentValue { get; set; }

        public decimal? ReconciliationPaymentValue { get; set; }

        public bool? PaymentPosted { get; set; }

        public Guid CappingSubnominalId { get; set; }

        public Guid ProfileSubnominalId { get; set; }

        public Guid ReconcilliationSubnominalId { get; set; }

        public bool Modified { get; set; }
    }
}
