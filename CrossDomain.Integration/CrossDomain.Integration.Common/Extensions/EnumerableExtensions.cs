namespace SFA.FCT.CrossDomain.Integration.Common.Extensions
{
    using System;
    using System.Collections.Generic;
    using System.Linq;

    public static class EnumerableExtensions
    {
        public static bool None<T>(this IEnumerable<T> items, Func<T, bool> predicate)
        {
            return items.All(item => predicate(item) == false);
        }

        public static bool None<T>(this IEnumerable<T> items)
        {
            return !items.Any();
        }

        public static bool Empty<T>(this IEnumerable<T> items)
        {
            return !items.Any();
        }
    }
}
