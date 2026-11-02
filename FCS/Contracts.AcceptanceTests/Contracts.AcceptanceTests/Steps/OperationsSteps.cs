namespace SFA.FCT.Contracts.AcceptanceTests.Steps
{
    using System;
    using Infrastructure.Repositories;
    using TechTalk.SpecFlow;

    [Binding]
    public class OperationsSteps
    {
        [Given(@"Clear down ProcessedMessage table in '(.*)' schema")]
        [When(@"Clear down ProcessedMessage table in '(.*)' schema")]
        [Then(@"Clear down ProcessedMessage table in '(.*)' schema")]
        public void WhenClearDownProcessedMessageTableOnSchema(string schemaName)
        {
            OperationsRepository.ClearProcessedMessageTable(schemaName);
        }

        [Given(@"Create '(.*)' records on ProcessedMessage table in '(.*)' schema that are '(.*)' days old")]
        [When(@"Create '(.*)' records on ProcessedMessage table in '(.*)' schema that are '(.*)' days old")]
        [Then(@"Create '(.*)' records on ProcessedMessage table in '(.*)' schema that are '(.*)' days old")]
        public void WhenCreateRecordsOnProcessedMessageTableInSchemaThatAreDaysOld(string numberOfRecords, string schemaName, string daysOld)
        {
            var createDateOfProcessedMessage = DateTime.UtcNow.Date.AddDays(-int.Parse(daysOld)).Date;

            OperationsRepository.CreateProcessedMessageRows(schemaName, int.Parse(numberOfRecords), createDateOfProcessedMessage);
        }
    }
}