namespace SFA.FCT.CrossDomain.Integration.Messages.Commands
{
    using System;

    public class ProcessPaymentRunCompleteCommand
    {
        public string FundingStreamShortCode { get; set; }

        public DateTime FundingStreamPeriodStartDate { get; set; }

        public DateTime FundingStreamPeriodEndDate { get; set; }
        
        public string FundingStreamPeriodCode { get; set; }

        public DateTime CensusEndDate { get; set; }

        public string LinkCode { get; set; }
     }
}
