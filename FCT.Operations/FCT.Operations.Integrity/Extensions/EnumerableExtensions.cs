namespace SFA.FCT.Operations.Integrity.Extensions
{ 
    using System.Collections.Generic;
    using System.Linq;

    public static class EnumerableExtensions
    {
        public static int GetHashcodeOfCollection<T>(this IEnumerable<T> items)
        {
            const int primeNumber1 = 19;
            const int primeNumber2 = 31;
            unchecked
            {
                return items.Aggregate(seed: primeNumber1, func: (current, item) => current*primeNumber2 + item.GetHashCode());
            }
        }
    }
}
