namespace ContractManagementDomain.Endpoint.Tests.InitiateContractWithdrawal
{
    using System.Linq;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Endpoint.InitiateContractWithdrawal;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus.Testing;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.ContractManagementService.Common.Commands;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractWithdrawal;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class PreIncrementWithdrawalHandlerTests 
    {
        [TestMethod, TestCategory("UnitTest")]
        public void InitiateContractWithdrawalHandler_ShouldResolve()
        {
            // arrange
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<PreIncrementWithdrawalHandler>().LifestyleScoped());

            container.BeginScope();

            // act
            container.Resolve<PreIncrementWithdrawalHandler>();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PreIncrementWithdrawalHandler_Handle_ShouldSendInitiateContractWithdrawalCommandWithCorrectValues()
        {
            // arrange
            TestableMessageHandlerContext context = new TestableMessageHandlerContext();
            PreIncrementWithdrawalHandler handler = new PreIncrementWithdrawalHandler(Mock.Of<ILogger>());

            PreIncrementWithdrawalCommand preIncrementWithdrawalCommand = new PreIncrementWithdrawalCommand
            {
                MasterContractNumber = "11",
                ContractNumber = "1",
                VersionNumber = 1,
                ShouldAddPayableNonLevyAllocationToPostWithdrawalAmendment = true,
                Ukprn = "10021107"
            };

            // act
            handler.Handle(preIncrementWithdrawalCommand, context).Wait();

            // assert
            InitiateContractWithdrawalCommand sentCommand = context.SentMessages.Select(m => m.Message).OfType<InitiateContractWithdrawalCommand>().SingleOrDefault();

            Assert.IsNotNull(sentCommand, "We have not sent a InitiateContractWithdrawalCommand");
            Assert.AreEqual(preIncrementWithdrawalCommand.VersionNumber, sentCommand.ContractVersionNumber, "We have not set ContractVersionNumber");
            Assert.AreEqual(preIncrementWithdrawalCommand.ContractNumber, sentCommand.ContractNumber, "We have not set ContractNumber");
            Assert.AreEqual(preIncrementWithdrawalCommand.MasterContractNumber, sentCommand.MasterContractNumber, "We have not set MasterContractNumber");
            Assert.AreEqual(ContractWithdrawalType.BulkWithdrawalByAgency, sentCommand.ContractWithdrawalType, "We have not set ContractWithdrawalType");
            Assert.AreEqual(WithdrawalRequestSource.Fcs, sentCommand.RequestSource, "We have not set RequestSource");
            Assert.AreEqual(preIncrementWithdrawalCommand.Ukprn, sentCommand.Ukprn, "We have not set Ukprn");
            Assert.AreEqual(true, sentCommand.IncrementContractVersionNumber, "We have not set IncrementContractVersionNumber");
            Assert.AreEqual(true, sentCommand.ShouldAddPayableNonLevyAllocationToPostWithdrawalAmendment, "We have not set ShouldAddPayableNonLevyAllocationToPostWithdrawalAmendment");
        }
    }
}
