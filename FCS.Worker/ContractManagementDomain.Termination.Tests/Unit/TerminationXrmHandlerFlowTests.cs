namespace ContractManagementDomain.Termination.Tests.Unit
{
    using System.Linq;
    using System.Threading.Tasks;
    using ContractManagementDomain.Termination.Xrm;
    using ContractManagementDomain.Termination.Xrm.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus.Testing;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class TerminationXrmHandlerFlowTests
    {
        private const string ContractNumber = "CON-1";
        private const int VersionNumber = 2;
        private const int SubVersionNumber = 3;

        private readonly Mock<ICrmContractRepository> _repository = new Mock<ICrmContractRepository>();
        private readonly TestableMessageHandlerContext _context = new TestableMessageHandlerContext();

        [TestMethod, TestCategory("UnitTest")]
        public async Task ContractTerminated_OverwritesEndDatesAndMarksTerminationSuccessful()
        {
            var handler = new ContractTerminatedHandler(Mock.Of<ILogger>(), _repository.Object);

            await handler.Handle(
                new ContractTerminatedEvent { ContractNumber = ContractNumber, VersionNumber = VersionNumber, SubVersionNumber = SubVersionNumber },
                _context);

            _repository.Verify(r => r.OverwriteNullEndDateWithTerminationDate(ContractNumber, VersionNumber, SubVersionNumber), Times.Once());
            _repository.Verify(r => r.OverwriteNullAllocationEndDatesWithTerminationDates(ContractNumber, VersionNumber, SubVersionNumber), Times.Once());
            _repository.Verify(r => r.UpdateServiceResponseOnContract(ContractNumber, VersionNumber, SubVersionNumber, sfa_serviceresponse.TerminationSuccessful), Times.Once());
        }

        [TestMethod, TestCategory("UnitTest")]
        public async Task ContractTerminationCancelled_MarksTerminationCancellationSuccessful()
        {
            var handler = new ContractTerminationCancelledHandler(Mock.Of<ILogger>(), _repository.Object);

            await handler.Handle(
                new ContractTerminationCancelledEvent { ContractNumber = ContractNumber, VersionNumber = VersionNumber, SubVersionNumber = SubVersionNumber },
                _context);

            _repository.Verify(r => r.UpdateServiceResponseOnContract(ContractNumber, VersionNumber, SubVersionNumber, sfa_serviceresponse.TerminationCancellationSuccessful), Times.Once());
        }

        [TestMethod, TestCategory("UnitTest")]
        public async Task ContractTerminationFailed_MarksFailedAndSendsCrmNotification()
        {
            var handler = new ContractTerminationFailedHandler(Mock.Of<ILogger>(), _repository.Object);

            await handler.Handle(
                new ContractTerminationFailedEvent { ContractNumber = ContractNumber, VersionNumber = VersionNumber, SubVersionNumber = SubVersionNumber, FailureReason = "bad date" },
                _context);

            _repository.Verify(r => r.UpdateServiceResponseOnContract(ContractNumber, VersionNumber, SubVersionNumber, sfa_serviceresponse.ContractTerminationFailed), Times.Once());
            var sent = _context.SentMessages.Select(m => m.Message).OfType<IssueCrmNotificationCommand>().Single();
            Assert.AreEqual(ContractNumber, sent.ContractNumber);
            Assert.AreEqual(VersionNumber, sent.VersionNumber);
            Assert.AreEqual(SubVersionNumber, sent.SubVersionNumber);
            Assert.AreEqual("bad date", sent.NotificationText);
            Assert.AreEqual(NotificationType.ContractTerminationFailed, sent.NotificationType);
        }
    }
}
