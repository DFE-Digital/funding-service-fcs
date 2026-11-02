namespace FCT.Operations.Cda.Dtos
{
    using Infrastructure.Csv.Attributes;

    public class CdaRow
    {
        private string _providerName;
        private string _deliveryProviderName;
        private string _deliverableDescription;
        private string _deliverable;
        private string _deliverableParent;

        [Order(0)]
        public string FundingStreamPeriodCode { get; set; }
        [Order(1)]
        public string UKPRN { get; set; }

        [Order(2)]
        public string ProviderName
        {
            get => $"\"{_providerName}\"";
            set => _providerName = value;
        }

        [Order(3)]
        public string DeliveryUKPRN { get; set; }

        [Order(4)]
        public string DeliveryProviderName
        {
            get => $"\"{_deliveryProviderName}\"";
            set => _deliveryProviderName = value;
        }

        [Order(5)]
        public string ContractAllocationNumber { get; set; }
        [Order(6)]
        public string ContractNumber { get; set; }
        [Order(7)]
        public string MasterContractReference { get; set; }
        [Order(8)]
        public string ContractAllocationStartDate { get; set; }
        [Order(9)]
        public string ContractAllocationEndDate { get; set; }
        [Order(10)]
        public string ContractVersionNumber { get; set; }
        [Order(11)]
        public string ContractStatus { get; set; }
        [Order(12)]
        public string ContractSubStatus { get; set; }
        [Order(13)]
        public string DeliverableDescription
        {
            get => $"\"{_deliverableDescription}\"";
            set => _deliverableDescription = value;
        }
        [Order(14)]
        public string Deliverable
        {
            get => $"\"{_deliverable}\"";
            set => _deliverable = value;
        }
        [Order(16)]
        public string DeliverableParent
        {
            get => $"\"{_deliverableParent}\"";
            set => _deliverableParent = value;
        }
        [Order(17)]
        public string DeliverablePeriod { get; set; }
        [Order(18)]
        public string DeliverableYear { get; set; }
        [Order(19)]
        public string FinancialYear { get; set; }
        [Order(20)]
        public string PlanningUnit { get; set; }
        [Order(21)]
        public string PlannedValue { get; set; }
        [Order(22)]
        public string ActualEarned { get; set; }
        [Order(23)]
        public string PlannedVolume { get; set; }
        [Order(24)]
        public string ActualVolume { get; set; }
        [Order(25)]
        public string PayableDeliverable { get; set; }
        [Order(26)]
        public string ProfilePayment { get; set; }
        [Order(27)]
        public string BalancingPayment { get; set; }
        [Order(28)]
        public string ReconciliationPayment { get; set; }
        [Order(29)]
        public string CappingPayment { get; set; }
        [Order(30)]
        public string TotalNetPayment { get; set; }
        [Order(31)]
        public string PaymentHeld { get; set; }
        [Order(32)]
        public string PaymentPosted { get; set; }
        [Order(33)]
        public string UnitOfProcurement { get; set; }
        [Order(34)]
        public string LEP { get; set; }
        [Order(35)]
        public string SubnominalProfile { get; set; }
        [Order(36)]
        public string SubnominalReconciliation { get; set; }
        [Order(37)]
        public string SubnominalCapping { get; set; }
        [Order(38)]
        public string DeliverableMonth { get; set; }
        [Order(39)]
        public string ExecutionTime { get; set; }
        [Order(40)]
        public string DeliverableCode { get; set; }
        [Order(41)]
        public string UnitCost { get; set; }
        [Order(42)]
        public string LotReference { get; set; }
        [Order(43)]
        public string AllocationDescription { get; set; }
    }
}
