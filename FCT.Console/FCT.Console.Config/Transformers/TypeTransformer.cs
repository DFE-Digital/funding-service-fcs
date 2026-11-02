namespace FCT.Console.Config.Transformers
{
    using System.Collections.Generic;

    public static class TypeTransformer
    {
        public static IEnumerable<TDestination> TransformCollection<TSource, TDestination>(
            IEnumerable<TSource> configSheetObjects)
        {
            AutoMapper.Mapper.CreateMap<TSource, TDestination>();
    
            return AutoMapper.Mapper.Map<IEnumerable<TSource>, IEnumerable<TDestination>>(configSheetObjects);
        }

        public static TDestination Transform<TSource, TDestination>(
            TSource source)
        { 
            AutoMapper.Mapper.CreateMap<TSource, TDestination>();

            return AutoMapper.Mapper.Map<TSource, TDestination>(source);
        }
    }
}
