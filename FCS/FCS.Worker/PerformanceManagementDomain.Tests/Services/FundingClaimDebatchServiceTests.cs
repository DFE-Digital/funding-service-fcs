namespace PerformanceManagementDomain.Tests.Services
{
    using System.Collections.Generic;
    using System.Linq;
    using SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaim;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using PerformanceManagementDomain.Services;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using FundingClaim = SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaim.FundingClaim;
    using PerformanceManagementDomain.ReconciliationCalculationEndpoint.Repositories;
    using System.Data;

    [TestClass]
    public class FundingClaimDebatchServiceTests
    {
        private const string AdultSkillsFspCode = "ASC1516";
        private const string AdultSkillsAllocGroupCode = "ASC1516";
        private const string AdultSkillsAllocGroupName = "Adult Skills 15/16";

        private const string CommunityLearningFspCode = "CL1516";
        private const string CommunityLearningAllocGroupCode = "CL1516";
        private const string CommunityLearningAllocGroupName = "Community Learning 15/16";

        private const string TwentyFourPlusFspCode = "24+ALLBC1516";
        private const string DlsFspCode = "DLS1516";
        private const string TwentyFourPlusAndDlsAllocGroupCode = "DLSALLBC1516";
        private const string TwentyFourPlusAndDlsAllocGroupName = "DLS and Advanced Learner Loans Bursary 15/16";

        private Mock<IClaimReconciliationAllocationGroupFspRepository> _repoMock;

        [TestInitialize]
        public void Setup()
        {
            _repoMock = new Mock<IClaimReconciliationAllocationGroupFspRepository>();

            _repoMock.Setup(x => x.GetClaimAllocationGroupForFundingStreamPeriod(It.Is<string>(fsp => fsp == AdultSkillsFspCode), It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(new ClaimReconciliationAllocationGroupFsp(AdultSkillsAllocGroupCode,
                    AdultSkillsFspCode)
                {
                    ClaimReconciliationAllocationGroup = new ClaimReconciliationAllocationGroup(
                        AdultSkillsAllocGroupCode,
                        AdultSkillsAllocGroupName)
                });

            _repoMock.Setup(
                x => x.GetClaimAllocationGroupForFundingStreamPeriod(It.Is<string>(fsp => fsp == TwentyFourPlusFspCode), It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(new ClaimReconciliationAllocationGroupFsp(
                    TwentyFourPlusAndDlsAllocGroupCode,
                    TwentyFourPlusFspCode)
                {
                    ClaimReconciliationAllocationGroup = new ClaimReconciliationAllocationGroup(
                        TwentyFourPlusAndDlsAllocGroupCode,
                        TwentyFourPlusAndDlsAllocGroupName)
                });

            _repoMock.Setup(x => x.GetClaimAllocationGroupForFundingStreamPeriod(It.Is<string>(fsp => fsp == DlsFspCode), It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(new ClaimReconciliationAllocationGroupFsp(
                    TwentyFourPlusAndDlsAllocGroupCode,
                    DlsFspCode)
                {
                    ClaimReconciliationAllocationGroup = new ClaimReconciliationAllocationGroup(
                        TwentyFourPlusAndDlsAllocGroupCode,
                        TwentyFourPlusAndDlsAllocGroupName)
                });

            _repoMock.Setup(x => x.GetClaimAllocationGroupForFundingStreamPeriod(It.Is<string>(fsp => fsp == CommunityLearningFspCode), It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(new ClaimReconciliationAllocationGroupFsp(
                    CommunityLearningAllocGroupCode,
                    CommunityLearningFspCode)
                {
                    ClaimReconciliationAllocationGroup = new ClaimReconciliationAllocationGroup(
                        CommunityLearningAllocGroupCode,
                        CommunityLearningAllocGroupName)
                });
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FundingClaimDebatchService_WhenPassedASingleFundingClaimWithSingleAllocation_DebatchesIntoSingleFundingClaim_EnrichedWithAllocationGroup()
        {
            // Arrange
            var fundingClaimDebatcher = new FundingClaimDebatchService(_repoMock.Object);
            FundingClaim fundingClaimToDebatch = CreateAscFundingClaim();
            var mockConnectionInfo = new Mock<ConnectionInfo>(null, Mock.Of<IDbConnection>());

            // Act
            IReadOnlyCollection<DebatchedFundingClaim> debatchedClaims = fundingClaimDebatcher.DebatchFundingClaimByAllocationGroup(fundingClaimToDebatch, mockConnectionInfo.Object).Result.ToList();

            // Assert
            Assert.AreEqual(1, debatchedClaims.Count);
            Assert.AreEqual(AdultSkillsAllocGroupCode, debatchedClaims.First().AllocationGroupCode);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FundingClaimDebatchService_WhenPassedASingleFundingClaimWithMultipleAllocations_ForOneAllocationGroup_DebatchesIntoSingleFundingClaim_WithAllocationGroupEnriched()
        {
            // Arrange
            var fundingClaimDebatcher = new FundingClaimDebatchService(_repoMock.Object);
            FundingClaim fundingClaimToDebatch = Create24PlusAndDlsFundingClaim();
            var mockConnectionInfo = new Mock<ConnectionInfo>(null, Mock.Of<IDbConnection>());

            // Act
            IReadOnlyCollection<DebatchedFundingClaim> debatchedClaims = fundingClaimDebatcher.DebatchFundingClaimByAllocationGroup(fundingClaimToDebatch, mockConnectionInfo.Object).Result.ToList();

            // Assert
            Assert.AreEqual(1, debatchedClaims.Count);
            Assert.AreEqual(TwentyFourPlusAndDlsAllocGroupCode, debatchedClaims.First().AllocationGroupCode);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FundingClaimDebatchService_WhenPassedASingleFundingClaimWithMultipleAllocations_ForAll4AllocationGroups_DebatchesInto3FundingClaim_WithAllocationGroupEnriched()
        {
            // Arrange
            var fundingClaimDebatcher = new FundingClaimDebatchService(_repoMock.Object);
            FundingClaim fundingClaimToDebatch = CreateAllAllocationGroupFundingClaim();
            var mockConnectionInfo = new Mock<ConnectionInfo>(null, Mock.Of<IDbConnection>());

            // Act
            List<DebatchedFundingClaim> debatchedClaims = fundingClaimDebatcher.DebatchFundingClaimByAllocationGroup(fundingClaimToDebatch, mockConnectionInfo.Object).Result.ToList();

            // Assert
            Assert.AreEqual(3, debatchedClaims.Count);
            Assert.AreEqual(CommunityLearningAllocGroupCode, debatchedClaims[0].AllocationGroupCode);
            Assert.AreEqual(AdultSkillsAllocGroupCode, debatchedClaims[1].AllocationGroupCode);
            Assert.AreEqual(TwentyFourPlusAndDlsAllocGroupCode, debatchedClaims[2].AllocationGroupCode);

            Assert.AreEqual(1, debatchedClaims[0].ContractAllocations.Count);
            Assert.AreEqual(1, debatchedClaims[1].ContractAllocations.Count);
            Assert.AreEqual(2, debatchedClaims[2].ContractAllocations.Count);
        }

        private FundingClaim CreateAllAllocationGroupFundingClaim()
        {
            FundingClaim fundingClaim = new FundingClaim
            {
                Period = "AY1516",
                HasBeenSigned = false,
                VersionNumber = 1,
                ClaimTypeName = ClaimTypeName.YEAREND,
                Contractor = new Contractor
                {
                    OrganisationIdentifier = "ORG000012",
                    Ukprn = 123456
                },
                PeriodTypeCode = PeriodTypeCode.AY
            };

            fundingClaim.ContractAllocations.Add(CreateContractAllocation(CommunityLearningFspCode, "CL-1234"));
            fundingClaim.ContractAllocations.Add(CreateContractAllocation(AdultSkillsFspCode, "ASC-1234"));
            fundingClaim.ContractAllocations.Add(CreateContractAllocation(DlsFspCode, "DLS-1234"));
            fundingClaim.ContractAllocations.Add(CreateContractAllocation(TwentyFourPlusFspCode, "ALLBC-1234"));

            return fundingClaim;
        }

        private FundingClaim CreateAscFundingClaim()
        {
            return new FundingClaim
            {
                Period = "AY1516",
                ContractAllocations = new List<ContractAllocation> { CreateContractAllocation(AdultSkillsFspCode, "ASC-1234") },
                HasBeenSigned = false,
                VersionNumber = 1,
                ClaimTypeName = ClaimTypeName.YEAREND,
                Contractor = new Contractor
                {
                    OrganisationIdentifier = "ORG000012",
                    Ukprn = 123456
                },
                PeriodTypeCode = PeriodTypeCode.AY
            };
        }

        private FundingClaim Create24PlusAndDlsFundingClaim()
        {
            FundingClaim fundingClaim = new FundingClaim
            {
                Period = "AY1516",
                HasBeenSigned = false,
                VersionNumber = 1,
                ClaimTypeName = ClaimTypeName.YEAREND,
                Contractor = new Contractor
                {
                    OrganisationIdentifier = "ORG000012",
                    Ukprn = 123456
                },
                PeriodTypeCode = PeriodTypeCode.AY
            };

            fundingClaim.ContractAllocations.Add(CreateContractAllocation(DlsFspCode, "DLS-1234"));
            fundingClaim.ContractAllocations.Add(CreateContractAllocation(TwentyFourPlusFspCode, "ALLBC-1234"));

            return fundingClaim;
        }

        private static ContractAllocation CreateContractAllocation(string fspCode, string allocNumber)
        {
            return new ContractAllocation
            {
                FundingStreamPeriodCode = fspCode,
                ContractAllocationNumber = allocNumber,
                DeliverableLines = CreateDeliverables()
            };
        }

        private static List<DeliverableLine> CreateDeliverables()
        {
            return new List<DeliverableLine>
                        {
                            new DeliverableLine
                            {
                                ActualValue = 100m,
                                AdjustmentValue = 10m,
                                DeliverableCode = 5,
                                ForecastValue = 200m
                            },
                            new DeliverableLine
                            {
                                ActualValue = 100m,
                                AdjustmentValue = 10m,
                                DeliverableCode = 6,
                                ForecastValue = 200m
                            }
                        };
        }
    }
}