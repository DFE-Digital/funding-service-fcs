namespace Datafix.Tests
{
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using NServiceBus;
    using OrganisationDomain.Implementation.Mappers;
    using OrganisationDomain.Integration.DataStore;
    using OrganisationDomain.Integration.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Events;

    [TestClass]
    public class OrganisationServiceUpdateProviderNameFix
    {
        [TestMethod, TestCategory("DataFix_R49a")]
        public void RenameLearnDirectToDimensionsTrainingSolutions()
        {
            const int ukprn = 10003816;
            const string newProviderName = "DIMENSIONS TRAINING SOLUTIONS LIMITED";

            using (OrganisationDomainDbContext context = new OrganisationDomainDbContext())
            {
                Organisation provider = context.Organisations.Single(o => o.Ukprn == ukprn);
                provider.TradingName = newProviderName;
                context.SaveChanges();

                CreateBus().Publish<OrganisationDetailsChanged>(e =>
                {
                    CpdsMapper mapper = new CpdsMapper();
                    e.ChangedOrganisation = mapper.MapDbEntityToCorpSchema(provider);
                });
            }
        }

        private static ISendOnlyBus CreateBus()
        {
            BusConfiguration configuration = new BusConfiguration();
            configuration.EndpointName("OrgService.Main");
            configuration.UseSerialization<JsonSerializer>();
            configuration.UseTransport<AzureServiceBusTransport>();
            configuration.Conventions().DefiningEventsAs(t => t == typeof(OrganisationDetailsChanged));

            return Bus.CreateSendOnly(configuration);
        }
    }
}
