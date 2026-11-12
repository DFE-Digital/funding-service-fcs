namespace PerformanceManagementDomain.Tests.PullFundingClaim.Handlers
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using Infrastructure;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus.Testing;
    using PerformanceManagementDomain.PullFundingClaim.DTOs;
    using PerformanceManagementDomain.PullFundingClaim.Handlers;
    using PerformanceManagementDomain.PullFundingClaim.Repositories;
    using PerformanceManagementDomain.PullFundingClaim.Services;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore.Services;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.PerformanceManagementDomain.Common.Commands;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;

    [TestClass]
    public class PullPageForPeriodClaimTypeHandlerFlowTests
    {
        private const string PeriodClaimType = "1617-YE";
        private const int PageNumber = 2;
        private static readonly DateTime CompletedDate = new DateTime(2020, 6, 1);

        private readonly Mock<IFundingClaimsApiAdapter> _adapter = new Mock<IFundingClaimsApiAdapter>();
        private readonly Mock<IFundingClaimImportInfoRepository> _importInfoRepository = new Mock<IFundingClaimImportInfoRepository>();
        private readonly Mock<IFundingClaimRepository> _fundingClaimRepository = new Mock<IFundingClaimRepository>();
        private readonly Mock<IDateProvider> _dateProvider = new Mock<IDateProvider>();
        private readonly Mock<IClaimReconciliationAllocationGroupFspRepository> _fspRepository = new Mock<IClaimReconciliationAllocationGroupFspRepository>();
        private readonly TestableMessageHandlerContext _context = new TestableMessageHandlerContext();
        private readonly Mock<ILogger> _logger = new Mock<ILogger>();

        private IReadOnlyCollection<FundingClaim> _addedClaims;

        private PullPageForPeriodClaimTypeHandler CreateHandler(List<FundingClaimApiDto> apiClaims, int totalRowsToImport, int rowsInDb)
        {
            _adapter
                .Setup(a => a.GetFundingClaimsForCollectionKey(PeriodClaimType, PageNumber))
                .Returns(Task.FromResult<IReadOnlyCollection<FundingClaimApiDto>>(apiClaims));
            _fspRepository
                .Setup(r => r.GetValidFundingStreamPeriodCodes(It.IsAny<ConnectionInfo>()))
                .Returns(Task.FromResult<IReadOnlyCollection<string>>(new List<string> { "VALID" }));
            _fundingClaimRepository
                .Setup(r => r.AddFundingClaims(It.IsAny<IReadOnlyCollection<FundingClaim>>(), It.IsAny<ConnectionInfo>()))
                .Returns(Task.FromResult(0))
                .Callback<IReadOnlyCollection<FundingClaim>, ConnectionInfo>((claims, c) => _addedClaims = claims);
            _fundingClaimRepository
                .Setup(r => r.GetCountOfFundingClaimsForCollection("1617", "YEAREND", It.IsAny<ConnectionInfo>()))
                .Returns(Task.FromResult(rowsInDb));
            _importInfoRepository
                .Setup(r => r.Find(PeriodClaimType, It.IsAny<ConnectionInfo>()))
                .Returns(Task.FromResult(new FundingClaimCollectionImportInfo(PeriodClaimType) { TotalRowsToImport = totalRowsToImport }));
            _importInfoRepository
                .Setup(r => r.SetToComplete(It.IsAny<string>(), It.IsAny<DateTime>(), It.IsAny<ConnectionInfo>()))
                .Returns(Task.FromResult(0));
            _dateProvider.Setup(d => d.GetDate(It.IsAny<ConnectionInfo>())).Returns(CompletedDate);

            return new PullPageForPeriodClaimTypeHandler(
                _logger.Object,
                _adapter.Object,
                _importInfoRepository.Object,
                Mock.Of<ISessionConnectionFactory>(),
                _fundingClaimRepository.Object,
                _dateProvider.Object,
                _fspRepository.Object);
        }

        private static FundingClaimApiDto ApiClaim()
        {
            return new FundingClaimApiDto
            {
                OrganisationIdentifier = "ORG1",
                Ukprn = "10000001",
                VersionNumber = 1,
                ClaimTypeName = "Year End",
                PeriodTypeCode = "AY",
                Period = "1617",
                HasBeenSigned = "true",
                ContractAllocations = new List<ContractAllocationApiDto>
                {
                    new ContractAllocationApiDto { ContractAllocationNumber = "A1", FundingStreamPeriodCode = "VALID", DeliverableCodes = new List<DeliverableCodeApiDto>() },
                    new ContractAllocationApiDto { ContractAllocationNumber = "A2", FundingStreamPeriodCode = "INVALID", DeliverableCodes = new List<DeliverableCodeApiDto>() }
                }
            };
        }

        private static PullPageForPeriodClaimTypeCommand Command()
        {
            return PullPageForPeriodClaimTypeCommand.Create(PeriodClaimType, PageNumber);
        }

        [TestMethod, TestCategory("UnitTest")]
        public async Task Handle_WhenLastPageStored_RemovesInvalidAllocationsMarksCompleteAndTriggersProcessing()
        {
            var handler = CreateHandler(new List<FundingClaimApiDto> { ApiClaim() }, totalRowsToImport: 5, rowsInDb: 5);

            await handler.Handle(Command(), _context);

            Assert.AreEqual(1, _addedClaims.Count);
            var allocation = _addedClaims.Single().Allocations.Single();
            Assert.AreEqual("A1", allocation.ContractAllocationNumber);
            _importInfoRepository.Verify(r => r.SetToComplete(PeriodClaimType, CompletedDate, It.IsAny<ConnectionInfo>()), Times.Once());
            var sent = _context.SentMessages.Select(m => m.Message).OfType<ProcessFundingClaimsCommand>().Single();
            Assert.AreEqual("1617", sent.Period);
            Assert.AreEqual("YEAREND", sent.ClaimTypeName);
        }

        [TestMethod, TestCategory("UnitTest")]
        public async Task Handle_WhenMorePagesToCome_StoresClaimsWithoutCompletingImport()
        {
            var handler = CreateHandler(new List<FundingClaimApiDto> { ApiClaim() }, totalRowsToImport: 5, rowsInDb: 3);

            await handler.Handle(Command(), _context);

            Assert.AreEqual(1, _addedClaims.Count);
            _importInfoRepository.Verify(r => r.SetToComplete(It.IsAny<string>(), It.IsAny<DateTime>(), It.IsAny<ConnectionInfo>()), Times.Never());
            Assert.AreEqual(0, _context.SentMessages.Length);
        }

        [TestMethod, TestCategory("UnitTest")]
        public async Task Handle_WhenImportedRowsExceedExpected_LogsErrorAndDoesNotComplete()
        {
            var handler = CreateHandler(new List<FundingClaimApiDto> { ApiClaim() }, totalRowsToImport: 5, rowsInDb: 6);

            await handler.Handle(Command(), _context);

            _importInfoRepository.Verify(r => r.SetToComplete(It.IsAny<string>(), It.IsAny<DateTime>(), It.IsAny<ConnectionInfo>()), Times.Never());
            Assert.AreEqual(0, _context.SentMessages.Length);
            _logger.Verify(l => l.LogError(It.IsAny<int>(), It.Is<string>(s => s.Contains("6") && s.Contains("5"))), Times.Once());
        }

        [TestMethod, TestCategory("UnitTest")]
        public async Task Handle_WhenPageIsEmpty_DoesNotStoreOrComplete()
        {
            var handler = CreateHandler(new List<FundingClaimApiDto>(), totalRowsToImport: 5, rowsInDb: 5);

            await handler.Handle(Command(), _context);

            _fundingClaimRepository.Verify(r => r.AddFundingClaims(It.IsAny<IReadOnlyCollection<FundingClaim>>(), It.IsAny<ConnectionInfo>()), Times.Never());
            _importInfoRepository.Verify(r => r.SetToComplete(It.IsAny<string>(), It.IsAny<DateTime>(), It.IsAny<ConnectionInfo>()), Times.Never());
            Assert.AreEqual(0, _context.SentMessages.Length);
        }
    }
}
