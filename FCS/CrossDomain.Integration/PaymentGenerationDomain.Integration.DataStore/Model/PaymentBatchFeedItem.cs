namespace PaymentGenerationDomain.Integration.DataStore.Model
{
    using System;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Linq;
    using SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.CrossDomain.Integration.Common.Serializers;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentGeneration;

    public class PaymentBatchFeedItem
    {
        private PaymentBatchFeedItem()
        {
        }

        public PaymentBatchFeedItem(int id, Guid identifier, string fundingStreamPeriod, string paymentPeriod, DateTime censusEndDate, int paymentLineCount, string linkCodeSuffix, byte[] corporatePaymentBatchBytes, DateTime createdDate)
        {
            Id = id;
            Identifier = identifier;
            FundingStreamPeriod = fundingStreamPeriod;
            PaymentPeriod = paymentPeriod;
            CensusEndDate = censusEndDate;
            PaymentLineCount = paymentLineCount;
            LinkCodeSuffix = linkCodeSuffix;
            CorporatePaymentBatchBytes = corporatePaymentBatchBytes;
            CreatedDate = createdDate;
        }

        [Key]
        public int Id { get; private set; }

        public Guid Identifier { get; private set; }

        [Required]
        [Index("IX_PaymentBatchFeedItemNaturalKey", IsUnique = true, Order = 1, IsClustered = false)]
        [MaxLength(20)]
        public string FundingStreamPeriod { get; private set; }

        [Required]
        [Index("IX_PaymentBatchFeedItemNaturalKey", IsUnique = true, Order = 2, IsClustered = false)]
        [MaxLength(10)]
        public string PaymentPeriod { get; private set; }

        [Required]
        [Index("IX_PaymentBatchFeedItemNaturalKey", IsUnique = true, Order = 3, IsClustered = false)]
        public DateTime CensusEndDate { get; private set; }

        public int PaymentLineCount { get; private set; }

        [Required]
        [Index("IX_PaymentBatchFeedItemNaturalKey", IsUnique = true, Order = 4, IsClustered = false)]
        [MaxLength(2)]
        public string LinkCodeSuffix { get; private set; }

        public byte[] CorporatePaymentBatchBytes { get; private set; }

        [Required, DatabaseGenerated(DatabaseGeneratedOption.Computed)]
        public DateTime CreatedDate { get; private set; }

        [Required]
        public decimal TotalValue { get; private set; }

        public string GetPaymentBatchXml()
        {
            return ZipHelper.ToStringFromZippedBytes(CorporatePaymentBatchBytes);
        }

        public static PaymentBatchFeedItem Create(PaymentPeriod corporatePaymentPeriod, string fundingStreamPeriod, string linkCodeSuffix)
        {
            PaymentBatchFeedItem feedItem = new PaymentBatchFeedItem
            {
                Identifier = Guid.NewGuid(),
                FundingStreamPeriod = fundingStreamPeriod,
                PaymentPeriod = $"{corporatePaymentPeriod.FinancialPaymentFinancialYear}{corporatePaymentPeriod.FinancialPaymentFinancialMonth}",
                CensusEndDate = corporatePaymentPeriod.CensusEndDate,
                PaymentLineCount = corporatePaymentPeriod.PaymentDetails.Count,
                LinkCodeSuffix = linkCodeSuffix,
                TotalValue = corporatePaymentPeriod.PaymentDetails.Sum(pd => pd.AggregatedValue)
            };

            feedItem.SetPaymentBatchBytes(corporatePaymentPeriod);

            return feedItem;
        }

        private void SetPaymentBatchBytes(PaymentPeriod corporatePaymentPeriod)
        {
            CorporatePaymentBatchBytes =
                ZipHelper.ToZippedBytesFromString(corporatePaymentPeriod.SerializeToXml());
        }

        public override string ToString()
        {
            return $"FundingStreamPeriod: {FundingStreamPeriod}, PaymentPeriod: {PaymentPeriod}, CensusEndDate: {CensusEndDate:dd/MM/yyyy HH:mm}, LinkCodeSuffix: {LinkCodeSuffix}";
        }
    }
}