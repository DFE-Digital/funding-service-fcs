namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.DTO.PaymentGeneration
{
    using System;

    public class PaymentTimetableHistory
    {
        public DateTime HistoryTime { get; set; }

        public string FundingStreamPeriodCode { get; set; }

        public string CalendarPeriod { get; set; }

        public string Description { get; set; }
    }
}
