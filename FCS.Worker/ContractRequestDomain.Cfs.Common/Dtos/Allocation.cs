namespace ContractRequestDomain.Cfs.Common.Dtos
{
    using System;
    using System.Collections.Generic;
    using System.Linq;

    public class Allocation
    {
        public string Id { get; set; }

        public string FundingStreamPeriodCode { get; set; }

        public int DeliverableCode { get; set; }

        public string FundingTypeCode { get; set; }

        public string FundingPeriod { get; set; }

        public int Ukprn { get; set; }

        public int MajorVersion { get; set; }

        public int MinorVersion { get; set; }

        public DateTime StartDate { get; set; }

        public DateTime EndDate { get; set; }

        public Guid? CrmEntityId { get; set; }

        public decimal GetProfileValue()
        {
            return AllocationPeriods.Sum(ap => ap.ProfileValue);
        }

        public List<AllocationPeriod> AllocationPeriods { get; set; } = new List<AllocationPeriod>();

        public override string ToString()
        {
            return $"FundingStreamPeriod: {FundingStreamPeriodCode}, DeliverableCode: {DeliverableCode}, Ukprn: {Ukprn}";
        }
    }
}