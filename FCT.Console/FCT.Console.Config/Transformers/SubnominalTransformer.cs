namespace FCT.Console.Config.Transformers
{
    using System.Collections.Generic;
    using ExcelTypes;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model;

    public static class SubnominalTransformer
    {
        public static IEnumerable<PolicySubnominal> TransformCollection(
            IEnumerable<SubnominalsSheetType> sheetTypes)
        {
            AutoMapper.Mapper.CreateMap<SubnominalsSheetType, PolicySubnominal>()
                .ForMember(dest => dest.SubnominalCode, opts => opts.MapFrom(source => int.Parse(source.SubnominalCode)))
                .ForMember(dest => dest.PaymentType, map => map.ResolveUsing(
                    new PaymentTypeResolver()).FromMember(source => source.PaymentType));

            return AutoMapper.Mapper.Map<IEnumerable<SubnominalsSheetType>, IEnumerable<PolicySubnominal>>(sheetTypes);
        }
    }
}
