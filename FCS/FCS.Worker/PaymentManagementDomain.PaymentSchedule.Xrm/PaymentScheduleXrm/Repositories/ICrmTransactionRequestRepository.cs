namespace PaymentManagementDomain.PaymentSchedule.PaymentScheduleXrm.Repositories
{
    using System.Collections.Generic;
    using Microsoft.Xrm.Sdk;

    public interface ICrmTransactionRequestRepository
    {
        void CreateEntities<T>(IReadOnlyCollection<T> entities)
            where T : Entity;

        void UpdateEntities<T>(IReadOnlyCollection<T> entities) where T : Entity;
    }
}