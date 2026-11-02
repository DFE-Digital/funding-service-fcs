namespace SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentDefiner.DocumentPartCreators
{
    using System.Collections.Generic;
    public static class PeriodIndexHelper
    {
        public static int GetColumnIndexOfPeriod(int period)
        {
            IList<int> periods = new List<int> { 8, 9, 10, 11, 12, 1, 2, 3, 4, 5, 6, 7 };

            return periods.IndexOf(period);
        }

        public static List<PeriodTotalValue> GetZeroPeriodTotalValuesAugToJuly(int firstColumnIndexWithData, int lastColumnWithData)
        {
            List<PeriodTotalValue> periodTotalValues = new List<PeriodTotalValue>
            {
                new PeriodTotalValue(8, 0.00m),
                new PeriodTotalValue(9, 0.00m),
                new PeriodTotalValue(10, 0.00m),
                new PeriodTotalValue(11, 0.00m),
                new PeriodTotalValue(12, 0.00m),
                new PeriodTotalValue(1, 0.00m),
                new PeriodTotalValue(2, 0.00m),
                new PeriodTotalValue(3, 0.00m),
                new PeriodTotalValue(4, 0.00m),
                new PeriodTotalValue(5, 0.00m),
                new PeriodTotalValue(6, 0.00m),
                new PeriodTotalValue(7, 0.00m),
            };

            periodTotalValues.ForEach(ptv =>
            {
                int indexOfPeriod = GetColumnIndexOfPeriod(ptv.Period);

                if (indexOfPeriod < firstColumnIndexWithData || indexOfPeriod > lastColumnWithData)
                {
                    ptv.RemoveValue();

                }
            });

            return periodTotalValues;
        }
    }
}
