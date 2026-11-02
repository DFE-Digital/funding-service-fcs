namespace FCT.Console.Config.Transformers
{
    using System.Collections.Generic;
    using ExcelTypes;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;

    public static class MonitoringDeliverablesFundingStreamPeriodTransformer
    {
        public static IEnumerable<FundingStreamPeriod> TransformCollection(
            IEnumerable<FundingStreamPeriodSheetType> sheetTypes)
        {
            AutoMapper.Mapper.CreateMap<FundingStreamPeriodSheetType, FundingStreamPeriod>()
                .ForMember(dest => dest.PaymentMethod, opts => opts.ResolveUsing(new PaymentMethodTypeResolver()).FromMember(src => src.PaymentMethod));

            return
                AutoMapper.Mapper.Map<IEnumerable<FundingStreamPeriodSheetType>, IEnumerable<FundingStreamPeriod>>(
                    sheetTypes);
        }
    }
}