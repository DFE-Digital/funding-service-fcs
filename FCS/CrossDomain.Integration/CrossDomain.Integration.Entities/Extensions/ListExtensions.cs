namespace SFA.FCT.CrossDomain.Integration.Entities.Extensions
{
    using System.Collections.Generic;

    public static class ListExtensions
    {
        public static void AddIfHasValue(this IList<string> items, string text)
        {
            if (text.HasValue())
            {
                items.Add(text);
            }
        }
    }
}
