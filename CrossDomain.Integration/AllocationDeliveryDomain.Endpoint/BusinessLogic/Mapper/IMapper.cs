namespace AllocationDeliveryDomain.Endpoint.BusinessLogic.Mapper
{
    using System.Collections.Generic;

    public interface IMapper<in TSource, out TTarget> where TSource : class
        where TTarget : class
    {
        IEnumerable<TTarget> Map(IEnumerable<TSource> source);
    }
}