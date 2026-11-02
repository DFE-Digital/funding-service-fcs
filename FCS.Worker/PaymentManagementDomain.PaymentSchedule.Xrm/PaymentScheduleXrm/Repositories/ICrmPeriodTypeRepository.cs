namespace PaymentManagementDomain.PaymentSchedule.PaymentScheduleXrm.Repositories
{
    using Microsoft.Xrm.Sdk;

    public interface ICrmPeriodTypeRepository
    {
        EntityReference GetCalendarMonthPeriodType();
    }
}