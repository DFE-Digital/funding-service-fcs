namespace PaymentManagement.Calculation.Services
{
    using System;
    using System.Linq;
    using Dtos;
    using Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model;

    public class CensusDateService : ICensusDateService
    {
        private readonly IPaymentTimetableRepository _paymentTimetableRepository;
        private readonly IDateService _dateService;
        private readonly IPolicyFundingStreamPeriodRepository _fspRepository;

        public CensusDateService(IPaymentTimetableRepository paymentTimetableRepository, IDateService dateService,
            IPolicyFundingStreamPeriodRepository fspRepository)
        {
            _paymentTimetableRepository = paymentTimetableRepository;
            _dateService = dateService;
            _fspRepository = fspRepository;
        }

        public CensusPeriodInfo GetCensusPeriodInfo(string fundingStreamPeriodCode, ConnectionInfo connectionInfo)
        {
            DateTime currentDate = _dateService.GetCurrentDate();

            var paymentMethod = _fspRepository.GetPaymentMethod(fundingStreamPeriodCode, connectionInfo);
            if (paymentMethod == PaymentMethod.NoPay)
            {
                var firstCensusPeriodInfo = GetFirstCensusPeriodInfo(fundingStreamPeriodCode, connectionInfo);

                if (GetPeriod(currentDate) < firstCensusPeriodInfo.GetPeriod())
                {
                    var periodBeforeStartOfTimetable = new DateTime(firstCensusPeriodInfo.Year, firstCensusPeriodInfo.CalendarPeriod, 1).AddMonths(-1);

                    return new CensusPeriodInfo(periodBeforeStartOfTimetable, calendarPeriod: periodBeforeStartOfTimetable.Month, year: periodBeforeStartOfTimetable.Year);
                }
            }

            return _paymentTimetableRepository.GetCensusPeriodInfo(fundingStreamPeriodCode, currentDate, connectionInfo);
        }

        private CensusPeriodInfo GetFirstCensusPeriodInfo(string fundingStreamPeriodCode, ConnectionInfo connectionInfo)
        {
            var censusPeriodInfos =
                _paymentTimetableRepository.GetFundingStreamPeriodCensusPeriodInfos(fundingStreamPeriodCode, connectionInfo);

            return censusPeriodInfos.OrderBy(d => d.CensusEndDate).First();
        }

        private static int GetPeriod(DateTime date)
        {
            string periodStr = date.Year + date.Month.ToString("00");

            return int.Parse(periodStr);
        }
    }
}
