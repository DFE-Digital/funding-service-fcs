namespace DocumentsDomain.Endpoint.Tests.ArchiveDocument.Services
{
    using System.Collections.Generic;
    using System.Linq;
    using Endpoint.ArchiveDocument;
    using Endpoint.ArchiveDocument.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;

    [TestClass]
    public class ArchiveFileOrchestratorTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ArchiveFileOrchestrator_ShouldOrchestrateNotification()
        {
            // arrange
            Mock<IOffice365Adapter> office365AdapterMock = new Mock<IOffice365Adapter>();
            office365AdapterMock.Setup(o => o.GetFilenamesByFileNameStartText(It.IsAny<string>(), It.IsAny<string>()))
                .Returns(new List<string>
                {
                    ""
                });

            ArchiveFileOrchestrator orchestrator = new ArchiveFileOrchestrator(office365AdapterMock.Object);

            contract contract = new contract
            {
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        fundingType = new fundingType
                        {
                            fundingTypeCode = "FT"
                        },
                        period = new period()
                    }
                }
            };

            // act
            var fileInfos = orchestrator.OrchestrateForNotification(contract);

            // assert
            Assert.AreEqual(1, fileInfos.Count(f => f.FileAction == FileAction.Delete));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ArchiveFileOrchestrator_ShouldOrchestrateNonNotification()
        {
            // arrange
            Mock<IOffice365Adapter> office365AdapterMock = new Mock<IOffice365Adapter>();
            office365AdapterMock.Setup(o => o.GetFilenamesByFileNameStartText(It.IsAny<string>(), It.IsAny<string>()))
                .Returns(new List<string>
                {
                    ""
                });

            ArchiveFileOrchestrator orchestrator = new ArchiveFileOrchestrator(office365AdapterMock.Object);

            contract contract = new contract
            {
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        fundingType = new fundingType
                        {
                            fundingTypeCode = "FT"
                        },
                        period = new period()
                    }
                }
            };

            // act
            var fileInfos = orchestrator.OrchestrateForNonNotification(contract);

            // assert
            Assert.AreEqual(1, fileInfos.Count(f => f.FileAction == FileAction.Archive));
        }
    }
}
