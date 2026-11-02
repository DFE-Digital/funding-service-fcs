namespace PaymentManagement.Calculation.Dtos
{
    using System;

    public class CensusPeriodInfo
    {
        public CensusPeriodInfo(DateTime censusEndDate, int calendarPeriod, int year)
        {
            CensusEndDate = censusEndDate;
            CalendarPeriod = calendarPeriod;
            Year = year;
        }

        public DateTime CensusEndDate { get; }

        public int CalendarPeriod { get; }

        public int Year { get; }

        public int GetPeriod()
        {
            string periodStr = Year + CalendarPeriod.ToString("00");

            return int.Parse(periodStr);
        }
    }
}
