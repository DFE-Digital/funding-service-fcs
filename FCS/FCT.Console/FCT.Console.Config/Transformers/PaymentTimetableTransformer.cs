namespace FCT.Console.Config.Transformers
{
    using System.Collections.Generic;
    using ExcelTypes;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model;
    using PaymentGenerationDomain.Integration.DataStore.Model;

    public static class PaymentTimetableTransformer
    {
        public static IEnumerable<PolicyFundingStreamCensusDate> TransformCollectionToPolicyFundingStreamCensusDates(IEnumerable<PaymentTimetablesSheetType> configSheetObjects)
        {
            AutoMapper.Mapper.CreateMap<PaymentTimetablesSheetType, PolicyFundingStreamCensusDate>()
                .ForMember(x => x.FundingStreamPeriod, opts => opts.MapFrom(pt => pt.FundingStreamPeriodCode))
                .ForMember(x => x.CensusDate, opts => opts.MapFrom(pt => pt.CensusEndDate))
                .ForMember(x => x.CalendarYear, opts => opts.MapFrom(pt => int.Parse(pt.CalendarPeriod.Substring(0, 4))))
                .ForMember(x => x.CalendarPeriod, opts => opts.MapFrom(pt => int.Parse(pt.CalendarPeriod.Substring(4, 2))));

            return AutoMapper.Mapper.Map<IEnumerable<PaymentTimetablesSheetType>, IEnumerable<PolicyFundingStreamCensusDate>>(configSheetObjects);

        }

        public static PolicyFundingStreamCensusDate TransformToPolicyFundingStreamCensusDate(
            PaymentTimetablesSheetType source)
        {
            AutoMapper.Mapper.CreateMap<PaymentTimetablesSheetType, PolicyFundingStreamCensusDate>()
                .ForMember(x => x.FundingStreamPeriod, opts => opts.MapFrom(pt => pt.FundingStreamPeriodCode))
                .ForMember(x => x.CensusDate, opts => opts.MapFrom(pt => pt.CensusEndDate))
                .ForMember(x => x.CalendarPeriod, opts => opts.MapFrom(pt => pt.CalendarPeriod.Substring(0, 4)))
                .ForMember(x => x.CalendarPeriod, opts => opts.MapFrom(pt => pt.CalendarPeriod.Substring(4, 2)));

            return AutoMapper.Mapper.Map<PaymentTimetablesSheetType, PolicyFundingStreamCensusDate>(source);
        }

        public static IEnumerable<PaymentTimetable> TransformToPaymentTimetableCollection(IEnumerable<PaymentTimetablesSheetType> sourceObjects)
        {
            AutoMapper.Mapper.CreateMap<PaymentTimetablesSheetType, PaymentTimetable>()
                .ForMember(dest => dest.PaymentDueDate,
                opt => opt.MapFrom(src => src.DueDate));

            return AutoMapper.Mapper.Map<IEnumerable<PaymentTimetablesSheetType>, IEnumerable<PaymentTimetable>>(sourceObjects);
        }

        public static PaymentTimetable TransformToPaymentTimetable(PaymentTimetablesSheetType sourceObject)
        {
            AutoMapper.Mapper.CreateMap<PaymentTimetablesSheetType, PaymentTimetable>()
                .ForMember(dest => dest.PaymentDueDate,
                opt => opt.MapFrom(src => src.DueDate));

            return AutoMapper.Mapper.Map<PaymentTimetablesSheetType, PaymentTimetable>(sourceObject);
        }

    }
}
