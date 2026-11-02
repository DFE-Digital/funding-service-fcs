namespace SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.Tests
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using ContractCreateDomain.Implementation.Persistence;
    using ContractManagementService.Common.Events;
    using Framework.Logging;
    using Framework.Logging.Interfaces;
    using Handlers;
    using IoC;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus;

    [TestClass]
    public class AnotherIntegrationTest
    {
        [TestMethod]
        public void TestToExploreThePKViolationInAT()
        {
            var crm = ConfigurationManager.ConnectionStrings["CrmConnectionString"];
            Console.WriteLine("ConnectionString: {0}", crm);

            ILoggerFactory factory = new LoggerFactory();
            var container = new WindsorContainer().Install(new WindsorInstaller(factory));
            container.Register(Component.For<ContractApproveHandler>());

            Mock<IMessageContext> currentContextMock = new Mock<IMessageContext>();
            currentContextMock.Setup(m => m.Headers).Returns(new Dictionary<string, string> {{Headers.CorrelationId, Guid.NewGuid().ToString()}});
            Mock<IBus> busMock = new Mock<IBus>();
            busMock.Setup(m => m.CurrentMessageContext).Returns(currentContextMock.Object);
            container.Register(Component.For<IBus>().Instance(busMock.Object));

            var contractNumber = "MAIN-2486";
            var masterContractNumber = "SFA-2561";

            var contractManager = (ContractsManager)container.Resolve<IContractsManager>();

            var exportedCorpContract = contractManager.GetCorporateContract(contractNumber, masterContractNumber);

            container.Release(contractManager);

            var message = new ContractApprovedEvent {CorporateContract = exportedCorpContract};

            var handler = container.Resolve<ContractApproveHandler>();

            try
            {
                handler.Handle(message);
            }
            catch (Exception ex)
            {             
                throw ex;
            }

        }
    }
}
