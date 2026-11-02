namespace Datafix.Tests
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using NServiceBus;
    using OrganisationDomain.Integration.DataStore;
    using OrganisationDomain.Integration.Messages.Commands;
    using SFA.FCT.CrossDomain.Integration.Common;

    [TestClass]
    public class TriggerOrgPopulationServiceWithoutNotificationsFix
    {
        [TestMethod, TestCategory("DataFix_R37"), TestCategory("DataFix_R58"), 
         TestCategory("DataFix_R59b")]
        public void ShouldResetUkrlpSuccessFlagAndTriggerOrgSupplementaryDataPopulationServiceWithoutCreatingCrmNotifications()
        {
            // arrange
            BusConfiguration configuration = new BusConfiguration();
            configuration.Conventions().DefiningCommandsAs(t => t == typeof(InitiateOrgSupplementaryDataPopulationCommand));
            configuration.UseSerialization<JsonSerializer>();
            configuration.UseTransport<AzureServiceBusTransport>();
            configuration.EnableInstallers();

            // set all Organisations to require UKRLP population
            using (OrganisationDomainDbContext context = new OrganisationDomainDbContext())
            {
                context.Database.ExecuteSqlCommand("UPDATE dbo.Organisations SET HasUkrlpBeenCalledSuccessfully = 0");
            }

            // send population command with notifications suppressed
            using (ISendOnlyBus bus = Bus.CreateSendOnly(configuration))
            {
                bus.Send(FctEndpoint.GenerateEndpointName("OrgService.Main"), new InitiateOrgSupplementaryDataPopulationCommand
                {
                    ShouldIssueCrmNotifications = false
                });
            }
        }
    }
}
