namespace AllocationDeliveryDomain.Endpoint.ContractUnderTerminationEndpoint.Extensions
{
    using System;
    using System.Collections.Generic;
    using System.Threading.Tasks;

    public static class EnumerableExtensions
    {
        public static async Task WhenAllOneByOne<T>(this IEnumerable<T> source, Func<T, Task> action)
        {
            foreach (T item in source)
            {
                await action(item)
                    .ConfigureAwait(continueOnCapturedContext: false);
            }
        }
    }
}