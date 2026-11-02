namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.DTO.PaymentGeneration
{
    using System;

    public class FundingStreamPeriod
    {
        public string Code { get; set; }

        public string Name { get; set; }

        public string FundingStreamCode { get; set; }

        public DateTime StartDate { get; set; }

        public DateTime EndDate { get; set; }
    }
}
