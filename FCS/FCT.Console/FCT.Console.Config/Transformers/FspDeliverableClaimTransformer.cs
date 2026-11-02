namespace FCT.Console.Config.Transformers
{
    using System.Collections.Generic;
    using ExcelTypes;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;

    public static class FspDeliverableClaimTransformer
    {
        public static IEnumerable<FspDeliverableClaim> TransformCollection(
            IEnumerable<FundingStreamPeriodDeliverablesSheetType> sheetTypes)
        {
            AutoMapper.Mapper.CreateMap<FundingStreamPeriodDeliverablesSheetType, FspDeliverableClaim>()
                .ForMember(dest => dest.AllowClaim, opts => opts.MapFrom(source => source.AllowClaim))
                .ForMember(dest => dest.DeliverableCode, opts => opts.MapFrom(source => source.DeliverableCode))
                .ForMember(dest => dest.FspCode, opts => opts.MapFrom(source => source.FundingStreamPeriodCode))
                .ForMember(dest => dest.ClaimReconciliationDeliverableGroupCode,
                    opts => opts.MapFrom(source => source.ClaimReconciliationDeliverableGroupCode));

            return
                AutoMapper.Mapper
                    .Map<IEnumerable<FundingStreamPeriodDeliverablesSheetType>, IEnumerable<FspDeliverableClaim>>(
                        sheetTypes);
        }
    }
}