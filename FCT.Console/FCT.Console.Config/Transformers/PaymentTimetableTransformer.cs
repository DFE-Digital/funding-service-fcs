
namespace FCT.Console.Config.Transformers
{
    using System.Collections.Generic;
    using AutoMapper;
    using ExcelTypes;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model;
    using PaymentGenerationDomain.Integration.DataStore.Model;
    using Microsoft.Extensions.Logging;

    public static class PaymentTimetableTransformer
    {
        private static readonly IMapper _mapper;
        private static readonly ILoggerFactory loggerFactory = LoggerFactory.Create(builder => { });

        static PaymentTimetableTransformer()
        {
            var config = new MapperConfiguration(cfg =>
            {
                cfg.CreateMap<PaymentTimetablesSheetType, PolicyFundingStreamCensusDate>()
                    .ForMember(x => x.FundingStreamPeriod, opt => opt.MapFrom(pt => pt.FundingStreamPeriodCode))
                    .ForMember(x => x.CensusDate, opt => opt.MapFrom(pt => pt.CensusEndDate))
                    .ForMember(x => x.CalendarYear, opt => opt.MapFrom(pt => int.Parse(pt.CalendarPeriod.Substring(0, 4))))
                    .ForMember(x => x.CalendarPeriod, opt => opt.MapFrom(pt => int.Parse(pt.CalendarPeriod.Substring(4, 2))));

                cfg.CreateMap<PaymentTimetablesSheetType, PaymentTimetable>()
                    .ForMember(dest => dest.PaymentDueDate,
                        opt => opt.MapFrom(src => src.DueDate));
            },loggerFactory);

            _mapper = config.CreateMapper();
        }

        public static IEnumerable<PolicyFundingStreamCensusDate>
            TransformCollectionToPolicyFundingStreamCensusDates(
                IEnumerable<PaymentTimetablesSheetType> configSheetObjects)
        {
            return _mapper.Map<IEnumerable<PolicyFundingStreamCensusDate>>(configSheetObjects);
        }

        public static PolicyFundingStreamCensusDate
            TransformToPolicyFundingStreamCensusDate(PaymentTimetablesSheetType source)
        {
            return _mapper.Map<PolicyFundingStreamCensusDate>(source);
        }

        public static IEnumerable<PaymentTimetable>
            TransformToPaymentTimetableCollection(
                IEnumerable<PaymentTimetablesSheetType> sourceObjects)
        {
            return _mapper.Map<IEnumerable<PaymentTimetable>>(sourceObjects);
        }

        public static PaymentTimetable
            TransformToPaymentTimetable(PaymentTimetablesSheetType sourceObject)
        {
            return _mapper.Map<PaymentTimetable>(sourceObject);
        }
    }
}
