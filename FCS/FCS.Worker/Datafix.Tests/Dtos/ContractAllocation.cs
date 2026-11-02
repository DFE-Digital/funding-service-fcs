using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Datafix.Tests.Dtos
{
    public class ContractAllocation
    {
        public Guid ContractId { get; set; }
        public Guid CAID { get; set; }
        public string AllocationNumber { get; set; }
        public string Ukprn { get; set; }
        public string Period { get; set; }
        public string Deliveryorganisationukprn { get; set; }
        public int? ContractVersion { get; set; }
    }

    public class ContractDeliverablePeriod
    {
        public Guid CDPId { get; set; }
        public decimal? BalancingpaymentAmount { get; set; }
        public decimal? ProfilePaymentAmount { get; set; }
        public decimal? NetPaymentAmount { get; set; }
        public bool? paymentPosted { get; set; }
        public string AllocationNumber { get; set; }
        public string ProfileSubnominalId { get; set; }
        public string DeliverableCode { get; set; }
        public string PeriodName { get; set; }
        public int? Period { get; set; }
        public int? ContractVersion { get; set; }
    }

    public class SubnominalAggregationData
    {
        public Guid SAId { get; set; }
        public decimal? AggregateValue { get; set; }
        public string SubnominalCode { get; set; }
        public string AggregateKey { get; set; }
    }

    public class DeliveryPayments
    {
        public decimal? BalancingpaymentAmount { get; set; }
        public decimal? ProfilePaymentAmount { get; set; }
        public decimal? NetPaymentAmount { get; set; }
        public decimal? PlannedValue { get; set; }
    }

    public class DeliveryPaymentObj
    {
        public string AllocationNumber { get; set; }
        public int VersionNumber { get; set; }
        public int DeliverableCode { get; set; }
        public string Period { get; set; }
        public int PeriodTypeCode { get; set; }
        public int PlannedVolume { get; set; }
        public decimal? PlannedValue { get; set; }
        public decimal? ProfilePaymentAmount { get; set; }
        public decimal? CappedPaymentAmount { get; set; }
        public decimal? BalancingPaymentAmount { get; set; }
        public decimal? ReconciliationPaymentAmount { get; set; }
        public decimal? NetPaymentAmount { get; set; }
        public string CollectionReturnCode { get; set; }
        public int ActualVolume { get; set; }
        public decimal? ActualValue { get; set; }
        public DateTime CreatedDate { get; set; }
    }


    public class ContractDeliverable
    {
        public int? sfa_Version { get; set; }
        public int? sfa_PlannedVolume { get; set; }
        public string sfa_deliverablename { get; set; }
        public string sfa_DeliverableCode { get; set; }
        public Guid? sfa_contractdeliverableId { get; set; }
        public Guid sfa_ContractAllocationId { get; set; }
        public string AllocationNumber { get; set; }
        public string ContractNo { get; set; }
        public decimal? sfa_PlannedValue { get; set; }
        public decimal? sfa_ActualValue { get; set; }
        public decimal? sfa_UnitCost { get; set; }
        public string sfa_DeliverableDescription { get; set; }
        public int? sfa_DisplayOrder { get; set; }
        public string sfa_AllocationRef { get; set; }
        public Guid sfa_ContractId { get; set; }
        public Guid sfa_FundingStreamPeriodDeliverableId { get; set; }
        public Guid? sfa_ParentDeliverableId { get; set; }
        public int statusCode { get; set; }
        public sfa_contractdeliverableState stateCode { get; set; }
        public List<sfa_contractdeliverableperiod> Contractdeliverableperiod { get; set; }
    }

    public class ContractDeliverablePeriodWithSubnominal
    {
        public Guid CDPId { get; set; }
        public string ReconciliationSubnominal { get; set; }
    }

    public class ContractDeliverablePeriodWithSubnominal1
    {
        public Guid CDPId { get; set; }
        public string Period { get; set; }
    }
}
