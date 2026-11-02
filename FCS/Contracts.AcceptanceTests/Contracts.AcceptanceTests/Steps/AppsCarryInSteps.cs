namespace SFA.FCT.Contracts.AcceptanceTests.Steps
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.AllocationDeliveryDomain.Common.Commands;
    using SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories;
    using SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Services;
    using SFA.FCT.Contracts.AcceptanceTests.Utilities;
    using TechTalk.SpecFlow;

    [Binding]
    public class AppsCarryInSteps
    {
        [Given(@"there are no rows on HeldReportedActualGroup for OrgId '(.*)'")]
        public void GivenThereAreNoEntriesOnHeldReportedActualGroupForOrgId(string orgId)
        {
            HeldReportedActualGroupRepository.RemoveRowsForOrgId(orgId);
        }

        [Then(@"there is '(.*)' row on table HeldReportedActualGroup for FSP '(.*)' OrgId '(.*)' and Collection '(.*)' marked as processed")]
        [Then(@"there are '(.*)' rows on table HeldReportedActualGroup for FSP '(.*)' OrgId '(.*)' and Collection '(.*)' marked as processed")]
        public void ThenThereAreRowsOnHeldReportedActualGroupForFspOrgIdAndCollectionMarkedAsProcessed(int expectedCount, string fundingStreamPeriod, string orgId, string collectionReturnCode)
        {
            int numberOfProcessed = 0;
            CheckResultPoller checkResultPoller = new CheckResultPoller(checkResult: () =>
                {

                    numberOfProcessed = HeldReportedActualGroupRepository.GetCountOfProcessedRows(orgId, fundingStreamPeriod, collectionReturnCode);
                    return numberOfProcessed == expectedCount;
                },
                maxNumChecks: 20,
                waitIntervalSeconds: 3);

            checkResultPoller.CheckResultAndWaitTillCompleteOrOutOfTime();

            Assert.AreEqual(expectedCount, numberOfProcessed, $"We have not got the correct number of processed held rows for {fundingStreamPeriod}, {orgId}, {collectionReturnCode}");
        }

        [Then(@"there is '(.*)' row on table HeldReportedActualGroup for FSP '(.*)' OrgId '(.*)' and Collection '(.*)' marked as unprocessed")]
        [Then(@"there are '(.*)' rows on table HeldReportedActualGroup for FSP '(.*)' OrgId '(.*)' and Collection '(.*)' marked as unprocessed")]
        public void ThenThereAreRowsOnHeldReportedActualGroupForFspOrgIdAndCollectionMarkedAsUnprocessed(int expectedCount, string fundingStreamPeriod, string orgId, string collectionReturnCode)
        {
            int numberOfUnprocessed = 0;
            CheckResultPoller checkResultPoller = new CheckResultPoller(checkResult: () =>
                {

                    numberOfUnprocessed = HeldReportedActualGroupRepository.GetCountOfUnprocessedRows(orgId,
                        fundingStreamPeriod,
                        collectionReturnCode);
                    return numberOfUnprocessed == expectedCount;
                },
                maxNumChecks: 20,
                waitIntervalSeconds: 3);

            checkResultPoller.CheckResultAndWaitTillCompleteOrOutOfTime();

            Assert.AreEqual(expectedCount, numberOfUnprocessed,  $"We have not got the correct number of unprocessed held rows for {fundingStreamPeriod}, {orgId}, {collectionReturnCode}");
        }

        [When(@"MonthEnd processing has completed and the processing of held data is triggered")]
        public void WhenMonthEndProcessingHasCompletedAndTheProcessingOfHeldDataIsTriggered()
        {
            MonthEndHistoryRepository.StopMonthEnd();

            MessageSendingBus.Send("AllocationDeliveryDomain.ReleaseHeldReportedActuals", new ReleaseHeldReportedActualsCommand());
        }

        [Given(@"there is no data on MonitoringDeliverables\.AllocationDeliverablePeriodActualAudit for UKPRN '(.*)'")]
        public void GivenThereIsNoDataOnMonitoringDeliverables_AllocationDeliverablePeriodActualAuditForUKPRN(int ukprn)
        {
            AllocationDeliverablePeriodActualAuditRepository.DeleteAllocationDeliverablePeriodActualAudits(ukprn);
        }
    }
}
