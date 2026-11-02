namespace FundingAllocation.Extensions
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;

    public static class ListExtensions
    {
        public static IEnumerable<IReadOnlyCollection<T>> GetBatchesOfSize<T>(this List<T> source, int batchSize)
        {
            if (source.IsEmpty() || batchSize <= 0)
            {
                yield break;
            }

            var indexer = 0;

            while (indexer < source.Count)
            {
                yield return source.GetRange(indexer, Math.Min(batchSize, source.Count - indexer));

                indexer += batchSize;
            }
        }

        public static async Task IfAny<T>(this IReadOnlyCollection<T> items, Func<IReadOnlyCollection<T>, Task> asyncFunc)
        {
            if (items.Any())
            {
                await asyncFunc(items);
            }
        }

        public static async Task IfAnyThenOneAtATimeAsync<T>(this IReadOnlyCollection<T> items, params Func<IReadOnlyCollection<T>, Task>[] asyncFuncs)
        {
            if (items.Any())
            {
                foreach (var asyncFunc in asyncFuncs)
                {
                    await asyncFunc(items);
                }
            }
        }
    }
}
