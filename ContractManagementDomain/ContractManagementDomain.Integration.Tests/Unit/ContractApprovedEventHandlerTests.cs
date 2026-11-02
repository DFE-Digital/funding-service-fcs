namespace ContractManagementDomain.Integration.Tests.Unit
{
    using System.Collections.Generic;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus;
    using SFA.FCT.ContractManagementService.Common.Events;
    using SFA.FCT.ContractManagementService.Common.Persistence;
    using SFA.FCT.Framework.Logging.Interfaces;
    using CorporateContract = SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;

    [TestClass]
    public class ContractApprovedEventHandlerTests
    {
        private Mock<ILogger> _loggerMock;
        private Mock<IApprovedContractRepository> _repositoryMock;
        private ContractApprovedEventHandler _handler;

        [TestInitialize]
        public void TestInitialize()
        {
            _loggerMock = new Mock<ILogger>();
            _repositoryMock = new Mock<IApprovedContractRepository>();
            _handler = new ContractApprovedEventHandler(_loggerMock.Object, _repositoryMock.Object);
        }

        [TestMethod]
        public void HandlesMessages_OfType_ContractApprovedEvent()
        {
            Assert.IsInstanceOfType(_handler, typeof(IHandleMessages<ContractApprovedEvent>), "Handler does not implement IHandleMessages for correct type");
        }

        [TestMethod]
        public void Calling_ContractApprovedEvent_Handler()
        {
            _handler.Handle(new ContractApprovedEvent
            {
                CorporateContract = new CorporateContract.contract
                {
                    contracts = new List<CorporateContract.contractType>
                    {
                        new CorporateContract.contractType
                        {
                            contractNumber = "Contract-001",
                            contractVersionNumber = 1
                        }
                    }
                }
            });

            _repositoryMock.Verify(
                m => m.Add(It.IsAny<CorporateContract.contract>()),
                Times.Once,
                "ContractApprovedEventHandler did not add to the paged contract repository.");
        }
    }
}
