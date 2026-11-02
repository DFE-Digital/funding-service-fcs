namespace Datafix.Tests
{
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using NServiceBus;
    using OrganisationDomain.Implementation.Mappers;
    using OrganisationDomain.Integration.DataStore;
    using OrganisationDomain.Integration.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Events;
    using MoreLinq;
    using OrganisationDomain.Integration.Messages.Commands;

    [TestClass]
    public class OrganisationServiceUpdateProviderStatusFix
    {
        [TestMethod, TestCategory("DataFix_R59")]
        public void UpdateProviderStatusToLockedRestructure()
        {
            int[] ukprnsToHaveStatusChanged = { 10001207, 10001458, 10001549, 10001744, 10002907, 10002918, 10002929,
                                                10004339, 10004969, 10005410, 10005991, 10005997, 10006348, 10006379 };

            using (OrganisationDomainDbContext context = new OrganisationDomainDbContext())
            {
                IReadOnlyCollection<Organisation> orgs = context.Organisations
                                                                .Where(o => ukprnsToHaveStatusChanged.Contains(o.Ukprn) 
                                                                            && o.Status == "Locked Restructure").ToList();

                Assert.AreEqual(14, orgs.Count, "Unexpected number of organisations returned with status 'Locked Restructure'");

                CpdsMapper mapper = new CpdsMapper();
                var bus = CreateBus();

                orgs.ForEach(org => PublishOrgDetailsChangedAndSendNotification(org, mapper, bus));
            }
        }

        private static void PublishOrgDetailsChangedAndSendNotification(Organisation organisation, ICpdsMapper mapper, ISendOnlyBus bus)
        {
            bus.Publish<OrganisationDetailsChanged>(e =>
            {
                e.ChangedOrganisation = mapper.MapDbEntityToCorpSchema(organisation);
            });

            var notification = $"Status has been updated to {organisation.Status} for provider {organisation.Ukprn} ({organisation.TradingName})";
            bus.Send("OrgService.XrmEndpoint", new CreateProviderUpdatedNotificationCommand
            {
                Notification = notification,
                Ukprn = organisation.Ukprn
            });
        }

        private static ISendOnlyBus CreateBus()
        {
            BusConfiguration configuration = new BusConfiguration();
            configuration.EndpointName("OrgService.Main");
            configuration.UseSerialization<JsonSerializer>();
            configuration.UseTransport<AzureServiceBusTransport>();
            configuration.Conventions().DefiningEventsAs(t => t == typeof(OrganisationDetailsChanged));
            configuration.Conventions().DefiningMessagesAs(t => t == typeof(CreateProviderUpdatedNotificationCommand));

            return Bus.CreateSendOnly(configuration);
        }
    }
}