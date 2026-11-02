namespace OrganisationDomain.Integration.MainEndpoint.Extensions
{
    using System.Collections.Generic;
    using System.Linq;

    public static class ListExtensions
    {
        public static IEnumerable<IEnumerable<T>> Batch<T>(this IList<T> items,
            int batchSize)
        {
            return items.Select((item, index) => new { item, index })
                .GroupBy(itemWithIndex => itemWithIndex.index / batchSize)
                .Select(g => g.Select(itemWithIndex => itemWithIndex.item));
        }
    }
}
