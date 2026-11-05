namespace PaymentManagement.Calculation.Extensions
{
    using System.Collections.Generic;
    using Optional;

    public static class ListExtensions
    {
        public static Option<T> GetItemAtIndexOrNone<T>(this List<T> items, int index)
        {
            if (index >= 0 && items.Count > index)
            {
                return items[index].Some();
            }

            return new Option<T>();
        }
    }
}
