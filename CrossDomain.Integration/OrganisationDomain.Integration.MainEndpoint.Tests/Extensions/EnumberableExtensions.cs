namespace OrganisationDomain.Integration.MainEndpoint.Tests.Extensions
{
    using System.Collections.Generic;
    using System.Linq;

    public static class EnumberableExtensions
    {
        public static IEnumerable<TCastType> CastWhere<TCastType>(this IEnumerable<object> source)
        {
            return source.Where(item => item.GetType() == typeof(TCastType)).Cast<TCastType>();
        }
    }
}
