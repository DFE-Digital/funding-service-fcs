namespace PaymentManagement.Calculation.Repositories
{
    using Dtos;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IOrganisationDetailsRepository
    {
        OrganisationDetails GetOrganisationDetailsForAllocation(string allocationNumber, int versionNumber, ConnectionInfo connectionInfo);
    }
}
