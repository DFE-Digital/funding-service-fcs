namespace SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Repositories
{
    using CrossDomain.Integration.Entities.Data;
    using Model;

    public class ProvisionIdentifierRepository : IProvisionIdentifierRepository
    {
        public void AddOrUpdate(ProvisionIdentifier provisionIdentifier, ConnectionInfo connectionInfo)
        {
            using (var context = new PaymentSchedulePolicyContext(connectionInfo))
            {
                UpSertHelper<ProvisionIdentifier> upSertHelper = new UpSertHelper<ProvisionIdentifier>(
                saveChanges: context.SaveChanges,
                updateExisting: context.UpdateEntry);

                upSertHelper.AddOrUpdateEntity(
                   entityToAddOrUpdate: provisionIdentifier,
                   getExisting: () => context.ProvisionIdentifiers.Find(provisionIdentifier.AllocationNumber, provisionIdentifier.VersionNumber, provisionIdentifier.ProvisionIdentifierCode),
                   dbSet: context.ProvisionIdentifiers);
            }
        }
    }
}
