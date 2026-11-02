namespace AllocationDeliveryDomain.Endpoint.Infrastructure
{
    using System;

    public static class DbIntExtensions
    {
        public static object GetValueOrDbNull(this int? intValue)
        {
            if (!intValue.HasValue)
            {
                return DBNull.Value;
            }

            return intValue;
        }
    }
}
