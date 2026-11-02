namespace SFA.FCT.Contracts.AcceptanceTests.Features.Tooling
{
    using System.Configuration;
    using System.Data.SqlClient;
    using AllocationDeliveryDomain.Common.Commands;
    using ContractRequestDomain.Common.Commands;
    using Dapper;
    using Extensions;
    using FCT.Xrm.TestFramework;
    using global::AllocationDelivery.Messages.Commands;
    using Infrastructure.Repositories;
    using Infrastructure.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using MoreLinq;
    using TechTalk.SpecFlow;
    using Utilities;
    using ContractManagement.DataStore;

    [Binding]
    public class ToolingSteps
    {
        [Given(@"feature variable '(.*)' is set to '(.*)'")]
        public void GivenFeatureVariableIsSetTo(string variableName, string value)
        {
            FeatureVariables.Set(variableName, value);
        }

        [Then(@"parameter '(.*)' is equal to parameter '(.*)'")]
        public void ThenParameterIsEqualToParameter(string expected, TransformedString actual)
        {
            Assert.AreEqual(expected, actual.Value);
        }

        [Then(@"the following table of values are equal")]
        public void ThenTheFollowingTableOfValuesAreEqual(TransformedTable table)
        {
            table.Rows.ForEach(row => Assert.AreEqual(row["Expected"], row["Actual"]));
        }

        [Then(@"we can connect to CRM as '(.*)'")]
        public void ThenWeCanConnectToCrmAs(string username)
        {
            XrmPackageEntity systemUserXrmPackageEntity = XrmService.Configuration.Entity("systemuser");

            XrmWebConnection xrmWebConnection = XrmService.ConnectAsUser(username);
            Assert.IsNotNull(xrmWebConnection);

            XrmWebEntity user = xrmWebConnection.GetUser(systemUserXrmPackageEntity, username);
            Assert.IsNotNull(user);
        }

        [When(@"month-end processing is started")]
        public void WhenMonthEndProcessingIsStarted()
        {
            MonthEndHistoryRepository.StartMonthEnd();
            MessageSendingBus.Send("AllocationDeliveryDomain.MonthEndCheck", new CheckForMonthEndCompletionCommand());
        }

        [When(@"staged actuals collection type '(.*)' with return code '(.*)' is processed")]
        public void WhenStagedActualsCollectionTypeWithReturnCodeIsProcessed(string collectionType, string collectionReturnCode)
        {
            ScenarioContext.Current.Pending();
        }

        [Given(@"DAS events are created for the following UKPRNs")]
        public void GivenNewDasEventsAreCreatedForTheFollowingUkprNs(Table table)
        {
            table.Rows.ForEach(row =>
            {
                int eventId = GetLowestDasEventId() - 1;

                InsertDasEvent(row.ParseInt("UKPRN"), eventId);
            });
        }

        [Given(@"processing of provider not found DAS events is triggered")]
        [When(@"processing of provider not found DAS events is triggered")]
        public void WhenProcessingOfProviderNotFoundDasEventsIsTriggered()
        {
            MessageSendingBus.Send("ContractRequestDomain.EngagementWatcher", new RetryNotFoundProviderEngagementsCommand());
        }

        private static int GetLowestDasEventId()
        {
            using (var connection = new ContractManagementDbContext())
            {
                return connection.Database.Connection.ExecuteScalar<int>("dbo.sp_ToolingStepsGetLowestDasEventId");

            }
        }

        private static void InsertDasEvent(int ukprn, int eventId)
        {
            using (var connection = new ContractManagementDbContext())
            {
                connection.Database.Connection.ExecuteScalar<int>("dbo.sp_InsertDasEvent @eventId,@ukprn", new { eventId, ukprn });
            }
        }
    }
}
