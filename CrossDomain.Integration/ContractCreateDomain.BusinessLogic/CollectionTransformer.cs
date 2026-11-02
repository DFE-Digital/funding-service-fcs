namespace SFA.FCT.ContractCreateDomain.BusinessLogic
{
    using System.Collections.Generic;

    public static class CollectionTransformer
    {
        public static IReadOnlyCollection<TDestination> Transform<TSource, TDestination>(IReadOnlyCollection<TSource> sourceItems)
        {
            AutoMapper.Mapper.CreateMap<TSource, TDestination>();

            return AutoMapper.Mapper.Map<IReadOnlyCollection<TSource>, IReadOnlyCollection<TDestination>>(sourceItems);
        }
    }
}
