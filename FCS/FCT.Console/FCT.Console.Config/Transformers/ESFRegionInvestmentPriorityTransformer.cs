namespace FCT.Console.Config.Transformers
{
    using System.Collections.Generic;
    using ExcelTypes;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model;

    public static class ESFRegionInvestmentPriorityTransformer
    {
        public static IEnumerable<ESFRegionInvestmentPriority> TransformCollection(
            IEnumerable<ESFRegionInvestmentPrioritySheetType> sheetTypes)
        {
            AutoMapper.Mapper.CreateMap<ESFRegionInvestmentPrioritySheetType, ESFRegionInvestmentPriority>()
                .ForMember(dest => dest.InvestmentPriority, opts => opts.MapFrom(source => source.InvestmentPriorityDecimal));

            return AutoMapper.Mapper.Map<IEnumerable<ESFRegionInvestmentPrioritySheetType>, IEnumerable<ESFRegionInvestmentPriority>>(sheetTypes);
        }
    }
}
