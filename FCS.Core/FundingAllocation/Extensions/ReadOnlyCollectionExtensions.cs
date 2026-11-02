namespace FundingAllocation.Extensions
{
    using System;
    using System.Collections.Generic;
    using System.Linq;

    public static class ReadOnlyCollectionExtensions
    {
        public static bool IsEmpty<T>(this IReadOnlyCollection<T> items)
        {
            return items == null || items.Count == 0;
        }

        public static void ShouldNotBeEmpty<T>(this IReadOnlyCollection<T> items, string errorMessage)
        {
            if (items.IsEmpty())
            {
                throw new InvalidOperationException(errorMessage);
            }
        }

        public static void ShouldContainOne<T>(this IReadOnlyCollection<T> items, string errorMessage)
        {
            if (items.Count != 1)
            {
                throw new InvalidOperationException(errorMessage);
            }
        }

        public static IReadOnlyCollection<T> GetValueOrEmpty<T>(this IReadOnlyCollection<T> items)
        {
            if (items == null)
            {
                return new List<T>();
            }

            return items;
        }

        public static string ToCsvOrCountIfTooMany<TSource>(this IReadOnlyCollection<TSource> items)
        {
            items = items.GetValueOrEmpty().ToList();
            if (items.Count < 10)
            {
                return items.ToCsv();
            }

            return items.Count.ToString();
        }

        public static IReadOnlyCollection<TSource> ToReadonlyCollection<TSource>(this IEnumerable<TSource> source)
        {
            return source.ToList();
        }
    }
}
