namespace PaymentManagement.Calculation.Extensions
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Dtos;
    using Optional;

    public static class CensusPeriodInfosExtensions
    {
        public static CensusPeriodInfo GetCurrent(this IEnumerable<CensusPeriodInfo> censusPeriodInfos,
            DateTime currentDate)
        {
            var censusPeriodOption = censusPeriodInfos
                .Where(cp => cp.CensusEndDate > currentDate)
                .OrderBy(c => c.CensusEndDate)
                .FirstOrDefault().NoneWhen(c => c == null);

            return censusPeriodOption.Match(some: cp => cp,
                none: () => new CensusPeriodInfo(currentDate, currentDate.Month, currentDate.Year));
        }
    }
}
