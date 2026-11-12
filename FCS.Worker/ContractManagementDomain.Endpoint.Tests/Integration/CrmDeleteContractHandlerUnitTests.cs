namespace ContractManagementDomain.Endpoint.Tests.Integration
{
    using System;
    using System.Collections.Generic;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Endpoint.DeleteContract;
    using Endpoint.DeleteContract.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus.Testing;
    using SFA.FCT.ContractManagementService.Common.Commands;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class CrmDeleteContractHandlerUnitTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void CrmDeleteContractHandler_AreTheseChildContractsTheOnlyOnesRelatedToTheMaster_WhenTrueShouldResultInMasterContractNumberBeingDeleted()
        {
            // Arrange 
            Guid masterContractId = Guid.NewGuid();
            Guid firstChildContractId = Guid.NewGuid();
            Guid secondChildContractId = Guid.NewGuid();
            Guid thirdChildContractId = Guid.NewGuid();

            var crmContractRepositoryMock = new Mock<ICrmContractRepository>();
            crmContractRepositoryMock.Setup(m => m.GetContractIds(It.IsAny<string>(), It.IsAny<int>()))
                .Returns(new List<CrmContractIdentity>
                {
                    new CrmContractIdentity {ContractId = firstChildContractId, MasterContractId = masterContractId},
                    new CrmContractIdentity {ContractId = secondChildContractId, MasterContractId = masterContractId},
                    new CrmContractIdentity {ContractId = thirdChildContractId, MasterContractId = masterContractId}
                });
            crmContractRepositoryMock.Setup(m => m.AreTheseChildContractsTheOnlyOnesRelatedToTheMaster(It.IsAny<Guid>(), It.IsAny<IReadOnlyCollection<Guid>>()))
                .Returns(true);

            var loggerMock = new Mock<ILogger>();
            var handler = new CrmDeleteContractHandler(
                loggerMock.Object,
                crmContractRepositoryMock.Object);

            var message = new DeleteContractCommand { ContractNumber = "CONTRACT-X", VersionNumber = 1 };
            var testableContext = new TestableMessageHandlerContext();

            // Act
            handler.Handle(message, testableContext).Wait();

            // Assert
            crmContractRepositoryMock.Verify(x => x.DeleteContractsTasksAndWorkflows(It.Is<List<Guid>>(p => p.Count == 3
                    && p.Contains(firstChildContractId)
                    && p.Contains(secondChildContractId)
                    && p.Contains(thirdChildContractId))),
                "Incorrect child or master contract ids in the list of contracts to be deleted");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CrmDeleteContractHandler_DoesMasterContractHaveOtherChildContractVersions_WhenFalseShouldResultInMasterContractNumberNotBeingDeleted()
        {
            // Arrange 
            Guid masterContractId = Guid.NewGuid();
            Guid firstChildContractId = Guid.NewGuid();
            Guid secondChildContractId = Guid.NewGuid();
            Guid thirdChildContractId = Guid.NewGuid();

            var crmContractRepositoryMock = new Mock<ICrmContractRepository>();
            crmContractRepositoryMock.Setup(m => m.GetContractIds(It.IsAny<string>(), It.IsAny<int>()))
                .Returns(new List<CrmContractIdentity>
                {
                    new CrmContractIdentity {ContractId = firstChildContractId, MasterContractId = masterContractId},
                    new CrmContractIdentity {ContractId = secondChildContractId, MasterContractId = masterContractId},
                    new CrmContractIdentity {ContractId = thirdChildContractId, MasterContractId = masterContractId}
                });
            crmContractRepositoryMock.Setup(m => m.AreTheseChildContractsTheOnlyOnesRelatedToTheMaster(It.IsAny<Guid>(), It.IsAny<IReadOnlyCollection<Guid>>()))
                .Returns(false);

            var loggerMock = new Mock<ILogger>();
            var handler = new CrmDeleteContractHandler(
                loggerMock.Object,
                crmContractRepositoryMock.Object);

            var message = new DeleteContractCommand { ContractNumber = "CONTRACT-X", VersionNumber = 1 };
            var testableContext = new TestableMessageHandlerContext();

            // Act
            handler.Handle(message, testableContext); 

            // Assert
            crmContractRepositoryMock.Verify(x => x.DeleteContractsTasksAndWorkflows(It.Is<List<Guid>>(p => p.Count == 3
                    && p.Contains(firstChildContractId)
                    && p.Contains(secondChildContractId)
                    && p.Contains(thirdChildContractId)
                    && !p.Contains(masterContractId))),
                "Incorrect contract ids in the list of child contracts to be deleted");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CrmDeleteContractHandler_ShouldResolveDependenciesFromIntegrationEndpointContainer()
        {
            // arrange
            IWindsorContainer container = new WindsorContainer().Install(new WindsorInstaller(new LoggerFactory()));
            container.Register(Component.For<Microsoft.Xrm.Sdk.IOrganizationService>().Instance(Mock.Of<Microsoft.Xrm.Sdk.IOrganizationService>()).IsDefault());
            container.Register(Component.For<CrmDeleteContractHandler>());
            container.BeginScope();

            // act
            var handler = container.Resolve<CrmDeleteContractHandler>();

            // assert
            Assert.IsNotNull(handler);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DeleteDocumentsForContractCommandHandler_ShouldResolveDependenciesFromIntegrationEndpointContainer()
        {
            // arrange
            IWindsorContainer container = new WindsorContainer().Install(new WindsorInstaller(new LoggerFactory()));
            container.Register(Component.For<Microsoft.Xrm.Sdk.IOrganizationService>().Instance(Mock.Of<Microsoft.Xrm.Sdk.IOrganizationService>()).IsDefault());
            container.Register(Component.For<DeleteDocumentsForContractCommandHandler>());
            container.BeginScope();

            // act
            var handler = container.Resolve<DeleteDocumentsForContractCommandHandler>();

            // assert
            Assert.IsNotNull(handler);
        }
    }
}