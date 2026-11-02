namespace FCT.Console.Config.Transformers
{
    using System.Collections.Generic;
    using ExcelTypes;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model;

    public class PolicyFundingStreamPeriodTransformer
    {
        public static IEnumerable<PolicyFundingStreamPeriod> TransformCollection(
           IEnumerable<FundingStreamPeriodSheetType> configSheetObjects)
        {
            AutoMapper.Mapper.CreateMap<FundingStreamPeriodSheetType, PolicyFundingStreamPeriod>()
                .ForMember(dest => dest.FundingStreamPeriod,
                           opt => opt.MapFrom(src => src.FundingStreamPeriodCode))
                .ForMember(dest => dest.PaymentCappingLevel,
                           map => map.ResolveUsing(
                           new PaymentCappingLevelTypeResolver()).FromMember(source => source.PaymentCappingLevel))
                .ForMember(dest => dest.PaymentCappingPeriod,
                           map => map.ResolveUsing(
                           new PaymentCappingPeriodTypeResolver()).FromMember(source => source.PaymentCappingPeriod))
                .ForMember(dest => dest.PaymentMethod,
                           map => map.ResolveUsing(
                           new PolicyPaymentMethodResolver()).FromMember(source => source.PaymentMethod));



            return AutoMapper.Mapper.Map<IEnumerable<FundingStreamPeriodSheetType>, IEnumerable<PolicyFundingStreamPeriod>>(configSheetObjects);
        }
    }
}
