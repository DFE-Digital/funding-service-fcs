namespace PerformanceManagementDomain.Tests.ReconciliationCalculationEndpoint.Handlers
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using Infrastructure;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus.Testing;
    using PerformanceManagementDomain.ReconciliationCalculationEndpoint.Handlers;
    using PerformanceManagementDomain.ReconciliationCalculationEndpoint.Repositories;
    using PerformanceManagementDomain.ReconciliationCalculationEndpoint.Services;
    using PerformanceManagementDomain.Services;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaim;
    using SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.PerformanceManagementDomain.Common.Commands;
    using ContractAllocation = SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaim.ContractAllocation;
    using FundingClaimRepository = PerformanceManagementDomain.ReconciliationCalculationEndpoint.Repositories.FundingClaimRepository;
    using IFundingClaimRepository = PerformanceManagementDomain.ReconciliationCalculationEndpoint.Repositories.IFundingClaimRepository;

    [TestClass]
    public class RecalculateFundingClaimReconciliationCommandHandlerFlowTests
    {
        private const string OrgId = "ORG0017192";
        private const int VersionNumber = 3;
        private const string PeriodTypeCode = "AY";
        private const string Period = "1617";
        private const string AllocationGroup = "AAC1617";

        private readonly Mock<IFundingClaimRepository> _fundingClaimRepository = new Mock<IFundingClaimRepository>();
        private readonly Mock<IFundingClaimDebatchService> _debatchService = new Mock<IFundingClaimDebatchService>();
        private readonly Mock<ICalculationService> _calculationService = new Mock<ICalculationService>();
        private readonly Mock<IFcrUpdateService> _fcrUpdateService = new Mock<IFcrUpdateService>();
        private readonly Mock<IFundingClaimEnrichmentService> _enrichmentService = new Mock<IFundingClaimEnrichmentService>();
        private readonly Mock<ISessionConnectionFactory> _connectionFactory = new Mock<ISessionConnectionFactory>();
        private readonly TestableMessageHandlerContext _context = new TestableMessageHandlerContext();
        private readonly Guid _fcrCrmId = Guid.NewGuid();

        private FundingClaimRepository.FundingClaimNaturalKey _capturedKey;
        private DebatchedFundingClaim _calculatedClaim;
        private decimal? _calculatedAdjustment;
        private decimal? _calculatedBoost;
        private readonly FundingClaimReconciliation _reconciliation = new FundingClaimReconciliation
        {
            Amounts = new AmountSummary { ProposedReconciliationValue = 100m, AdjustedCappedClaimValue = 90m },
            ContractAllocations = new List<SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation.ContractAllocation>()
        };

        private RecalculateFundingClaimReconciliationCommandHandler CreateHandler(params string[] allocationGroups)
        {
            var fundingClaim = new FundingClaim();
            _fundingClaimRepository
                .Setup(r => r.GetFundingClaimByNaturalKey(It.IsAny<FundingClaimRepository.FundingClaimNaturalKey>(), It.IsAny<ConnectionInfo>()))
                .Returns(Task.FromResult(fundingClaim))
                .Callback<FundingClaimRepository.FundingClaimNaturalKey, ConnectionInfo>((key, c) => _capturedKey = key);
            _enrichmentService.Setup(e => e.Enrich(fundingClaim, It.IsAny<ConnectionInfo>())).Returns(Task.FromResult(0));
            _debatchService
                .Setup(d => d.DebatchFundingClaimByAllocationGroup(fundingClaim, It.IsAny<ConnectionInfo>()))
                .Returns(Task.FromResult<IEnumerable<DebatchedFundingClaim>>(
                    allocationGroups.Select(g => new DebatchedFundingClaim { AllocationGroupCode = g }).ToList()));
            _calculationService
                .Setup(c => c.Calculate(It.IsAny<DebatchedFundingClaim>(), It.IsAny<ConnectionInfo>(), It.IsAny<decimal>(), It.IsAny<decimal?>()))
                .Returns(Task.FromResult(_reconciliation))
                .Callback<DebatchedFundingClaim, ConnectionInfo, decimal, decimal?>((dfc, c, adjustment, boost) =>
                {
                    _calculatedClaim = dfc;
                    _calculatedAdjustment = adjustment;
                    _calculatedBoost = boost;
                });

            return new RecalculateFundingClaimReconciliationCommandHandler(
                _calculationService.Object,
                _fundingClaimRepository.Object,
                _debatchService.Object,
                _fcrUpdateService.Object,
                _enrichmentService.Object,
                Mock.Of<ILogger>(),
                _connectionFactory.Object);
        }

        private RecalculateFcrOnCappedClaimAdjustmentCommand CappedCommand(decimal? boost, bool updateFinal)
        {
            return new RecalculateFcrOnCappedClaimAdjustmentCommand
            {
                OrganisationIdentifier = OrgId,
                VersionNumber = VersionNumber,
                ClaimTypeName = "Year End",
                PeriodTypeCode = PeriodTypeCode,
                Period = Period,
                AllocationGroupCode = AllocationGroup,
                FcrCrmId = _fcrCrmId,
                CappedClaimAdjustment = 5m,
                EarningsBoostValue = boost,
                ShouldUpdateFinalReconciliation = updateFinal
            };
        }

        [TestMethod, TestCategory("UnitTest")]
        public async Task Handle_RecalculateCommand_CalculatesForMatchingAllocationGroupAndUpdatesCrm()
        {
            var handler = CreateHandler("OTHER", AllocationGroup);

            await handler.Handle(
                new RecalculateFundingClaimReconciliationCommand(OrgId, VersionNumber, "Year End", PeriodTypeCode, Period, AllocationGroup, _fcrCrmId, 7m),
                _context);

            Assert.AreEqual(AllocationGroup, _calculatedClaim.AllocationGroupCode);
            Assert.AreEqual(7m, _calculatedAdjustment);
            Assert.AreEqual(OrgId, _capturedKey.OrganisationIdentifier);
            Assert.AreEqual(VersionNumber, _capturedKey.VersionNumber);
            Assert.AreEqual(FundingClaimRepository.ClaimTypeNames.YEAREND, _capturedKey.ClaimTypeName);
            Assert.AreEqual(PeriodTypeCode, _capturedKey.PeriodTypeCode);
            Assert.AreEqual(Period, _capturedKey.Period);
            _fcrUpdateService.Verify(u => u.UpdateFundingClaimReconciliationInCrm(_reconciliation.Amounts, _reconciliation.ContractAllocations, _fcrCrmId), Times.Once());
        }

        [TestMethod, TestCategory("UnitTest")]
        public async Task Handle_RecalculateCommand_WhenNoMatchingAllocationGroup_Throws()
        {
            var handler = CreateHandler("OTHER");

            try
            {
                await handler.Handle(
                    new RecalculateFundingClaimReconciliationCommand(OrgId, VersionNumber, "Year End", PeriodTypeCode, Period, AllocationGroup, _fcrCrmId, 0m),
                    _context);
                Assert.Fail("Expected InvalidOperationException");
            }
            catch (InvalidOperationException)
            {
            }

            _fcrUpdateService.Verify(u => u.UpdateFundingClaimReconciliationInCrm(It.IsAny<AmountSummary>(), It.IsAny<IEnumerable<SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation.ContractAllocation>>(), It.IsAny<Guid>()), Times.Never());
        }

        [TestMethod, TestCategory("UnitTest")]
        public async Task Handle_CappedAdjustment_WhenFinalReconciliationWithBoost_AddsBoostToReconciliationValue()
        {
            var handler = CreateHandler(AllocationGroup);

            await handler.Handle(CappedCommand(boost: 10m, updateFinal: true), _context);

            Assert.AreEqual(5m, _calculatedAdjustment);
            Assert.AreEqual(10m, _calculatedBoost);
            _fcrUpdateService.Verify(u => u.UpdateFundingClaimReconciliationInCrm(90m, 5m, 100m, 110m, 10m, _fcrCrmId), Times.Once());
            _fcrUpdateService.Verify(u => u.UpdateFcrAdjustedCappedClaimValueInCrm(It.IsAny<decimal?>(), It.IsAny<decimal?>(), It.IsAny<decimal?>(), It.IsAny<decimal?>(), It.IsAny<Guid>()), Times.Never());
        }

        [TestMethod, TestCategory("UnitTest")]
        public async Task Handle_CappedAdjustment_WhenFinalReconciliationWithoutBoost_UsesProposedValueAsReconciliationValue()
        {
            var handler = CreateHandler(AllocationGroup);

            await handler.Handle(CappedCommand(boost: null, updateFinal: true), _context);

            _fcrUpdateService.Verify(u => u.UpdateFundingClaimReconciliationInCrm(90m, 5m, 100m, 100m, null, _fcrCrmId), Times.Once());
        }

        [TestMethod, TestCategory("UnitTest")]
        public async Task Handle_CappedAdjustment_WhenNotFinal_OnlyUpdatesAdjustedCappedClaimValue()
        {
            var handler = CreateHandler(AllocationGroup);

            await handler.Handle(CappedCommand(boost: 10m, updateFinal: false), _context);

            _fcrUpdateService.Verify(u => u.UpdateFcrAdjustedCappedClaimValueInCrm(90m, 5m, 100m, 10m, _fcrCrmId), Times.Once());
            _fcrUpdateService.Verify(u => u.UpdateFundingClaimReconciliationInCrm(It.IsAny<decimal?>(), It.IsAny<decimal?>(), It.IsAny<decimal?>(), It.IsAny<decimal?>(), It.IsAny<decimal?>(), It.IsAny<Guid>()), Times.Never());
        }
    }
}
