namespace FCT.Operations.Cda.Extensions
{
    using System.Collections.Generic;
    using System.Linq;

    public static class EnumerableExtensions
    {
        public static IEnumerable<IEnumerable<TSource>> Batch<TSource>(
            this IEnumerable<TSource> source, int size)
        {
            TSource[] bucket = null;
            var count = 0;

            foreach (var item in source)
            {
                if (bucket == null)
                    bucket = new TSource[size];

                bucket[count++] = item;
                if (count != size)
                    continue;

                yield return bucket;

                bucket = null;
                count = 0;
            }

            if (bucket != null && count > 0)
                yield return bucket.Take(count);
        }

        public static IReadOnlyCollection<TSource> WhereNotIn<TSource>(this IEnumerable<TSource> items, IEnumerable<TSource> others)
        {
            return items.Where(others.DoesNotContain).ToList();
        }

        private static bool DoesNotContain<TSource>(this IEnumerable<TSource> items, TSource item)
        {
            return !items.Contains(item);
        }
    }
}
