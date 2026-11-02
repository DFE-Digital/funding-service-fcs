namespace FCT.Console.Config.Tests.Reseed
{
    using Synchronizers.Writers.CRM;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Common.PagedStorage;
    using SFA.FCT.CrossDomain.Integration.Common.PagedStorage.Repositories;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.FundingStreamConfigDomain.BusinessLogic.FundingPolicySeed;

    [TestClass]
    public class ReseedDeliverableAtomFeedStorageTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void DeliverableSettingConfigurationSeed_ShouldRunSeedAndDataInFeedShouldContainAllSeedData()
        {
            var logger = new SimpleConsoleLogger();
            var azureRepository = new AzureDeliverableSettingConfigurationRepository(
                new EnvironmentContext(), new AzureTableStore(), new StorageObjectSerializer(), logger);
            var pagedStorageSeedRunner = new PagedStorageSeedRunner<DeliverableSettingConfiguration>(logger, azureRepository);
            var pagedStorageSeed = new DeliverableSettingConfigurationSeed(CrmHelper.GetConnection());

            azureRepository.Clear();

            pagedStorageSeedRunner.ExecuteBulkReseed(pagedStorageSeed);
        }
    }
}