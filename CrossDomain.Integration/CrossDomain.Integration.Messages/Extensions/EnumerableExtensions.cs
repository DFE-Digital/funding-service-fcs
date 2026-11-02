namespace SFA.FCT.CrossDomain.Integration.Messages.Extensions
{
    using System.Collections.Generic;
    using System.Linq;
    public static class EnumerableExtensions
    {
        public static IEnumerable<TSource> GetValueOrEmpty<TSource>(this IEnumerable<TSource> items)
        {
            return items ?? Enumerable.Empty<TSource>();
        }

        public static string ToCsv<TSource>(this IEnumerable<TSource> items)
        {
            return string.Join(", ", items.GetValueOrEmpty());
        }
    }
}
