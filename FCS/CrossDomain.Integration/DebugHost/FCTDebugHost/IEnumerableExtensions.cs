namespace SFA.FCT.FCTDebugHost
{
    using System;
    using System.Collections.Generic;

    internal static class EnumerableExtensions
    {
        public static IEnumerable<T> Act<T>(this IEnumerable<T> list, Action<T> action)
        {
            foreach (T entry in list)
            {
                action(entry);
            }

            return list;
        }
    }
}
