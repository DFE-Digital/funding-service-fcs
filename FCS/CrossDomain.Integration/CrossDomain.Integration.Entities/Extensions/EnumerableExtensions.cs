namespace SFA.FCT.CrossDomain.Integration.Entities.Extensions
{
    using System.Collections.Generic;
    using System.Linq;
    public static class EnumerableExtensions
    {
        public static bool None<TItem>(this IEnumerable<TItem> items, TItem itemToFind)
        {
            return !items.Contains(itemToFind);
        }
    }
}
