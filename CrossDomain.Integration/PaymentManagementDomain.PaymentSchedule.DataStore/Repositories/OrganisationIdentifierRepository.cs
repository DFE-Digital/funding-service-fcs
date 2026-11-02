namespace SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Repositories
{
    using System.Linq;
    using CrossDomain.Integration.Entities.Data;
    using Model;

    public class OrganisationIdentifierRepository : IOrganisationIdentifierRepository
    {
        public OrganisationIdentifer GetOrganisationIdentiferForAllocation(string allocationNumber, int versionNumber, ConnectionInfo connectionInfo)
        {
            using (var context = new PaymentSchedulePolicyContext(connectionInfo))
            {
                return
                     context.OrganisationIdentifiers.Single(
                        o => o.AllocationNumber == allocationNumber && o.VersionNumber == versionNumber);
            }
        }

        public void AddOrUpdate(OrganisationIdentifer organisationIdentifer, ConnectionInfo connectionInfo)
        {
            using (var context = new PaymentSchedulePolicyContext(connectionInfo))
            {
                UpSertHelper<OrganisationIdentifer> upSertHelper = new UpSertHelper<OrganisationIdentifer>(
                    saveChanges: context.SaveChanges,
                    updateExisting: context.UpdateEntry);

                upSertHelper.AddOrUpdateEntity(
                    entityToAddOrUpdate: organisationIdentifer,
                    getExisting: () => context.OrganisationIdentifiers.Find(
                        organisationIdentifer.AllocationNumber,
                        organisationIdentifer.VersionNumber,
                        organisationIdentifer.MainOrganisationIdentifier,
                        organisationIdentifer.OrganisationId),
                    dbSet: context.OrganisationIdentifiers);
            }
        }
    }
}
