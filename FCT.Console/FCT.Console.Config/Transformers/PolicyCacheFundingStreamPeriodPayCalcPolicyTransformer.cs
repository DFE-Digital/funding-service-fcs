namespace FCT.Console.Config.Transformers
{
    using System;
    using System.Collections.Generic;
    using AutoMapper;
    using ExcelTypes;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model;
    using Microsoft.Extensions.Logging;
    public class PolicyCacheFundingStreamPeriodPayCalcPolicyTransformer
    {
        private static readonly IMapper _mapper;
        private static readonly ILoggerFactory loggerFactory = LoggerFactory.Create(builder => { });

        static PolicyCacheFundingStreamPeriodPayCalcPolicyTransformer()
        {
            var config = new MapperConfiguration(cfg =>
            {
                cfg.CreateMap<FundingStreamPeriodPayCalcPolicySheetType, FundingStreamPeriodPayCalcPolicy>()

                    // ✅ Inline mapping (no resolver needed)
                    .ForMember(dest => dest.PaymentCappingPeriod,
                        opt => opt.MapFrom(src =>
                            string.IsNullOrWhiteSpace(src.PaymentCappingPeriod)
                                ? null
                                : (PaymentCappingPeriodType?)Enum.Parse(
                                    typeof(PaymentCappingPeriodType),
                                    src.PaymentCappingPeriod.Replace(" ", "") == "ContractAllocationDuration"
                                        ? "ContractDuration"
                                        : src.PaymentCappingPeriod.Replace(" ", ""),
                                    true)));
            }, loggerFactory);

            _mapper = config.CreateMapper();
        }

        public static IEnumerable<FundingStreamPeriodPayCalcPolicy> TransformCollection(
            IEnumerable<FundingStreamPeriodPayCalcPolicySheetType> rows)
        {
            return _mapper.Map<IEnumerable<FundingStreamPeriodPayCalcPolicy>>(rows);
        }
    }
}
