namespace SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Model
{
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System;
    using System.Diagnostics.CodeAnalysis;

    [SuppressMessage("ReSharper", "InconsistentNaming")]
    public enum PeriodTypeCode
    {
        AY = 0,
        FY = 1,
        CY = 1,
        CM = 2,
        CQ = 3,
        ESF = 4,
        EOF = 5,
        EOP = 6,
        LEVY = 7,
        NONLEVY = 8
    }

    public class DeliverablePayment
    {
        [Key, Column(Order = 0)]
        public string AllocationNumber { get; set; }

        [Key, Column(Order = 1)]
        public int VersionNumber { get; set; }

        [Key, Column(Order = 2)]
        public int DeliverableCode { get; set; }

        [Key, Column(Order = 3)]
        public string Period { get; set; }

        public PeriodTypeCode PeriodTypeCode { get; set; }

        public int? PlannedVolume { get; set; }

        public decimal? PlannedValue { get; set; }

        public decimal? ProfilePaymentAmount { get; set; }

        public decimal? CappedPaymentAmount { get; set; }

        public decimal? BalancingPaymentAmount { get; set; }

        public decimal? ReconciliationPaymentAmount { get; set; }

        public decimal NetPaymentAmount { get; set; }

        public int? ActualVolume { get; set; }

        public decimal? ActualValue { get; set; }

        public string CollectionReturnCode { get; set; }

        //[Column(TypeName = "datetime2")]
        public DateTime? LastModifiedDate { get; set; }

        protected bool Equals(DeliverablePayment other)
        {
            return string.Equals(AllocationNumber, other.AllocationNumber) && VersionNumber == other.VersionNumber && DeliverableCode == other.DeliverableCode && string.Equals(Period, other.Period);
        }

        public override bool Equals(object obj)
        {
            if (ReferenceEquals(null, obj)) return false;
            if (ReferenceEquals(this, obj)) return true;
            if (obj.GetType() != this.GetType()) return false;
            return Equals((DeliverablePayment)obj);
        }

        public override int GetHashCode()
        {
            unchecked
            {
                var hashCode = AllocationNumber.GetHashCode();
                hashCode = (hashCode * 397) ^ VersionNumber;
                hashCode = (hashCode * 397) ^ DeliverableCode;
                hashCode = (hashCode * 397) ^ Period.GetHashCode();
                return hashCode;
            }
        }

        public override string ToString()
        {
            return
                $"AllocationNumber: {AllocationNumber}, VersionNumber: {VersionNumber}, DeliverableCode: {DeliverableCode}, Period: {Period}";
        }
    }
}
