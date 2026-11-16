namespace FCT.Console.Config.Transformers
{
    using System.Collections.Generic;
    using AutoMapper;
    using ExcelTypes;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model;
    using Microsoft.Extensions.Logging;

    public static class ESFRegionInvestmentPriorityTransformer
    {
        private static readonly IMapper _mapper;
        private static readonly ILoggerFactory loggerFactory = LoggerFactory.Create(builder => { });

        static ESFRegionInvestmentPriorityTransformer()
        {
            var config = new MapperConfiguration(cfg =>
            {
                cfg.CreateMap<ESFRegionInvestmentPrioritySheetType, ESFRegionInvestmentPriority>()
                    .ForMember(dest => dest.InvestmentPriority,
                        opts => opts.MapFrom(source => source.InvestmentPriorityDecimal));
            }, loggerFactory);

            _mapper = config.CreateMapper();
        }

        public static IEnumerable<ESFRegionInvestmentPriority> TransformCollection(
            IEnumerable<ESFRegionInvestmentPrioritySheetType> sheetTypes)
        {
            return _mapper.Map<IEnumerable<ESFRegionInvestmentPriority>>(sheetTypes);
        }
    }
}
