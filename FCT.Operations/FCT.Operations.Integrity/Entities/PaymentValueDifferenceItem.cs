namespace SFA.FCT.Operations.Integrity.Entities
{
    using Attributes;
    using Helpers;
    using CrossDomain.Integration.Entities.ContractRequest;
    using DTOs;

    public class PaymentValueDifferenceItem
    {
        public PaymentValueDifferenceItem(DeliverablePaymentWithFsp localStorePaymentValues, CrmDeliverablePaymentData crmPaymentValues)
        {
            AllocationNumber = localStorePaymentValues.AllocationNumber;
            VersionNumber = localStorePaymentValues.VersionNumber;
            DeliverableCode = localStorePaymentValues.DeliverableCode;
            Period = localStorePaymentValues.Period;
            PlannedValue = localStorePaymentValues.PlannedValue;
            PlannedVolume = localStorePaymentValues.PlannedVolume;
            ActualValue = localStorePaymentValues.ActualValue;
            ActualVolume = localStorePaymentValues.ActualVolume;
            ReconciliationPaymentValue = localStorePaymentValues.ReconciliationPaymentAmount;
            CappingPaymentValue = localStorePaymentValues.CappedPaymentAmount;
            NetPaymentValue = localStorePaymentValues.NetPaymentAmount;
            BalancingPaymentValue = localStorePaymentValues.BalancingPaymentAmount;
            ProfilePaymentValue = localStorePaymentValues.ProfilePaymentAmount;


            if (crmPaymentValues != null)
            {
                CrmPlannedValue = crmPaymentValues.PlannedValue;
                CrmActualValue = crmPaymentValues.ActualValue;
                CrmActualVolume = crmPaymentValues.ActualVolume;
                CrmReconciliationPaymentValue = crmPaymentValues.ReconciliationPaymentValue;
                CrmCappingPaymentValue = crmPaymentValues.CappingPaymentValue;
                CrmNetPaymentValue = crmPaymentValues.NetPaymentValue ?? 0;
                CrmBalancingPaymentValue = crmPaymentValues.BalancingPaymentValue ?? 0;
                CrmProfilePaymentValue = crmPaymentValues.ProfilePaymentValue ?? 0;
                CrmPlannedVolume = crmPaymentValues.PlannedVolume;

                IsDuplicatesInCrm = crmPaymentValues.IsDupilcateRows;
            }
            else
            {
                NotInCrm = true;
            }
        }

        [Order(1)]
        public string AllocationNumber { get; set; }

        [Order(2)]
        public int VersionNumber { get; set; }

        [Order(3)]
        public int DeliverableCode { get; set; }

        [Order(4)]
        public string Period { get; set; }

        [Order(5)]
        public decimal PlannedValue { get; set; }

        [Order(6)]
        public int PlannedVolume { get; set; }

        [Order(7)]
        public decimal ActualValue { get; set; }

        [Order(8)]
        public int ActualVolume { get; set; }

        [Order(9)]
        public decimal? ReconciliationPaymentValue { get; set; }

        [Order(10)]
        public decimal? CappingPaymentValue { get; set; }

        [Order(11)]
        public decimal NetPaymentValue { get; set; }

        [Order(12)]
        public decimal BalancingPaymentValue { get; set; }

        [Order(13)]
        public decimal ProfilePaymentValue { get; set; }

        [Order(14)]
        public decimal CrmPlannedValue { get; set; }

        [Order(15)]
        public int CrmPlannedVolume { get; set; }

        [Order(16)]
        public decimal CrmActualValue { get; set; }

        [Order(17)]
        public int CrmActualVolume { get; set; }

        [Order(18)]
        public decimal? CrmReconciliationPaymentValue { get; set; }

        [Order(19)]
        public decimal? CrmCappingPaymentValue { get; set; }

        [Order(20)]
        public decimal CrmNetPaymentValue { get; set; }

        [Order(21)]
        public decimal CrmBalancingPaymentValue { get; set; }

        [Order(22)]
        public decimal CrmProfilePaymentValue { get; set; }

        [Order(23)]
        public bool IsDuplicatesInCrm { get; set; }

        [Order(24)]
        public bool NotInCrm { get; set; }
    }
}
