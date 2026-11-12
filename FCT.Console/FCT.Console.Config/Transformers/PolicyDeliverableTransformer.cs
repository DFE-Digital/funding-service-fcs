namespace FCT.Console.Config.Transformers
{
    using System.Collections.Generic;
    using AutoMapper;
    using ExcelTypes;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model;
    using Microsoft.Extensions.Logging;
    public class PolicyDeliverableTransformer
    {
        private static readonly IMapper _mapper;
        private static readonly ILoggerFactory loggerFactory = LoggerFactory.Create(builder => { });

        static PolicyDeliverableTransformer()
        {
            var config = new MapperConfiguration(cfg =>
            {
                cfg.CreateMap<FundingStreamPeriodDeliverablesSheetType, PolicyDeliverable>()
                    .ForMember(dest => dest.DeliverableCode,
                        opt => opt.MapFrom(src => src.DeliverableCode))
                    .ForMember(dest => dest.FundingStreamPeriod,
                        opt => opt.MapFrom(src => src.FundingStreamPeriodCode))
                    .ForMember(dest => dest.IsPayable,
                        opt => opt.MapFrom(src => src.IsPayable))
                    .ForMember(dest => dest.ParentDeliverableCode,
                        opt => opt.MapFrom(src => src.ParentDeliverableCode));
            }, loggerFactory); 

            _mapper = config.CreateMapper();
        }

        public static IEnumerable<PolicyDeliverable> TransformCollection(
           IEnumerable<FundingStreamPeriodDeliverablesSheetType> configSheetObjects)
        {
            return _mapper.Map<IEnumerable<PolicyDeliverable>>(configSheetObjects);
        }
    }
}
