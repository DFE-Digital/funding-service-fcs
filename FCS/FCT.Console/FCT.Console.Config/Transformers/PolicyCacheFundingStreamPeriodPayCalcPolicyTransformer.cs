namespace FCT.Console.Config.Transformers
{
    using System.Collections.Generic;
    using AutoMapper;
    using ExcelTypes;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model;

    public class PolicyCacheFundingStreamPeriodPayCalcPolicyTransformer
    {
        public static IEnumerable<FundingStreamPeriodPayCalcPolicy> TransformCollection(IEnumerable<FundingStreamPeriodPayCalcPolicySheetType> rows)
        {
            Mapper
                .CreateMap<FundingStreamPeriodPayCalcPolicySheetType, FundingStreamPeriodPayCalcPolicy>()
                .ForMember(
                    dest => dest.PaymentCappingPeriod,
                    map => map.ResolveUsing(new PaymentCappingPeriodTypeResolver()).FromMember(source => source.PaymentCappingPeriod));

            return Mapper.Map<IEnumerable<FundingStreamPeriodPayCalcPolicySheetType>, IEnumerable<FundingStreamPeriodPayCalcPolicy>>(rows);
        }
    }
}
