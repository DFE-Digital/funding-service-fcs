namespace Datafix.Tests
{
    using Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using NServiceBus;
    using OrganisationDomain.Integration.Messages.Commands;
    using System.Configuration;
    using System.Data.SqlClient;
    using Automation;
    using Dapper;

    [TestClass]
    public class TriggerOrgPopulationServiceWithoutNotificationsFix //: IApplyDataFix
    {
        public string Release => "R67";
        public int StoryNumber => 26974;
        public string Name => "Reset Ukrlp data in the organisation database and CRM";
        public int Order => 1;
        public void ApplyDataFix()
        {
            ShouldResetUkrlpSuccessFlagAndTriggerOrgSupplementaryDataPopulationServiceWithoutCreatingCrmNotifications();
        }

        [TestMethod, TestCategory("DataFix_R67")]
        public void ShouldResetUkrlpSuccessFlagAndTriggerOrgSupplementaryDataPopulationServiceWithoutCreatingCrmNotifications()
        {
            // arrange
            var endpoint = EndpointBuilder.CreateSendOnlyEndpoint<InitiateOrgSupplementaryDataPopulationCommand>();

            // set all Organisations to require UKRLP population
            string connectionString = ConfigurationManager.ConnectionStrings["organisationDomainDatabase"].ConnectionString;
            using (var connection = new SqlConnection(connectionString))
            {
                const string sql = @"UPDATE dbo.Organisations SET HasUkrlpBeenCalledSuccessfully = 0";

                connection.Execute(sql);
            }

            var command = new InitiateOrgSupplementaryDataPopulationCommand
            {
                ShouldIssueCrmNotifications = false
            };
            
            // act
            endpoint.Send("OrgService.Main", command).Wait();
        }
    }
}