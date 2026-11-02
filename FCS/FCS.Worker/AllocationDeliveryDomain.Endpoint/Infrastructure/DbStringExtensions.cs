namespace AllocationDeliveryDomain.Endpoint.Infrastructure
{
    public static class DbStringExtensions
    {
        public static object GetValueOrDbNull(this string text)
        {
            if (string.IsNullOrEmpty(text))
            {
                return System.DBNull.Value;
            }

            return text;
        }
    }
}
