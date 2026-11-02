using System.Collections.Generic;

namespace PerformanceManagementDomain.Extensions
{
    public static class EnumerableExtensions
    {
        public static ISet<T> ToHashSet<T>(this IEnumerable<T> source)
        {
            return new HashSet<T>(source);
        }
    }
}