namespace PaymentManagementDomain.PaymentSchedule.Xrm.Tests.Handlers
{
    using System;
    using System.Collections.Generic;
    using System.Security.Cryptography;
    using System.Text;
    using System.Threading.Tasks;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus;
    using PaymentManagementDomain.AllocationActualsVerified;
    using PaymentManagementDomain.AllocationActualsVerified.Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.AllocationActuals;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Repositories;

    [TestClass]
    public class AllocationActualsVerifiedHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void AllocationActualsVerifiedHandler_Handle_ShouldNotDoAnythingForPaymentMethodsOtherThanPayOnProfileAndNoPay()
        {
            // arrange
            Mock<IAllocationActualsRepository> mockXrmAllocationEvidenceManager =
                new Mock<IAllocationActualsRepository>();
            Mock<IPayCalcPolicyQueryRepository> mockPayCalcPolicyQueryRepository =
                new Mock<IPayCalcPolicyQueryRepository>();

            Mock<IMessageHandlerContext> mockHandlerContext = new Mock<IMessageHandlerContext>();
            Mock<ISessionConnectionFactory> mockSessionConnectionFactory = new Mock<ISessionConnectionFactory>();
            mockSessionConnectionFactory.Setup(s => s.GetConnection(It.IsAny<IMessageHandlerContext>()))
                .Returns(ConnectionInfo.CreateDefault());

            mockHandlerContext.SetupGet(m => m.MessageHeaders)
                .Returns(new Dictionary<string, string> {{Headers.CorrelationId, ""}});

            // set up sequential returns for three calls
            mockPayCalcPolicyQueryRepository.SetupSequence(m => m.GetFundingStreamPeriod(It.IsAny<ConnectionInfo>(), It.IsAny<string>()))
                .Returns(new PolicyFundingStreamPeriod {PaymentMethod = PaymentMethod.NoCalcAndNoPay})
                .Returns(new PolicyFundingStreamPeriod {PaymentMethod = PaymentMethod.PayOnActuals})
                .Returns(new PolicyFundingStreamPeriod {PaymentMethod = PaymentMethod.PayOnInstruction});

            AllocationActualsVerifiedHandler handler = new AllocationActualsVerifiedHandler(
                Mock.Of<ILogger>(), mockXrmAllocationEvidenceManager.Object, mockPayCalcPolicyQueryRepository.Object,
                mockSessionConnectionFactory.Object);

            AllocationActualsVerified allocationActualsVerifiedEvent = new AllocationActualsVerified
            {
                AllocationActuals = new ContractAllocationActualsType
                {
                    FundingStreamPeriodCode = "abc"
                }
            };

            // act 
            Task.WaitAll(
                handler.Handle(allocationActualsVerifiedEvent, mockHandlerContext.Object),  // NoCalcAndNoPay
                handler.Handle(allocationActualsVerifiedEvent, mockHandlerContext.Object),  // PayOnActuals
                handler.Handle(allocationActualsVerifiedEvent, mockHandlerContext.Object)); // PayOnInstruction

            // assert
            mockXrmAllocationEvidenceManager.Verify(
                m => m.WriteAllocationActualsToCrm(It.IsAny<ContractAllocationActualsType>()), Times.Never);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationActualsVerifiedHandler_Handle_ShouldPersistAllocationActualsForPayOnProfile()
        {
            // arrange
            Mock<IAllocationActualsRepository> mockXrmAllocationEvidenceManager =
                new Mock<IAllocationActualsRepository>();
            Mock<IPayCalcPolicyQueryRepository> mockPayCalcPolicyQueryRepository =
                new Mock<IPayCalcPolicyQueryRepository>();
            Mock<IMessageHandlerContext> mockHandlerContext = new Mock<IMessageHandlerContext>();
            Mock<ISessionConnectionFactory> mockSessionConnectionFactory = new Mock<ISessionConnectionFactory>();
            mockSessionConnectionFactory.Setup(s => s.GetConnection(It.IsAny<IMessageHandlerContext>()))
                .Returns(ConnectionInfo.CreateDefault());

            mockHandlerContext.SetupGet(m => m.MessageHeaders)
                .Returns(new Dictionary<string, string> { { Headers.CorrelationId, "" } });

            // set up sequential returns for four calls
            mockPayCalcPolicyQueryRepository.Setup(m => m.GetFundingStreamPeriod(It.IsAny<ConnectionInfo>(), It.IsAny<string>()))
                .Returns(new PolicyFundingStreamPeriod { PaymentMethod = PaymentMethod.PayOnProfile });

            AllocationActualsVerifiedHandler handler = new AllocationActualsVerifiedHandler(
                Mock.Of<ILogger>(), mockXrmAllocationEvidenceManager.Object, mockPayCalcPolicyQueryRepository.Object,
                mockSessionConnectionFactory.Object);

            AllocationActualsVerified allocationActualsVerifiedEvent = new AllocationActualsVerified
            {
                AllocationActuals = new ContractAllocationActualsType
                {
                    FundingStreamPeriodCode = "abc"
                }
            };

            // act 
            Task.WaitAll(handler.Handle(allocationActualsVerifiedEvent, mockHandlerContext.Object));

            // assert
            mockXrmAllocationEvidenceManager.Verify(
                m => m.WriteAllocationActualsToCrm(It.IsAny<ContractAllocationActualsType>()), Times.Once);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationActualsVerifiedHandler_Handle_ShouldPersistAllocationActualsForNoPay()
        {
            // arrange
            Mock<IAllocationActualsRepository> mockXrmAllocationEvidenceManager =
                new Mock<IAllocationActualsRepository>();
            Mock<IPayCalcPolicyQueryRepository> mockPayCalcPolicyQueryRepository =
                new Mock<IPayCalcPolicyQueryRepository>();
            Mock<IMessageHandlerContext> mockHandlerContext = new Mock<IMessageHandlerContext>();
            Mock<ISessionConnectionFactory> mockSessionConnectionFactory = new Mock<ISessionConnectionFactory>();
            mockSessionConnectionFactory.Setup(s => s.GetConnection(It.IsAny<IMessageHandlerContext>()))
                .Returns(ConnectionInfo.CreateDefault());

            mockHandlerContext.SetupGet(m => m.MessageHeaders)
                .Returns(new Dictionary<string, string> { { Headers.CorrelationId, "" } });

            // set up sequential returns for four calls
            mockPayCalcPolicyQueryRepository.Setup(m => m.GetFundingStreamPeriod(It.IsAny<ConnectionInfo>(), It.IsAny<string>()))
                .Returns(new PolicyFundingStreamPeriod { PaymentMethod = PaymentMethod.NoPay });

            AllocationActualsVerifiedHandler handler = new AllocationActualsVerifiedHandler(
                Mock.Of<ILogger>(), mockXrmAllocationEvidenceManager.Object, mockPayCalcPolicyQueryRepository.Object,
                mockSessionConnectionFactory.Object);

            AllocationActualsVerified allocationActualsVerifiedEvent = new AllocationActualsVerified
            {
                AllocationActuals = new ContractAllocationActualsType
                {
                    FundingStreamPeriodCode = "abc"
                }
            };

            // act 
            Task.WaitAll(handler.Handle(allocationActualsVerifiedEvent, mockHandlerContext.Object));

            // assert
            mockXrmAllocationEvidenceManager.Verify(
                m => m.WriteAllocationActualsToCrm(It.IsAny<ContractAllocationActualsType>()), Times.Once);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationActualsVerifiedHandler_ShouldResolve()
        {
            var handler = GetContainer().Resolve<IHandleMessages<AllocationActualsVerified>>();

            Assert.IsNotNull(handler);
        }

        public static string Build(string input)
        {
            //use MD5 hash to get a 16-byte hash of the string
            using (var provider = new MD5CryptoServiceProvider())
            {
                var inputBytes = Encoding.Default.GetBytes(input);
                var hashBytes = provider.ComputeHash(inputBytes);

                return new Guid(hashBytes).ToString();
            }
        }

        private IWindsorContainer GetContainer()
        {
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<IHandleMessages<AllocationActualsVerified>>().ImplementedBy<AllocationActualsVerifiedHandler>());
            container.Register(global::Castle.MicroKernel.Registration.Component.For<global::Microsoft.Xrm.Sdk.IOrganizationService>().Instance(global::Moq.Mock.Of<global::Microsoft.Xrm.Sdk.IOrganizationService>()).IsDefault());

            container.BeginScope();

            return container;
        }
    }
}