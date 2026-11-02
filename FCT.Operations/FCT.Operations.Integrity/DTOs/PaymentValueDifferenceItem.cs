namespace SFA.FCT.Operations.Integrity.DTOs
{
    using Attributes;
    using CrossDomain.Integration.Entities.ContractRequest;

    public class PaymentValueDifferenceItem
    {

        public PaymentValueDifferenceItem(DeliverablePaymentData localStorePaymentValues,
            DeliverablePeriodsValueData crmPaymentValues)
        {
            AllocationNumber = localStorePaymentValues.AllocationNumber;
            VersionNumber = localStorePaymentValues.VersionNumber;
            DeliverableCode = localStorePaymentValues.DeliverableCode;
            Period = localStorePaymentValues.Period;
            PlannedValue = localStorePaymentValues.PlannedValue;
            ActualValue = localStorePaymentValues.ActualValue;
            ReconciliationPaymentValue = localStorePaymentValues.ReconciliationPaymentValue;
            CappingPaymentValue = localStorePaymentValues.CappingPaymentValue;
            NetPaymentValue = localStorePaymentValues.NetPaymentValue;
            BalancingPaymentValue = localStorePaymentValues.BalancingPaymentValue;
            ProfilePaymentValue = localStorePaymentValues.ProfilePaymentValue;

            if (crmPaymentValues != null)
            {
                CrmPlannedValue = crmPaymentValues.PlannedValue;
                CrmActualValue = crmPaymentValues.ActualValue;
                CrmReconciliationPaymentValue = crmPaymentValues.ReconciliationPaymentValue;
                CrmCappingPaymentValue = crmPaymentValues.CappingPaymentValue;
                CrmNetPaymentValue = crmPaymentValues.NetPaymentValue ?? 0;
                CrmBalancingPaymentValue = crmPaymentValues.BalancingPaymentValue ?? 0;
                CrmProfilePaymentValue = crmPaymentValues.ProfilePaymentValue ?? 0;

                IsDuplicatesInCrm = crmPaymentValues.IsDupilcateRows;
            }
            else
            {
                NotInCrm = true;
            }
        }

        [Order(0)]
        public string AllocationNumber { get; set; }

        [Order(1)]
        public int VersionNumber { get; set; }

        [Order(2)]
        public int DeliverableCode { get; set; }

        [Order(3)]
        public string Period { get; set; }

        [Order(4)]
        public decimal PlannedValue { get; set; }

        [Order(5)]
        public decimal ActualValue { get; set; }

        [Order(5)]
        public decimal? ReconciliationPaymentValue { get; set; }

        [Order(6)]
        public decimal? CappingPaymentValue { get; set; }

        [Order(7)]
        public decimal NetPaymentValue { get; set; }

        [Order(8)]
        public decimal BalancingPaymentValue { get; set; }

        [Order(9)]
        public decimal ProfilePaymentValue { get; set; }

        [Order(10)]
        public decimal CrmPlannedValue { get; set; }

        [Order(11)]
        public decimal CrmActualValue { get; set; }

        [Order(12)]
        public decimal? CrmReconciliationPaymentValue { get; set; }

        [Order(13)]
        public decimal? CrmCappingPaymentValue { get; set; }

        [Order(14)]
        public decimal CrmNetPaymentValue { get; set; }

        [Order(15)]
        public decimal CrmBalancingPaymentValue { get; set; }

        [Order(16)]
        public decimal CrmProfilePaymentValue { get; set; }

        [Order(17)]
        public bool IsDuplicatesInCrm { get; set; }

        [Order(17)]
        public bool NotInCrm { get; set; }
    }
}
