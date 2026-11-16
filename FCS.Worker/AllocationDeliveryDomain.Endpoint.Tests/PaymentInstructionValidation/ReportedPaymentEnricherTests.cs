
namespace AllocationDeliveryDomain.Endpoint.Tests.PaymentInstructionValidation
{
    using System.Collections.Generic;
    using System.Data;
    using System.Linq;
    using AutoMapper;
    using Endpoint.PaymentInstructionValidation.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.AllocationDeliveryDomain.Common.Storage;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    [TestClass]
    public class ReportedPaymentEnricherTests
    {
        private const string ContractNumber = "LEVY-1234";
        private const int ContractVersionNumber = 1;
        private const int ContractSubVersionNumber = 2;
        private const string AllocationNumber = "APPS-100";

        private const string ValidOrganisationId = "ORG0000001";
        private const string Ukprn = "10000020";
        private const string ValidFundingStreamPeriodCode = "LEVY1799";

        private const string InvalidOrganisationId = "ORG000002";

        private readonly Mock<IMonitoringDeliverableStore> _mockStore =
            new Mock<IMonitoringDeliverableStore>();

        private IMapper _mapper;

        // ✅ Mapper setup
        [TestInitialize]
        public void SetupTests()
        {
            var config = new MapperConfiguration(cfg =>
            {
                cfg.CreateMap<ReportedActual, EnrichedReportedActual>();
            },null);

            _mapper = config.CreateMapper();

            var allocationDeliverablePeriods = new List<AllocationDeliverablePeriod>
            {
                new AllocationDeliverablePeriod
                {
                    ContractNumber = ContractNumber,
                    ContractVersionNumber = ContractVersionNumber,
                    ContractSubVersionNumber = ContractSubVersionNumber,
                    ContractAllocationNumber = AllocationNumber,
                    DeliverableCode = 1,
                    FundingStreamPeriodCode = ValidFundingStreamPeriodCode,
                    OrganisationId = ValidOrganisationId,
                    Period = "201705",
                    Ukprn = Ukprn
                },
                new AllocationDeliverablePeriod
                {
                    ContractNumber = ContractNumber,
                    ContractVersionNumber = ContractVersionNumber,
                    ContractSubVersionNumber = ContractSubVersionNumber,
                    ContractAllocationNumber = AllocationNumber,
                    DeliverableCode = 2,
                    FundingStreamPeriodCode = ValidFundingStreamPeriodCode,
                    OrganisationId = ValidOrganisationId,
                    Period = "201705",
                    Ukprn = Ukprn
                },
                new AllocationDeliverablePeriod
                {
                    ContractNumber = "1",
                    ContractVersionNumber = ContractVersionNumber,
                    ContractSubVersionNumber = ContractSubVersionNumber,
                    ContractAllocationNumber = "1A",
                    DeliverableCode = 1,
                    FundingStreamPeriodCode = ValidFundingStreamPeriodCode,
                    OrganisationId = "ABC",
                    Period = "201705",
                    Ukprn = "ABC01"
                },
                new AllocationDeliverablePeriod
                {
                    ContractNumber = "1",
                    ContractVersionNumber = ContractVersionNumber,
                    ContractSubVersionNumber = ContractSubVersionNumber,
                    ContractAllocationNumber = "1A",
                    DeliverableCode = 2,
                    FundingStreamPeriodCode = ValidFundingStreamPeriodCode,
                    OrganisationId = "ABC",
                    Period = "201705",
                    Ukprn = "ABC01"
                }
            };

            _mockStore.Setup(s =>
                s.GetActiveAllocationDeliverablePeriods(
                    ValidOrganisationId,
                    ValidFundingStreamPeriodCode,
                    null,
                    It.IsAny<ConnectionInfo>()))
                .Returns(allocationDeliverablePeriods
                    .Where(m => m.FundingStreamPeriodCode == ValidFundingStreamPeriodCode && m.Ukprn == Ukprn)
                    .ToList());

            _mockStore.Setup(s =>
                s.GetActiveAllocationDeliverablePeriods(
                    "ABC",
                    ValidFundingStreamPeriodCode,
                    null,
                    It.IsAny<ConnectionInfo>()))
                .Returns(allocationDeliverablePeriods
                    .Where(m => m.FundingStreamPeriodCode == ValidFundingStreamPeriodCode && m.Ukprn == "ABC01")
                    .ToList());

            _mockStore.Setup(s =>
                s.GetActiveAllocationDeliverablePeriods(
                    InvalidOrganisationId,
                    It.IsAny<string>(),
                    It.IsAny<string>(),
                    It.IsAny<ConnectionInfo>()))
                .Returns(new List<AllocationDeliverablePeriod>());
        }

        [TestMethod]
        public void Enrich_WhenValidData_ShouldReturnEnrichedResults()
        {
            var actuals = new List<ReportedActual>
            {
                new ReportedActual
                {
                    OrganisationId = ValidOrganisationId,
                    FundingStreamPeriodCode = ValidFundingStreamPeriodCode,
                    DeliverableCode = "1",
                    Period = "201705"
                },
                new ReportedActual
                {
                    OrganisationId = ValidOrganisationId,
                    FundingStreamPeriodCode = ValidFundingStreamPeriodCode,
                    DeliverableCode = "2",
                    Period = "201705"
                }
            };

            var enricher = new ReportedPaymentEnricher(_mapper)
            {
                DeliverableStore = _mockStore.Object
            };

            var connection = new Mock<ConnectionInfo>(null, Mock.Of<IDbConnection>());

            var result = enricher.Enrich(connection.Object, actuals);

            Assert.AreEqual(2, result.Count);
            Assert.IsTrue(result.All(e => e.Ukprn == Ukprn));
            Assert.IsTrue(result.All(e => e.ContractNumber == ContractNumber));
        }

        [TestMethod]
        public void Enrich_WhenNoAllocations_ShouldReturnEmpty()
        {
            var storeMock = new Mock<IMonitoringDeliverableStore>();

            storeMock.Setup(m =>
                m.GetActiveAllocationDeliverablePeriods(
                    It.IsAny<string>(),
                    It.IsAny<string>(),
                    It.IsAny<string>(),
                    It.IsAny<ConnectionInfo>()))
                .Returns(new List<AllocationDeliverablePeriod>());

            var enricher = new ReportedPaymentEnricher(_mapper)
            {
                DeliverableStore = storeMock.Object
            };

            var actuals = new List<ReportedActual>
            {
                new ReportedActual
                {
                    OrganisationId = ValidOrganisationId,
                    FundingStreamPeriodCode = ValidFundingStreamPeriodCode,
                    DeliverableCode = "1",
                    Period = "201705"
                }
            };

            var connection = new Mock<ConnectionInfo>(null, Mock.Of<IDbConnection>());

            var result = enricher.Enrich(connection.Object, actuals);

            Assert.IsFalse(result.Any());
        }
    }
}
