namespace FCT.Console.Config.Transformers
{
    using System.Collections.Generic;
    using AutoMapper;
    using ExcelTypes;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model;
    using Microsoft.Extensions.Logging;
    public class PolicyFundingStreamPeriodTransformer
    {
        private static readonly IMapper _mapper;
        private static readonly ILoggerFactory loggerFactory = LoggerFactory.Create(builder => { });

        static PolicyFundingStreamPeriodTransformer()
        {
            var config = new MapperConfiguration(cfg =>
            {
                cfg.CreateMap<FundingStreamPeriodSheetType, PolicyFundingStreamPeriod>()
                    .ForMember(dest => dest.FundingStreamPeriod,
                        opt => opt.MapFrom(src => src.FundingStreamPeriodCode))

                    // ✅ Correct usage (no <Resolver, string>)
                    .ForMember(dest => dest.PaymentCappingLevel,
                        opt => opt.MapFrom<PaymentCappingLevelTypeResolver>())

                    .ForMember(dest => dest.PaymentCappingPeriod,
                        opt => opt.MapFrom<PaymentCappingPeriodTypeResolver>())

                    .ForMember(dest => dest.PaymentMethod,
                        opt => opt.MapFrom<PolicyPaymentMethodResolver>());
            }, loggerFactory);

            _mapper = config.CreateMapper();
        }

        public static IEnumerable<PolicyFundingStreamPeriod> TransformCollection(
            IEnumerable<FundingStreamPeriodSheetType> configSheetObjects)
        {
            return _mapper.Map<IEnumerable<PolicyFundingStreamPeriod>>(configSheetObjects);
        }
    }
}
