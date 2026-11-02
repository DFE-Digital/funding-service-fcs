namespace FundingAllocation.Dto
{
    using System;
    using System.Globalization;

    public class FundingAllocationProfilePeriodApiDto
    {
        public string Month { get; set; }

        public int Year { get; set; }

        public decimal PlannedValue { get; set; }

        public int GetPeriod()
        {
            int month = DateTime.ParseExact(Month, "MMMM", CultureInfo.CreateSpecificCulture("en-GB")).Month;
            return int.Parse($"{Year}{month:D2}");
        }
    }
}
