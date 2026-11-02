namespace SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Repositories
{
    using CrossDomain.Integration.Entities.Data;
    using Model;

    public interface IOrganisationIdentifierRepository
    {
        OrganisationIdentifer GetOrganisationIdentiferForAllocation(string allocationNumber, int versionNumber, ConnectionInfo connectionInfo);
        void AddOrUpdate(OrganisationIdentifer provisionIdentifier, ConnectionInfo connectionInfo);
    }
}
