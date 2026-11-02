namespace PaymentManagementDomain.PaymentSchedule.PaymentAggregated.Repositories
{
    using System;

    public interface IOrganisationRepository
    {
        Guid GetOrganisationEntityId(string ukprn);
    }
}