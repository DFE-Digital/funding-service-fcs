namespace SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Cache
{
    using System;

    public interface IFundingStreamPeriodCache
    {
        object Add(string key, object value, TimeSpan expiration);

        object Get(string key);
    }
}