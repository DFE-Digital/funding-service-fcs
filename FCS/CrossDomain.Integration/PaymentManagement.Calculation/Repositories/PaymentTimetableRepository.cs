namespace PaymentManagement.Calculation.Repositories
{
    using Dtos;
    using PaymentManagement.Calculation.Extensions;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore;
    using System;
    using System.Collections.Concurrent;
    using System.Collections.Generic;
    using System.Linq;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public class PaymentTimetableRepository : IPaymentTimetableRepository
    {
        private static readonly ConcurrentDictionary<string, Lazy<IReadOnlyCollection<CensusPeriodInfo>>> CachedCensusPeriodInfos
            = new ConcurrentDictionary<string, Lazy<IReadOnlyCollection<CensusPeriodInfo>>>();

        public IReadOnlyCollection<CensusPeriodInfo> GetFundingStreamPeriodCensusPeriodInfos(string fundingStreamPeriodCode, ConnectionInfo connectionInfo)
        {
            var lazyCensusPeriodInfos = new Lazy<IReadOnlyCollection<CensusPeriodInfo>>(() => GetFromDb(fundingStreamPeriodCode, connectionInfo));

            lazyCensusPeriodInfos = CachedCensusPeriodInfos.GetOrAdd(fundingStreamPeriodCode, lazyCensusPeriodInfos);

            return lazyCensusPeriodInfos.Value;
        }

        public CensusPeriodInfo GetCensusPeriodInfo(string fundingStreamPeriodCode, DateTime currentDate, ConnectionInfo connectionInfo)
        {
            IReadOnlyCollection<CensusPeriodInfo> censusDates =
                GetFundingStreamPeriodCensusPeriodInfos(fundingStreamPeriodCode, connectionInfo);
            CensusPeriodInfo currentPeriodInfo = censusDates.GetCurrent(currentDate);

            return currentPeriodInfo;
        }

        private IReadOnlyCollection<CensusPeriodInfo> GetFromDb(string fundingStreamPeriodCode, ConnectionInfo connectionInfo)
        {
            using (var context = new PaymentManagementPolicyContext(connectionInfo))
            {
                return context.PolicyFundingStreamCensusDates
                    .Where(pfscd => pfscd.FundingStreamPeriod == fundingStreamPeriodCode)
                    .ToList()
                    .Select(pfscd => new CensusPeriodInfo(censusEndDate: pfscd.CensusDate, calendarPeriod: pfscd.CalendarPeriod, year: pfscd.CalendarYear))
                    .ToList();
            }
        }
    }
}