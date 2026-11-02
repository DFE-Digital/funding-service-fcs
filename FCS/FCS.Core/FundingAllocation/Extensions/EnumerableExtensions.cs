namespace FundingAllocation.Extensions
{
    using System;
    using System.Collections.Generic;
    using System.Linq;

    public static class EnumerableExtensions
    {
        public static bool Unanimous<TSource, TValue>(this IEnumerable<TSource> items, Func<TSource, TValue> valueSelector)
        {
            return items.Select(valueSelector).Distinct().Count() == 1;
        }

        public static IEnumerable<TSource> GetValueOrEmpty<TSource>(this IEnumerable<TSource> items)
        {
            return items ?? Enumerable.Empty<TSource>();
        }

        public static string ToCsv<TSource>(this IEnumerable<TSource> items)
        {
            return string.Join(", ", items.GetValueOrEmpty());
        }

        public static bool DoesNotContain<TSource>(this IEnumerable<TSource> items, TSource item)
        {
            return !items.Contains(item);
        }

        public static IReadOnlyCollection<TSource> WhereNotIn<TSource>(this IEnumerable<TSource> items, IEnumerable<TSource> others)
        {
            return items.Where(others.DoesNotContain).ToList();
        }

        public static bool NotAny<TSource>(this IEnumerable<TSource> items, Func<TSource, bool> predicate)
        {
            return !items.Any(predicate);
        }
    }
}
