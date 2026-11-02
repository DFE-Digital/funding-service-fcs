namespace SFA.FCT.PaymentManagementDomain.BusinessLogic.FundingClaimReconciliation.Dto
{
    public class DeliverablePeriodResult
    {
        public int? DeliverablePeriodId { get; set; }
        public string AllocationNumber { get; set; }
        public decimal? ProfileValue { get; set; }
        public int DeliverableCode { get; set; }
        public string ContractNumber { get; set; }
        public int ContractVersionNumber { get; set; }
        public decimal? NetPaymentValue { get; set; }
        public int Period { get; set; }
        public decimal? ReconciliationPaymentValue { get; set; }
        public decimal? YearToDateValue { get; set; }
        public decimal? ProfilePaymentValue { get; set; }
        public int Year { get; set; }
        public decimal? BalancingPaymentValue { get; set; }
        public decimal? CappingPaymentValue { get; set; }
        public decimal? ActualValue { get; set; }
    }
}
