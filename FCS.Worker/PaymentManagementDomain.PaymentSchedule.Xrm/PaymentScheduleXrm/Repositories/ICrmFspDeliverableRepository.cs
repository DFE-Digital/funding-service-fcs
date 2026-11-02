namespace PaymentManagementDomain.PaymentSchedule.PaymentScheduleXrm.Repositories
{
    using System.Collections.Generic;

    public interface ICrmFspDeliverableRepository
    {
        IReadOnlyCollection<FspDeliverableInfo> GetFundingStreamPeriodDeliverables(string fundingStreamPeriodCode);
    }
}