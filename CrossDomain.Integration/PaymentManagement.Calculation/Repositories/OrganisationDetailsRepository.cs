namespace PaymentManagement.Calculation.Repositories
{
    using System.Linq;
    using Dtos;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore;

    public class OrganisationDetailsRepository : IOrganisationDetailsRepository
    {
        public OrganisationDetails GetOrganisationDetailsForAllocation(string allocationNumber, int versionNumber, ConnectionInfo connectionInfo)
        {
            using (var context = new PaymentSchedulePolicyContext(connectionInfo))
            {
                return context.OrganisationIdentifiers
                    .Where(o => o.AllocationNumber == allocationNumber && o.VersionNumber == versionNumber)
                    .ToList()
                    .Select(o => new OrganisationDetails(organisationId: o.MainOrganisationIdentifier, ukprn: int.Parse(o.OrganisationId)))
                    .Single();
            }
        }
    }
}