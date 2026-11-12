namespace FCT.Console.Config.Transformers
{
    using System.Collections.Generic;
    using AutoMapper;
    using ExcelTypes;
    using Microsoft.Extensions.Logging;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;

    public static class FspDeliverableClaimTransformer
    {
        private static readonly IMapper _mapper;
        private static readonly ILoggerFactory loggerFactory = LoggerFactory.Create(builder => { });
        static FspDeliverableClaimTransformer()
        {
            var config = new MapperConfiguration(cfg =>
            {
                cfg.CreateMap<FundingStreamPeriodDeliverablesSheetType, FspDeliverableClaim>()
                    .ForMember(dest => dest.AllowClaim,
                        opts => opts.MapFrom(source => source.AllowClaim))
                    .ForMember(dest => dest.DeliverableCode,
                        opts => opts.MapFrom(source => source.DeliverableCode))
                    .ForMember(dest => dest.FspCode,
                        opts => opts.MapFrom(source => source.FundingStreamPeriodCode))
                    .ForMember(dest => dest.ClaimReconciliationDeliverableGroupCode,
                        opts => opts.MapFrom(source => source.ClaimReconciliationDeliverableGroupCode));
            }, loggerFactory); 

            _mapper = config.CreateMapper();
        }

        public static IEnumerable<FspDeliverableClaim> TransformCollection(
            IEnumerable<FundingStreamPeriodDeliverablesSheetType> sheetTypes)
        {
            return _mapper.Map<IEnumerable<FspDeliverableClaim>>(sheetTypes);
        }
    }
}
