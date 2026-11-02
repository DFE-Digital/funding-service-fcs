namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.DTO.Cfs
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

        //      public string provider { get; set; }
        //      public string DeliveryUkprn { get; set; }
        //      public string deliveryprovider { get; set; }

        public int MajorVersion { get; set; }

        public int MinorVersion { get; set; }

        public DateTime StartDate { get; set; }

        public DateTime EndDate { get; set; }

        public string Status { get; set; }

        public string SubStatus { get; set; }

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

    public class AllocationPeriod
    {
        /// <summary>
        /// 1 equates to Jan ...
        /// </summary>
        public int Month { get; set; }

        public int Year { get; set; }

        public decimal ProfileValue { get; set; }

        /// <summary>
        /// e.g. "Jan-19"
        /// </summary>
        public string Period { get; set; }
    }
}
