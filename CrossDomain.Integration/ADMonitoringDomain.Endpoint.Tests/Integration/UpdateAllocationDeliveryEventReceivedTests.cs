namespace ADMonitoringDomain.Endpoint.Tests.Integration
{
    extern alias Entities;
    using System.Data.Entity;
    using System.Linq;
    using BusinessLogic;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Repositories;
    using DataStore;
    using DataStore.Model;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using PaymentGenerationDomain.BusinessLogic;
    using PaymentGenerationDomain.Integration.DataStore;
    using SFA.FCT.AllocationDelivery.DataStore;
    using SFA.FCT.AllocationDelivery.DataStore.Model;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
    using SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.CrossDomain.Integration.Common.SchemaValidator;
    using SFA.FCT.CrossDomain.Integration.Common.Serializers;
    using Entities::SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentAggregation;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore;
    using SFA.FCT.Framework.Logging.NullObjects;
    using PaymentGenerationDomain.Integration.DataStore.Repositories;
    using ADMonitoringDomain.Endpoint.Repositories;
    using Entities::SFA.FCT.CrossDomain.Integration.Entities.Data;

    [TestClass]
    public class UpdateAllocationDeliveryEventReceivedTests
    {
        private const string ConnectionString =
            "";

        private PaymentGenerationDbContext _paymentGenerationDbContext;
        private AllocationDeliveryMonitoringDbContext _allocationDeliveryMonitoringDbContext;
        private PaymentSchedulePolicyContext _paymentSchedulePolicyContext;
        private MonitoringDeliverablesDbContext _monitoringDeliverablesDbContext;
        private AllocationDeliveryDbContext _allocationDeliveryDbContext;
        private ContractManagementDbContext _contractManagementDbContext;

        [TestInitialize]
        public void TestInitialize()
        {
            _paymentGenerationDbContext = CreateContextWithConnectionString<PaymentGenerationDbContext>();
            _allocationDeliveryMonitoringDbContext = CreateContextWithConnectionString<AllocationDeliveryMonitoringDbContext>();
            _paymentSchedulePolicyContext = CreateContextWithConnectionString<PaymentSchedulePolicyContext>();
            _monitoringDeliverablesDbContext = CreateContextWithConnectionString<MonitoringDeliverablesDbContext>();
            _allocationDeliveryDbContext = CreateContextWithConnectionString<AllocationDeliveryDbContext>();
            _paymentGenerationDbContext = CreateContextWithConnectionString<PaymentGenerationDbContext>();
            _contractManagementDbContext = CreateContextWithConnectionString<ContractManagementDbContext>();
        }

        private static TContext CreateContextWithConnectionString<TContext>() where TContext : DbContext, new()
        {
            TContext context = new TContext();
            context.Database.Connection.ConnectionString = ConnectionString;
            return context;
        }

        [TestMethod, TestCategory("DataFix_R17a")]
        public void AllocationDeliveryEventReceived_ShouldUpdatePaymentAggregatedEventsAndCreateAllocationDeliveryPerformanceFeedEvents()
        {
            // the correct data is in the [PaymentGeneration].[SubnominalAggregation] for allocations - ALLC-2146,  DLS-2636
            // unfortunately the data in the AllocationDeliveryEventReceived table for these 2 allocations for version 4 is incorrect
            // it is just the 201701 period that has changed

            string allocationNumber = "ALLC-2146";
            string period = "201701";
            string paymentType = "RECONCILIATION";
            string subnominalCode = "2303975";
            int versionNumber = 4;
            var aggregatedvalue = GetAggregatedValueFromSubnominalAggregation(allocationNumber, period, paymentType, subnominalCode);
            Assert.AreEqual(1981.10m, aggregatedvalue);
            UpdatePaymentAggregatedEvent(allocationNumber, versionNumber, aggregatedvalue, period, subnominalCode);
            CreateAmendedContractAllocationApprovedEvent(allocationNumber, versionNumber);

            allocationNumber = "DLS-2636";
            period = "201701";
            paymentType = "RECONCILIATION";
            subnominalCode = "2303075";
            versionNumber = 4;

            aggregatedvalue = GetAggregatedValueFromSubnominalAggregation(allocationNumber, period, paymentType, subnominalCode);
            Assert.AreEqual(33455.16m, aggregatedvalue);
            UpdatePaymentAggregatedEvent(allocationNumber, versionNumber, aggregatedvalue, period, subnominalCode);
            CreateAmendedContractAllocationApprovedEvent(allocationNumber, versionNumber);
        }

        private decimal GetAggregatedValueFromSubnominalAggregation(string allocationNumber, string period,
            string paymentType, string subnominalCode)
        {
            return
                _paymentGenerationDbContext.SubnominalAggregations.Find(allocationNumber, period, subnominalCode, paymentType)
                    .AggregatedValue;
        }

        private void UpdatePaymentAggregatedEvent(string allocationNumber, int version, decimal aggregatedValue, string period, string subnominalCode)
        {
            AllocationDeliveryEventReceived allocationDeliveryEventReceived =
                _allocationDeliveryMonitoringDbContext.AllocationDeliveryEventsReceived.Find(allocationNumber, version,
                    "AmendedContractAllocationApproved", "PaymentAggregatedEvent");
            PaymentAggregatedEvent paymentAggregatedEvent =
                allocationDeliveryEventReceived.SerializedXml.DeserializeXml<PaymentAggregatedEvent>();

            var aggregation = paymentAggregatedEvent.Allocation.AllocationPeriods.Single(ap => ap.Period == period)
                .Aggregations.Single(
                    agg =>
                        agg.SubnominalCode == subnominalCode &&
                        agg.PaymentType == AggregationPaymentType.RECONCILIATION);

            aggregation.AggregatedValue = aggregatedValue;

            allocationDeliveryEventReceived.SerializedXml = paymentAggregatedEvent.SerializeToXml();

            _allocationDeliveryMonitoringDbContext.SaveChanges();
        }


        private void CreateAmendedContractAllocationApprovedEvent(string allocationNumber, int versionNumber)
        {
            AtomGenerator atomGenerator = new AtomGenerator(
                new AtomItemCreator(
                    new DataAccessManager(new SubnominalAggregationRepository(), new LoggerNullObject()),
                    new ApprovedContractRepository(),
                    new AllocationDeliverablePeriodActualAuditRepository()))
            {
                SchemaValidator = new SchemaValidator()
            };

            atomGenerator.GenerateAtomFeed(allocationNumber, versionNumber, AllocationDeliveryEntryCategory.AmendedContractAllocationApproved, ConnectionInfo.CreateDefault());
        }
    }
}
