namespace SFA.FCT.Contracts.AcceptanceTests.Steps
{
    using System.Collections.Generic;
    using System.Linq;
    using NUnit.Core;
    using TechTalk.SpecFlow;
    using System.IO;
    using AllocationDeliveryDomain.Common.DataStore.Model;
    using Extensions;
    using global::AllocationDelivery.Messages.Commands;
    using Infrastructure.Repositories;
    using Infrastructure.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Pages;
    using Pages.DTO;
    using Utilities;

    [Binding]
    public class RetrieveSummarisedActualsSteps
    {
        private readonly RetrieveSummarisedActualsPageObject _pageObject;
        public StreamWriter file;

        public RetrieveSummarisedActualsSteps(RetrieveSummarisedActualsPageObject pageObject)
        {
            _pageObject = pageObject;
        }

        [Given(@"the following closed collections are available in DCFS")]
        [Then(@"the following closed collections are available in DCFS")]               // really a given, but used as a then. better way??
        public void GivenTheFollowingClosedCollectionsAreAvailableInDcfs(TransformedTable table)
        {
            var reportedActuals = table.Rows
                .Select(r => new ReportedActual
                {
                    CollectionReturnCode = r["CollectionReturnCode"],
                    OrganisationId = r["OrganisationId"],
                    PeriodTypeCode = r["PeriodTypeCode"],
                    Period = r["Period"],
                    FundingStreamPeriodCode = r["FundingStreamPeriodCode"],
                    CollectionType = r["CollectionType"],
                    ContractAllocationNumber = r["ContractAllocationNumber"],
                    UoPCode = r.ParseStringIfPresentElseEmpty("UoPCode"),
                    DeliverableCode = r["DeliverableCode"],
                    ActualVolume = long.Parse(r["ActualVolume"]),
                    ActualValue = ParseDoubleValue(r["ActualValue"])
                });

            _pageObject.StoreClosedCollectionActuals(reportedActuals);
        }

        [Given(@"there is a closed collection with no data for CollectionType '(.*)' and CollectionReturnCode '(.*)'")]
        public void GivenThereIsAClosedCollectionWithNoDataForCollectionTypeAndCollectionReturnCode(string collectionType, string collectionReturnCode)
        {
            _pageObject.AddEmptyClosedCollectionToStubStorage(collectionType, collectionReturnCode);
        }

        [When(@"the FCT system polls the SLD service")]
        public void WhenTheFctSystemPollsTheSldService()
        {
            MessageSendingBus.Send("AllocationDeliveryDomain.ActualsPull", new BeginDcActualsPullCommand());
        }

        [Then(@"the following Actuals are stored in FCT for processing")]
        public void ThenTheFollowingActualsAreStoredInFctForProcessing(Table table)
        {
            _pageObject.WaitTillReportedActualTablePopulated();

            IEnumerable<SummarisedActual> testReportedActuals = table.Rows
                .Select(r => new SummarisedActual
                {
                    OrganisationId = r["OrganisationId"],
                    Period = r.ParseInt("Period"),
                    FundingStreamPeriodCode = r["FundingStreamPeriodCode"],
                    ContractAllocationNumber = r["ContractAllocationNumber"],
                    UopCode = r["UoPCode"],
                    DeliverableCode = r.ParseInt("DeliverableCode"),
                    ActualVolume = r.ParseNullableInt("ActualVolume"),
                    ActualValue = r.ParseDecimal("ActualValue")
                });

            var missingRows = testReportedActuals.Where(expected =>
            {
                var matched = _pageObject.SummarisedActuals.SingleOrDefault(actual =>

                    actual.OrganisationId == expected.OrganisationId &&
                    actual.Period == expected.Period &&
                    actual.FundingStreamPeriodCode == expected.FundingStreamPeriodCode &&
                    (actual.ContractAllocationNumber ?? string.Empty) == expected.ContractAllocationNumber &&
                    (actual.UopCode ?? string.Empty) == expected.UopCode &&
                    actual.DeliverableCode == expected.DeliverableCode &&
                    actual.ActualVolume == expected.ActualVolume &&
                    actual.ActualValue == expected.ActualValue
                );

                return matched == null;
            });

            // assert both that the results are correct, and also that no other results were stored at the client
            var firstMissing = missingRows.FirstOrDefault();
            Assert.IsFalse(missingRows.Any(), $"Some actuals are missing, deliverableCode: {firstMissing?.DeliverableCode}, actualValue: {firstMissing?.ActualValue}");
        }

        [Given(@"there are no entries in the DCFS stub table")]
        public void GivenThereAreNoEntriesInTheDcfsStubTable()
        {
            _pageObject.RemoveAllRowsFromDcfsStubTable();
        }

        [Given(@"there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS")]
        [Given(@"there are no entries in the summarised actuals PaaS table")]
        [Then(@"there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS")]
        public void GivenThereAreNoEntriesInTheSummarisedActualsPaaSTable()
        {
            SummarisedActualRepository.RemoveAll();
            ClosedCollectionRepository.RemoveAll();
        }

        [Given(@"the collections data in '(.*)' is added to the stub")]
        public void GivenTheCollectionsDataInIsAddedToTheStub(string filePath)
        {
            _pageObject.StoreClosedCollectionActualsFromFile(filePath);
        }

        private static double? ParseDoubleValue(string doubleValueStr)
        {
            double? value = null;
            if (doubleValueStr != "?")
            {
                value = double.Parse(doubleValueStr);
            }

            return value;
        }
    }
}
