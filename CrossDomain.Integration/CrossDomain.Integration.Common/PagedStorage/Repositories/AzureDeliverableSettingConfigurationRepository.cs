namespace SFA.FCT.CrossDomain.Integration.Common.PagedStorage.Repositories
{
    using System;
    using Framework.Logging.Interfaces;
    using Integration.Entities;
    using Storage;

    public class AzureDeliverableSettingConfigurationRepository
        : AzurePagedStorageRepository<DeliverableSettingConfiguration>, IPagedStorageRepository<DeliverableSettingConfiguration>
    {
        private const string StorageTableName = "DeliverableSettingConfiguration";

        public AzureDeliverableSettingConfigurationRepository(
            IEnvironmentContext context, IAzureTableStore azureTableStore, IStorageObjectSerializer storageObjectSerializer, ILogger logger)
            : base(StorageTableName + context.StorageTableSuffix, azureTableStore, storageObjectSerializer, logger)
        {
        }

        public void Add(DeliverableSettingConfiguration setting)
        {
            AssertIsValidContract(setting);

            Add(setting, Guid.NewGuid().ToString());
        }

        private static void AssertIsValidContract(DeliverableSettingConfiguration setting)
        {
            if (setting == null)
            {
                throw new ArgumentException("Setting cannot be null");
            }
        }
    }
}
