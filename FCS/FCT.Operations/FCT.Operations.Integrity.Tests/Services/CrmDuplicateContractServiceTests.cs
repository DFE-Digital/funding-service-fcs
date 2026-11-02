namespace FCT.Operations.Integrity.Tests.Services
{
    using SFA.FCT.Operations.Integrity.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.Operations.Integrity.Services;
    using Moq;
    using System.Collections.Generic;
    using SFA.FCT.Operations.Integrity.DTOs;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class CrmDuplicateContractServiceTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void CrmDuplicateContractService_IdentifyNewDuplicateContracts_ShouldRefreshDuplicatedContractsWhenThereAreNewCrmDuplicateContracts()
        {
            // Arrange
            var duplicateContractRepositoryMock = new Mock<IDuplicateContractRepository>();
            duplicateContractRepositoryMock.Setup(dcr => dcr.GetDuplicatedContracts())
                .Returns(new List<DuplicateContract>
                {
                    new DuplicateContract("contract_1", 1, 0, 0, 1),
                    new DuplicateContract("contract_2", 1, 0, 0, 1),
                    new DuplicateContract("contract_3", 1, 0, 0, 1)
                });

            var crmDuplicateContractRepositoryMock = new Mock<ICrmDuplicateContractRepository>();
            crmDuplicateContractRepositoryMock.Setup(cdcr => cdcr.GetDuplicatedContracts())
                .Returns(new List<DuplicateContract>
                {
                    new DuplicateContract("contract_1", 1, 0, 0, 1),
                    new DuplicateContract("contract_2", 1, 0, 0, 1),
                    new DuplicateContract("contract_3", 1, 0, 0, 1),
                    new DuplicateContract("contract_4", 1, 0, 0, 1)
                });

            var crmDuplicateContractService = new CrmDuplicateContractService(crmDuplicateContractRepositoryMock.Object,
                duplicateContractRepositoryMock.Object);

            // Act
            crmDuplicateContractService.IdentifyNewDuplicateContracts(Mock.Of<ILogger>());

            // Assert
            duplicateContractRepositoryMock.Verify(dcr => 
                    dcr.RefreshDuplicatedContracts(It.IsAny<IReadOnlyCollection<DuplicateContract>>()), Times.Once,"We have not updated the PAAS table");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void
            CrmDuplicateContractService_IdentifyNewDuplicateContracts_ShouldNotRefreshDuplicatedContractsWhenThereAreNoChanges()
        {
            // Arrange
            var duplicateContractRepositoryMock = new Mock<IDuplicateContractRepository>();
            duplicateContractRepositoryMock.Setup(dcr => dcr.GetDuplicatedContracts())
                .Returns(new List<DuplicateContract>
                {
                    new DuplicateContract("contract_1", 1, 0, 0, 1),
                    new DuplicateContract("contract_2", 1, 0, 0, 1),
                    new DuplicateContract("contract_3", 1, 0, 0, 1)
                });

            var crmDuplicateContractRepositoryMock = new Mock<ICrmDuplicateContractRepository>();
            crmDuplicateContractRepositoryMock.Setup(cdcr => cdcr.GetDuplicatedContracts())
                .Returns(new List<DuplicateContract>
                {
                    new DuplicateContract("contract_1", 1, 0, 0, 1),
                    new DuplicateContract("contract_2", 1, 0, 0, 1),
                    new DuplicateContract("contract_3", 1, 0, 0, 1)
                });

            var crmDuplicateContractService = new CrmDuplicateContractService(crmDuplicateContractRepositoryMock.Object,
                duplicateContractRepositoryMock.Object);

            // Act
            crmDuplicateContractService.IdentifyNewDuplicateContracts(Mock.Of<ILogger>());

            // Assert
            duplicateContractRepositoryMock.Verify(dcr =>
                    dcr.RefreshDuplicatedContracts(It.IsAny<IReadOnlyCollection<DuplicateContract>>()), Times.Never,
                "We have updated the PAAS table");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CrmDuplicateContractService_IdentifyNewDuplicateContracts_ShouldRefreshDuplicatedContractsWhenSomeItemsInPaasListAreNoLongerDuplicatesInCrm()
        {
            // Arrange
            var duplicateContractRepositoryMock = new Mock<IDuplicateContractRepository>();
            duplicateContractRepositoryMock.Setup(dcr => dcr.GetDuplicatedContracts())
                .Returns(new List<DuplicateContract>
                {
                    new DuplicateContract("contract_1", 1, 0, 0, 1),
                    new DuplicateContract("contract_2", 1, 0, 0, 1),
                    new DuplicateContract("contract_3", 1, 0, 0, 1)
                });

            var crmDuplicateContractRepositoryMock = new Mock<ICrmDuplicateContractRepository>();
            crmDuplicateContractRepositoryMock.Setup(cdcr => cdcr.GetDuplicatedContracts())
                .Returns(new List<DuplicateContract>
                {
                    new DuplicateContract("contract_1", 1, 0, 0, 1),
                    new DuplicateContract("contract_3", 1, 0, 0, 1)
                });

            var crmDuplicateContractService = new CrmDuplicateContractService(crmDuplicateContractRepositoryMock.Object,
                duplicateContractRepositoryMock.Object);

            // Act
            crmDuplicateContractService.IdentifyNewDuplicateContracts(Mock.Of<ILogger>());

            // Assert
            duplicateContractRepositoryMock.Verify(dcr =>
                    dcr.RefreshDuplicatedContracts(It.IsAny<IReadOnlyCollection<DuplicateContract>>()), Times.Once,
                "We have updated the PAAS table");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CrmDuplicateContractService_IdentifyNewDuplicateContracts_ShouldRefreshDuplicatedContractsWhenSomeItemsInPaasAreNoLongerDuplicatesAndThereAreNewCrmDuplicates()
        {
            // Arrange
            var duplicateContractRepositoryMock = new Mock<IDuplicateContractRepository>();
            duplicateContractRepositoryMock.Setup(dcr => dcr.GetDuplicatedContracts())
                .Returns(new List<DuplicateContract>
                {
                    new DuplicateContract("contract_1", 1, 0, 0, 1),
                    new DuplicateContract("contract_2", 1, 0, 0, 1),
                    new DuplicateContract("contract_3", 1, 0, 0, 1)
                });

            var crmDuplicateContractRepositoryMock = new Mock<ICrmDuplicateContractRepository>();
            crmDuplicateContractRepositoryMock.Setup(cdcr => cdcr.GetDuplicatedContracts())
                .Returns(new List<DuplicateContract>
                {
                    new DuplicateContract("contract_3", 1, 0, 0, 1),
                    new DuplicateContract("contract_4", 1, 0, 0, 1)
                });

            var crmDuplicateContractService = new CrmDuplicateContractService(crmDuplicateContractRepositoryMock.Object,
                duplicateContractRepositoryMock.Object);

            // Act
            crmDuplicateContractService.IdentifyNewDuplicateContracts(Mock.Of<ILogger>());

            // Assert
            duplicateContractRepositoryMock.Verify(dcr =>
                    dcr.RefreshDuplicatedContracts(It.IsAny<IReadOnlyCollection<DuplicateContract>>()), Times.Once, "We have not updated the PAAS table");
        }
    }
}