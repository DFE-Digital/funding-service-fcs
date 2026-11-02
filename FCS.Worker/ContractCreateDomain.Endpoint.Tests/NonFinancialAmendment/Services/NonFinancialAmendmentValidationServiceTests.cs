namespace ContractCreateDomain.Endpoint.Tests.NonFinancialAmendment.Services
{
    using System;
    using System.Configuration;
    using System.Data;
    using System.Data.SqlClient;
    using System.Linq;
    using ContractCreateDomain.Endpoint.Infrastructure;
    using ContractManagement.DataStore.Model;
    using Endpoint.NonFinancialAmendment.Dtos;
    using Endpoint.NonFinancialAmendment.Repositories;
    using Endpoint.NonFinancialAmendment.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using Moq;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;

    [TestClass]
    public class NonFinancialAmendmentValidationServiceTests
    {
        private const string NotApprovedStatusValidationErrorMessage = @"It must be in a status of ""Approved"" and a substatus of either ""Approved"", ""Modified"" or ""Under Termination""";
        private const string DraftAmendmentAlreadyExistsValidationErrorMessage = "A draft amendment already exists";

        private const string FundingTypeFundingPeriodValidationErrorMessage = "Non-financial amendments cannot be created for {0} {1} contracts";
        private const string ContractActivityCloseDatePastValidationErrorMessage = "Contracting activity has closed for {0} {1} contracts";
        private const string HasSiblingContractWithDraftStatusOrAmendmentCreationInProgressErrorMessage = "A draft amendment already exists (or has been initiated) for another contract associated with this Master Contract";

        private const string DefaultFundingTypeCode = "Test-FundingCode";
        private const string DefaultPeriodName = "Test-FundingPeriodName";

        [TestMethod, TestCategory("UnitTest")]
        public void NonFinancialAmendmentValidationService_IsValid_WhenSubsequentDraftVersionsOfContractExists_ShouldReturnCorrectErrorMessage()
        {
            // Arrange
            var mockConnectionInfo = new Mock<ConnectionInfo>(null, Mock.Of<IDbConnection>());
            var mockFundingTypeFundingPeriodQueryRepository = new Mock<IFundingTypeFundingPeriodQueryRepository>();
            var mockCrmContractRepository = new Mock<ICrmContractRepository>();
            FundingTypeFundingPeriodKey fundingTypeFundingPeriodKey = new FundingTypeFundingPeriodKey("dummyCode", "dummyPeriod");
            FundingTypeFundingPeriod validDefaultFundingTypeFundingPeriod = GetValidDefaultFundingTypeFundingPeriod();

            mockFundingTypeFundingPeriodQueryRepository.Setup(
                m => m.Get(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                      .Returns(validDefaultFundingTypeFundingPeriod);

            mockCrmContractRepository.Setup(m => m.IsThereNoSubsequentDraftContracts(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>())).Returns(false);
            mockCrmContractRepository.Setup(m => m.IsContractApprovedWithSubstatus(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>(), It.IsAny<string[]>())).Returns(true);
            mockCrmContractRepository.Setup(m => m.GetFundingTypeFundingPeriodKeyForGivenContract(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>())).Returns(fundingTypeFundingPeriodKey);

            NonFinancialAmendmentValidationService nonFinancialAmendmentValidationService =
                new NonFinancialAmendmentValidationService(mockCrmContractRepository.Object, mockFundingTypeFundingPeriodQueryRepository.Object, Mock.Of<IDate>());

            // Act
            string returnedValidationText = nonFinancialAmendmentValidationService.IsValid(new ContractIdentifier("dummy contract number", 1, 0), mockConnectionInfo.Object);

            // Assert
            Assert.AreEqual(DraftAmendmentAlreadyExistsValidationErrorMessage, returnedValidationText);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void NonFinancialAmendmentValidationService_IsValid_WhenContractIsNotApproved_ShouldReturnErrorMessage()
        {
            // Arrange
            var mockConnectionInfo = new Mock<ConnectionInfo>(null, Mock.Of<IDbConnection>());
            var mockFundingTypeFundingPeriodQueryRepository = new Mock<IFundingTypeFundingPeriodQueryRepository>();
            var mockCrmContractRepository = new Mock<ICrmContractRepository>();
            FundingTypeFundingPeriodKey fundingTypeFundingPeriodKey = new FundingTypeFundingPeriodKey("dummyCode", "dummyPeriod");
            var validFundingTypeFundingPeriod = GetValidDefaultFundingTypeFundingPeriod();

            mockFundingTypeFundingPeriodQueryRepository.Setup(m => m.Get(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<ConnectionInfo>())).Returns(validFundingTypeFundingPeriod);
            mockCrmContractRepository.Setup(m => m.IsThereNoSubsequentDraftContracts(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>())).Returns(false);
            mockCrmContractRepository.Setup(m => m.GetFundingTypeFundingPeriodKeyForGivenContract(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>())).Returns(fundingTypeFundingPeriodKey);
            mockCrmContractRepository
                .Setup(m => m.IsContractApprovedWithSubstatus(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>(), It.IsAny<string[]>()))
                .Returns(false);

            NonFinancialAmendmentValidationService nonFinancialAmendmentValidationService =
                new NonFinancialAmendmentValidationService(mockCrmContractRepository.Object, mockFundingTypeFundingPeriodQueryRepository.Object, Mock.Of<IDate>());

            // Act
            string returnedValidationText = nonFinancialAmendmentValidationService.IsValid(new ContractIdentifier("dummy contract number", 1, 0), mockConnectionInfo.Object);

            // Assert
            Assert.AreEqual(NotApprovedStatusValidationErrorMessage, returnedValidationText);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void NonFinancialAmendmentValidationService_IsValid_WhenAssociatedWithAFundingTypeFundingPeriodWithInvalidGenerateContractDocumentationFlagSet_ShouldReturnCorrectErrorMessage()
        {
            // Arrange
            var mockConnectionInfo = new Mock<ConnectionInfo>(null, Mock.Of<IDbConnection>());
            var mockFundingTypeFundingPeriodQueryRepository = new Mock<IFundingTypeFundingPeriodQueryRepository>();
            var mockCrmContractRepository = new Mock<ICrmContractRepository>();
            FundingTypeFundingPeriodKey fundingTypeFundingPeriodKey = new FundingTypeFundingPeriodKey("dummyCode", "dummyPeriod");
            var invalidFundingTypeFundingPeriod = GetDefaultFundingTypeFundingPeriod(c =>
            {
                c.FundingTypeCode = fundingTypeFundingPeriodKey.FundingTypeCode;
                c.FundingPeriodName = fundingTypeFundingPeriodKey.FundingPeriodName;
                c.DocumentsRequired = false;
                c.SkipDocumentMerge = false;
                c.ContractingActivityCloseDate = null;
            });

            mockFundingTypeFundingPeriodQueryRepository.Setup(m => m.Get(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<ConnectionInfo>())).Returns(invalidFundingTypeFundingPeriod);
            mockCrmContractRepository.Setup(m => m.IsThereNoSubsequentDraftContracts(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>())).Returns(true);
            mockCrmContractRepository.Setup(m => m.IsContractApprovedWithSubstatus(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>(), It.IsAny<string[]>())).Returns(true);
            mockCrmContractRepository.Setup(m => m.GetFundingTypeFundingPeriodKeyForGivenContract(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>())).Returns(fundingTypeFundingPeriodKey);

            NonFinancialAmendmentValidationService nonFinancialAmendmentValidationService =
                new NonFinancialAmendmentValidationService(mockCrmContractRepository.Object, mockFundingTypeFundingPeriodQueryRepository.Object, Mock.Of<IDate>());

            // Act
            string returnedValidationText = nonFinancialAmendmentValidationService.IsValid(new ContractIdentifier("dummy contract number", 1, 0), mockConnectionInfo.Object);

            // Assert
            string expectedError = string.Format(FundingTypeFundingPeriodValidationErrorMessage, fundingTypeFundingPeriodKey.FundingTypeCode, fundingTypeFundingPeriodKey.FundingPeriodName);
            Assert.AreEqual(expectedError, returnedValidationText);

        }

        [TestMethod, TestCategory("UnitTest")]
        public void NonFinancialAmendmentValidationService_IsValid_WhenAssociatedWithAFundingTypeFundingPeriodWithInvalidSkipDocumentMergeFlagSet_ShouldReturnCorrectErrorMessage()
        {
            // Arrange
            var mockConnectionInfo = new Mock<ConnectionInfo>(null, Mock.Of<IDbConnection>());
            var mockFundingTypeFundingPeriodQueryRepository = new Mock<IFundingTypeFundingPeriodQueryRepository>();
            var mockCrmContractRepository = new Mock<ICrmContractRepository>();
            FundingTypeFundingPeriodKey fundingTypeFundingPeriodKey = new FundingTypeFundingPeriodKey("dummyCode", "dummyPeriod");
            var invalidFundingTypeFundingPeriod = GetDefaultFundingTypeFundingPeriod(c =>
            {
                c.FundingTypeCode = fundingTypeFundingPeriodKey.FundingTypeCode;
                c.FundingPeriodName = fundingTypeFundingPeriodKey.FundingPeriodName;
                c.DocumentsRequired = true;
                c.SkipDocumentMerge = true;
                c.ContractingActivityCloseDate = null;
            });

            mockFundingTypeFundingPeriodQueryRepository.Setup(m => m.Get(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<ConnectionInfo>())).Returns(invalidFundingTypeFundingPeriod);
            mockCrmContractRepository.Setup(m => m.IsThereNoSubsequentDraftContracts(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>())).Returns(true);
            mockCrmContractRepository.Setup(m => m.IsContractApprovedWithSubstatus(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>(), It.IsAny<string[]>())).Returns(true);
            mockCrmContractRepository.Setup(m => m.GetFundingTypeFundingPeriodKeyForGivenContract(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>())).Returns(fundingTypeFundingPeriodKey);
            mockCrmContractRepository.Setup(m => m.GetFundingTypeFundingPeriodKeyForGivenContract(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>())).Returns(fundingTypeFundingPeriodKey);

            NonFinancialAmendmentValidationService nonFinancialAmendmentValidationService =
                new NonFinancialAmendmentValidationService(mockCrmContractRepository.Object,
                    mockFundingTypeFundingPeriodQueryRepository.Object, Mock.Of<IDate>());

            // Act
            string returnedValidationText = nonFinancialAmendmentValidationService.IsValid(new ContractIdentifier("dummy contract number", 1, 0), mockConnectionInfo.Object);

            // Assert
            string expectedError = string.Format(FundingTypeFundingPeriodValidationErrorMessage, fundingTypeFundingPeriodKey.FundingTypeCode, fundingTypeFundingPeriodKey.FundingPeriodName);
            Assert.AreEqual(expectedError, returnedValidationText);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void NonFinancialAmendmentValidationService_IsValid_WhenAssociatedWithAFundingTypeFundingPeriodWithContractingActivityCloseDateBeforeCurrentDate_ShoulReturnCorrectErrorMessage()
        {
            // Arrange
            var mockConnectionInfo = new Mock<ConnectionInfo>(null, Mock.Of<IDbConnection>());
            var mockFundingTypeFundingPeriodQueryRepository = new Mock<IFundingTypeFundingPeriodQueryRepository>();
            var mockCrmContractRepository = new Mock<ICrmContractRepository>();
            var mockDate = new Mock<IDate>();
            DateTime mockCurrentDate = new DateTime(2018, 1, 1, 17, 0, 0);

            FundingTypeFundingPeriodKey fundingTypeFundingPeriodKey = new FundingTypeFundingPeriodKey("dummyCode", "dummyPeriod");
            var invalidFundingTypeFundingPeriod = GetDefaultFundingTypeFundingPeriod(c =>
            {
                c.FundingTypeCode = fundingTypeFundingPeriodKey.FundingTypeCode;
                c.FundingPeriodName = fundingTypeFundingPeriodKey.FundingPeriodName;
                c.DocumentsRequired = true;
                c.SkipDocumentMerge = false;
                c.ContractingActivityCloseDate = mockCurrentDate.AddSeconds(-1);
            });
            mockFundingTypeFundingPeriodQueryRepository.Setup(m => m.Get(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<ConnectionInfo>())).Returns(invalidFundingTypeFundingPeriod);

            mockCrmContractRepository.Setup(m => m.IsThereNoSubsequentDraftContracts(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>())).Returns(true);
            mockCrmContractRepository.Setup(m => m.IsContractApprovedWithSubstatus(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>(), It.IsAny<string[]>())).Returns(true);
            mockCrmContractRepository.Setup(m => m.GetFundingTypeFundingPeriodKeyForGivenContract(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>())).Returns(fundingTypeFundingPeriodKey);

            mockDate.Setup(m => m.GetCalculationDate()).Returns(mockCurrentDate);

            NonFinancialAmendmentValidationService nonFinancialAmendmentValidationService =
                new NonFinancialAmendmentValidationService(mockCrmContractRepository.Object,
                    mockFundingTypeFundingPeriodQueryRepository.Object, mockDate.Object);


            // Act
            string returnedValidationText = nonFinancialAmendmentValidationService.IsValid(new ContractIdentifier("dummy contract number", 1, 0), mockConnectionInfo.Object);

            // Assert
            string expectedError = string.Format(ContractActivityCloseDatePastValidationErrorMessage, fundingTypeFundingPeriodKey.FundingTypeCode, fundingTypeFundingPeriodKey.FundingPeriodName);
            Assert.AreEqual(expectedError, returnedValidationText);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void NonFinancialAmendmentValidationService_IsValid_WhenAssociatedWithAFundingTypeFundingPeriodWithContractingActivityCloseDateAfterCurrentDate_ShouldNotReturnAnErrorMessage()
        {
            // Arrange
            var mockConnectionInfo = new Mock<ConnectionInfo>(null, Mock.Of<IDbConnection>());
            var mockFundingTypeFundingPeriodQueryRepository = new Mock<IFundingTypeFundingPeriodQueryRepository>();
            var mockCrmContractRepository = new Mock<ICrmContractRepository>();
            DateTime mockCurrentDate = new DateTime(2018, 1, 1, 17, 0, 0);
            var mockDate = new Mock<IDate>();

            FundingTypeFundingPeriodKey fundingTypeFundingPeriodKey = new FundingTypeFundingPeriodKey("dummyCode", "dummyPeriod");
            FundingTypeFundingPeriod validDefaultFundingTypeFundingPeriod = GetDefaultFundingTypeFundingPeriod(c =>
            {
                c.FundingTypeCode = fundingTypeFundingPeriodKey.FundingTypeCode;
                c.FundingPeriodName = fundingTypeFundingPeriodKey.FundingPeriodName;
                c.DocumentsRequired = true;
                c.SkipDocumentMerge = false;
                c.ContractingActivityCloseDate = mockCurrentDate.AddSeconds(1);
            });

            mockDate.Setup(m => m.GetCalculationDate()).Returns(mockCurrentDate);
            mockFundingTypeFundingPeriodQueryRepository.Setup(m => m.Get(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<ConnectionInfo>())).Returns(validDefaultFundingTypeFundingPeriod);
            mockCrmContractRepository.Setup(m => m.IsThereNoSubsequentDraftContracts(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>())).Returns(true);
            mockCrmContractRepository.Setup(m => m.IsContractApprovedWithSubstatus(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>(), It.IsAny<string[]>())).Returns(true);
            mockCrmContractRepository.Setup(m => m.GetFundingTypeFundingPeriodKeyForGivenContract(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>())).Returns(fundingTypeFundingPeriodKey);

            NonFinancialAmendmentValidationService nonFinancialAmendmentValidationService =
                new NonFinancialAmendmentValidationService(mockCrmContractRepository.Object, mockFundingTypeFundingPeriodQueryRepository.Object, mockDate.Object);

            // Act
            string returnedValidationText = nonFinancialAmendmentValidationService.IsValid(new ContractIdentifier("dummy contract number", 1, 0), mockConnectionInfo.Object);

            // Assert
            Assert.IsNull(returnedValidationText, $"Returned {returnedValidationText} when null was expected");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void NonFinancialAmendmentValidationService_IsValid_WhenEverythingIsValid_ShouldReturnNull()
        {
            // Arrange
            var mockConnectionInfo = new Mock<ConnectionInfo>(null, Mock.Of<IDbConnection>());
            var mockFundingTypeFundingPeriodQueryRepository = new Mock<IFundingTypeFundingPeriodQueryRepository>();
            var mockCrmContractRepository = new Mock<ICrmContractRepository>();
            DateTime mockCurrentDate = new DateTime(2018, 1, 1, 17, 0, 0);
            var mockDate = new Mock<IDate>();

            FundingTypeFundingPeriodKey fundingTypeFundingPeriodKey = new FundingTypeFundingPeriodKey("dummyCode", "dummyPeriod");
            FundingTypeFundingPeriod validDefaultFundingTypeFundingPeriod = GetDefaultFundingTypeFundingPeriod(c =>
            {
                c.FundingTypeCode = fundingTypeFundingPeriodKey.FundingTypeCode;
                c.FundingPeriodName = fundingTypeFundingPeriodKey.FundingPeriodName;
                c.DocumentsRequired = true;
                c.SkipDocumentMerge = false;
                c.ContractingActivityCloseDate = mockCurrentDate;
            });

            mockDate.Setup(m => m.GetCalculationDate()).Returns(mockCurrentDate);
            mockFundingTypeFundingPeriodQueryRepository.Setup(m => m.Get(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<ConnectionInfo>())).Returns(validDefaultFundingTypeFundingPeriod);
            mockCrmContractRepository.Setup(m => m.IsThereNoSubsequentDraftContracts(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>())).Returns(true);
            mockCrmContractRepository.Setup(m => m.IsContractApprovedWithSubstatus(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>(), It.IsAny<string[]>())).Returns(true);
            mockCrmContractRepository.Setup(m => m.GetFundingTypeFundingPeriodKeyForGivenContract(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>())).Returns(fundingTypeFundingPeriodKey);

            NonFinancialAmendmentValidationService nonFinancialAmendmentValidationService =
                new NonFinancialAmendmentValidationService(mockCrmContractRepository.Object, mockFundingTypeFundingPeriodQueryRepository.Object, mockDate.Object);

            // Act
            string returnedValidationText = nonFinancialAmendmentValidationService.IsValid(new ContractIdentifier("dummy contract number", 1, 0), mockConnectionInfo.Object);

            // Assert
            Assert.IsNull(returnedValidationText, $"Returned {returnedValidationText} when null was expected");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void NonFinancialAmendmentValidationService_IsValid_WhenContractHasSiblingContractWithDraftStatus_ShouldReturnCorrectErrorMessage()
        {
            // Arrange
            var mockConnectionInfo = new Mock<ConnectionInfo>(null, Mock.Of<IDbConnection>());
            var mockFundingTypeFundingPeriodQueryRepository = new Mock<IFundingTypeFundingPeriodQueryRepository>();
            var mockCrmContractRepository = new Mock<ICrmContractRepository>();
            DateTime mockCurrentDate = new DateTime(2018, 1, 1, 17, 0, 0);
            var mockDate = new Mock<IDate>();

            FundingTypeFundingPeriodKey fundingTypeFundingPeriodKey = new FundingTypeFundingPeriodKey("dummyCode", "dummyPeriod");
            FundingTypeFundingPeriod validDefaultFundingTypeFundingPeriod = GetDefaultFundingTypeFundingPeriod(c =>
            {
                c.FundingTypeCode = fundingTypeFundingPeriodKey.FundingTypeCode;
                c.FundingPeriodName = fundingTypeFundingPeriodKey.FundingPeriodName;
                c.DocumentsRequired = true;
                c.SkipDocumentMerge = false;
                c.ContractingActivityCloseDate = mockCurrentDate.AddSeconds(1);
                c.IncludeAllContractsOnSummaryOfFunding = true;
            });

            mockDate.Setup(m => m.GetCalculationDate()).Returns(mockCurrentDate);
            mockFundingTypeFundingPeriodQueryRepository.Setup(m => m.Get(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<ConnectionInfo>())).Returns(validDefaultFundingTypeFundingPeriod);
            mockCrmContractRepository.Setup(m => m.IsThereNoSubsequentDraftContracts(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>())).Returns(true);
            mockCrmContractRepository.Setup(m => m.IsContractApprovedWithSubstatus(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>(), It.IsAny<string[]>())).Returns(true);
            mockCrmContractRepository.Setup(m => m.GetFundingTypeFundingPeriodKeyForGivenContract(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>())).Returns(fundingTypeFundingPeriodKey);
            mockCrmContractRepository.Setup(m => m.HasSiblingContractWithDraftStatusOrAmendmentCreationInProgress(It.IsAny<string>())).Returns((true));

            NonFinancialAmendmentValidationService nonFinancialAmendmentValidationService =
                new NonFinancialAmendmentValidationService(mockCrmContractRepository.Object, mockFundingTypeFundingPeriodQueryRepository.Object, mockDate.Object);

            // Act
            string returnedValidationText = nonFinancialAmendmentValidationService.IsValid(new ContractIdentifier("dummy contract number", 1, 0), mockConnectionInfo.Object);

            // Assert
            Assert.AreEqual(HasSiblingContractWithDraftStatusOrAmendmentCreationInProgressErrorMessage, returnedValidationText);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void NonFinancialAmendmentValidationService_IsValid_WhenContractIsModified_ShouldReturnSuccess()
        {
            // arrange
            const string contractNumber = "TEST-1234";
            DeleteContracts(contractNumber);
            CreateApprovedModifiedContract(contractNumber);

            var service = new NonFinancialAmendmentValidationService(
                new CrmContractRepository(CrmConnectionFactory.GetRetryOnErrorOrganizationService()),
                new FundingTypeFundingPeriodQueryRepository(),
                Mock.Of<IDate>());

            ConnectionInfo connectionInfo = ConnectionInfo.CreateFrom(new SqlConnection(ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString));

            // act
            string errorMessage = service.IsValid(new ContractIdentifier("TEST-1234", 1, 0), connectionInfo);

            // assert
            Assert.IsTrue(string.IsNullOrEmpty(errorMessage), $"Error message was not empty: {errorMessage}");
        }

        private static void DeleteContracts(string contractNumber)
        {
            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            using (var context = new XrmServiceContext(organizationService))
            {
                context.sfa_contractSet.Where(c => c.sfa_number == contractNumber)
                    .Select(c => c.Id)
                    .ToList()
                    .ForEach(c => organizationService.Delete(sfa_contract.EntityLogicalName, c));
            }
        }

        private static void CreateApprovedModifiedContract(string contractNumber)
        {
            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            Guid contractId = organizationService.Create(new sfa_contract
            {
                sfa_number = contractNumber,
                sfa_Version = 1,
                sfa_SubVersion = 0,
                sfa_LastApprovedVersion = true,
                sfa_LatestVersion = true,
                sfa_FundingType = GetFundingTypeEntityReference("16-18FU"),
                sfa_PeriodId = GetPeriodEntityReference("FY2021"),
                sfa_ProviderName = GetFirstOrganisationEntityReference(),
            });

            organizationService.Update(new sfa_contract // update needed to set status
            {
                Id = contractId,
                sfa_ContractStatusEnum = sfa_contractstatus.Approved,
                sfa_ContractStatus = new OptionSetValue(Convert.ToInt32(sfa_contractstatus.Approved)),
                sfa_SubStatus = GetStatusEntityReference("Modified"),
            });
        }

        private static EntityReference GetFundingTypeEntityReference(string fundingType)
        {
            using (var context = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                return context.sfa_fundingtypeSet.Single(ft => ft.sfa_fundingtypecode == fundingType).ToEntityReference();
            }
        }

        private static EntityReference GetPeriodEntityReference(string period)
        {
            using (var context = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                return context.sfa_periodSet.Single(p => p.sfa_periodname == period).ToEntityReference();
            }
        }

        private static EntityReference GetFirstOrganisationEntityReference()
        {
            using (var context = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                return context.AccountSet.First().ToEntityReference();
            }
        }

        private static EntityReference GetStatusEntityReference(string statusName)
        {
            using (var context = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                return context.sfa_statusSet.Single(s => s.sfa_name == statusName).ToEntityReference();
            }
        }

        private static FundingTypeFundingPeriod GetValidDefaultFundingTypeFundingPeriod()
        {
            FundingTypeFundingPeriod validDefaultFundingTypeFundingPeriod = GetDefaultFundingTypeFundingPeriod(c =>
            {
                c.FundingTypeCode = DefaultFundingTypeCode;
                c.FundingPeriodName = DefaultPeriodName;
                c.DocumentsRequired = true;
                c.SkipDocumentMerge = false;
                c.ContractingActivityCloseDate = null;
            });
            return validDefaultFundingTypeFundingPeriod;
        }

        private static FundingTypeFundingPeriod GetDefaultFundingTypeFundingPeriod(Action<FundingTypeFundingPeriod> creator = null)
        {
            FundingTypeFundingPeriod fundingTypeFundingPeriod = new FundingTypeFundingPeriod()
            {
                FundingPeriodName = DefaultPeriodName,
                FundingTypeCode = DefaultFundingTypeCode,
                DocumentsRequired = false,
                SkipDocumentMerge = false,
                ContractingActivityCloseDate = DateTime.MinValue
            };

            creator?.Invoke(fundingTypeFundingPeriod);
            return fundingTypeFundingPeriod;
        }
    }
}
