namespace SFA.FCT.PaymentManagementDomain.PaymentSchedule.Xrm.Integration
{
    using System;
    using System.Collections.Generic;
    using System.Globalization;

    public static class DateBetweenPeriodGenerator
    {
        public static IList<string> GetPeriodsBetweenTwoDates(DateTime startDate, DateTime endDate)
        {
            if (startDate > endDate)
            {
                throw new ArgumentOutOfRangeException(nameof(startDate), "start date cannot be at a later date than end date.");
            }
            List<string> periods = new List<string>();
            
            DatePeriod currentPeriod = new DatePeriod(startDate);
            DatePeriod endPeriod = new DatePeriod(endDate);

            while (currentPeriod.Value <= endPeriod.Value)
            {
                periods.Add(currentPeriod.ToString());
                currentPeriod.AddMonth();
            }

            return periods;
        }

        private class DatePeriod
        {
            private DateTime _date;
            
            public DatePeriod(DateTime date)
            {
                _date = date;             
            }
 
            public int Value => (_date.Year * 100) + _date.Month;

            public void AddMonth()
            {
                _date = _date.AddMonths(1);
            }

            public override string ToString()
            {
                return $"{_date.ToString("MMM", CultureInfo.InvariantCulture)}-{_date.ToString("yy", CultureInfo.InvariantCulture)}";
            }
        }
    }
}
