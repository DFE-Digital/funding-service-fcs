namespace FCT.Operations.FundingConfirmationReport.DTOs
{
    using System;

    public class Period
    {
        public Period(int periodInt)
        {
            PeriodInt = periodInt;
        }

        public int PeriodInt { get; }

        public static implicit operator Period(int period) => new Period(period);
        public static implicit operator int(Period p) => p.PeriodInt;

        public int GetAcademicYearStart()
        {
            return (int) Math.Floor((decimal) PeriodInt / 100) *100 + 200008;
        }

        public int GetAcademicYearEnd()
        {
            decimal periodDividedBy100 = (decimal) PeriodInt / 100;
            var endYear = (periodDividedBy100 - Math.Truncate(periodDividedBy100)) * 100;

            return (int)endYear * 100 + 200007;
        }

        public int GetFinancialYearStart()
        {
            return (int)Math.Floor((decimal)PeriodInt / 100) * 100 + 200004;
        }

        public int GetFinancialYearEnd()
        {
            decimal periodDividedBy100 = (decimal)PeriodInt / 100;
            var endYear = (periodDividedBy100 - Math.Truncate(periodDividedBy100)) * 100;

            return (int)endYear * 100 + 200003;
        }

        public override string ToString()
        {
            return
                $"20{PeriodInt.ToString().Substring(0,2)} to 20{PeriodInt.ToString().Substring(2,2)}";
        }
    }
}
