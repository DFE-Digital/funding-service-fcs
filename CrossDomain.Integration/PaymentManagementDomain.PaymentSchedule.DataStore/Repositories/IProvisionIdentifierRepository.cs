namespace SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Repositories
{
    using CrossDomain.Integration.Entities.Data;
    using Model;

    public interface IProvisionIdentifierRepository
    {
        void AddOrUpdate(ProvisionIdentifier provisionIdentifier, ConnectionInfo connectionInfo);

    }
}
