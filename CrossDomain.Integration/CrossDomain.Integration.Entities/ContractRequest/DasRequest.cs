namespace SFA.FCT.CrossDomain.Integration.Entities.ContractRequest
{
    using System;

    public class DasRequest
    {
        public string FundingType { get; set; }

        public int Ukprn { get; set; }

        public DateTime StartDate { get; set; }

        public long DasEngagementEventId { get; set; }

        public override string ToString()
        {
            return $" EventId: {DasEngagementEventId}, FundingType: {FundingType}, UKPRN: {Ukprn}, Start Date: {StartDate.ToString("dd-MM-yyyy")}";
        }
    }
}