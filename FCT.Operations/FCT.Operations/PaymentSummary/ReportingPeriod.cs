namespace FCT.Operations.PaymentSummary
{
    using System;

    public class ReportingPeriod
    {
        private DateTime _date;

        public ReportingPeriod(DateTime date)
        {
            _date = date;
        }

        /// <summary>
        /// Period in 'May 2020' format
        /// </summary>
        public string Period => _date.ToString("MMM yyyy");

        /// <summary>
        /// Period in 202005 format
        /// </summary>
        public int PeriodAsInt => int.Parse(_date.ToString("yyyyMM"));

        public int Year => _date.Year;

        public int Month => _date.Month;

        public int Day => _date.Day;


    }
}
