namespace AllocationDeliveryDomain.Endpoint.ActualsPull.Extensions
{
    public static class StringExtensions
    {
        public static string GetValueOrDefault(this string s, string defaultValue)
        {
            return string.IsNullOrEmpty(s) ? defaultValue : s;
        }
    }
}
