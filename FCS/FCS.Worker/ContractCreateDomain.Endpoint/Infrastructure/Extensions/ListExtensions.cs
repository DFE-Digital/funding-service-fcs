namespace ContractCreateDomain.Endpoint.Infrastructure.Extensions
{
    using System;
    using System.Collections.Generic;
    using System.Linq;

    internal static class ListExtensions
    {
        public static decimal? SumIfAny<T>(this IList<T> items, Func<T, decimal?> selector)
        {
            List<decimal?> valuesToSum = items.Select(selector).Where(d => d.HasValue).ToList();

            return valuesToSum.Any() ? valuesToSum.Sum() : null;
        }
    }
}
