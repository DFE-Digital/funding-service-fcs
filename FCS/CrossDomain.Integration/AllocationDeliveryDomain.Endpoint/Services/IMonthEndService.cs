namespace AllocationDeliveryDomain.Endpoint.Services
{
    using System;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IMonthEndService
    {
        void MarkMonthEndAsStarted(ConnectionInfo connectionInfo);

        void MarkMonthEndAsCompleted(ConnectionInfo connectionInfo);

        bool HasMonthEndInitialDeferralPeriodExpired(ConnectionInfo connectionInfo);

        bool HasMonthEndServiceBusActivityCompleted();

        TimeSpan MonthEndCheckDeferralTime { get; }
    }
}
