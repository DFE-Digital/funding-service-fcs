namespace FCT.Console.Config.Transformers
{
    using System;
    using System.Collections.Generic;
    using AutoMapper;
    using ExcelTypes;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model;
    using Microsoft.Extensions.Logging;
    public static class SubnominalTransformer
    {
        private static readonly IMapper _mapper;
        private static readonly ILoggerFactory loggerFactory = LoggerFactory.Create(builder => { });

        static SubnominalTransformer()
        {
            var config = new MapperConfiguration(cfg =>
            {
                cfg.CreateMap<SubnominalsSheetType, PolicySubnominal>()
                    .ForMember(dest => dest.SubnominalCode,
                        opts => opts.MapFrom(src => int.Parse(src.SubnominalCode)))

                    // ✅ Inline mapping instead of resolver
                    .ForMember(dest => dest.PaymentType,
                        opts => opts.MapFrom(src =>
                            string.IsNullOrWhiteSpace(src.PaymentType)
                                ? null
                                : (PaymentType?)Enum.Parse(
                                    typeof(PaymentType),
                                    src.PaymentType.Replace(" ", ""),
                                    true)));
            }, loggerFactory);

            _mapper = config.CreateMapper();
        }

        public static IEnumerable<PolicySubnominal> TransformCollection(
            IEnumerable<SubnominalsSheetType> sheetTypes)
        {
            return _mapper.Map<IEnumerable<PolicySubnominal>>(sheetTypes);
        }
    }
}