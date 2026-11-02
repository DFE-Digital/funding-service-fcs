namespace ContractRequestDomain.Cfs.Tests.Release
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Cfs.Infrastructure;
    using Cfs.Release;
    using Cfs.Release.Services;
    using Dto;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus.Testing;
    using SFA.FCT.ContractManagementService.Common.Commands;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class InitiateCfsAllocationReleaseHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void InitiateCfsAllocationReleaseHandler_ShouldStoreContractAndSendOnwardDocGenCommandWhenAllocationReleaseServiceGeneratesContract()
        {
            // arrange
            Mock<IAllocationReleaseService> allocationReleaseServiceMock = new Mock<IAllocationReleaseService>();
            allocationReleaseServiceMock
                .Setup(m => m.ReleaseAllocations(
                    It.IsAny<string>(),
                    It.IsAny<string>(),
                    It.IsAny<Func<ContractCfsAllocation, Task>>(),
                    It.IsAny<ConnectionInfo>()))
                .Callback<string, string, Func<ContractCfsAllocation, Task>, ConnectionInfo>((ft, fp, cg, ci) =>
                {
                    cg(new ContractCfsAllocation
                    {
                        Contract = new ExtendedContractType
                        {
                            contracts = new List<ExtendedContractType> { new ExtendedContractType() }
                        }
                    });
                })
                .Returns(Task.CompletedTask);

            Mock<IContractCfsAllocationStorage> contractCfsAllocationStorageMock = new Mock<IContractCfsAllocationStorage>();

            InitiateCfsAllocationReleaseHandler handler = new InitiateCfsAllocationReleaseHandler(
                Mock.Of<ILogger>(),
                allocationReleaseServiceMock.Object,
                contractCfsAllocationStorageMock.Object,
                Mock.Of<ISessionConnectionFactory>());

            TestableMessageHandlerContext handlerContext = new TestableMessageHandlerContext();

            // act
            handler.Handle(new InitiateCfsAllocationReleaseCommand(), handlerContext).Wait();

            // assert
            contractCfsAllocationStorageMock.Verify(
                m => m.UploadContract(It.IsAny<string>(), It.IsAny<ContractCfsAllocation>()),
                Times.Once,
                "Unexpected number of contracts stored");

            Assert.AreEqual(1, handlerContext.SentMessages.Length, "Unexpected number of messages sent");
            Assert.AreEqual(1, handlerContext.SentMessages.Select(sm => sm.Message).OfType<DocumentGenerationCommand>().Count(),
                "Unexpected number of DocumentGenerationCommand messages sent");
        }
        
        [TestMethod, TestCategory("UnitTest")]
        public void InitiateCfsAllocationReleaseHandler_ShouldResolveDependencies()
        {
            // arrange
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<InitiateCfsAllocationReleaseHandler, InitiateCfsAllocationReleaseHandler>());
            container.BeginScope();

            // act
            container.Resolve<InitiateCfsAllocationReleaseHandler>();
        }
    }
}
