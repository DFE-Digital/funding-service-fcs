namespace FCT.Console.Config.Transformers
{
    using System.Collections.Generic;
    using AutoMapper;
    using Microsoft.Extensions.Logging;
    public static class TypeTransformer
    {
        private static readonly ILoggerFactory loggerFactory = LoggerFactory.Create(builder => { });
        public static IEnumerable<TDestination> TransformCollection<TSource, TDestination>(
            IEnumerable<TSource> configSheetObjects)
        {            
            var config = new MapperConfiguration(cfg =>
            {
                cfg.CreateMap<TSource, TDestination>();
            }, loggerFactory);

            var mapper = config.CreateMapper();

            return mapper.Map<IEnumerable<TDestination>>(configSheetObjects);
        }

        public static TDestination Transform<TSource, TDestination>(
            TSource source)
        {
            var config = new MapperConfiguration(cfg =>
            {
                cfg.CreateMap<TSource, TDestination>();
            }, loggerFactory);


            var mapper = config.CreateMapper();

            return mapper.Map<TDestination>(source);
        }
    }
}
