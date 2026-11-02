namespace FCT.Console.Config.Transformers
{
    using System.Collections.Generic;
    using ExcelTypes;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model;

    public class PolicyDeliverableTransformer
    {
        public static IEnumerable<PolicyDeliverable> TransformCollection(
           IEnumerable<FundingStreamPeriodDeliverablesSheetType> configSheetObjects)
        {
            AutoMapper.Mapper.CreateMap<FundingStreamPeriodDeliverablesSheetType, PolicyDeliverable>()
                .ForMember(dest => dest.DeliverableCode,
                           opt => opt.MapFrom(src => src.DeliverableCode))
                .ForMember(dest => dest.FundingStreamPeriod,
                           opt => opt.MapFrom(src => src.FundingStreamPeriodCode))
                .ForMember(dest => dest.IsPayable,
                           opt => opt.MapFrom(src => src.IsPayable))
                .ForMember(dest => dest.ParentDeliverableCode,
                           opt => opt.MapFrom(src => src.ParentDeliverableCode));

            return AutoMapper.Mapper.Map<IEnumerable<FundingStreamPeriodDeliverablesSheetType>, IEnumerable<PolicyDeliverable>>(configSheetObjects);
        }
    }
}