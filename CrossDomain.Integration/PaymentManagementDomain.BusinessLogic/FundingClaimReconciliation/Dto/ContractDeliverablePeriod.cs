namespace SFA.FCT.PaymentManagementDomain.BusinessLogic.FundingClaimReconciliation.Dto
{
    public class ContractDeliverablePeriod
    {
        public int PeriodMonth { get; set; }

        public decimal ActualValue { get; set; }

        public decimal ProfileValue { get; set; }

        public int Year { get; set; }

        public decimal ExistingCap { get; set; }

        public decimal BalancingPaymentValue { get; set; }

        public decimal CappingPaymentValue { get; set; }

        public decimal ProfilePaymentValue { get; set; }

        public decimal ReconcilationPaymentValue { get; set; }

        public decimal NetPaymentValue { get; set; }
    }
}
