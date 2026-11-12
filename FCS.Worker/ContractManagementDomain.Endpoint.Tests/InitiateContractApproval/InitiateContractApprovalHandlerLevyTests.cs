namespace ContractManagementDomain.Endpoint.Tests.InitiateContractApproval
{
    using System;
    using System.Collections.Generic;
    using ContractManagement.DataStore.Repositories;
    using Endpoint.InitiateContractApproval;
    using Endpoint.InitiateContractApproval.Dtos;
    using Endpoint.InitiateContractApproval.Repositories;
    using Endpoint.InitiateContractApproval.Services;
    using Endpoint.Repositories;
    using Endpoint.Services;
    using Infrastructure;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus.Testing;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.ContractManagementService.Common.Commands;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore.Services;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class InitiateContractApprovalHandlerLevyTests
    {
        private static readonly Guid ContractId = Guid.NewGuid();
        private static readonly Guid AllocationA = Guid.NewGuid();
        private static readonly Guid AllocationB = Guid.NewGuid();
        private static readonly Guid PeriodA1 = Guid.NewGuid();
        private static readonly Guid PeriodA2 = Guid.NewGuid();
        private static readonly Guid PeriodB1 = Guid.NewGuid();

        private Mock<IContractCheckerService> _checker;
        private Mock<IDateProvider> _dateProvider;
        private Mock<ICrmContractDeliverablePeriodRepository> _periods;
        private Mock<ICrmContractRepository> _contracts;
        private Mock<ICrmContractAllocationRepository> _allocations;
        private Mock<IMonthEndHistoryRepository> _monthEnd;
        private TestableMessageHandlerContext _context;
        private InitiateContractApprovalHandler _handler;

        [TestInitialize]
        public void Setup()
        {
            _checker = new Mock<IContractCheckerService>();
            _dateProvider = new Mock<IDateProvider>();
            _periods = new Mock<ICrmContractDeliverablePeriodRepository>();
            _contracts = new Mock<ICrmContractRepository>();
            _allocations = new Mock<ICrmContractAllocationRepository>();
            _monthEnd = new Mock<IMonthEndHistoryRepository>();
            _context = new TestableMessageHandlerContext();
            _handler = new InitiateContractApprovalHandler(
                Mock.Of<ILogger>(),
                Mock.Of<ISessionConnectionFactory>(),
                _monthEnd.Object,
                _checker.Object,
                _dateProvider.Object,
                _periods.Object,
                _contracts.Object,
                _allocations.Object,
                Mock.Of<IFundingTypeFundingPeriodService>(),
                Mock.Of<IXrmManager>(),
                Mock.Of<IContractsManager>());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Handle_WhenLevyContractIsNew_ShouldUpdateContractAllocationsAndPeriods()
        {
            DateTime now = new DateTime(2021, 6, 15, 0, 0, 0, DateTimeKind.Utc);
            SetupLevy(isNew: true, isAllocationNew: false, now: now);
            _periods
                .Setup(p => p.GetContractDeliverablePeriods("ABC-1", 1))
                .Returns(new List<ContractDeliverablePeriodDto>
                {
                    new ContractDeliverablePeriodDto(ContractId, AllocationA, PeriodA1),
                    new ContractDeliverablePeriodDto(ContractId, AllocationA, PeriodA2),
                    new ContractDeliverablePeriodDto(ContractId, AllocationB, PeriodB1)
                });

            _handler.Handle(Command("ABC-1"), _context).Wait();

            _contracts.Verify(c => c.UpdateStartDate(ContractId, now), Times.Once);
            _allocations.Verify(a => a.UpdateStartDate(AllocationA, now), Times.Once);
            _allocations.Verify(a => a.UpdateStartDate(AllocationB, now), Times.Once);
            _periods.Verify(p => p.UpdatePeriod(PeriodA1, 2021, 6), Times.Once);
            _periods.Verify(p => p.UpdatePeriod(PeriodA2, 2021, 6), Times.Once);
            _periods.Verify(p => p.UpdatePeriod(PeriodB1, 2021, 6), Times.Once);
            _periods.Verify(
                p => p.GetContractDeliverablePeriodsForAllocation(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<string>()),
                Times.Never);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Handle_WhenNewLevyContractIsPostMarch2020AndBeforeNoticeEnd_ShouldUseLastDayOfMarch()
        {
            DateTime now = new DateTime(2020, 4, 1, 0, 0, 0, DateTimeKind.Utc);
            SetupLevy(isNew: true, isAllocationNew: false, now: now);
            _periods
                .Setup(p => p.GetContractDeliverablePeriods("ABC-5001", 1))
                .Returns(new List<ContractDeliverablePeriodDto> { new ContractDeliverablePeriodDto(ContractId, AllocationA, PeriodA1) });
            DateTime lastDayOfMarch = new DateTime(2020, 3, 31, 0, 0, 0, DateTimeKind.Utc);

            _handler.Handle(Command("ABC-5001"), _context).Wait();

            _contracts.Verify(c => c.UpdateStartDate(ContractId, lastDayOfMarch), Times.Once);
            _periods.Verify(p => p.UpdatePeriod(PeriodA1, 2020, 3), Times.Once);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Handle_WhenOnlyLevyAllocationIsNew_ShouldUpdateAllocationAndItsPeriodsOnly()
        {
            DateTime now = new DateTime(2021, 9, 2, 0, 0, 0, DateTimeKind.Utc);
            SetupLevy(isNew: false, isAllocationNew: true, now: now);
            _periods
                .Setup(p => p.GetContractDeliverablePeriodsForAllocation("ABC-1", 1, "NONLEVY2019"))
                .Returns(new List<ContractDeliverablePeriodDto>
                {
                    new ContractDeliverablePeriodDto(ContractId, AllocationB, PeriodB1)
                });

            _handler.Handle(Command("ABC-1"), _context).Wait();

            _allocations.Verify(a => a.UpdateStartDate(AllocationB, now), Times.Once);
            _periods.Verify(p => p.UpdatePeriod(PeriodB1, 2021, 9), Times.Once);
            _contracts.Verify(c => c.UpdateStartDate(It.IsAny<Guid>(), It.IsAny<DateTime>()), Times.Never);
            _periods.Verify(p => p.GetContractDeliverablePeriods(It.IsAny<string>(), It.IsAny<int>()), Times.Never);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Handle_WhenLevyContractAndAllocationAreNotNew_ShouldNotUpdateStartDates()
        {
            SetupLevy(isNew: false, isAllocationNew: false, now: DateTime.UtcNow);

            _handler.Handle(Command("ABC-1"), _context).Wait();

            _contracts.Verify(c => c.UpdateStartDate(It.IsAny<Guid>(), It.IsAny<DateTime>()), Times.Never);
            _allocations.Verify(a => a.UpdateStartDate(It.IsAny<Guid>(), It.IsAny<DateTime>()), Times.Never);
            _periods.Verify(p => p.UpdatePeriod(It.IsAny<Guid>(), It.IsAny<int>(), It.IsAny<int>()), Times.Never);
        }

        private void SetupLevy(bool isNew, bool isAllocationNew, DateTime now)
        {
            _checker
                .Setup(c => c.GetContractCheckerServiceResult(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(ContractCheckerServiceResult.GetResult(isNew, isAllocationNew));
            _dateProvider.Setup(d => d.GetDate(It.IsAny<ConnectionInfo>())).Returns(now);
        }

        private static InitiateContractApprovalCommand Command(string contractNumber)
        {
            return new InitiateContractApprovalCommand
            {
                ContractNumber = contractNumber,
                MasterContractNumber = "MAS-1",
                ContractVersionNumber = 1
            };
        }
    }
}
