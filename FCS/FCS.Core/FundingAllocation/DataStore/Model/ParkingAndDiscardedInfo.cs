namespace FundingAllocation.DataStore.Model
{
    using System;

    public class ParkingAndDiscardedInfo
    {
        public DateTime? LastParked { get; set; }
        public DateTime? LastDiscarded { get; set; }
        public string FundingAllocationId { get; set; }
    }
}
