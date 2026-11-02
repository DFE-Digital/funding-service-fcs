using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace XrmTestModel.Extensions
{
    internal static class IEnumerableExtensions
    {
        public static IEnumerable<T> IfNotNull<T>(this IEnumerable<T> source)
        {
            return source ?? Enumerable.Empty<T>();
        }

    }
}
