namespace FundingAllocation.Tests.Endpoints.ReleaseGroup.Services
{
    using System.Collections.Generic;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using FluentAssertions;
    using Moq;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using FundingAllocation.Dto;
    using FundingAllocation.Endpoints.ReleaseGroup.Services;
    using FundingAllocation.Repositories;
    using System;
    using LanguageExt;
    using FundingAllocation.Endpoints.ReleaseGroup.Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using SFA.FCT.CrossDomain.Integration.Messages.Dtos;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Dtos;

    [TestClass]
    public class IntentServiceTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void IntentService_GetIntent_ShouldReturnIntentNew_WhenThereAreNoExistingContracts()
        {
            // arrange
            const int randomUkprn = 1;
            const string randomFundingTypeCode = "";
            const string randomFundingPeriodCode = "";
            var crmContractStatusInfos = new List<CrmContractStatusInfo>();

            var crmContractRepositoryMock = new Mock<ICrmContractRepository>();
            crmContractRepositoryMock
                .Setup(m => m.GetContractStatusInfosForUkprn(It.IsAny<int>(), It.IsAny<string>()))
                .ReturnsAsync(crmContractStatusInfos);

            Mock<IFundingTypeFundingPeriodRepository> fundingTypeFundingPeriodRepositoryMock = new Mock<IFundingTypeFundingPeriodRepository>();
            fundingTypeFundingPeriodRepositoryMock
                .Setup(r => r.GetAmendmentInfo(It.IsAny<string>(), It.IsAny<string>())).ReturnsAsync(
                    new IntentFundingTypeFundingPeriod(false, null, null, null));
            var intentService = new IntentService(crmContractRepositoryMock.Object, fundingTypeFundingPeriodRepositoryMock.Object);

            // act
            var returnedIntent = intentService.GetIntent(randomUkprn, randomFundingTypeCode, randomFundingPeriodCode, null, new List<ContractAndStatus>()).Result;

            // assert
            returnedIntent.Intent.Should().Be(ContractIntent.New);
            Assert.AreEqual(Option<CrmContractInfo>.None, returnedIntent.ExistingCrmContract, "ExistingCrmContract is not null");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void IntentService_GetIntent_ShouldReturnIntentUpdateDraft_WhenTheLatestContractStatusIsDraftAndThereWasNotAPreviousContractWithApprovedStatus()
        {
            // arrange
            const int randomUkprn = 1;

            const string randomContractNo = "contractNo";
            const bool randomLastVersion = false;
            const int randomVersion = -999;
            const int randomSubVersion = -999;
            const string randomCrmEntityId = "crmEntityId";
            const string randomFundingTypeCode = "";
            const string randomFundingPeriodCode = "";

            var contractStatusFirstVersion = new CrmContractStatusInfo(randomContractNo, "NotApproved", "subStatus", randomLastVersion, randomVersion, 
                randomSubVersion, DateTime.Now.AddDays(-7),  randomCrmEntityId, "masterContractNumber", "", "", false, "Variation");
            var contractStatusSecondVersion = new CrmContractStatusInfo(randomContractNo, "Draft", "Unassigned", true, randomVersion, 
                randomSubVersion, DateTime.Now, randomCrmEntityId, "masterContractNumber", "", "", false, "Variation");

            var crmContractStatusInfos = new List<CrmContractStatusInfo>();
            crmContractStatusInfos.Add(contractStatusSecondVersion);
            crmContractStatusInfos.Add(contractStatusFirstVersion);

            var crmContractRepositoryMock = new Mock<ICrmContractRepository>();
            crmContractRepositoryMock
                .Setup(m => m.GetContractStatusInfosForUkprn(It.IsAny<int>(), It.IsAny<string>()))
                .ReturnsAsync(crmContractStatusInfos);

            var fundingTypeFundingPeriodRepositoryMock = new Mock<IFundingTypeFundingPeriodRepository>();
            fundingTypeFundingPeriodRepositoryMock
                .Setup(m => m.GetAmendmentInfo(It.IsAny<string>(), It.IsAny<string>()))
                .ReturnsAsync(new IntentFundingTypeFundingPeriod(false, "", "", ""));

            var intentService = new IntentService(crmContractRepositoryMock.Object, fundingTypeFundingPeriodRepositoryMock.Object);

            // act
            var returnedIntent = intentService.GetIntent(randomUkprn, randomFundingTypeCode, randomFundingPeriodCode, null, new List<ContractAndStatus>()).Result;

            // assert
            returnedIntent.Intent.Should().Be(ContractIntent.UpdateDraft);
            Assert.IsNotNull(returnedIntent.ExistingCrmContract, "ExistingCrmContract is null");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void IntentService_GetIntent_ShouldReturnIntentUpdateDraftAmendment_WhenTheLatestContractStatusIsDraftAndThereWasAPreviousContractWithApprovedStatus()
        {
            // arrange
            const int randomUkprn = 1;
            const string randomContractNo = "contractNo";
            const bool randomLastVersion = false;
            const int randomVersion = -999;
            const int randomSubVersion = -999;
            const string randomCrmEntityId = "crmEntityId";
            const string randomFundingTypeCode = "";
            const string randomFundingPeriodCode = "";

            var contractStatusFirstVersion = new CrmContractStatusInfo(randomContractNo, "Approved", "subStatus", randomLastVersion, randomVersion, randomSubVersion, 
                DateTime.Now.AddDays(-14), randomCrmEntityId, "masterContractNumber", "", "", false, "Variation");
            var contractStatusSecondVersion = new CrmContractStatusInfo(randomContractNo, "Withdrawn", "subStatus", randomLastVersion, randomVersion, randomSubVersion, 
                DateTime.Now.AddDays(-7), randomCrmEntityId, "masterContractNumber", "", "", false, "Variation");
            var contractStatusThirdVersion = new CrmContractStatusInfo(randomContractNo, "Draft", "In Review", true, randomVersion, randomSubVersion, 
                DateTime.Now, randomCrmEntityId, "masterContractNumber", "", "", false, "Variation");

            var crmContractStatusInfos = new List<CrmContractStatusInfo>();
            crmContractStatusInfos.Add(contractStatusThirdVersion);
            crmContractStatusInfos.Add(contractStatusSecondVersion);
            crmContractStatusInfos.Add(contractStatusFirstVersion);

            var crmContractRepositoryMock = new Mock<ICrmContractRepository>();
            crmContractRepositoryMock
                .Setup(m => m.GetContractStatusInfosForUkprn(It.IsAny<int>(), It.IsAny<string>()))
                .ReturnsAsync(crmContractStatusInfos);

            var fundingTypeFundingPeriodRepositoryMock = new Mock<IFundingTypeFundingPeriodRepository>();
            fundingTypeFundingPeriodRepositoryMock
                .Setup(m => m.GetAmendmentInfo(It.IsAny<string>(), It.IsAny<string>()))
                .ReturnsAsync(new IntentFundingTypeFundingPeriod(false, "", "", ""));

            var intentService = new IntentService(crmContractRepositoryMock.Object, fundingTypeFundingPeriodRepositoryMock.Object);

            // act
            var returnedIntent = intentService.GetIntent(randomUkprn, randomFundingTypeCode, randomFundingPeriodCode, null, new List<ContractAndStatus>()).Result;

            // assert
            returnedIntent.Intent.Should().Be(ContractIntent.UpdateDraftAmendment);
            Assert.IsNotNull(returnedIntent.ExistingCrmContract, "ExistingCrmContract is null");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void IntentService_GetIntent_ShouldReturnNewAmendment_WhenAmendmentsAllowedAndTheLatestContractStatusIsApprovedAndOfThePreviousFundingTypeAndPeriod()
        {
            // arrange
            const int randomUkprn = 1;
            const string randomContractNo = "contractNo";
            const bool lastVersion = true;
            const int randomVersion = -999;
            const int randomSubVersion = -999;
            const string randomCrmEntityId = "crmEntityId";
            const string fundingTypeCode = "fundingCode";
            const string fundingPeriodCode = "fundingPeriodCode";
            const string previousFundingType = "previousFundingType";
            const string previousFundingPeriod = "previousFundingPeriod";
            const string ftpGroupCode = "previousFtpGroupCode";

            var contractStatusSecondVersion = new CrmContractStatusInfo(randomContractNo, "Approved", "subStatus", lastVersion, randomVersion, randomSubVersion,
                DateTime.Now, randomCrmEntityId, "masterContractNumber", previousFundingPeriod, fundingTypeCode, true, "Variation");
            var contractStatusFirstVersion = new CrmContractStatusInfo(randomContractNo, "Approved", "subStatus", lastVersion, randomVersion, randomSubVersion,
                DateTime.Now.AddDays(-14), randomCrmEntityId, "masterContractNumber", previousFundingPeriod, previousFundingType, true, "Variation");

            var fundingTypeFundingPeriodRepository = new Mock<IFundingTypeFundingPeriodRepository>();
            fundingTypeFundingPeriodRepository.Setup(r => r.GetAmendmentInfo(fundingTypeCode, fundingPeriodCode))
                .ReturnsAsync(new IntentFundingTypeFundingPeriod(true, previousFundingPeriod, previousFundingType, ftpGroupCode));

            var crmContractStatusInfos = new List<CrmContractStatusInfo>
            {
                contractStatusFirstVersion, contractStatusSecondVersion
            };

            var crmContractRepositoryMock = new Mock<ICrmContractRepository>();
            crmContractRepositoryMock
                .Setup(m => m.GetContractStatusInfosForUkprn(It.IsAny<int>(), It.IsAny<string>()))
                .ReturnsAsync(crmContractStatusInfos);

            var intentService = new IntentService(crmContractRepositoryMock.Object, fundingTypeFundingPeriodRepository.Object);

            // act
            var returnedIntent = intentService.GetIntent(randomUkprn, fundingTypeCode, fundingPeriodCode, new List<ContractIdentity>(), new List<ContractAndStatus>()).Result;

            // assert
            returnedIntent.Intent.Should().Be(ContractIntent.NewAmendment);
            Assert.IsNotNull(returnedIntent.ExistingCrmContract, "ExistingCrmContract is null");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void IntentService_GetIntent_ShouldReturnNewAmendment_WhenCrmContractStatusInfosIncludesDraftStatusButItIsTheContractIdentityToIgnore()
        {
            // arrange
            const int randomUkprn = 1;
            const string randomContractNo = "contractNo";
            const bool lastVersion = true;
            const string randomCrmEntityId = "crmEntityId";
            const string fundingTypeCode = "fundingCode";
            const string fundingPeriodCode = "fundingPeriodCode";
            const string previousFundingType = "previousFundingType";
            const string previousFundingPeriod = "previousFundingPeriod";
            const string ftpGroupCode = "previousFtpGroupCode";

            var contractStatusSecondVersion = new CrmContractStatusInfo(randomContractNo, "Approved", "subStatus", lastVersion, 3, 0,
                DateTime.Now, randomCrmEntityId, "masterContractNumber", previousFundingPeriod, fundingTypeCode, true, "Variation");
            var contractStatusFirstVersion = new CrmContractStatusInfo(randomContractNo, "Approved", "subStatus", lastVersion, 2, 0,
                DateTime.Now.AddDays(-14), randomCrmEntityId, "masterContractNumber", previousFundingPeriod, previousFundingType, true, "Variation");
            var draftContractDeletedContractStatus = new CrmContractStatusInfo(randomContractNo, "Draft", "subStatus", lastVersion, 1, 0,
                DateTime.Now.AddDays(-14), randomCrmEntityId, "masterContractNumber", previousFundingPeriod, previousFundingType, true, "Variation");

            var fundingTypeFundingPeriodRepository = new Mock<IFundingTypeFundingPeriodRepository>();
            fundingTypeFundingPeriodRepository.Setup(r => r.GetAmendmentInfo(fundingTypeCode, fundingPeriodCode))
                .ReturnsAsync(new IntentFundingTypeFundingPeriod(true, previousFundingPeriod, previousFundingType, ftpGroupCode));

            var crmContractStatusInfos = new List<CrmContractStatusInfo>
            {
                contractStatusFirstVersion, contractStatusSecondVersion, draftContractDeletedContractStatus
            };

            var crmContractRepositoryMock = new Mock<ICrmContractRepository>();
            crmContractRepositoryMock
                .Setup(m => m.GetContractStatusInfosForUkprn(It.IsAny<int>(), It.IsAny<string>()))
                .ReturnsAsync(crmContractStatusInfos);

            var contractIdentityToIgnore = new ContractIdentity(
                draftContractDeletedContractStatus.Number,
                draftContractDeletedContractStatus.Version,
                draftContractDeletedContractStatus.SubVersion);

            var intentService = new IntentService(crmContractRepositoryMock.Object, fundingTypeFundingPeriodRepository.Object);

            // act
            var returnedIntent = intentService.GetIntent(randomUkprn, fundingTypeCode, fundingPeriodCode, new List<ContractIdentity>{contractIdentityToIgnore}, new List<ContractAndStatus>()).Result;

            // assert
            returnedIntent.Intent.Should().Be(ContractIntent.NewAmendment);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void IntentService_GetIntent_ShouldReturnRevisedNew_WithCurrentPeriodMatchingContract()
        {
            // arrange
            const int randomUkprn = 1;
            const string randomContractNo = "contractNo";
            const bool lastVersion = false;
            const int randomVersion = -999;
            const int randomSubVersion = -999;
            const string randomCrmEntityId = "crmEntityId";
            const string fundingTypeCode = "fundingCode";
            const string fundingPeriodCode = "fundingPeriodCode";
            const string previousFundingType = "previousFundingType";
            const string previousFundingPeriod = "previousFundingPeriod";
            const string ftpGroupCode = "previousFtpGroupCode";
            const string contractNumberForCurrentPeriod = "CN -12";

            var contractStatusSecondVersion = new CrmContractStatusInfo(randomContractNo, "Approved", "subStatus", lastVersion, randomVersion, randomSubVersion,
                DateTime.Now, randomCrmEntityId, "masterContractNumber", previousFundingPeriod, fundingTypeCode, true, "Variation");
            var contractStatusFirstVersion = new CrmContractStatusInfo(randomContractNo, "Approved", "subStatus", lastVersion, randomVersion, randomSubVersion,
                DateTime.Now.AddDays(-14), randomCrmEntityId, "masterContractNumber", previousFundingPeriod, previousFundingType, true, "Variation");
            var contractStatusLatest = new CrmContractStatusInfo(contractNumberForCurrentPeriod, "Approved", "subStatus", lastVersion, randomVersion, randomSubVersion,
                DateTime.Now.AddDays(1), randomCrmEntityId, "masterContractNumber", fundingPeriodCode, previousFundingType, true, "Variation");

            var fundingTypeFundingPeriodRepository = new Mock<IFundingTypeFundingPeriodRepository>();
            fundingTypeFundingPeriodRepository.Setup(r => r.GetAmendmentInfo(fundingTypeCode, fundingPeriodCode))
                .ReturnsAsync(new IntentFundingTypeFundingPeriod(true, previousFundingPeriod, previousFundingType, ftpGroupCode));

            var crmContractStatusInfos = new List<CrmContractStatusInfo>
            {
                contractStatusFirstVersion, contractStatusSecondVersion, contractStatusLatest
            };

            var crmContractRepositoryMock = new Mock<ICrmContractRepository>();
            crmContractRepositoryMock
                .Setup(m => m.GetContractStatusInfosForUkprn(It.IsAny<int>(), It.IsAny<string>()))
                .ReturnsAsync(crmContractStatusInfos);

            var intentService = new IntentService(crmContractRepositoryMock.Object, fundingTypeFundingPeriodRepository.Object);

            // act
            var returnedIntent = intentService.GetIntent(randomUkprn, fundingTypeCode, fundingPeriodCode, new List<ContractIdentity>(), new List<ContractAndStatus>()).Result;

            // assert
            returnedIntent.Intent.Should().Be(ContractIntent.RevisedNew);
            Assert.IsNotNull(returnedIntent.ExistingCrmContract, "ExistingCrmContract is null");
            returnedIntent.ExistingCrmContract.Match(Some: c => c.Number.Should().Be(contractNumberForCurrentPeriod),
                None: Assert.Fail);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void IntentService_GetIntent_ShouldReturnQueue_WhenTheFundingTypeIsDadaWeShouldChooseTheEarliestFundingPeriod()
        {
            // arrange
            const int randomUkprn = 1;
            const string contractNo2021 = "DADAS-341";
            const string contractNo2122 = "DADAS-2856";
            const bool lastVersion = true;

            const string randomCrmEntityId = "crmEntityId";
            const string fundingTypeCode = "DADA";
            const string fundingPeriodCode = "AY2122";
            const string previousFundingPeriod = "AY2021";
            const string ftpGroupCode = "DADA2020";
            DateTime createdDateFor2021 = new DateTime(2021, 07, 2);
            DateTime createdDateFor2022 = new DateTime(2021, 07, 1);

            var contractFor2021 = new CrmContractStatusInfo(contractNo2021, "Approved", "Approved", false, 1, 0,
                createdDateFor2021, randomCrmEntityId, "masterContractNumber", previousFundingPeriod, fundingTypeCode, true, "Variation");

            var contractFor2021V2 = new CrmContractStatusInfo(contractNo2021, "Draft", "Awaiting Documentation ", lastVersion, 2, 0,
                createdDateFor2021, randomCrmEntityId, "masterContractNumber", previousFundingPeriod, fundingTypeCode, false, "Variation");

            var contractFor2122 = new CrmContractStatusInfo(contractNo2122, "Approved", "Approved", lastVersion, 1, 0,
                createdDateFor2022, randomCrmEntityId, "masterContractNumber", fundingPeriodCode, fundingTypeCode, true, "Variation");

            var fundingTypeFundingPeriodRepository = new Mock<IFundingTypeFundingPeriodRepository>();
            fundingTypeFundingPeriodRepository.Setup(r => r.GetAmendmentInfo(fundingTypeCode, fundingPeriodCode))
                .ReturnsAsync(new IntentFundingTypeFundingPeriod(true, previousFundingPeriod, fundingTypeCode, ftpGroupCode));

            var crmContractStatusInfos = new List<CrmContractStatusInfo>
            {
                 contractFor2122, contractFor2021, contractFor2021V2
            };

            var crmContractRepositoryMock = new Mock<ICrmContractRepository>();
            crmContractRepositoryMock
                .Setup(m => m.GetContractStatusInfosForUkprn(It.IsAny<int>(), It.IsAny<string>()))
                .ReturnsAsync(crmContractStatusInfos);

            var intentService = new IntentService(crmContractRepositoryMock.Object, fundingTypeFundingPeriodRepository.Object);

            // act
            var returnedIntent = intentService.GetIntent(randomUkprn, fundingTypeCode, fundingPeriodCode, new List<ContractIdentity>(), new List<ContractAndStatus>()).Result;

            // assert
            returnedIntent.Intent.Should().Be(ContractIntent.Queue);
            Assert.IsNotNull(returnedIntent.ExistingCrmContract, "ExistingCrmContract is null");
            returnedIntent.ExistingCrmContract.Match(Some: c => c.Number.Should().Be(contractNo2021),
                None: Assert.Fail);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void IntentService_GetIntent_ShouldReturnQueue_A342()
        {
            // arrange
            const int randomUkprn = 1;
            const string contractNo2021 = "DADAS-342";
            const string contractNo2122 = "DADAS-2856";
            const bool lastVersion = true;

            const string randomCrmEntityId = "crmEntityId";
            const string fundingTypeCode = "DADA";
            const string fundingPeriodCode = "AY2122";
            const string previousFundingPeriod = "AY2021";
            const string ftpGroupCode = "DADA2020";
            DateTime createdDateFor2021 = new DateTime(2021, 07, 2);
            DateTime createdDateFor2022 = new DateTime(2021, 07, 1);

            var contractFor2021V2 = new CrmContractStatusInfo(contractNo2021, "Approved", "Approved", true, 2, 0,
                createdDateFor2021, randomCrmEntityId, "masterContractNumber", previousFundingPeriod, fundingTypeCode, true, "Variation");

            var contractFor2021 = new CrmContractStatusInfo(contractNo2021, "Replaced", "Approved", false, 1, 0,
                createdDateFor2021, randomCrmEntityId, "masterContractNumber", previousFundingPeriod, fundingTypeCode, true, "Variation");

            var contractFor2122 = new CrmContractStatusInfo(contractNo2122, "Approved", "Awaiting Termination Initiation Approval", lastVersion, 1, 0,
                createdDateFor2022, randomCrmEntityId, "masterContractNumber", fundingPeriodCode, fundingTypeCode, true, "Variation");

            var fundingTypeFundingPeriodRepository = new Mock<IFundingTypeFundingPeriodRepository>();
            fundingTypeFundingPeriodRepository.Setup(r => r.GetAmendmentInfo(fundingTypeCode, fundingPeriodCode))
                .ReturnsAsync(new IntentFundingTypeFundingPeriod(true, previousFundingPeriod, fundingTypeCode, ftpGroupCode));

            var crmContractStatusInfos = new List<CrmContractStatusInfo>
            {
                 contractFor2122, contractFor2021V2, contractFor2021
            };

            var crmContractRepositoryMock = new Mock<ICrmContractRepository>();
            crmContractRepositoryMock
                .Setup(m => m.GetContractStatusInfosForUkprn(It.IsAny<int>(), It.IsAny<string>()))
                .ReturnsAsync(crmContractStatusInfos);

            var intentService = new IntentService(crmContractRepositoryMock.Object, fundingTypeFundingPeriodRepository.Object);

            // act
            var returnedIntent = intentService.GetIntent(randomUkprn, fundingTypeCode, fundingPeriodCode, null, new List<ContractAndStatus>()).Result;

            // assert
            returnedIntent.Intent.Should().Be(ContractIntent.Queue);
            Assert.IsNotNull(returnedIntent.ExistingCrmContract, "ExistingCrmContract is null");
            returnedIntent.ExistingCrmContract.Match(Some: c => c.Number.Should().Be(contractNo2122),
                None: Assert.Fail);
        }
    }
}