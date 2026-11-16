namespace FCT.Console.Config.Transformers
{
    using System.Collections.Generic;
    using AutoMapper;
    using ExcelTypes;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using Microsoft.Extensions.Logging;

    public static class MonitoringDeliverablesFundingStreamPeriodTransformer
    {
        private static readonly IMapper _mapper;
        private static readonly ILoggerFactory loggerFactory = LoggerFactory.Create(builder => { });

        static MonitoringDeliverablesFundingStreamPeriodTransformer()
        {
            var config = new MapperConfiguration(cfg =>
            {
                cfg.CreateMap<FundingStreamPeriodSheetType, FundingStreamPeriod>()

                    // ✅ Replace ResolveUsing with MapFrom
                    .ForMember(dest => dest.PaymentMethod,
                        opts => opts.MapFrom<PaymentMethodTypeResolver>());
            }, loggerFactory);

            _mapper = config.CreateMapper();
        }

        public static IEnumerable<FundingStreamPeriod> TransformCollection(
            IEnumerable<FundingStreamPeriodSheetType> sheetTypes)
        {
            return _mapper.Map<IEnumerable<FundingStreamPeriod>>(sheetTypes);
        }
    }
}
