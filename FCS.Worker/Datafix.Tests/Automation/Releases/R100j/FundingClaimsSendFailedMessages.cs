namespace Datafix.Tests.Automation.Releases.R100j
{
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data.SqlClient;
    using System.IO;
    using System.Linq;
    using System.Reflection;
    using System.Threading.Tasks;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using NServiceBus;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Newtonsoft.Json;
    using Newtonsoft.Json.Linq;
    using NServiceBus.Testing;
    using PerformanceManagementDomain.ReconciliationCalculationEndpoint;
    using PerformanceManagementDomain.ReconciliationCalculationEndpoint.DTOs;
    using PerformanceManagementDomain.ReconciliationCalculationEndpoint.Extensions;
    using PerformanceManagementDomain.ReconciliationCalculationEndpoint.Handlers;
    using PerformanceManagementDomain.ReconciliationCalculationEndpoint.Repositories;
    using Services;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaim;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore;
    using SFA.FCT.PerformanceManagementDomain.DataStore;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;

    public class FundingClaimsSendFailedMessages : IApplyDataFix
    {
        public string Release => "R100j";

        public int StoryNumber => 34170;

        public string Name => "Funding Claims Deliverable Code 5 missing issue (34170)";

        public int Order => 1;

        public void ApplyDataFix()
        {
            const string fspCode = "AEBC-ASCL2021";
            const int deliverableCode = 5;

            var fundingClaimDebatchedEvents = GetFundingClaimDebatchedEvents("Datafix.Tests", "Resources.R100j.FundingClaimDebatchedEvents.json");
            Assert.AreEqual(91, fundingClaimDebatchedEvents.Count);

            var rows = Datafix.Tests.Repositories.FspDeliverableClaimRepository.GetAllRowsInDb();
            var claimReconciliationDeliverableGroupRows = Datafix.Tests.Repositories.FspDeliverableClaimRepository
                .GetAllClaimReconciliationDeliverableGroupRowsInDb();

            var rowsToRemove = rows.Where(r => r.FspCode == fspCode && r.DeliverableCode == deliverableCode).ToList();

            rows = rows.Where(r => !rowsToRemove.Any(rowToRemove => rowToRemove.FspCode == r.FspCode && rowToRemove.DeliverableCode == r.DeliverableCode))
                .ToList();

            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<IPerformanceManagementDbContext>().ImplementedBy<PerformanceManagementDbContext>().LifestyleScoped().IsDefault())
                .Register(Component.For<IPaymentManagementPolicyContext>().ImplementedBy<PaymentManagementPolicyContext>().LifestyleScoped().IsDefault())
                .Register(Component.For<IFspDeliverableClaimRepository>().Instance(new MockedFspDeliverableClaimRepository(rows, claimReconciliationDeliverableGroupRows)).IsDefault())
                .Register(Component.For<PerformanceManagementDomain.Infrastructure.ISessionConnectionFactory>().Instance(new MockSessionConnectionFactory()).IsDefault())
                .Register(Component.For<FundingClaimDebatchedEventHandler>().LifestyleScoped());

            container.BeginScope();

            var handler = container.Resolve<FundingClaimDebatchedEventHandler>();
            TestableMessageHandlerContext testableContext = new TestableMessageHandlerContext();
            fundingClaimDebatchedEvents
                .ToList()
                .ForEach(e =>
                {
                    handler.Handle(e, testableContext).Wait();
                });

            var endpoint = EndpointBuilder.CreateSendOnlyEndpoint<ProposedReconciliationCalculatedEvent>();
            string endpointToSendTo = "PerformanceManagementDomain.XrmEndpoint";
            var eventsToSend = testableContext
                .PublishedMessages
                .Select(m => m.Message).Cast<ProposedReconciliationCalculatedEvent>();
            eventsToSend.ToList()
                .ForEach(m =>
                {
                    endpoint.Send(destination: endpointToSendTo, m).Wait();
                });
        }


        private static IReadOnlyCollection<FundingClaimDebatchedEvent> GetFundingClaimDebatchedEvents(string nameSpace, string resourceName)
        {
            using (var stream = Assembly.GetCallingAssembly().GetManifestResourceStream($"{nameSpace}.{resourceName}"))
            using (var streamReader = new StreamReader(stream))
            {
                var text = streamReader.ReadToEnd();
                List<FundingClaimDebatchedEvent> fundingClaimDebatchedEvents = new List<FundingClaimDebatchedEvent>();
                var array = JArray.Parse(text);
                foreach (var item in array)
                {
                    var messageBody = item["body"].ToString();
                    var fundingClaimDebatchedEvent = JsonConvert.DeserializeObject<FundingClaimDebatchedEvent>(messageBody);
                    fundingClaimDebatchedEvents.Add(fundingClaimDebatchedEvent);
                }

                return fundingClaimDebatchedEvents;
            }
        }

        private class MockedFspDeliverableClaimRepository : IFspDeliverableClaimRepository
        {
            private readonly IReadOnlyCollection<FspDeliverableClaim> _fspDeliverableClaims = null;

            private readonly IReadOnlyCollection<ClaimReconciliationDeliverableGroup>
                _claimReconciliationDeliverableGroups;
            public MockedFspDeliverableClaimRepository(IReadOnlyCollection<FspDeliverableClaim> rows,
                IReadOnlyCollection<ClaimReconciliationDeliverableGroup> claimReconciliationDeliverableGroups)
            {
                _fspDeliverableClaims = rows;
                _claimReconciliationDeliverableGroups = claimReconciliationDeliverableGroups;
            }

            public Task<IReadOnlyCollection<FspDeliverableClaim>> GetFspDeliverablesIncludingClaimDeliverableGroup(string fundingStreamPeriodCode, ConnectionInfo connectionInfo)
            {
                var fspDeliverables = _fspDeliverableClaims.Where(fsp => fsp.FspCode == fundingStreamPeriodCode
                                      && fsp.ClaimReconciliationDeliverableGroupCode != null).ToList();

                fspDeliverables.ForEach(d => d.ClaimReconciliationDeliverableGroup = _claimReconciliationDeliverableGroups.SingleOrDefault(c => c.ClaimReconciliationDeliverableGroupCode == d.ClaimReconciliationDeliverableGroupCode));

                return Task.FromResult((IReadOnlyCollection<FspDeliverableClaim>) fspDeliverables);
            }

            public Task<string> GetDeliverableName(int deliverableCode, string fundingStreamPeriodCode, ConnectionInfo connectionInfo)
            {
                return Task.FromResult(_fspDeliverableClaims.Single(fsp => fsp.FspCode == fundingStreamPeriodCode &&
                                                                           fsp.DeliverableCode == deliverableCode).DeliverableName);
            }

            public Task<IReadOnlyCollection<DeliverableCodeInfo>> GetDeliverableCodeInfos(string fundingStreamPeriodCode, ConnectionInfo connectionInfo)
            {
                return Task.FromResult(_fspDeliverableClaims.Where(fsp => fsp.FspCode == fundingStreamPeriodCode)
                    .Select(fsp => new DeliverableCodeInfo(fsp.DeliverableCode, fsp.ParentDeliverableCode, fsp.ClaimReconciliationDeliverableGroupCode, fsp.AllowProfile))
                    .ToList() as IReadOnlyCollection<DeliverableCodeInfo>);
            }

            public decimal GetSumOfParentDeliverablesPlannedValueForGroup(IReadOnlyCollection<DeliverableLine> deliverableLines,
                IReadOnlyCollection<DeliverableCodeInfo> deliverableCodeInfos)
            {
                return deliverableLines.GetSumOfParentDeliverablesPlannedValueForGroup(deliverableCodeInfos);
            }

            public Task<IReadOnlyCollection<int>> GetProfileDeliverableCodes(string fundingStreamPeriodCode, ConnectionInfo connectionInfo)
            {
                return Task.FromResult(_fspDeliverableClaims.Where(fsp => fsp.FspCode == fundingStreamPeriodCode && fsp.AllowProfile)
                    .Select(fsp => fsp.DeliverableCode)
                    .ToList() as IReadOnlyCollection<int>);
            }
        }

        private class MockSessionConnectionFactory : PerformanceManagementDomain.Infrastructure.ISessionConnectionFactory
        {
            public ConnectionInfo GetConnection(IMessageHandlerContext context)
            {
                string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

                return new ConnectionInfo(null, new SqlConnection(connectionString));
            }
        }
    }
}
