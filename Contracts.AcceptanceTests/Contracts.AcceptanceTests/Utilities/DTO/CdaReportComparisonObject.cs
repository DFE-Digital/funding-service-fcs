namespace SFA.FCT.Contracts.AcceptanceTests.Utilities.DTO
{
    public class CdaReportComparisonObject
    {
        public string Fundingstreamperiodcode { get; set; }

        public string Ukprn { get; set; }

        public string ProviderName { get; set; }

        public string DeliveryUkprn { get; set; }

        public string DeliveryProviderName { get; set; }

        public string ContractAllocationNumber { get; set; }

        public string ContractNumber { get; set; }

        public string MasterContractReference { get; set; }

        public string ContractAllocationStartDate { get; set; }

        public string ContractAllocationEndDate { get; set; }

        public string ContractVersionNumber { get; set; }

        public string ContractStatus { get; set; }

        public string ContractSubStatus { get; set; }

        public string DeliverableDescription { get; set; }

        public string Deliverable { get; set; }

        public string DeliverableParent { get; set; }

        public string DeliverablePeriod { get; set; }

        public string DeliverableYear { get; set; }

        public string FinancialYear { get; set; }

        public string PlanningUnit { get; set; }

        private string _plannedValue;

        public string PlannedValue
        {
            get { return $"{ParseToDecimal(_plannedValue):0.00}"; }
            set { _plannedValue = value; }
        }

        public string ActualEarned { get; set; }

        public string PlannedVolume { get; set; }

        public string ActualVolume { get; set; }

        public string PayableDeliverable { get; set; }

        public string ProfilePayment { get; set; }

        public string BalancingPayment { get; set; }

        public string ReconciliationPayment { get; set; }

        public string CappingPayment { get; set; }

        public string TotalNetPayment { get; set; }

        public string PaymentHeld { get; set; }

        public string PaymentPosted { get; set; }

        public string UnitOfProcurement { get; set; }

        public string Lep { get; set; }

        public string SubnominalProfile { get; set; }

        public string SubnominalReconciliation { get; set; }

        public string SubnominalCapping { get; set; }

        public string DeliverableMonth { get; set; }

        public string ExecutionTime { get; set; }

        public CdaReportComparisonObjectKey GetKey()
        {
            return new CdaReportComparisonObjectKey(ContractNumber, MasterContractReference, ContractAllocationNumber,
                Deliverable, DeliverableYear, DeliverablePeriod);
        }

        private decimal ParseToDecimal(string text)
        {
            decimal d;
            if (decimal.TryParse(text, out d))
            {
                return d;
            }

            return 0;
        }

        public override string ToString()
        {
            return
                $"Fundingstreamperiodcode: {Fundingstreamperiodcode}, Deliverable: {Deliverable}, DeliverablePeriod: {DeliverablePeriod}, DeliverableYear: {DeliverableYear}";
        }
    }
}
