namespace SFA.FCT.ContractCreateDomain.BusinessLogic
{
    using System.Collections.Generic;
    using AutoMapper;

    public static class CollectionTransformer
    {
        /// <summary>
        /// Transforms a collection using the provided IMapper instance.
        /// Assumes a TSource -> TDestination map is already configured.
        /// </summary>
        public static IReadOnlyCollection<TDestination> Transform<TSource, TDestination>(
            IReadOnlyCollection<TSource> sourceItems,
            IMapper mapper)
        {
            if (sourceItems is null) return null;
            // Maps a collection using the existing configuration
            return mapper.Map<IReadOnlyCollection<TSource>, IReadOnlyCollection<TDestination>>(sourceItems);
        }
    }
}
