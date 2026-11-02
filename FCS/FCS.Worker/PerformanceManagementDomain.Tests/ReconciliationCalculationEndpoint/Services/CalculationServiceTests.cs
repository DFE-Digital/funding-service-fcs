namespace PerformanceManagementDomain.Tests.ReconciliationCalculationEndpoint.Services
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaim;
    using SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation;
    using DataStore = SFA.FCT.PerformanceManagementDomain.DataStore;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using PerformanceManagementDomain.ReconciliationCalculationEndpoint.Services;
    using ClaimType = SFA.FCT.PerformanceManagementDomain.DataStore.Models.ClaimType;
    using ContractAllocation = SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaim.ContractAllocation;
    using Contractor = SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaim.Contractor;
    using PeriodTypeCode = SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaim.PeriodTypeCode;
    using Reconciliation = SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation;
    using SFA.FCT.PerformanceManagementDomain.DataStore;
    using SFA.FCT.Framework.Logging;
    using PerformanceManagementDomain.ReconciliationCalculationEndpoint;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using System.Data;
    using PerformanceManagementDomain.ReconciliationCalculationEndpoint.Repositories;

    [TestClass]
    public class CalculationServiceTests
    {
        private CalculationService _calculationService;
        private Mock<IClaimReconciliationBehaviourRepository> _claimBehaviourRepoMock;
        private Mock<IFspDeliverableClaimRepository> _fspDeliverableClaimRepoMock;
        private Mock<IContractAllocationRepository> _contractAllocationRepoMock;
        private Mock<IClaimReconciliationAllocationGroupRepository> _claimReconAllocGroupRepoMock;
        private Mock<IClaimTypeRepository> _claimTypeRepoMock;
        private Mock<IClaimReferenceProfileRepository> _claimRefProfileRepoMock;
        private Mock<ConnectionInfo> _connectionInfoMock;
        
        private const string ClaimCollectionCode = "1516-YEAREND";
        private const string CommunityLearningFspCode = "CL1516";
        private const string CommunityLearningAllocGroupCode = "CL1516";
        private const string CommunityLearningAllocNumber = "CL-1234";
        private const string CommunityLearningDeliverableGroupCode = "CL1516";
        private const string CommunityLearningDeliverableGroupName = "Community Learning 15/16";

        private const string DlsFspCode = "DLS1516";
        private const string DlsAndTwentyFourPlusAllocGroupCode = "DLSALLBC1516";
        private const string DlsAllocNumber = "DLS-1234";
        private const string DlsDeliverableGroupCode = "DLS1516";
        private const string DlsDeliverableGroupName = "Discretionary Learner Support 15/16";

        private const string TwentyFourPlusFspCode = "24+ALLBC1516";
        private const string TwentyFourPlusAllocNumber = "ALLBC-1234";
        private const string TwentyFourPlusDeliverableGroupCode = "ALL1516";
        private const string TwentyFourPlusDeliverableGroupName = "Advanced Learner Loans 15/16";

        private const string AdultSkillsFspCode = "ASC1516";
        private const string AdultSkillsAllocNumber = "ASC-1234";
        private const string AdultSkillsAllocGroupCode = "ASC-1516";
        private const string AscAppsDeliverableGroupCode = "ASC1516_APPS";
        private const string AscAppsDeliverableGroupName = "Adult Apprenticeships 15/16";
        private const string AscOtherDeliverableGroupCode = "ASC1516_OTHER";
        private const string AscOtherDeliverableGroupName = "Other ASB 15/16";

        private const int Ukprn = 100001;

        [TestInitialize]
        public void SetUp()
        {
            _claimBehaviourRepoMock = new Mock<IClaimReconciliationBehaviourRepository>();
            _fspDeliverableClaimRepoMock = new Mock<IFspDeliverableClaimRepository>();
            _contractAllocationRepoMock = new Mock<IContractAllocationRepository>();
            _claimReconAllocGroupRepoMock = new Mock<IClaimReconciliationAllocationGroupRepository>();
            _claimTypeRepoMock = new Mock<IClaimTypeRepository>();
            _claimRefProfileRepoMock = new Mock<IClaimReferenceProfileRepository>();

            _connectionInfoMock = new Mock<ConnectionInfo>(null, Mock.Of<IDbConnection>());

            SetupContractAllocationRepoMock();
            SetupClaimReconAllocGroupMock();
            SetupClaimTypeMock();

            _calculationService = new CalculationService(_claimBehaviourRepoMock.Object,
                _fspDeliverableClaimRepoMock.Object,
                _contractAllocationRepoMock.Object,
                _claimReconAllocGroupRepoMock.Object,
                _claimTypeRepoMock.Object,
                new DeliverableGroupAmountSummaryCreator(_claimRefProfileRepoMock.Object));
        }

        private void SetupClaimTypeMock()
        {
            _claimTypeRepoMock.Setup(x => x.FindByName(It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(new ClaimType("ClaimTypeCode", "ClaimTypeName"));
        }

        private void SetupClaimReconAllocGroupMock()
        {
            var claimReconciliationAllocationGroup = new ClaimReconciliationAllocationGroup("AllocGroupCode", "AllocGroupname");

            _claimReconAllocGroupRepoMock.Setup(x => x.Find(It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(claimReconciliationAllocationGroup);
        }

        private void SetupContractAllocationRepoMock()
        {
            var contractAllocation = new DataStore.Models.Allocation.ContractAllocation("AllocNum", DateTime.MinValue, DateTime.MaxValue)
            {
                Contract = new DataStore.Models.Allocation.Contract
                {
                    ContractNumber = "ContractNum",
                    ApprovalDate = DateTime.Today.AddDays(-10),
                    VersionNumber = 1,
                    SubVersionNumber = 0
                },
                Contractor = new DataStore.Models.Allocation.Contractor
                {
                    UKPRN = 100001,
                    LegalName = "LegalName",
                    OrganisationIdentifier = "ORG0001"
                },
                FundingType = new DataStore.Models.Allocation.FundingType
                {
                    FundingTypeName = "FtName",
                    FundingTypeCode = "FtCode"
                },
                Period = new DataStore.Models.Allocation.Period
                {
                    PeriodTypeName = "ACADEMICYEAR"
                }
            };

            _contractAllocationRepoMock.Setup(x => x.Find(It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                            .ReturnsAsync(contractAllocation);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ReconciliationCalculationService_ShouldResolveServiceFromEndpointContainer()
        {
            // arrange
            IWindsorContainer container = new WindsorContainer().Install(new WindsorInstaller(new LoggerFactory()));
            container.Register(Component.For<IPerformanceManagementDbContext>().ImplementedBy<PerformanceManagementDbContext>().IsDefault().LifestyleScoped());
            container.BeginScope();

            // act, assert
            container.Resolve<ICalculationService>();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ReconciliationCalculationService_ShouldCalculateForSingleAllocationAndSingleDeliverableGroup_EqualPlannedAndClaimed()
        {
            using (PerformanceManagementDbContext context = new PerformanceManagementDbContext())
            {
                // arrange
                const decimal plannedValue = 310M;
                _claimBehaviourRepoMock.Setup(x => x.Find(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                    .ReturnsAsync(new ClaimReconciliationBehaviour(ClaimCollectionCode, CommunityLearningAllocGroupCode,
                        isReconciliationPayable: true,
                        doWeReconcileUnderDelivery: true,
                        doWeReconcileOverDelivery: false,
                        underDeliveryDeMinimis: -100m,
                        overDeliveryDeMinimis: 0,
                        publicationCloseDate: null,
                        underDeliveryTolerancePercentage: 0,
                        overDeliveryLimitPercentage: 0,
                        underDeliveryRecoveryAmount: UnderDeliveryRecoveryAmount.Full));

                _fspDeliverableClaimRepoMock.Setup(x => x.GetFspDeliverablesIncludingClaimDeliverableGroup(
                        It.Is<string>(fsp => fsp == CommunityLearningFspCode), It.IsAny<ConnectionInfo>()))
                    .ReturnsAsync(CreateListOfCommunityLearningDeliverableClaims());

                ContractAllocation allocation = CreateContractAllocation(CommunityLearningAllocNumber, CommunityLearningFspCode, plannedValue);
                allocation.DeliverableLines = CreateEqualCommunityLearningDeliverableLines();
                DebatchedFundingClaim fundingClaimToCalculate = CreateDebatchedFundingClaim(CommunityLearningAllocGroupCode);
                fundingClaimToCalculate.ContractAllocations.Add(allocation);

                var mockConnectionInfo = new Mock<ConnectionInfo>(null, Mock.Of<IDbConnection>());

                // act
                FundingClaimReconciliation calculatedReconciliation = _calculationService.Calculate(fundingClaimToCalculate, mockConnectionInfo.Object).Result;

                // assert
                Assert.AreEqual(plannedValue, calculatedReconciliation.Amounts.PlannedValue, "Claim Planned value calculated incorrectly");
                Assert.AreEqual(310m, calculatedReconciliation.Amounts.ClaimedValue, "Claim Claimed value calculated incorrectly");
                Assert.AreEqual(310m, calculatedReconciliation.Amounts.CappedClaimedValue, "Claim Capped Claimed Value calculated incorrectly");
                Assert.AreEqual(0m, calculatedReconciliation.Amounts.ProposedReconciliationValue, "Claim Proposed Reconciliation value calculated incorrectly");

                Assert.AreEqual(plannedValue, calculatedReconciliation.ContractAllocations[0].Amounts.PlannedValue, "Allocation Planned value calculated incorrectly");
                Assert.AreEqual(310m, calculatedReconciliation.ContractAllocations[0].Amounts.ClaimedValue, "Allocation Claimed value calculated incorrectly");
                Assert.AreEqual(310m, calculatedReconciliation.ContractAllocations[0].Amounts.CappedClaimedValue, "Allocation CappedClaimedValue calculated incorrectly");
                Assert.AreEqual(0m, calculatedReconciliation.ContractAllocations[0].Amounts.ProposedReconciliationValue, "Allocation ProposedReconciliationValue calculated incorrectly");
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ReconciliationCalculationService_ShouldCalculateForSingleAllocationAndSingleDeliverableGroup_UnderDelivery_LessThanDeminimis()
        {
            // arrange
            const decimal plannedValue = 310M;
            _claimBehaviourRepoMock.Setup(x => x.Find(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(new ClaimReconciliationBehaviour(ClaimCollectionCode, CommunityLearningAllocGroupCode,
                    isReconciliationPayable: true,
                    doWeReconcileUnderDelivery: true,
                    doWeReconcileOverDelivery: false,
                    underDeliveryDeMinimis: -100m,
                    overDeliveryDeMinimis: 0,
                    publicationCloseDate: null,
                    underDeliveryTolerancePercentage: 0,
                    overDeliveryLimitPercentage: 0,
                    underDeliveryRecoveryAmount: UnderDeliveryRecoveryAmount.Full));

            _fspDeliverableClaimRepoMock.Setup(x => x.GetFspDeliverablesIncludingClaimDeliverableGroup(
                    It.Is<string>(fsp => fsp == CommunityLearningFspCode), It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(CreateListOfCommunityLearningDeliverableClaims());

            ContractAllocation allocation = CreateContractAllocation(CommunityLearningAllocNumber, CommunityLearningFspCode, plannedValue);
            allocation.DeliverableLines = CreateUnderDeliveryLessThanDeminimisCommunityLearningDeliverableLines();
            DebatchedFundingClaim fundingClaimToCalculate = CreateDebatchedFundingClaim(CommunityLearningAllocGroupCode);
            fundingClaimToCalculate.ContractAllocations.Add(allocation);
            var mockConnectionInfo = new Mock<ConnectionInfo>(null, Mock.Of<IDbConnection>());

            // act
            FundingClaimReconciliation calculatedReconciliation = _calculationService.Calculate(fundingClaimToCalculate, mockConnectionInfo.Object).Result;

            // assert
            Assert.AreEqual(plannedValue, calculatedReconciliation.Amounts.PlannedValue, "Planned value calculated incorrectly");
            Assert.AreEqual(240m, calculatedReconciliation.Amounts.ClaimedValue, "Claimed value calculated incorrectly");
            Assert.AreEqual(240m, calculatedReconciliation.Amounts.CappedClaimedValue, "Capped Claimed Value calculated incorrectly");
            Assert.AreEqual(0m, calculatedReconciliation.Amounts.ProposedReconciliationValue, "Proposed Reconciliation value calculated incorrectly");

            Assert.AreEqual(plannedValue, calculatedReconciliation.ContractAllocations[0].Amounts.PlannedValue, "Allocation Planned value calculated incorrectly");
            Assert.AreEqual(240m, calculatedReconciliation.ContractAllocations[0].Amounts.ClaimedValue, "Allocation ClaimedValue calculated incorrectly");
            Assert.AreEqual(240m, calculatedReconciliation.ContractAllocations[0].Amounts.CappedClaimedValue, "Allocation CappedClaimedValue calculated incorrectly");
            Assert.AreEqual(0m, calculatedReconciliation.ContractAllocations[0].Amounts.ProposedReconciliationValue, "Allocation ProposedReconciliationValue calculated incorrectly");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ReconciliationCalculationService_ShouldCalculateForSingleAllocationAndSingleDeliverableGroup_UnderDelivery_MoreThanDeminimis()
        {
            const decimal plannedValue = 510M;
            // arrange
            _claimBehaviourRepoMock.Setup(x => x.Find(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(new ClaimReconciliationBehaviour(ClaimCollectionCode, CommunityLearningAllocGroupCode,
                    isReconciliationPayable: true,
                    doWeReconcileUnderDelivery: true,
                    doWeReconcileOverDelivery: false,
                    underDeliveryDeMinimis: -100m,
                    overDeliveryDeMinimis: 0,
                    publicationCloseDate: null,
                    underDeliveryTolerancePercentage: 0,
                    overDeliveryLimitPercentage: 0,
                    underDeliveryRecoveryAmount: UnderDeliveryRecoveryAmount.Full));

            _fspDeliverableClaimRepoMock.Setup(x => x.GetFspDeliverablesIncludingClaimDeliverableGroup(
                    It.Is<string>(fsp => fsp == CommunityLearningFspCode), It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(CreateListOfCommunityLearningDeliverableClaims());

            ContractAllocation allocation = CreateContractAllocation(CommunityLearningAllocNumber, CommunityLearningFspCode, plannedValue);
            allocation.DeliverableLines = CreateUnderDeliveryMoreThanDeminimisCommunityLearningDeliverableLines();
            DebatchedFundingClaim fundingClaimToCalculate = CreateDebatchedFundingClaim(CommunityLearningAllocGroupCode);
            fundingClaimToCalculate.ContractAllocations.Add(allocation);
            var mockConnectionInfo = new Mock<ConnectionInfo>(null, Mock.Of<IDbConnection>());

            // act
            FundingClaimReconciliation calculatedReconciliation = _calculationService.Calculate(fundingClaimToCalculate, mockConnectionInfo.Object).Result;

            // assert
            Assert.AreEqual(plannedValue, calculatedReconciliation.Amounts.PlannedValue, "Planned value calculated incorrectly");
            Assert.AreEqual(240m, calculatedReconciliation.Amounts.ClaimedValue, "Claimed value calculated incorrectly");
            Assert.AreEqual(240m, calculatedReconciliation.Amounts.CappedClaimedValue, "Capped Claimed Value calculated incorrectly");
            Assert.AreEqual(-270m, calculatedReconciliation.Amounts.ProposedReconciliationValue, "Proposed Reconciliation value calculated incorrectly");

            Assert.AreEqual(plannedValue, calculatedReconciliation.ContractAllocations[0].Amounts.PlannedValue, "Allocation Planned value calculated incorrectly");
            Assert.AreEqual(240m, calculatedReconciliation.ContractAllocations[0].Amounts.ClaimedValue, "Allocation ClaimedValue calculated incorrectly");
            Assert.AreEqual(240m, calculatedReconciliation.ContractAllocations[0].Amounts.CappedClaimedValue, "Allocation CappedClaimedValue calculated incorrectly");
            Assert.AreEqual(-270m, calculatedReconciliation.ContractAllocations[0].Amounts.ProposedReconciliationValue, "Allocation ProposedReconciliationValue calculated incorrectly");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ReconciliationCalculationService_ShouldCalculateForSingleAllocationAndSingleDeliverableGroup_OverDelivery_MoreThanDeminimis()
        {
            // arrange
            decimal plannedValue = 310M;
            _claimBehaviourRepoMock.Setup(x => x.Find(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(new ClaimReconciliationBehaviour(ClaimCollectionCode, CommunityLearningAllocGroupCode,
                    isReconciliationPayable: true,
                    doWeReconcileUnderDelivery: true,
                    doWeReconcileOverDelivery: false,
                    underDeliveryDeMinimis: -100m,
                    overDeliveryDeMinimis: 0,
                    publicationCloseDate: null,
                    underDeliveryTolerancePercentage: 0,
                    overDeliveryLimitPercentage: 0,
                    underDeliveryRecoveryAmount: UnderDeliveryRecoveryAmount.Full));

            _fspDeliverableClaimRepoMock.Setup(x => x.GetFspDeliverablesIncludingClaimDeliverableGroup(
                    It.Is<string>(fsp => fsp == CommunityLearningFspCode), It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(CreateListOfCommunityLearningDeliverableClaims());

            ContractAllocation allocation = CreateContractAllocation(CommunityLearningAllocNumber, CommunityLearningFspCode, plannedValue);
            allocation.DeliverableLines = CreateOverDeliveryMoreThanDeminimisCommunityLearningDeliverableLines();
            DebatchedFundingClaim fundingClaimToCalculate = CreateDebatchedFundingClaim(CommunityLearningAllocGroupCode);
            fundingClaimToCalculate.ContractAllocations.Add(allocation);
            var mockConnectionInfo = new Mock<ConnectionInfo>(null, Mock.Of<IDbConnection>());

            // act
            FundingClaimReconciliation calculatedReconciliation = _calculationService.Calculate(fundingClaimToCalculate, mockConnectionInfo.Object).Result;

            // assert
            Assert.AreEqual(plannedValue, calculatedReconciliation.Amounts.PlannedValue, "Planned value calculated incorrectly");
            Assert.AreEqual(500m, calculatedReconciliation.Amounts.ClaimedValue, "Claimed value calculated incorrectly");
            Assert.AreEqual(500m, calculatedReconciliation.Amounts.CappedClaimedValue, "Capped Claimed Value calculated incorrectly");
            Assert.AreEqual(0m, calculatedReconciliation.Amounts.ProposedReconciliationValue, "Proposed Reconciliation value calculated incorrectly");

            Assert.AreEqual(plannedValue, calculatedReconciliation.ContractAllocations[0].Amounts.PlannedValue, "Allocation Planned value calculated incorrectly");
            Assert.AreEqual(500m, calculatedReconciliation.ContractAllocations[0].Amounts.ClaimedValue, "Allocation ClaimedValue calculated incorrectly");
            Assert.AreEqual(500m, calculatedReconciliation.ContractAllocations[0].Amounts.CappedClaimedValue, "Allocation CappedClaimedValue calculated incorrectly");
            Assert.AreEqual(0m, calculatedReconciliation.ContractAllocations[0].Amounts.ProposedReconciliationValue, "Allocation ProposedReconciliationValue calculated incorrectly");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ReconciliationCalculationService_ShouldCalculateForMultipleAllocationsWithSingleDeliverableGroup_EqualPlannedAndClaimed()
        {
            // arrange
            const decimal plannedValue = 310M;
            _claimBehaviourRepoMock.Setup(x => x.Find(
                It.Is<string>(ccc => ccc == ClaimCollectionCode),
                It.Is<string>(agc => agc == DlsAndTwentyFourPlusAllocGroupCode), It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(new ClaimReconciliationBehaviour(ClaimCollectionCode, DlsAndTwentyFourPlusAllocGroupCode,
                isReconciliationPayable: true,
                doWeReconcileUnderDelivery: true,
                doWeReconcileOverDelivery: true,
                overDeliveryDeMinimis: 100m,
                underDeliveryDeMinimis: -100m,
                publicationCloseDate: null,
                underDeliveryTolerancePercentage: 0,
                overDeliveryLimitPercentage: 0,
                underDeliveryRecoveryAmount: UnderDeliveryRecoveryAmount.Full));

            _fspDeliverableClaimRepoMock.Setup(x => x.GetFspDeliverablesIncludingClaimDeliverableGroup(
                It.Is<string>(fsp => fsp == DlsFspCode), It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(CreateListOfDlsDeliverableClaims());

            _fspDeliverableClaimRepoMock.Setup(x => x.GetFspDeliverablesIncludingClaimDeliverableGroup(
                It.Is<string>(fsp => fsp == TwentyFourPlusFspCode), It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(CreateListOf24PlusDeliverableClaims());


            ContractAllocation allocation1 = CreateContractAllocation(DlsAllocNumber, DlsFspCode, plannedValue);
            ContractAllocation allocation2 = CreateContractAllocation(TwentyFourPlusAllocNumber, TwentyFourPlusFspCode, plannedValue);
            allocation1.DeliverableLines = CreateEqualDeliverableLines();
            allocation2.DeliverableLines = CreateEqualDeliverableLines();

            DebatchedFundingClaim fundingClaimToCalculate = CreateDebatchedFundingClaim(DlsAndTwentyFourPlusAllocGroupCode);
            fundingClaimToCalculate.ContractAllocations.Add(allocation1);
            fundingClaimToCalculate.ContractAllocations.Add(allocation2);
            var mockConnectionInfo = new Mock<ConnectionInfo>(null, Mock.Of<IDbConnection>());

            // act
            FundingClaimReconciliation calculatedReconciliation = _calculationService.Calculate(fundingClaimToCalculate, mockConnectionInfo.Object).Result;

            // assert
            // Funding Claim values
            Assert.AreEqual(2 * plannedValue, calculatedReconciliation.Amounts.PlannedValue, "Claim Planned value calculated incorrectly");
            Assert.AreEqual(620m, calculatedReconciliation.Amounts.ClaimedValue, "Claim Claimed value calculated incorrectly");
            Assert.AreEqual(620m, calculatedReconciliation.Amounts.CappedClaimedValue, "Claim Capped Claimed Value calculated incorrectly");
            Assert.AreEqual(0m, calculatedReconciliation.Amounts.ProposedReconciliationValue, "Claim Proposed Reconciliation value calculated incorrectly");

            // Dls Allocation Values
            Reconciliation.ContractAllocation dlsAllocation = calculatedReconciliation.ContractAllocations.SingleOrDefault(a => a.ContractAllocationNumber == DlsAllocNumber);

            Assert.IsNotNull(dlsAllocation, "Dls Allocation does not exist on the reconciliation.");
            Assert.AreEqual(310, calculatedReconciliation.ContractAllocations[0].Amounts.PlannedValue, "Allocation Planned value calculated incorrectly");
            Assert.AreEqual(310m, calculatedReconciliation.ContractAllocations[0].Amounts.ClaimedValue, "Allocation Claimed value calculated incorrectly");
            Assert.AreEqual(310m, calculatedReconciliation.ContractAllocations[0].Amounts.CappedClaimedValue, "Allocation CappedClaimedValue calculated incorrectly");
            Assert.AreEqual(0m, calculatedReconciliation.ContractAllocations[0].Amounts.ProposedReconciliationValue, "Allocation ProposedReconciliationValue calculated incorrectly");

            //24+ Allocation Values
            Reconciliation.ContractAllocation twentyFourPlusAllocation = calculatedReconciliation.ContractAllocations.SingleOrDefault(a => a.ContractAllocationNumber == TwentyFourPlusAllocNumber);

            Assert.IsNotNull(twentyFourPlusAllocation, "24+ Allocation does not exist on the reconciliation.");
            Assert.AreEqual(310m, calculatedReconciliation.ContractAllocations[1].Amounts.PlannedValue, "Allocation Planned value calculated incorrectly");
            Assert.AreEqual(310m, calculatedReconciliation.ContractAllocations[1].Amounts.ClaimedValue, "Allocation Claimed value calculated incorrectly");
            Assert.AreEqual(310m, calculatedReconciliation.ContractAllocations[1].Amounts.CappedClaimedValue, "Allocation CappedClaimedValue calculated incorrectly");
            Assert.AreEqual(0m, calculatedReconciliation.ContractAllocations[1].Amounts.ProposedReconciliationValue, "Allocation ProposedReconciliationValue calculated incorrectly");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ReconciliationCalculationService_ShouldCalculateForMultipleAllocationsWithSingleDeliverableGroup_UnderDelivery_MoreThanDeminimis()
        {
            // arrange
            const decimal plannedValue1 = 510M;
            const decimal plannedValue2 = 310M;
            _claimBehaviourRepoMock.Setup(x => x.Find(
                It.Is<string>(ccc => ccc == ClaimCollectionCode),
                It.Is<string>(fsp => fsp == DlsAndTwentyFourPlusAllocGroupCode), It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(new ClaimReconciliationBehaviour(ClaimCollectionCode, DlsAndTwentyFourPlusAllocGroupCode,
                isReconciliationPayable: true,
                doWeReconcileUnderDelivery: true,
                doWeReconcileOverDelivery: true,
                overDeliveryDeMinimis: 100m,
                underDeliveryDeMinimis: -100m,
                publicationCloseDate: null,
                underDeliveryTolerancePercentage: 0,
                overDeliveryLimitPercentage: 0,
                underDeliveryRecoveryAmount: UnderDeliveryRecoveryAmount.Full));

            _fspDeliverableClaimRepoMock.Setup(x => x.GetFspDeliverablesIncludingClaimDeliverableGroup(
                It.Is<string>(fsp => fsp == DlsFspCode), It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(CreateListOfDlsDeliverableClaims());

            _fspDeliverableClaimRepoMock.Setup(x => x.GetFspDeliverablesIncludingClaimDeliverableGroup(
                It.Is<string>(fsp => fsp == TwentyFourPlusFspCode), It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(CreateListOf24PlusDeliverableClaims());

            ContractAllocation allocation1 = CreateContractAllocation(DlsAllocNumber, DlsFspCode, plannedValue1);
            ContractAllocation allocation2 = CreateContractAllocation(TwentyFourPlusAllocNumber, TwentyFourPlusFspCode, plannedValue2);
            allocation1.DeliverableLines = CreateUnderDeliveryMoreThanDeminimisDeliverableLines();
            allocation2.DeliverableLines = CreateEqualDeliverableLines();

            DebatchedFundingClaim fundingClaimToCalculate = CreateDebatchedFundingClaim(DlsAndTwentyFourPlusAllocGroupCode);
            fundingClaimToCalculate.ContractAllocations.Add(allocation1);
            fundingClaimToCalculate.ContractAllocations.Add(allocation2);
            var mockConnectionInfo = new Mock<ConnectionInfo>(null, Mock.Of<IDbConnection>());

            // act
            FundingClaimReconciliation calculatedReconciliation = _calculationService.Calculate(fundingClaimToCalculate, mockConnectionInfo.Object).Result;

            // assert
            // Funding Claim values
            Assert.AreEqual(plannedValue1 + plannedValue2, calculatedReconciliation.Amounts.PlannedValue, "Claim Planned value calculated incorrectly");
            Assert.AreEqual(550m, calculatedReconciliation.Amounts.ClaimedValue, "Claim Claimed value calculated incorrectly");
            Assert.AreEqual(550m, calculatedReconciliation.Amounts.CappedClaimedValue, "Claim Capped Claimed Value calculated incorrectly");
            Assert.AreEqual(-270m, calculatedReconciliation.Amounts.ProposedReconciliationValue, "Claim Proposed Reconciliation value calculated incorrectly");

            // Dls Allocation Values
            Reconciliation.ContractAllocation dlsAllocation = calculatedReconciliation.ContractAllocations.SingleOrDefault(a => a.ContractAllocationNumber == DlsAllocNumber);

            Assert.IsNotNull(dlsAllocation, "Dls Allocation does not exist on the reconciliation.");
            Assert.AreEqual(plannedValue1, calculatedReconciliation.ContractAllocations[0].Amounts.PlannedValue, "Allocation Planned value calculated incorrectly");
            Assert.AreEqual(240m, calculatedReconciliation.ContractAllocations[0].Amounts.ClaimedValue, "Allocation Claimed value calculated incorrectly");
            Assert.AreEqual(240m, calculatedReconciliation.ContractAllocations[0].Amounts.CappedClaimedValue, "Allocation CappedClaimedValue calculated incorrectly");
            Assert.AreEqual(-270m, calculatedReconciliation.ContractAllocations[0].Amounts.ProposedReconciliationValue, "Allocation ProposedReconciliationValue calculated incorrectly");

            //24+ Allocation Values
            Reconciliation.ContractAllocation twentyFourPlusAllocation = calculatedReconciliation.ContractAllocations.SingleOrDefault(a => a.ContractAllocationNumber == TwentyFourPlusAllocNumber);

            Assert.IsNotNull(twentyFourPlusAllocation, "24+ Allocation does not exist on the reconciliation.");
            Assert.AreEqual(plannedValue2, calculatedReconciliation.ContractAllocations[1].Amounts.PlannedValue, "Allocation Planned value calculated incorrectly");
            Assert.AreEqual(310m, calculatedReconciliation.ContractAllocations[1].Amounts.ClaimedValue, "Allocation Claimed value calculated incorrectly");
            Assert.AreEqual(310m, calculatedReconciliation.ContractAllocations[1].Amounts.CappedClaimedValue, "Allocation CappedClaimedValue calculated incorrectly");
            Assert.AreEqual(0m, calculatedReconciliation.ContractAllocations[1].Amounts.ProposedReconciliationValue, "Allocation ProposedReconciliationValue calculated incorrectly");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ReconciliationCalculationService_ShouldCalculateForMultipleAllocationsWithSingleDeliverableGroup_OverDelivery_MoreThanDeminimis()
        {
            // arrange
            const decimal plannedValue = 310M;
            _claimBehaviourRepoMock.Setup(x => x.Find(
                 It.Is<string>(ccc => ccc == ClaimCollectionCode),
                 It.Is<string>(fsp => fsp == DlsAndTwentyFourPlusAllocGroupCode), It.IsAny<ConnectionInfo>()))
                 .ReturnsAsync(new ClaimReconciliationBehaviour(ClaimCollectionCode, DlsAndTwentyFourPlusAllocGroupCode,
                 isReconciliationPayable: true,
                 doWeReconcileUnderDelivery: true,
                 doWeReconcileOverDelivery: true,
                 overDeliveryDeMinimis: 100m,
                 underDeliveryDeMinimis: -100m,
                 publicationCloseDate: null,
                 underDeliveryTolerancePercentage: 0,
                 overDeliveryLimitPercentage: 0,
                 underDeliveryRecoveryAmount: UnderDeliveryRecoveryAmount.Full));

            _fspDeliverableClaimRepoMock.Setup(x => x.GetFspDeliverablesIncludingClaimDeliverableGroup(
                It.Is<string>(fsp => fsp == DlsFspCode), It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(CreateListOfDlsDeliverableClaims());

            _fspDeliverableClaimRepoMock.Setup(x => x.GetFspDeliverablesIncludingClaimDeliverableGroup(
                It.Is<string>(fsp => fsp == TwentyFourPlusFspCode), It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(CreateListOf24PlusDeliverableClaims());

            ContractAllocation allocation1 = CreateContractAllocation(DlsAllocNumber, DlsFspCode, plannedValue);
            ContractAllocation allocation2 = CreateContractAllocation(TwentyFourPlusAllocNumber, TwentyFourPlusFspCode, plannedValue);
            allocation1.DeliverableLines = CreateOverDeliveryMoreThanDeminimisDeliverableLines();
            allocation2.DeliverableLines = CreateEqualDeliverableLines();

            DebatchedFundingClaim fundingClaimToCalculate = CreateDebatchedFundingClaim(DlsAndTwentyFourPlusAllocGroupCode);
            fundingClaimToCalculate.ContractAllocations.Add(allocation1);
            fundingClaimToCalculate.ContractAllocations.Add(allocation2);
            var mockConnectionInfo = new Mock<ConnectionInfo>(null, Mock.Of<IDbConnection>());

            // act
            FundingClaimReconciliation calculatedReconciliation = _calculationService.Calculate(fundingClaimToCalculate, mockConnectionInfo.Object).Result;

            // assert
            // Funding Claim values
            Assert.AreEqual(2 * plannedValue, calculatedReconciliation.Amounts.PlannedValue, "Claim Planned value calculated incorrectly");
            Assert.AreEqual(810m, calculatedReconciliation.Amounts.ClaimedValue, "Claim Claimed value calculated incorrectly");
            Assert.AreEqual(810m, calculatedReconciliation.Amounts.CappedClaimedValue, "Claim Capped Claimed Value calculated incorrectly");
            Assert.AreEqual(0m, calculatedReconciliation.Amounts.ProposedReconciliationValue, "Claim Proposed Reconciliation value calculated incorrectly");

            // Dls Allocation Values
            Reconciliation.ContractAllocation dlsAllocation = calculatedReconciliation.ContractAllocations.SingleOrDefault(a => a.ContractAllocationNumber == DlsAllocNumber);

            Assert.IsNotNull(dlsAllocation, "Dls Allocation does not exist on the reconciliation.");
            Assert.AreEqual(plannedValue, calculatedReconciliation.ContractAllocations[0].Amounts.PlannedValue, "Allocation Planned value calculated incorrectly");
            Assert.AreEqual(500m, calculatedReconciliation.ContractAllocations[0].Amounts.ClaimedValue, "Allocation Claimed value calculated incorrectly");
            Assert.AreEqual(500m, calculatedReconciliation.ContractAllocations[0].Amounts.CappedClaimedValue, "Allocation CappedClaimedValue calculated incorrectly");
            Assert.AreEqual(0m, calculatedReconciliation.ContractAllocations[0].Amounts.ProposedReconciliationValue, "Allocation ProposedReconciliationValue calculated incorrectly");

            //24+ Allocation Values
            Reconciliation.ContractAllocation twentyFourPlusAllocation = calculatedReconciliation.ContractAllocations.SingleOrDefault(a => a.ContractAllocationNumber == TwentyFourPlusAllocNumber);

            Assert.IsNotNull(twentyFourPlusAllocation, "24+ Allocation does not exist on the reconciliation.");
            Assert.AreEqual(plannedValue, calculatedReconciliation.ContractAllocations[1].Amounts.PlannedValue, "Allocation Planned value calculated incorrectly");
            Assert.AreEqual(310m, calculatedReconciliation.ContractAllocations[1].Amounts.ClaimedValue, "Allocation Claimed value calculated incorrectly");
            Assert.AreEqual(310m, calculatedReconciliation.ContractAllocations[1].Amounts.CappedClaimedValue, "Allocation CappedClaimedValue calculated incorrectly");
            Assert.AreEqual(0m, calculatedReconciliation.ContractAllocations[1].Amounts.ProposedReconciliationValue, "Allocation ProposedReconciliationValue calculated incorrectly");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ReconciliationCalculationService_DlsAnd24Plus_DaveBarclaySpreadsheetScenario()
        {
            // arrange
            const decimal plannedValue = 1500M;

            _claimBehaviourRepoMock.Setup(x => x.Find(
                 It.Is<string>(ccc => ccc == ClaimCollectionCode),
                 It.Is<string>(fsp => fsp == DlsAndTwentyFourPlusAllocGroupCode), It.IsAny<ConnectionInfo>()))
                 .ReturnsAsync(new ClaimReconciliationBehaviour(ClaimCollectionCode, DlsAndTwentyFourPlusAllocGroupCode,
                 isReconciliationPayable: true,
                 doWeReconcileUnderDelivery: true,

                 doWeReconcileOverDelivery: true,
                 overDeliveryDeMinimis: 100m,
                 underDeliveryDeMinimis: -100m,
                 publicationCloseDate: null,
                 underDeliveryTolerancePercentage: 0,
                 overDeliveryLimitPercentage: 0,
                 underDeliveryRecoveryAmount: UnderDeliveryRecoveryAmount.Full));

            _fspDeliverableClaimRepoMock.Setup(x => x.GetFspDeliverablesIncludingClaimDeliverableGroup(
                It.Is<string>(fsp => fsp == DlsFspCode), It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(CreateListOfDlsDeliverableClaims());

            _fspDeliverableClaimRepoMock.Setup(x => x.GetFspDeliverablesIncludingClaimDeliverableGroup(
                It.Is<string>(fsp => fsp == TwentyFourPlusFspCode), It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(CreateListOf24PlusDeliverableClaims());

            ContractAllocation allocation1 = CreateContractAllocation(DlsAllocNumber, DlsFspCode, plannedValue);
            ContractAllocation allocation2 = CreateContractAllocation(TwentyFourPlusAllocNumber, TwentyFourPlusFspCode, plannedValue);
            allocation1.DeliverableLines = CreateDlsDeliverableLines();
            allocation2.DeliverableLines = Create24PlusDeliverableLines();

            DebatchedFundingClaim fundingClaimToCalculate = CreateDebatchedFundingClaim(DlsAndTwentyFourPlusAllocGroupCode);
            fundingClaimToCalculate.ContractAllocations.Add(allocation1);
            fundingClaimToCalculate.ContractAllocations.Add(allocation2);

            var mockConnectionInfo = new Mock<ConnectionInfo>(null, Mock.Of<IDbConnection>());

            // act
            FundingClaimReconciliation calculatedReconciliation = _calculationService.Calculate(fundingClaimToCalculate, mockConnectionInfo.Object).Result;

            // assert
            // Funding Claim values
            Assert.AreEqual(3000m, calculatedReconciliation.Amounts.PlannedValue, "Claim Planned value calculated incorrectly");
            Assert.AreEqual(3690m, calculatedReconciliation.Amounts.ClaimedValue, "Claim Claimed value calculated incorrectly");
            Assert.AreEqual(3690m, calculatedReconciliation.Amounts.CappedClaimedValue, "Claim Capped Claimed Value calculated incorrectly");
            Assert.AreEqual(0m, calculatedReconciliation.Amounts.ProposedReconciliationValue, "Claim Proposed Reconciliation value calculated incorrectly");

            // Dls Allocation Values
            Reconciliation.ContractAllocation dlsAllocation = calculatedReconciliation.ContractAllocations.SingleOrDefault(a => a.ContractAllocationNumber == DlsAllocNumber);

            Assert.IsNotNull(dlsAllocation, "Dls Allocation does not exist on the reconciliation.");
            Assert.AreEqual(plannedValue, calculatedReconciliation.ContractAllocations[0].Amounts.PlannedValue, "Allocation Planned value calculated incorrectly");
            Assert.AreEqual(3290m, calculatedReconciliation.ContractAllocations[0].Amounts.ClaimedValue, "Allocation Claimed value calculated incorrectly");
            Assert.AreEqual(3290m, calculatedReconciliation.ContractAllocations[0].Amounts.CappedClaimedValue, "Allocation CappedClaimedValue calculated incorrectly");
            Assert.AreEqual(0m, calculatedReconciliation.ContractAllocations[0].Amounts.ProposedReconciliationValue, "Allocation ProposedReconciliationValue calculated incorrectly");

            //24+ Allocation Values
            Reconciliation.ContractAllocation twentyFourPlusAllocation = calculatedReconciliation.ContractAllocations.SingleOrDefault(a => a.ContractAllocationNumber == TwentyFourPlusAllocNumber);

            Assert.IsNotNull(twentyFourPlusAllocation, "24+ Allocation does not exist on the reconciliation.");
            Assert.AreEqual(plannedValue, calculatedReconciliation.ContractAllocations[1].Amounts.PlannedValue, "Allocation Planned value calculated incorrectly");
            Assert.AreEqual(400m, calculatedReconciliation.ContractAllocations[1].Amounts.ClaimedValue, "Allocation Claimed value calculated incorrectly");
            Assert.AreEqual(400m, calculatedReconciliation.ContractAllocations[1].Amounts.CappedClaimedValue, "Allocation CappedClaimedValue calculated incorrectly");
            Assert.AreEqual(0m, calculatedReconciliation.ContractAllocations[1].Amounts.ProposedReconciliationValue, "Allocation ProposedReconciliationValue calculated incorrectly");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ReconciliationCalculationService_ShouldCalculateForSingleAllocationWithMultipleDeliverableGroups_EqualPlannedAndClaimed()
        {
            // arrange
            const decimal plannedValue = 310M;
            _claimBehaviourRepoMock.Setup(x => x.Find(
                It.Is<string>(ccc => ccc == ClaimCollectionCode),
                It.Is<string>(agc => agc == AdultSkillsAllocGroupCode), It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(new ClaimReconciliationBehaviour(ClaimCollectionCode, AdultSkillsAllocGroupCode,
                isReconciliationPayable: false,
                doWeReconcileUnderDelivery: true,
                doWeReconcileOverDelivery: false,
                overDeliveryDeMinimis: 0m,
                underDeliveryDeMinimis: -100m,
                publicationCloseDate: null,
                underDeliveryTolerancePercentage: 0,
                overDeliveryLimitPercentage: 0,
                underDeliveryRecoveryAmount: UnderDeliveryRecoveryAmount.Full));

            _fspDeliverableClaimRepoMock.Setup(x => x.GetFspDeliverablesIncludingClaimDeliverableGroup(
                It.Is<string>(fsp => fsp == AdultSkillsFspCode), It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(CreateListOfAdultSkillsDeliverableClaims());

            ContractAllocation allocation = CreateContractAllocation(AdultSkillsAllocNumber, AdultSkillsFspCode, plannedValue);
            allocation.DeliverableLines = CreateEqualDeliverableLines();

            DebatchedFundingClaim fundingClaimToCalculate = CreateDebatchedFundingClaim(AdultSkillsAllocGroupCode);
            fundingClaimToCalculate.ContractAllocations.Add(allocation);
            var mockConnectionInfo = new Mock<ConnectionInfo>(null, Mock.Of<IDbConnection>());

            // act
            FundingClaimReconciliation calculatedReconciliation = _calculationService.Calculate(fundingClaimToCalculate, mockConnectionInfo.Object).Result;

            // assert
            // Funding Claim values
            Assert.AreEqual(plannedValue, calculatedReconciliation.Amounts.PlannedValue, "Claim Planned value calculated incorrectly");
            Assert.AreEqual(310m, calculatedReconciliation.Amounts.ClaimedValue, "Claim Claimed value calculated incorrectly");
            Assert.AreEqual(310m, calculatedReconciliation.Amounts.CappedClaimedValue, "Claim Capped Claimed Value calculated incorrectly");
            Assert.AreEqual(0m, calculatedReconciliation.Amounts.ProposedReconciliationValue, "Claim Proposed Reconciliation value calculated incorrectly");

            // Asc Allocation Values
            Reconciliation.ContractAllocation ascAllocation = calculatedReconciliation.ContractAllocations.SingleOrDefault(a => a.ContractAllocationNumber == AdultSkillsAllocNumber);

            Assert.IsNotNull(ascAllocation, "ASC Allocation does not exist on the reconciliation.");
            Assert.AreEqual(plannedValue, calculatedReconciliation.ContractAllocations[0].Amounts.PlannedValue, "Allocation Planned value calculated incorrectly");
            Assert.AreEqual(310m, calculatedReconciliation.ContractAllocations[0].Amounts.ClaimedValue, "Allocation Claimed value calculated incorrectly");
            Assert.AreEqual(310m, calculatedReconciliation.ContractAllocations[0].Amounts.CappedClaimedValue, "Allocation CappedClaimedValue calculated incorrectly");
            Assert.AreEqual(0m, calculatedReconciliation.ContractAllocations[0].Amounts.ProposedReconciliationValue, "Allocation ProposedReconciliationValue calculated incorrectly");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ReconciliationCalculationService_DaveBarclay_SpreadsheetScenario()
        {
            // arrange
            const decimal plannedValue = 1500M;
            _claimBehaviourRepoMock.Setup(x => x.Find(
                It.Is<string>(ccc => ccc == ClaimCollectionCode),
                It.Is<string>(agc => agc == AdultSkillsAllocGroupCode), It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(new ClaimReconciliationBehaviour(ClaimCollectionCode, AdultSkillsAllocGroupCode,
                isReconciliationPayable: false,
                doWeReconcileUnderDelivery: true,
                doWeReconcileOverDelivery: false,
                overDeliveryDeMinimis: 0m,
                underDeliveryDeMinimis: -100m,
                publicationCloseDate: null,
                underDeliveryTolerancePercentage: 0,
                overDeliveryLimitPercentage: 0,
                underDeliveryRecoveryAmount: UnderDeliveryRecoveryAmount.Full));

            _fspDeliverableClaimRepoMock.Setup(x => x.GetFspDeliverablesIncludingClaimDeliverableGroup(
                It.Is<string>(fsp => fsp == AdultSkillsFspCode), It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(CreateListOfAdultSkillsDeliverableClaims());

            ContractAllocation allocation = CreateContractAllocation(AdultSkillsAllocNumber, AdultSkillsFspCode, plannedValue);
            allocation.DeliverableLines = CreateAscDeliverableLines();

            DebatchedFundingClaim fundingClaimToCalculate = CreateDebatchedFundingClaim(AdultSkillsAllocGroupCode);
            fundingClaimToCalculate.ContractAllocations.Add(allocation);
            var mockConnectionInfo = new Mock<ConnectionInfo>(null, Mock.Of<IDbConnection>());

            // act
            FundingClaimReconciliation calculatedReconciliation = _calculationService.Calculate(fundingClaimToCalculate, mockConnectionInfo.Object).Result;

            // assert
            // Funding Claim values
            Assert.AreEqual(1500m, calculatedReconciliation.Amounts.PlannedValue, "Claim Planned value calculated incorrectly");
            Assert.AreEqual(960m, calculatedReconciliation.Amounts.ClaimedValue, "Claim Claimed value calculated incorrectly");
            Assert.AreEqual(900m, calculatedReconciliation.Amounts.CappedClaimedValue, "Claim Capped Claimed Value calculated incorrectly");
            Assert.AreEqual(-600m, calculatedReconciliation.Amounts.ProposedReconciliationValue, "Claim Proposed Reconciliation value calculated incorrectly");

            // Dls Allocation Values
            Reconciliation.ContractAllocation ascAllocation = calculatedReconciliation.ContractAllocations.SingleOrDefault(a => a.ContractAllocationNumber == AdultSkillsAllocNumber);

            Assert.IsNotNull(ascAllocation, "ASC Allocation does not exist on the reconciliation.");
            Assert.AreEqual(1500m, calculatedReconciliation.ContractAllocations[0].Amounts.PlannedValue, "Allocation Planned value calculated incorrectly");
            Assert.AreEqual(960m, calculatedReconciliation.ContractAllocations[0].Amounts.ClaimedValue, "Allocation Claimed value calculated incorrectly");
            Assert.AreEqual(900m, calculatedReconciliation.ContractAllocations[0].Amounts.CappedClaimedValue, "Allocation CappedClaimedValue calculated incorrectly");
            Assert.AreEqual(-600m, calculatedReconciliation.ContractAllocations[0].Amounts.ProposedReconciliationValue, "Allocation ProposedReconciliationValue calculated incorrectly");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ReconciliationCalculationService_ShouldUseGivenTotalDeliveryValuesAndNotCalculateClaimedValue()
        {
            // arrange
            _claimBehaviourRepoMock.Setup(x => x.Find(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(new ClaimReconciliationBehaviour(ClaimCollectionCode, CommunityLearningAllocGroupCode,
                    isReconciliationPayable: true,
                    doWeReconcileUnderDelivery: true,
                    doWeReconcileOverDelivery: false,
                    underDeliveryDeMinimis: -100m,
                    overDeliveryDeMinimis: 0,
                    publicationCloseDate: null,
                    underDeliveryTolerancePercentage: 0,
                    overDeliveryLimitPercentage: 0,
                    underDeliveryRecoveryAmount: UnderDeliveryRecoveryAmount.Full));

            _fspDeliverableClaimRepoMock.Setup(x => x.GetFspDeliverablesIncludingClaimDeliverableGroup(
                It.Is<string>(fsp => fsp == CommunityLearningFspCode), It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(CreateListOfCommunityLearningDeliverableClaims());

            ContractAllocation allocation = CreateContractAllocation(CommunityLearningAllocNumber, CommunityLearningFspCode);
            allocation.DeliverableLines = new List<DeliverableLine>
            {
                new DeliverableLine
                {
                    DeliverableCode = 1,
                    PlannedValue = 310,
                    ActualValue = 1m,
                    AdjustmentValue = 1m,
                    ForecastValue = 1m,
                    TotalDelivery = 2000m
                },
                new DeliverableLine
                {
                    DeliverableCode = 1,
                    PlannedValue = 310,
                    ActualValue = 1m,
                    AdjustmentValue = 1m,
                    ForecastValue = 1m,
                    TotalDelivery = 2000m
                }
            };

            DebatchedFundingClaim fundingClaimToCalculate = CreateDebatchedFundingClaim(CommunityLearningAllocGroupCode);
            fundingClaimToCalculate.ContractAllocations.Add(allocation);
            var mockConnectionInfo = new Mock<ConnectionInfo>(null, Mock.Of<IDbConnection>());

            // act
            FundingClaimReconciliation calculatedReconciliation = _calculationService.Calculate(fundingClaimToCalculate, mockConnectionInfo.Object).Result;

            // assert
            Assert.AreEqual(4000m, calculatedReconciliation.Amounts.ClaimedValue, "Claimed value is not the sum of TotalDelivery values");
            Assert.AreNotEqual(6m, calculatedReconciliation.Amounts.ClaimedValue, "Claimed value was incorrectly calculated using ActualValue, AdjustmentValue & ForecastValue");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ReconciliationCalculationService_ShouldHaveZeroReconcilliationWhenVarianceBelowTolerance()
        {
            // arrange
            const decimal plannedValue = 1500m;
            _claimBehaviourRepoMock.Setup(x => x.Find(
                It.Is<string>(ccc => ccc == ClaimCollectionCode),
                It.Is<string>(agc => agc == AdultSkillsAllocGroupCode), It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(new ClaimReconciliationBehaviour(ClaimCollectionCode, AdultSkillsAllocGroupCode,
                isReconciliationPayable: false,
                doWeReconcileUnderDelivery: true,
                doWeReconcileOverDelivery: false,
                overDeliveryDeMinimis: 0m,
                underDeliveryDeMinimis: -100m,
                publicationCloseDate: null,
                underDeliveryTolerancePercentage: -50, // 50 percent of planned value -> 750
                overDeliveryLimitPercentage: 0,
                underDeliveryRecoveryAmount: UnderDeliveryRecoveryAmount.Full));           

            _fspDeliverableClaimRepoMock.Setup(x => x.GetFspDeliverablesIncludingClaimDeliverableGroup(
                It.Is<string>(fsp => fsp == AdultSkillsFspCode), It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(CreateListOfAdultSkillsDeliverableClaims());

            ContractAllocation allocation = CreateContractAllocation(AdultSkillsAllocNumber, AdultSkillsFspCode, plannedValue);
            allocation.DeliverableLines = CreateAscDeliverableLines();

            DebatchedFundingClaim fundingClaimToCalculate = CreateDebatchedFundingClaim(AdultSkillsAllocGroupCode);
            fundingClaimToCalculate.ContractAllocations.Add(allocation);
            var mockConnectionInfo = new Mock<ConnectionInfo>(null, Mock.Of<IDbConnection>());

            // act
            FundingClaimReconciliation calculatedReconciliation = _calculationService.Calculate(fundingClaimToCalculate, mockConnectionInfo.Object).Result;

            // assert
            // Funding Claim values
            Assert.AreEqual(plannedValue, calculatedReconciliation.Amounts.PlannedValue, "Claim Planned value calculated incorrectly");
            Assert.AreEqual(960m, calculatedReconciliation.Amounts.ClaimedValue, "Claim Claimed value calculated incorrectly");
            Assert.AreEqual(900m, calculatedReconciliation.Amounts.CappedClaimedValue, "Claim Capped Claimed Value calculated incorrectly");
            Assert.AreEqual(0m, calculatedReconciliation.Amounts.ProposedReconciliationValue, "Claim Proposed Reconciliation value calculated incorrectly");

            // Dls Allocation Values
            Reconciliation.ContractAllocation ascAllocation = calculatedReconciliation.ContractAllocations.SingleOrDefault(a => a.ContractAllocationNumber == AdultSkillsAllocNumber);

            Assert.IsNotNull(ascAllocation, "ASC Allocation does not exist on the reconciliation.");
            Assert.AreEqual(plannedValue, calculatedReconciliation.ContractAllocations[0].Amounts.PlannedValue, "Allocation Planned value calculated incorrectly");
            Assert.AreEqual(960m, calculatedReconciliation.ContractAllocations[0].Amounts.ClaimedValue, "Allocation Claimed value calculated incorrectly");
            Assert.AreEqual(900m, calculatedReconciliation.ContractAllocations[0].Amounts.CappedClaimedValue, "Allocation CappedClaimedValue calculated incorrectly");
            Assert.AreEqual(0m, calculatedReconciliation.ContractAllocations[0].Amounts.ProposedReconciliationValue, "Allocation ProposedReconciliationValue calculated incorrectly");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ReconciliationCalculationService_ShouldHaveZeroReconcilliationWhenVarianceEqualsTheTolerance()
        {
            // arrange
            const decimal plannedValue = 1500M;

            _claimBehaviourRepoMock.Setup(x => x.Find(
                It.Is<string>(ccc => ccc == ClaimCollectionCode),
                It.Is<string>(agc => agc == AdultSkillsAllocGroupCode), It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(new ClaimReconciliationBehaviour(ClaimCollectionCode, AdultSkillsAllocGroupCode,
                isReconciliationPayable: false,
                doWeReconcileUnderDelivery: true,
                doWeReconcileOverDelivery: false,
                overDeliveryDeMinimis: 0m,
                underDeliveryDeMinimis: -100m,
                publicationCloseDate: null,
                underDeliveryTolerancePercentage: -40, // 40 percent of planned value -> 600
                overDeliveryLimitPercentage: 0,
                underDeliveryRecoveryAmount: UnderDeliveryRecoveryAmount.Full));

            _fspDeliverableClaimRepoMock.Setup(x => x.GetFspDeliverablesIncludingClaimDeliverableGroup(
                It.Is<string>(fsp => fsp == AdultSkillsFspCode), It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(CreateListOfAdultSkillsDeliverableClaims());

            ContractAllocation allocation = CreateContractAllocation(AdultSkillsAllocNumber, AdultSkillsFspCode, plannedValue);
            allocation.DeliverableLines = CreateAscDeliverableLines();

            DebatchedFundingClaim fundingClaimToCalculate = CreateDebatchedFundingClaim(AdultSkillsAllocGroupCode);
            fundingClaimToCalculate.ContractAllocations.Add(allocation);
            var mockConnectionInfo = new Mock<ConnectionInfo>(null, Mock.Of<IDbConnection>());

            // act
            FundingClaimReconciliation calculatedReconciliation = _calculationService.Calculate(fundingClaimToCalculate, mockConnectionInfo.Object).Result;

            // assert
            // Funding Claim values
            Assert.AreEqual(plannedValue, calculatedReconciliation.Amounts.PlannedValue, "Claim Planned value calculated incorrectly");
            Assert.AreEqual(960m, calculatedReconciliation.Amounts.ClaimedValue, "Claim Claimed value calculated incorrectly");
            Assert.AreEqual(900m, calculatedReconciliation.Amounts.CappedClaimedValue, "Claim Capped Claimed Value calculated incorrectly");
            Assert.AreEqual(0m, calculatedReconciliation.Amounts.ProposedReconciliationValue, "Claim Proposed Reconciliation value calculated incorrectly");

            // Dls Allocation Values
            Reconciliation.ContractAllocation ascAllocation = calculatedReconciliation.ContractAllocations.SingleOrDefault(a => a.ContractAllocationNumber == AdultSkillsAllocNumber);

            Assert.IsNotNull(ascAllocation, "ASC Allocation does not exist on the reconciliation.");
            Assert.AreEqual(plannedValue, calculatedReconciliation.ContractAllocations[0].Amounts.PlannedValue, "Allocation Planned value calculated incorrectly");
            Assert.AreEqual(960m, calculatedReconciliation.ContractAllocations[0].Amounts.ClaimedValue, "Allocation Claimed value calculated incorrectly");
            Assert.AreEqual(900m, calculatedReconciliation.ContractAllocations[0].Amounts.CappedClaimedValue, "Allocation CappedClaimedValue calculated incorrectly");
            Assert.AreEqual(0m, calculatedReconciliation.ContractAllocations[0].Amounts.ProposedReconciliationValue, "Allocation ProposedReconciliationValue calculated incorrectly");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ReconciliationCalculationService_ShouldUseReferenceDataForPlannedValueWhenGroupAndUkprnPresent()
        {
            // arrange
            const string adultEducationBudgetCollegeFsp = "AEBC1617";
            const string adultEducationBudgetMhDelGroupCode = "AEB1617_CLMH";
            const string adultEducationBudgetPfDelGroupCode = "AEB1617_CLPF";

            _claimBehaviourRepoMock.Setup(x => x.Find(
                It.Is<string>(ccc => ccc == ClaimCollectionCode),
                It.Is<string>(agc => agc == AdultSkillsAllocGroupCode), It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(new ClaimReconciliationBehaviour(ClaimCollectionCode, AdultSkillsAllocGroupCode,
                isReconciliationPayable: false,
                doWeReconcileUnderDelivery: true,
                doWeReconcileOverDelivery: false,
                overDeliveryDeMinimis: 0m,
                underDeliveryDeMinimis: -100m,
                publicationCloseDate: null,
                underDeliveryTolerancePercentage: -3, // 3 percent of planned value -> 9700
                overDeliveryLimitPercentage: 0,
                underDeliveryRecoveryAmount: UnderDeliveryRecoveryAmount.Full));

            _fspDeliverableClaimRepoMock.Setup(x => x.GetFspDeliverablesIncludingClaimDeliverableGroup(
                It.Is<string>(fsp => fsp == adultEducationBudgetCollegeFsp), It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(CreateListOfAdultSkillsDeliverableClaimsForProfile(adultEducationBudgetCollegeFsp));

            _claimRefProfileRepoMock.Setup(m => m.GetPlannedValue(adultEducationBudgetMhDelGroupCode, Ukprn, It.IsAny<ConnectionInfo>())).ReturnsAsync((decimal?)500m);
            _claimRefProfileRepoMock.Setup(m => m.GetPlannedValue(adultEducationBudgetPfDelGroupCode, Ukprn, It.IsAny<ConnectionInfo>())).ReturnsAsync((decimal?)0m);
            _claimRefProfileRepoMock.Setup(r => r.IsProfileFromReferenceData(It.IsAny<string>(), It.IsAny<ConnectionInfo>())).ReturnsAsync(true);

            ContractAllocation allocation = CreateContractAllocation(AdultSkillsAllocNumber, adultEducationBudgetCollegeFsp);
            allocation.DeliverableLines = CreateAdultEducationBudgetDeliverableLines();

            DebatchedFundingClaim fundingClaimToCalculate = CreateDebatchedFundingClaim(AdultSkillsAllocGroupCode, Ukprn);
            fundingClaimToCalculate.ContractAllocations.Add(allocation);
            var mockConnectionInfo = new Mock<ConnectionInfo>(null, Mock.Of<IDbConnection>());

            // act
            FundingClaimReconciliation calculatedReconciliation = _calculationService.Calculate(fundingClaimToCalculate, mockConnectionInfo.Object).Result;

            // assert
            // Funding Claim values
            Assert.AreEqual(9700, calculatedReconciliation.Amounts.CappedClaimedValue);
        }

        private static DebatchedFundingClaim CreateDebatchedFundingClaim(string allocGroupCode, int ukprn = 1000012)
        {
            return new DebatchedFundingClaim
            {
                AllocationGroupCode = allocGroupCode,
                ClaimTypeName = ClaimTypeName.YEAREND,
                Period = "1516",
                Contractor = new Contractor { OrganisationIdentifier = "ORG0000012", Ukprn = ukprn },
                PeriodTypeCode = PeriodTypeCode.AY,
                ContractAllocations = new List<ContractAllocation>(),
                HasBeenSigned = false,
                VersionNumber = 1
            };
        }

        private static ContractAllocation CreateContractAllocation(string allocationNumber, string fspCode,
            decimal plannedValue = 0)
        {
            return new ContractAllocation
            {
                ContractAllocationNumber = allocationNumber,
                FundingStreamPeriodCode = fspCode,
                PlannedValueAggregation = plannedValue,
            };
        }

        private static List<DeliverableLine> CreateEqualCommunityLearningDeliverableLines()
        {
            return new List<DeliverableLine>
            {
                new DeliverableLine
                {
                    DeliverableCode = 1,
                    PlannedValue = 310m,
                    ActualValue = 200m,
                    AdjustmentValue = 50m,
                    ForecastValue = 60m,
                    TotalDelivery = 310m
                }
            };
        }

        private static List<DeliverableLine> CreateEqualDeliverableLines()
        {
            return new List<DeliverableLine>
            {
                new DeliverableLine
                {
                    DeliverableCode = 4,
                    PlannedValue = 160m,
                    ActualValue = 100m,
                    AdjustmentValue = 10m,
                    ForecastValue = 50m,
                    TotalDelivery = 160m
                },
                new DeliverableLine
                {
                    DeliverableCode = 5,
                    PlannedValue = 150m,
                    ActualValue = 100m,
                    AdjustmentValue = 10m,
                    ForecastValue = 40m,
                    TotalDelivery = 150m
                }
            };
        }

        private static List<DeliverableLine> CreateUnderDeliveryLessThanDeminimisCommunityLearningDeliverableLines()
        {
            return new List<DeliverableLine>
            {
                new DeliverableLine
                {
                    DeliverableCode = 1,
                    PlannedValue = 310,
                    ActualValue = 200m,
                    AdjustmentValue = 20m,
                    ForecastValue = 20m,
                    TotalDelivery = 240m
                }
            };
        }

        private static List<DeliverableLine> CreateUnderDeliveryMoreThanDeminimisDeliverableLines()
        {
            return new List<DeliverableLine>
            {
                new DeliverableLine
                {
                    DeliverableCode = 2,
                    PlannedValue = 260,
                    ActualValue = 100m,
                    AdjustmentValue = 10m,
                    ForecastValue = 10m,
                    TotalDelivery = 120m
                },
                new DeliverableLine
                {
                    DeliverableCode = 3,
                    PlannedValue = 250,
                    ActualValue = 100m,
                    AdjustmentValue = 10m,
                    ForecastValue = 10m,
                    TotalDelivery = 120m
                }
            };
        }

        private static List<DeliverableLine> CreateUnderDeliveryMoreThanDeminimisCommunityLearningDeliverableLines()
        {
            return new List<DeliverableLine>
            {
                new DeliverableLine
                {
                    DeliverableCode = 1,
                    PlannedValue = 510,
                    ActualValue = 200m,
                    AdjustmentValue = 20m,
                    ForecastValue = 20m,
                    TotalDelivery = 240m
                }
            };
        }

        private static List<DeliverableLine> CreateOverDeliveryMoreThanDeminimisDeliverableLines()
        {
            return new List<DeliverableLine>
            {
                new DeliverableLine
                {
                    DeliverableCode = 2,
                    PlannedValue = 160,
                    ActualValue = 150m,
                    AdjustmentValue = 30m,
                    ForecastValue = 120m,
                    TotalDelivery = 300m
                },
                new DeliverableLine
                {
                    DeliverableCode = 3,
                    PlannedValue = 150,
                    ActualValue = 100m,
                    AdjustmentValue = 20m,
                    ForecastValue = 80m,
                    TotalDelivery = 200m
                }
            };
        }

        private static List<DeliverableLine> CreateOverDeliveryMoreThanDeminimisCommunityLearningDeliverableLines()
        {
            return new List<DeliverableLine>
            {
                new DeliverableLine
                {
                    DeliverableCode = 1,
                    PlannedValue = 310,
                    ActualValue = 250m,
                    AdjustmentValue = 50m,
                    ForecastValue = 200m,
                    TotalDelivery = 500m
                }
            };
        }

        private static List<DeliverableLine> CreateDlsDeliverableLines()
        {
            return new List<DeliverableLine>
            {
                new DeliverableLine
                {
                    DeliverableCode = 1,
                    PlannedValue = 1000m,
                    ActualValue = 2000m,
                    AdjustmentValue = 0m,
                    ForecastValue = 0m,
                    TotalDelivery = 2000m
                },
                new DeliverableLine
                {
                    DeliverableCode = 2,
                    PlannedValue = 500m,
                    ActualValue = 1000m,
                    AdjustmentValue = 0m,
                    ForecastValue = 0m,
                    TotalDelivery = 1000m
                },
                new DeliverableLine
                {
                    DeliverableCode = 3,
                    PlannedValue = 500m,
                    ActualValue = 0m,
                    AdjustmentValue = 0m,
                    ForecastValue = 0m,
                    TotalDelivery = 0m
                },
                new DeliverableLine
                {
                    DeliverableCode = 4,
                    ActualValue = 300m,
                    AdjustmentValue = 0m,
                    ForecastValue = -10m,
                    TotalDelivery = 290m
                }
            };
        }

        private static List<DeliverableLine> CreateAscDeliverableLines()
        {
            return new List<DeliverableLine>
            {
                new DeliverableLine
                {
                    DeliverableCode = 2,
                    PlannedValue = 1000m
                },
                new DeliverableLine
                {
                    DeliverableCode = 4,
                    ActualValue = 100m,
                    AdjustmentValue = 50m,
                    ForecastValue = 0m,
                    TotalDelivery = 150m
                },
                new DeliverableLine
                {
                    DeliverableCode = 5,
                    ActualValue = 250m,
                    AdjustmentValue = 0m,
                    ForecastValue = 0m,
                    TotalDelivery = 250m
                },
                new DeliverableLine
                {
                    DeliverableCode = 6
                },
                new DeliverableLine
                {
                    DeliverableCode = 7
                },
                new DeliverableLine
                {
                    DeliverableCode = 8
                },
                new DeliverableLine
                {
                    DeliverableCode = 9
                },
                new DeliverableLine
                {
                    DeliverableCode = 10
                },
                new DeliverableLine
                {
                    DeliverableCode = 11
                },
                new DeliverableLine
                {
                    DeliverableCode = 12
                },
                new DeliverableLine //Other ASB Parent
                {
                    DeliverableCode = 3,
                    PlannedValue = 500m
                },
                new DeliverableLine
                {
                    DeliverableCode = 13,
                    ActualValue = 300m,
                    ForecastValue = 0m,
                    AdjustmentValue = -10m,
                    TotalDelivery = 290m
                },
                new DeliverableLine
                {
                    DeliverableCode = 14,
                    ActualValue = 270m,
                    ForecastValue = 0m,
                    AdjustmentValue = 0m,
                    TotalDelivery = 270m
                },
                new DeliverableLine
                {
                    DeliverableCode = 15
                },
                new DeliverableLine
                {
                    DeliverableCode = 16
                },
                new DeliverableLine
                {
                    DeliverableCode = 17
                },
                new DeliverableLine
                {
                    DeliverableCode = 18
                },
                new DeliverableLine
                {
                    DeliverableCode = 19
                }
            };
        }

        private static List<DeliverableLine> Create24PlusDeliverableLines()
        {
            return new List<DeliverableLine>
            {
                new DeliverableLine
                {
                    DeliverableCode = 1,
                    PlannedValue = 1000
                },
                new DeliverableLine
                {
                    DeliverableCode = 2,
                    PlannedValue = 0m,
                    ActualValue = 0m,
                    AdjustmentValue = 0m,
                    ForecastValue = 0m,
                    TotalDelivery = 0m
                },
                new DeliverableLine
                {
                    DeliverableCode = 3,
                    ActualValue = 100m,
                    AdjustmentValue = 50m,
                    ForecastValue = 0m,
                    TotalDelivery = 150m
                },
                new DeliverableLine
                {
                    DeliverableCode = 4,
                    PlannedValue = 0m,
                    ActualValue = 250m,
                    AdjustmentValue = 0m,
                    ForecastValue = 0m,
                    TotalDelivery = 250m
                },
                new DeliverableLine
                {
                    DeliverableCode = 5,
                    PlannedValue = 0m,
                    ActualValue = 0m,
                    AdjustmentValue = 0m,
                    ForecastValue = 0m,
                    TotalDelivery = 0m
                },
                new DeliverableLine
                {
                    DeliverableCode = 6,
                    PlannedValue = 0m,
                    ActualValue = 0m,
                    AdjustmentValue = 0m,
                    ForecastValue = 0m,
                    TotalDelivery = 0m
                },
                new DeliverableLine
                {
                    DeliverableCode = 7,
                    PlannedValue = 0m,
                    ActualValue = 0m,
                    AdjustmentValue = 0m,
                    ForecastValue = 0m,
                    TotalDelivery = 0m
                },
                new DeliverableLine
                {
                    DeliverableCode = 8,
                    PlannedValue = 0m,
                    ActualValue = 0m,
                    AdjustmentValue = 0m,
                    ForecastValue = 0m,
                    TotalDelivery = 0m
                }
            };
        }

        private static IReadOnlyCollection<FspDeliverableClaim> CreateListOfCommunityLearningDeliverableClaims()
        {
            return new List<FspDeliverableClaim>
            {
                new FspDeliverableClaim(CommunityLearningFspCode, 1, "Deliverable 1", true, CommunityLearningDeliverableGroupCode)
                {
                    ClaimReconciliationDeliverableGroup = new ClaimReconciliationDeliverableGroup(CommunityLearningDeliverableGroupCode, CommunityLearningDeliverableGroupName, false, false)
                }
            };
        }

        private static IReadOnlyCollection<FspDeliverableClaim> CreateListOfDlsDeliverableClaims()
        {
            return new List<FspDeliverableClaim>
            {
                new FspDeliverableClaim(DlsFspCode, 1, "Deliverable 1", false, DlsDeliverableGroupCode)
                {
                    ClaimReconciliationDeliverableGroup = new ClaimReconciliationDeliverableGroup(DlsDeliverableGroupCode, DlsDeliverableGroupName, false, false)
                },
                new FspDeliverableClaim(DlsFspCode, 2, "Deliverable 2", true, DlsDeliverableGroupCode)
                {
                    ClaimReconciliationDeliverableGroup = new ClaimReconciliationDeliverableGroup(DlsDeliverableGroupCode, DlsDeliverableGroupName, false, false)
                },
                new FspDeliverableClaim(DlsFspCode, 3, "Deliverable 3", true, DlsDeliverableGroupCode)
                {
                    ClaimReconciliationDeliverableGroup = new ClaimReconciliationDeliverableGroup(DlsDeliverableGroupCode, DlsDeliverableGroupName, false, false)
                },
                new FspDeliverableClaim(DlsFspCode, 4, "Deliverable 4", true, DlsDeliverableGroupCode)
                {
                    ClaimReconciliationDeliverableGroup = new ClaimReconciliationDeliverableGroup(DlsDeliverableGroupCode, DlsDeliverableGroupName, false, false)
                },
                new FspDeliverableClaim(DlsFspCode, 5, "Deliverable 5", true, DlsDeliverableGroupCode)
                {
                    ClaimReconciliationDeliverableGroup = new ClaimReconciliationDeliverableGroup(DlsDeliverableGroupCode, DlsDeliverableGroupName, false, false)
                },
            };
        }

        private static IReadOnlyCollection<FspDeliverableClaim> CreateListOf24PlusDeliverableClaims()
        {
            return new List<FspDeliverableClaim>
            {
                new FspDeliverableClaim(TwentyFourPlusFspCode, 1, "Deliverable 1", false, TwentyFourPlusDeliverableGroupCode)
                {
                    ClaimReconciliationDeliverableGroup = new ClaimReconciliationDeliverableGroup(TwentyFourPlusDeliverableGroupCode, TwentyFourPlusDeliverableGroupName, false, false)
                },
                new FspDeliverableClaim(TwentyFourPlusFspCode, 2, "Deliverable 2", true, TwentyFourPlusDeliverableGroupCode)
                {
                    ClaimReconciliationDeliverableGroup = new ClaimReconciliationDeliverableGroup(TwentyFourPlusDeliverableGroupCode, TwentyFourPlusDeliverableGroupName, false, false)
                },
                new FspDeliverableClaim(TwentyFourPlusFspCode, 3, "Deliverable 3", true, TwentyFourPlusDeliverableGroupCode)
                {
                    ClaimReconciliationDeliverableGroup = new ClaimReconciliationDeliverableGroup(TwentyFourPlusDeliverableGroupCode, TwentyFourPlusDeliverableGroupName, false, false)
                },
                new FspDeliverableClaim(TwentyFourPlusFspCode, 4, "Deliverable 4", true, TwentyFourPlusDeliverableGroupCode)
                {
                    ClaimReconciliationDeliverableGroup = new ClaimReconciliationDeliverableGroup(TwentyFourPlusDeliverableGroupCode, TwentyFourPlusDeliverableGroupName, false, false)
                },
                new FspDeliverableClaim(TwentyFourPlusFspCode, 5, "Deliverable 5", true, TwentyFourPlusDeliverableGroupCode)
                {
                    ClaimReconciliationDeliverableGroup = new ClaimReconciliationDeliverableGroup(TwentyFourPlusDeliverableGroupCode, TwentyFourPlusDeliverableGroupName, false, false)
                },
                new FspDeliverableClaim(TwentyFourPlusFspCode, 6, "Deliverable 6", true, TwentyFourPlusDeliverableGroupCode)
                {
                    ClaimReconciliationDeliverableGroup = new ClaimReconciliationDeliverableGroup(TwentyFourPlusDeliverableGroupCode, TwentyFourPlusDeliverableGroupName, false, false)
                },
                new FspDeliverableClaim(TwentyFourPlusFspCode, 7, "Deliverable 7", true, TwentyFourPlusDeliverableGroupCode)
                {
                    ClaimReconciliationDeliverableGroup = new ClaimReconciliationDeliverableGroup(TwentyFourPlusDeliverableGroupCode, TwentyFourPlusDeliverableGroupName, false, false)
                },
                new FspDeliverableClaim(TwentyFourPlusFspCode, 8, "Deliverable 8", true, TwentyFourPlusDeliverableGroupCode)
                {
                    ClaimReconciliationDeliverableGroup = new ClaimReconciliationDeliverableGroup(TwentyFourPlusDeliverableGroupCode, TwentyFourPlusDeliverableGroupName, false, false)
                },
            };
        }

        private static IReadOnlyCollection<FspDeliverableClaim> CreateListOfAdultSkillsDeliverableClaims()
        {
            return new List<FspDeliverableClaim>
            {
                //dont return dels where claim group is null 
                //new FspDeliverableClaim(AdultSkillsFspCode, 1, false, null)
                //{
                //    ClaimReconciliationDeliverableGroup = null
                //},
                new FspDeliverableClaim(AdultSkillsFspCode, 2, "Deliverable 2", false, AscAppsDeliverableGroupCode)
                {
                    ClaimReconciliationDeliverableGroup = new ClaimReconciliationDeliverableGroup(AscAppsDeliverableGroupCode, AscAppsDeliverableGroupName, false, false)
                },
                new FspDeliverableClaim(AdultSkillsFspCode, 3, "Deliverable 3", false, AscOtherDeliverableGroupCode)
                {
                    ClaimReconciliationDeliverableGroup = new ClaimReconciliationDeliverableGroup(AscOtherDeliverableGroupCode, AscOtherDeliverableGroupName, true, false)
                },
                new FspDeliverableClaim(AdultSkillsFspCode, 4, "Deliverable 4", true, AscAppsDeliverableGroupCode)
                {
                    ClaimReconciliationDeliverableGroup = new ClaimReconciliationDeliverableGroup(AscAppsDeliverableGroupCode, AscAppsDeliverableGroupName, false, false)
                },
                new FspDeliverableClaim(AdultSkillsFspCode, 5, "Deliverable 5", true, AscAppsDeliverableGroupCode)
                {
                    ClaimReconciliationDeliverableGroup = new ClaimReconciliationDeliverableGroup(AscAppsDeliverableGroupCode, AscAppsDeliverableGroupName, false, false)
                },
                new FspDeliverableClaim(AdultSkillsFspCode, 6, "Deliverable 6", true, AscAppsDeliverableGroupCode)
                {
                    ClaimReconciliationDeliverableGroup = new ClaimReconciliationDeliverableGroup(AscAppsDeliverableGroupCode, AscAppsDeliverableGroupName, false, false)
                },
                new FspDeliverableClaim(AdultSkillsFspCode, 7, "Deliverable 7", true, AscAppsDeliverableGroupCode)
                {
                    ClaimReconciliationDeliverableGroup = new ClaimReconciliationDeliverableGroup(AscAppsDeliverableGroupCode, AscAppsDeliverableGroupName, false, false)
                },
                new FspDeliverableClaim(AdultSkillsFspCode, 8, "Deliverable 8", true, AscAppsDeliverableGroupCode)
                {
                    ClaimReconciliationDeliverableGroup = new ClaimReconciliationDeliverableGroup(AscAppsDeliverableGroupCode, AscAppsDeliverableGroupName, false, false)
                },
                new FspDeliverableClaim(AdultSkillsFspCode, 9, "Deliverable 9", true, AscAppsDeliverableGroupCode)
                {
                    ClaimReconciliationDeliverableGroup = new ClaimReconciliationDeliverableGroup(AscAppsDeliverableGroupCode, AscAppsDeliverableGroupName, false, false)
                },
                new FspDeliverableClaim(AdultSkillsFspCode, 10, "Deliverable 10", true, AscAppsDeliverableGroupCode)
                {
                    ClaimReconciliationDeliverableGroup = new ClaimReconciliationDeliverableGroup(AscAppsDeliverableGroupCode, AscAppsDeliverableGroupName, false, false)
                },
                new FspDeliverableClaim(AdultSkillsFspCode, 11, "Deliverable 11", true, AscAppsDeliverableGroupCode)
                {
                    ClaimReconciliationDeliverableGroup = new ClaimReconciliationDeliverableGroup(AscAppsDeliverableGroupCode, AscAppsDeliverableGroupName, false, false)
                },
                new FspDeliverableClaim(AdultSkillsFspCode, 12, "Deliverable 12", true, AscAppsDeliverableGroupCode)
                {
                    ClaimReconciliationDeliverableGroup = new ClaimReconciliationDeliverableGroup(AscAppsDeliverableGroupCode, AscAppsDeliverableGroupName, false, false)
                },
                new FspDeliverableClaim(AdultSkillsFspCode, 13, "Deliverable 13", true, AscOtherDeliverableGroupCode)
                {
                    ClaimReconciliationDeliverableGroup = new ClaimReconciliationDeliverableGroup(AscOtherDeliverableGroupCode, AscOtherDeliverableGroupName, true, false)
                },
                new FspDeliverableClaim(AdultSkillsFspCode, 14, "Deliverable 14", true, AscOtherDeliverableGroupCode)
                {
                    ClaimReconciliationDeliverableGroup = new ClaimReconciliationDeliverableGroup(AscOtherDeliverableGroupCode, AscOtherDeliverableGroupName, true, false)
                },
                new FspDeliverableClaim(AdultSkillsFspCode, 15, "Deliverable 15", true, AscOtherDeliverableGroupCode)
                {
                    ClaimReconciliationDeliverableGroup = new ClaimReconciliationDeliverableGroup(AscOtherDeliverableGroupCode, AscOtherDeliverableGroupName, true, false)
                },
                new FspDeliverableClaim(AdultSkillsFspCode, 16, "Deliverable 16", true, AscOtherDeliverableGroupCode)
                {
                    ClaimReconciliationDeliverableGroup = new ClaimReconciliationDeliverableGroup(AscOtherDeliverableGroupCode, AscOtherDeliverableGroupName, true, false)
                },
                new FspDeliverableClaim(AdultSkillsFspCode, 17, "Deliverable 17", true, AscOtherDeliverableGroupCode)
                {
                    ClaimReconciliationDeliverableGroup = new ClaimReconciliationDeliverableGroup(AscOtherDeliverableGroupCode, AscOtherDeliverableGroupName, true, false)
                },
                new FspDeliverableClaim(AdultSkillsFspCode, 18, "Deliverable 10", true, AscOtherDeliverableGroupCode)
                {
                    ClaimReconciliationDeliverableGroup = new ClaimReconciliationDeliverableGroup(AscOtherDeliverableGroupCode, AscOtherDeliverableGroupName, true, false)
                }
            };
        }

        private static IReadOnlyCollection<FspDeliverableClaim> CreateListOfAdultSkillsDeliverableClaimsForProfile(string fspCode)
        {
            const string AEB1617_OTHER = "AEB1617_OTHER";
            const string AEB1617_CLMH = "AEB1617_CLMH";
            const string AEB1617_CLPF = "AEB1617_CLPF";

            return new List<FspDeliverableClaim>
            {

                new FspDeliverableClaim(fspCode, 1, "", false, AEB1617_OTHER)
                {
                    ClaimReconciliationDeliverableGroup = new ClaimReconciliationDeliverableGroup(AEB1617_OTHER, AscAppsDeliverableGroupName, false, false)
                },
                new FspDeliverableClaim(fspCode, 2, "Deliverable 2", true, AEB1617_OTHER)
                {
                    ClaimReconciliationDeliverableGroup = new ClaimReconciliationDeliverableGroup(AEB1617_OTHER, AscAppsDeliverableGroupName, false, false)
                },
                new FspDeliverableClaim(fspCode, 3, "Deliverable 3", true, AEB1617_OTHER)
                {
                    ClaimReconciliationDeliverableGroup = new ClaimReconciliationDeliverableGroup(AEB1617_OTHER, AscOtherDeliverableGroupName, false, false)
                },
                new FspDeliverableClaim(fspCode, 4, "Deliverable 4", true, AEB1617_OTHER)
                {
                    ClaimReconciliationDeliverableGroup = new ClaimReconciliationDeliverableGroup(AEB1617_OTHER, AscAppsDeliverableGroupName, false, false)
                },
                new FspDeliverableClaim(fspCode, 5, "Deliverable 5", true, AEB1617_OTHER)
                {
                    ClaimReconciliationDeliverableGroup = new ClaimReconciliationDeliverableGroup(AEB1617_OTHER, AscAppsDeliverableGroupName, false, false)
                },
                new FspDeliverableClaim(fspCode, 6, "Deliverable 6", true, AEB1617_OTHER)
                {
                    ClaimReconciliationDeliverableGroup = new ClaimReconciliationDeliverableGroup(AEB1617_OTHER, AscAppsDeliverableGroupName, false, false)
                },
                new FspDeliverableClaim(fspCode, 7, "Deliverable 7", true, AEB1617_OTHER)
                {
                    ClaimReconciliationDeliverableGroup = new ClaimReconciliationDeliverableGroup(AEB1617_OTHER, AscAppsDeliverableGroupName, false, false)
                },
                new FspDeliverableClaim(fspCode, 8, "Deliverable 8", true, AEB1617_OTHER)
                {
                    ClaimReconciliationDeliverableGroup = new ClaimReconciliationDeliverableGroup(AEB1617_OTHER, AscAppsDeliverableGroupName, false, false)
                },
                new FspDeliverableClaim(fspCode, 9, "Deliverable 9", true, AEB1617_OTHER)
                {
                    ClaimReconciliationDeliverableGroup = new ClaimReconciliationDeliverableGroup(AEB1617_OTHER, AscAppsDeliverableGroupName, false, false)
                },
                new FspDeliverableClaim(fspCode, 10, "Deliverable 10", true, AEB1617_OTHER)
                {
                    ClaimReconciliationDeliverableGroup = new ClaimReconciliationDeliverableGroup(AEB1617_OTHER, AscAppsDeliverableGroupName, false, false)
                },
                 new FspDeliverableClaim(fspCode, 11, "Deliverable 11", true, AEB1617_CLMH)
                {
                    ClaimReconciliationDeliverableGroup = new ClaimReconciliationDeliverableGroup(AEB1617_CLMH, AscAppsDeliverableGroupName, true, true)
                },
                new FspDeliverableClaim(fspCode, 12, "Deliverable 12", true, AEB1617_CLPF)
                {
                    ClaimReconciliationDeliverableGroup = new ClaimReconciliationDeliverableGroup(AEB1617_CLPF, AscAppsDeliverableGroupName, true, true)
                }
            };
        }

        private static List<DeliverableLine> CreateAdultEducationBudgetDeliverableLines()
        {
            return new List<DeliverableLine>
            {
                new DeliverableLine
                {
                    DeliverableCode = 1,
                    PlannedValue = 10000m
                },
                new DeliverableLine
                {
                    DeliverableCode = 2,
                    TotalDelivery = 5200m
                },
                new DeliverableLine
                {
                    DeliverableCode = 3,
                    TotalDelivery = 1500m
                },
                new DeliverableLine
                {
                    DeliverableCode = 4,
                    TotalDelivery = 2500m
                },
                new DeliverableLine
                {
                    DeliverableCode = 5
                },
                new DeliverableLine
                {
                    DeliverableCode = 6
                },
                new DeliverableLine
                {
                    DeliverableCode = 7,
                },
                  new DeliverableLine
                {
                    DeliverableCode = 8
                },
                new DeliverableLine
                {
                    DeliverableCode = 9,
                },
                new DeliverableLine
                {
                    DeliverableCode = 10,
                },
                  new DeliverableLine
                {
                    DeliverableCode = 11,
                    TotalDelivery = 600m
                },
                new DeliverableLine
                {
                    DeliverableCode = 12,
                    TotalDelivery = 1000m
                }
            };
        }
    }
}