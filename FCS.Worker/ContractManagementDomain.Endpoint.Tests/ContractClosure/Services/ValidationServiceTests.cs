namespace ContractManagementDomain.Endpoint.Tests.ContractClosure.Services
{
    using System;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Repositories;
    using Endpoint.ContractClosure;
    using Endpoint.ContractClosure.Services;
    using Endpoint.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.ContractManagementDomain.Integration.Dtos;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore.Services;
    using SFA.FCT.Framework.Logging;

    [TestClass]
    public class ValidationServiceTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ValidationService_GetFirstFailureMessageForInitiateContractClosure_ShouldReturnErrorMessageWhenContractEndDateIsNotInThePast()
        {
            // arrange
            Mock<ICrmContractRepository> crmContractRepMock = new Mock<ICrmContractRepository>();
            DateTime now = DateTime.Now;

            crmContractRepMock.Setup(
                r =>
                    r.GetContractEndDateInfoByContractNumberVersionAndSubVersion(It.IsAny<string>(), It.IsAny<int>(),
                        It.IsAny<int>())).Returns(new ContractEndDateInfo(now, isContractPresent: true));

            Mock<IApprovedContractRepository> approvedContractRepositoryMock = new Mock<IApprovedContractRepository>();
            approvedContractRepositoryMock
                .Setup(ac => ac.HasOutstandingPayments(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>(), It.IsAny<ConnectionInfo>()))
                .Returns(true);

            Mock<IDateProvider> dateProviderMock = new Mock<IDateProvider>();
            dateProviderMock.Setup(d => d.GetDate(It.IsAny<ConnectionInfo>())).Returns(now);

            ValidationService validationService = new ValidationService(crmContractRepMock.Object, dateProviderMock.Object, approvedContractRepositoryMock.Object, Mock.Of<IMonthEndHistoryRepository>());

            // act
            string failureMessage = validationService.GetFirstFailureMessageForInitiateContractClosure(new ContractIdentifier("1", 1, 1), ConnectionInfo.CreateDefault());

            // assert
            Assert.IsNotNull(failureMessage);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ValidationService_GetFirstFailureMessageForInitiateContractClosure_ShouldNotReturnErrorMessageWhenContractEndDateIsInThePast()
        {
            // arrange
            Mock<ICrmContractRepository> crmContractRepMock = new Mock<ICrmContractRepository>();
            DateTime now = DateTime.Now;

            crmContractRepMock.Setup(
                r =>
                    r.GetContractEndDateInfoByContractNumberVersionAndSubVersion(It.IsAny<string>(), It.IsAny<int>(),
                        It.IsAny<int>())).Returns(new ContractEndDateInfo(now.AddDays(-1), isContractPresent: true));

            crmContractRepMock.Setup(m => m.IsContractLatestVersion(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>()))
                .Returns(true);

            Mock<IApprovedContractRepository> approvedContractRepositoryMock = new Mock<IApprovedContractRepository>();
            approvedContractRepositoryMock
                .Setup(ac => ac.HasOutstandingPayments(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>(), It.IsAny<ConnectionInfo>()))
                .Returns(false);

            Mock<IDateProvider> dateProviderMock = new Mock<IDateProvider>();
            dateProviderMock.Setup(d => d.GetDate(It.IsAny<ConnectionInfo>())).Returns(now);

            ValidationService validationService = new ValidationService(crmContractRepMock.Object, dateProviderMock.Object, approvedContractRepositoryMock.Object, Mock.Of<IMonthEndHistoryRepository>());

            // act
            string failureMessage = validationService.GetFirstFailureMessageForInitiateContractClosure(new ContractIdentifier("1", 1, 1), ConnectionInfo.CreateDefault());

            // assert
            Assert.IsNull(failureMessage);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ValidationService_GetFirstFailureMessageForInitiateContractClosure_ShouldReturnErrorMessageIfContractIsNotLatestVersion()
        {
            // arrange
            Mock<ICrmContractRepository> crmContractRepMock = new Mock<ICrmContractRepository>();
            DateTime now = DateTime.Now;

            crmContractRepMock.Setup(
                r =>
                    r.GetContractEndDateInfoByContractNumberVersionAndSubVersion(It.IsAny<string>(), It.IsAny<int>(),
                        It.IsAny<int>())).Returns(new ContractEndDateInfo(now.AddDays(-1), isContractPresent: true));

            crmContractRepMock.Setup(m => m.IsContractLatestVersion(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>()))
                .Returns(false);

            Mock<IApprovedContractRepository> approvedContractRepositoryMock = new Mock<IApprovedContractRepository>();
            approvedContractRepositoryMock
                .Setup(ac => ac.HasOutstandingPayments(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>(), It.IsAny<ConnectionInfo>()))
                .Returns(true);

            Mock<IDateProvider> dateProviderMock = new Mock<IDateProvider>();
            dateProviderMock.Setup(d => d.GetDate(It.IsAny<ConnectionInfo>())).Returns(now);

            ValidationService validationService = new ValidationService(crmContractRepMock.Object, dateProviderMock.Object, approvedContractRepositoryMock.Object, Mock.Of<IMonthEndHistoryRepository>());
            // act
            string failureMessage = validationService.GetFirstFailureMessageForInitiateContractClosure(new ContractIdentifier("1", 1, 1), ConnectionInfo.CreateDefault());

            // assert
            Assert.IsNotNull(failureMessage, "Expected a failure message");
            Assert.AreEqual("an outstanding draft amendment exists", failureMessage, "Incorrect failure was returned");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ValidationService_GetFirstFailureMessageForInitiateContractClosure_ShouldNotReturnErrorMessageWhenThereAreNoOutstandingPayments()
        {
            // arrange
            DateTime now = DateTime.Now;
            Mock<ICrmContractRepository> crmContractRepMock = new Mock<ICrmContractRepository>();
            crmContractRepMock
                .Setup(r => r.GetContractEndDateInfoByContractNumberVersionAndSubVersion
                      (It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>()))
                .Returns(new ContractEndDateInfo(now.AddDays(-1), isContractPresent: true));
            crmContractRepMock
                .Setup(m => m.IsContractLatestVersion(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>()))
                .Returns(true);

            Mock<IApprovedContractRepository> approvedContractRepositoryMock = new Mock<IApprovedContractRepository>();
            approvedContractRepositoryMock
                .Setup(ac => ac.HasOutstandingPayments(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>(), It.IsAny<ConnectionInfo>()))
                .Returns(false);

            Mock<IDateProvider> dateProviderMock = new Mock<IDateProvider>();
            dateProviderMock.Setup(d => d.GetDate(It.IsAny<ConnectionInfo>())).Returns(now);

            ValidationService validationService = new ValidationService(crmContractRepMock.Object, dateProviderMock.Object, approvedContractRepositoryMock.Object, Mock.Of<IMonthEndHistoryRepository>());

            // act
            string failureMessage = validationService.GetFirstFailureMessageForInitiateContractClosure(new ContractIdentifier("1", 1, 1), ConnectionInfo.CreateDefault());

            // assert
            Assert.IsNull(failureMessage);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ValidationService_GetFirstFailureMessageForInitiateContractClosure_ShouldReturnErrorMessageWhenThereAreOutstandingPayments()
        {
            // arrange
            DateTime now = DateTime.Now;
            Mock<ICrmContractRepository> crmContractRepMock = new Mock<ICrmContractRepository>();
            crmContractRepMock
                .Setup(r => r.GetContractEndDateInfoByContractNumberVersionAndSubVersion
                      (It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>()))
                .Returns(new ContractEndDateInfo(now.AddDays(-1), isContractPresent: true));
            crmContractRepMock
                .Setup(m => m.IsContractLatestVersion(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>()))
                .Returns(true);

            Mock<IApprovedContractRepository> approvedContractRepositoryMock = new Mock<IApprovedContractRepository>();
            approvedContractRepositoryMock
                .Setup(ac => ac.HasOutstandingPayments(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>(), It.IsAny<ConnectionInfo>()))
                .Returns(true);

            Mock<IDateProvider> dateProviderMock = new Mock<IDateProvider>();
            dateProviderMock.Setup(d => d.GetDate(It.IsAny<ConnectionInfo>())).Returns(now);

            ValidationService validationService = new ValidationService(crmContractRepMock.Object, dateProviderMock.Object, approvedContractRepositoryMock.Object, Mock.Of<IMonthEndHistoryRepository>());

            // act
            string failureMessage = validationService.GetFirstFailureMessageForInitiateContractClosure(new ContractIdentifier("1", 1, 1), ConnectionInfo.CreateDefault());

            // assert
            Assert.IsNotNull(failureMessage, "Expected a failure message");
            Assert.AreEqual("outstanding payments exist", failureMessage, "Incorrect failure was returned");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ValidationService_GetFirstFailureMessageForInitiateContractClosure_ShouldReturnFirstFailureMessageIfMultipleRulesFail()
        {
            // arrange
            Mock<ICrmContractRepository> crmContractRepMock = new Mock<ICrmContractRepository>();
            DateTime now = DateTime.Now;

            crmContractRepMock.Setup(
                r =>
                    r.GetContractEndDateInfoByContractNumberVersionAndSubVersion(It.IsAny<string>(), It.IsAny<int>(),
                        It.IsAny<int>())).Returns(new ContractEndDateInfo(now.AddDays(1), isContractPresent: true));

            crmContractRepMock.Setup(m => m.IsContractLatestVersion(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>()))
                .Returns(false);

            Mock<IApprovedContractRepository> approvedContractRepositoryMock = new Mock<IApprovedContractRepository>();
            approvedContractRepositoryMock
                .Setup(ac => ac.HasOutstandingPayments(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>(), It.IsAny<ConnectionInfo>()))
                .Returns(true);

            Mock<IDateProvider> dateProviderMock = new Mock<IDateProvider>();
            dateProviderMock.Setup(d => d.GetDate(It.IsAny<ConnectionInfo>())).Returns(now);

            ValidationService validationService = new ValidationService(crmContractRepMock.Object, dateProviderMock.Object, approvedContractRepositoryMock.Object, Mock.Of<IMonthEndHistoryRepository>());

            // act
            string failureMessage = validationService.GetFirstFailureMessageForInitiateContractClosure(new ContractIdentifier("1", 1, 1), ConnectionInfo.CreateDefault());

            // assert
            Assert.IsNotNull(failureMessage, "Expected a failure message");
            Assert.AreEqual("its end date must be in the past", failureMessage, "Incorrect failure was returned");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ValidationService_GetFirstFailureMessageForApproveContractClosure_ShouldReturnCorrectFailureMessageIfMonthEndIsInProgress()
        {
            // arrange
            Mock<IApprovedContractRepository> approvedContractRepositoryMock = new Mock<IApprovedContractRepository>();
            approvedContractRepositoryMock
                .Setup(ac => ac.HasOutstandingPayments(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>(), It.IsAny<ConnectionInfo>()))
                .Returns(false);

            Mock<IMonthEndHistoryRepository> monthEndRepostoryMock = new Mock<IMonthEndHistoryRepository>();
            monthEndRepostoryMock.Setup(m => m.IsMonthEndInProgress(It.IsAny<ConnectionInfo>())).Returns(true);

            ValidationService validationService = new ValidationService(Mock.Of<ICrmContractRepository>(), Mock.Of<IDateProvider>(), approvedContractRepositoryMock.Object, monthEndRepostoryMock.Object);

            // act
            string failureMessage = validationService.GetFirstFailureMessageForApproveContractClosure(new ContractIdentifier("1", 1, 1), ConnectionInfo.CreateDefault());

            // assert
            Assert.IsNotNull(failureMessage, "Expected a failure message");
            Assert.AreEqual("month-end processing is in progress - please try again later", failureMessage, "Incorrect failure was returned");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ValidationService_GetFirstFailureMessageForApproveContractClosure_ShouldReturnCorrectFailureMessageIfThereAreOutstandingPayments()
        {
            // arrange
            Mock<IApprovedContractRepository> approvedContractRepositoryMock = new Mock<IApprovedContractRepository>();
            approvedContractRepositoryMock
                .Setup(ac => ac.HasOutstandingPayments(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>(), It.IsAny<ConnectionInfo>()))
                .Returns(true);

            Mock<IMonthEndHistoryRepository> monthEndRepostoryMock = new Mock<IMonthEndHistoryRepository>();
            monthEndRepostoryMock.Setup(m => m.IsMonthEndInProgress(It.IsAny<ConnectionInfo>())).Returns(false);

            ValidationService validationService = new ValidationService(Mock.Of<ICrmContractRepository>(), Mock.Of<IDateProvider>(), approvedContractRepositoryMock.Object, monthEndRepostoryMock.Object);

            // act
            string failureMessage = validationService.GetFirstFailureMessageForApproveContractClosure(new ContractIdentifier("1", 1, 1), ConnectionInfo.CreateDefault());

            // assert
            Assert.IsNotNull(failureMessage, "Expected a failure message");
            Assert.AreEqual("outstanding payments exist", failureMessage, "Incorrect failure was returned");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ValidationService_GetFirstFailureMessageForApproveContractClosure_ShouldNotReturnAnErrorIfMonthEndIsNotInProgressAndNoOutstandingPayments()
        {
            // arrange
            Mock<IApprovedContractRepository> approvedContractRepositoryMock = new Mock<IApprovedContractRepository>();
            approvedContractRepositoryMock
                .Setup(ac => ac.HasOutstandingPayments(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>(), It.IsAny<ConnectionInfo>()))
                .Returns(false);

            Mock<IMonthEndHistoryRepository> monthEndRepostoryMock = new Mock<IMonthEndHistoryRepository>();
            monthEndRepostoryMock.Setup(m => m.IsMonthEndInProgress(ConnectionInfo.CreateDefault())).Returns(false);

            ValidationService validationService = new ValidationService(Mock.Of<ICrmContractRepository>(), Mock.Of<IDateProvider>(), approvedContractRepositoryMock.Object, monthEndRepostoryMock.Object);

            // act
            string failureMessage = validationService.GetFirstFailureMessageForApproveContractClosure(new ContractIdentifier("1", 1, 1), ConnectionInfo.CreateDefault());

            // assert
            Assert.IsNull(failureMessage);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ValidationService_ShouldResolve()
        {
            IValidationService validationService = GetContainer().Resolve<IValidationService>();

            Assert.IsNotNull(validationService);
        }

        private static IWindsorContainer GetContainer()
        {
            IWindsorContainer container =
                new WindsorContainer().Install(
                    new WindsorInstaller(
                        new LoggerFactory()));
            container.BeginScope();
            return container;
        }
    }
}
