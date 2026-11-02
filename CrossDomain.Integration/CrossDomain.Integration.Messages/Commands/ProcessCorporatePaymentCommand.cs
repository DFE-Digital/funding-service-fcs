namespace SFA.FCT.CrossDomain.Integration.Messages.Commands
{
    using System;

    public class ProcessCorporatePaymentRunCommand
    {
        public string FundingStreamPeriod { get; set; }

        public string PaymentPeriod { get; set; }

        public DateTime CensusEndDateTime { get; set; }

        public string LinkCodeSuffix { get; set; }

        public int FeedIdInDatabase { get; set; }

        public override string ToString()
        {
            return
                $"FundingStreamPeriod: {FundingStreamPeriod}, PaymentPeriod: {PaymentPeriod}, CensusEndDateTime: {CensusEndDateTime}, LinkCodeSuffix: {LinkCodeSuffix}, FeedIdInDatabase: {FeedIdInDatabase}";
        }
    }
}
