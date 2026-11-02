namespace DocumentsDomain.Endpoint.Tests.ArchiveDocument.Services
{
    using System.IO;
    using System.Linq;
    using System.Reflection;
    using Endpoint.ArchiveDocument;
    using Endpoint.ArchiveDocument.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Newtonsoft.Json;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;
    using SFA.FCT.CrossDomain.Integration.Events;

    [TestClass]
    public class ArchiveFileOrchestratorIntegrationTests
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void ArchiveFileOrchestrator_OrchestrateNotification_ShouldCallDeleteCorrectlyWhenFilesFound()
        {
            ArchiveFileOrchestrator orchestrator = new ArchiveFileOrchestrator(new Office365StorageWrapper());

            ContractApprovedEvent contractApprovedEvent =
                FromJson<ContractApprovedEvent>("DocumentsDomain.Endpoint.Tests",
                    "Resources.ContractApprovedEvent.json");
            
            // act
            var fileInfos = orchestrator.OrchestrateForNotification(contractApprovedEvent.CorporateContract);

            // assert
            Assert.AreEqual(2, fileInfos.Count);
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void ArchiveFileOrchestrator_OrchestrateNonNotification_ShouldCallDeleteCorrectlyWhenFilesFound()
        {
           

            ArchiveFileOrchestrator orchestrator = new ArchiveFileOrchestrator(new Office365StorageWrapper());

            ContractApprovedEvent contractApprovedEvent =
                FromJson<ContractApprovedEvent>("DocumentsDomain.Endpoint.Tests",
                    "Resources.ContractApprovedEvent_Levy.json");

            // act
            var fileInfos = orchestrator.OrchestrateForNonNotification(
                contractApprovedEvent.CorporateContract);

            // assert
            Assert.AreEqual(0, fileInfos.Count(fi => fi.FileAction == FileAction.Delete));
            Assert.AreEqual(3, fileInfos.Count(fi => fi.FileAction == FileAction.Archive));
        }

        private static T FromJson<T>(string nameSpace, string resourceName)
        {
            using (Stream stream = Assembly.GetCallingAssembly().GetManifestResourceStream($"{nameSpace}.{resourceName}"))
            using (StreamReader streamReader = new StreamReader(stream))
            {
                return JsonConvert.DeserializeObject<T>(streamReader.ReadToEnd());
            }
        }
    }
}
