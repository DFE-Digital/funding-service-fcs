namespace SFA.FCT.Contracts.AcceptanceTests.Steps
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.IO;
    using System.Linq;
    using System.ServiceModel.Syndication;
    using System.Xml;
    using System.Xml.Linq;
    using System.Xml.XPath;
    using AllocationDelivery.DataStore.Model;
    using CrossDomain.Integration.Common.Serializers;
    using CrossDomain.Integration.Entities;
    using Extensions;
    using Infrastructure.Repositories;
    using Infrastructure.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using MoreLinq;
    using TechTalk.SpecFlow;
    using Utilities;

    [Binding]
    public class AllocationDeliveryMonitoringSteps
    {
        [Then(@"the Allocation Delivery Monitoring Service atom feed contains the following Allocation Delivery Performance events and values")]
        public void ThenTheAllocationDeliveryMonitoringServiceAtomFeedContainsTheFollowingAllocationDeliveryPerformanceEventsAndValues(TransformedTable table)
        {
            PollableProxyCache<AllocationDeliveryEntry> proxyCache = new PollableProxyCache<AllocationDeliveryEntry>();

            table.Rows.ForEach(row =>
            {
                AllocationDeliveryPerformanceKey adpKey = row.CreateInstance<AllocationDeliveryPerformanceKey>();
                AllocationDeliveryEntry atomFeedItem = null;

                CheckResultPoller poller = new CheckResultPoller(() =>
                {
                    atomFeedItem = proxyCache.GetItemIfAvailable(
                        key: new { adpKey.AllocationDeliveryEntryCategory, adpKey.AllocationNumber, adpKey.VersionNumber },
                        getData: () => AllocationDeliveryEntryRepository.GetAllocationDeliveryEntries(adpKey.AllocationDeliveryEntryCategory, adpKey.AllocationNumber, adpKey.VersionNumber).SingleOrDefault());

                    return atomFeedItem != null;
                }, maxNumChecks: 15, waitIntervalSeconds: 4);

                poller.CheckResultAndWaitTillCompleteOrOutOfTime();

                Assert.IsNotNull(atomFeedItem, $"No matching atom feed item for AllocationDeliveryEntryCategory: { adpKey.AllocationDeliveryEntryCategory}, AllocationNumber: { adpKey.AllocationNumber}, VersionNumber: {adpKey.VersionNumber}");

                AllocationDeliveryPerformance allocationDeliveryPerformance = atomFeedItem.GetAllocationDeliveryPerformanceXml().DeserializeXml<AllocationDeliveryPerformance>();

                ScheduledPaymentTYPE scheduledPaymentType = allocationDeliveryPerformance.ScheduledPaymentPeriods
                    .SingleOrDefault(x => x.Period == adpKey.Period)?.ScheduledPayment
                    .SingleOrDefault(x => x.DeliverableCode == adpKey.DeliverableCode);

                Assert.IsNotNull(scheduledPaymentType, $"No matching Scheduled Payment in atom feed item for {adpKey}");

                AssertDecimalValueIfPresent(row, "ProfilePayment", scheduledPaymentType.ProfilePayment, adpKey.ToString());
                AssertDecimalValueIfPresent(row, "BalancingPayment", scheduledPaymentType.BalancingPayment, adpKey.ToString());
                AssertDecimalValueIfPresent(row, "ReconciliationPayment", scheduledPaymentType.ReconciliationPayment, adpKey.ToString());
                AssertDecimalValueIfPresent(row, "CappingPayment", scheduledPaymentType.CappingPayment, adpKey.ToString());
                AssertDecimalValueIfPresent(row, "NetPayment", scheduledPaymentType.NetPayment, adpKey.ToString());

                decimal? expectedActualValue = row.ParseNullableDecimal("ActualValue"); 

                ActualTYPE actualType = allocationDeliveryPerformance.ActualsPeriods.ActualsPeriod
                    .SingleOrDefault(ap => ap.Period == adpKey.Period)?.Actual
                    .SingleOrDefault(a => a.DeliverableCode == adpKey.DeliverableCode);

                Assert.AreEqual(expectedActualValue, actualType?.ActualValue, $"No matching Actual in atom feed item for {adpKey}");
            });

            void AssertDecimalValueIfPresent(TableRow row, string columnName, decimal? actualValue, string rowDescription)
            {
                if (row.ContainsKey(columnName))
                {
                    decimal? expectedValue = row.ParseNullableDecimal(columnName);
                    Assert.AreEqual(expectedValue, actualValue, $"{columnName} for {rowDescription}");
                }
            }
        }

        [Then(@"the Allocation Delivery Performance atom feed contains the following FCR Published events")]
        public void ThenTheAllocationDeliveryPerformanceAtomFeedContainsTheFollowingFcrPublishedEvents(TransformedTable table)
        {
            table.Rows.ForEach(row =>
            {
                // * The event type written to the ADP feed when we publish a payable FCR and recalculate payments is either NewContractAllocationApproved or
                // AmendedContractAllocationApproved depending on contract version number. We create 2 x events when this occurs, resulting in the allocation
                // having 3 x NewContractAllocationApproved/AmendedContractAllocationApproved events for the same version.
                // * This step ensures the latest event has both the correct scheduled payments and aggregated payments.
                // * We have a story on the backlog since 2016 to add a proper 'Payable FCR Published' event.
                AllocationDeliveryEntryCategory fcrPublishedCategory = row.ParseInt("VersionNumber") == 1 ?
                    AllocationDeliveryEntryCategory.NewContractAllocationApproved : AllocationDeliveryEntryCategory.AmendedContractAllocationApproved;

                bool HasMatchingScheduledPayment(AllocationDeliveryPerformance adp)
                {
                    ScheduledPaymentTYPE scheduledPayment = adp.ScheduledPaymentPeriods
                        .SingleOrDefault(spp => spp.Period == row["Period"])?.ScheduledPayment
                        .SingleOrDefault(sp => sp.DeliverableCode == row.ParseInt("DeliverableCode"));

                    if (scheduledPayment != null
                        && scheduledPayment.ProfilePayment == row.ParseDecimal("ProfilePayment")
                        && scheduledPayment.BalancingPayment == row.ParseDecimal("BalancingPayment")
                        && scheduledPayment.ReconciliationPayment == row.ParseDecimal("ReconciliationPayment")
                        && scheduledPayment.CappingPayment == row.ParseDecimal("CappingPayment")
                        && scheduledPayment.NetPayment == row.ParseDecimal("NetPayment"))
                    {
                        return true;
                    }

                    return false;
                }

                bool HasMatchingAggregatedPaymentPeriod(AllocationDeliveryPerformance adp)
                {
                    AggregatedPaymentTYPE aggregatedPayment = adp.AggregatedPaymentPeriods
                        .SingleOrDefault(app => app.Period == row["Period"])?.AggregatedPayment
                        .SingleOrDefault(ap =>
                            ap.PaymentTYPE == row.ParseEnum<PaymentTypeTYPE>("AggregatedPaymentType") && ap.SubnominalCode == row["SubnominalCode"]);

                    if (aggregatedPayment != null && aggregatedPayment.AggregatedValue == row.ParseDecimal("AggregatedValue"))
                    {
                        return true;
                    }

                    return false;
                }

                CheckResultPoller poller = new CheckResultPoller(() =>
                {
                    AllocationDeliveryEntry latestMatchingAtomFeedItem =
                        AllocationDeliveryEntryRepository.GetAllocationDeliveryEntries(fcrPublishedCategory, row["AllocationNumber"], row.ParseInt("VersionNumber"))
                            .OrderBy(ade => ade.ID)
                            .LastOrDefault();

                    if (latestMatchingAtomFeedItem != null)
                    {
                        AllocationDeliveryPerformance adpEvent =
                            latestMatchingAtomFeedItem.GetAllocationDeliveryPerformanceXml().DeserializeXml<AllocationDeliveryPerformance>();

                        if (HasMatchingScheduledPayment(adpEvent) && HasMatchingAggregatedPaymentPeriod(adpEvent))
                        {
                            return true;
                        }
                    }

                    return false;
                }, 30, 3);

                bool success = poller.CheckResultAndWaitTillCompleteOrOutOfTime();

                Assert.IsTrue(success, $"Could not find ADP atom feed entry for {row.ToHeaderAndValueString()}");
            });
        }

        [Given(@"the ADP feed includes the following values")]
        [Then(@"the ADP feed includes the following values")]
        public void ThenTheAdpFeedIncludesTheFollowingValues(TransformedTable table)
        {
            table.Rows.ForEach(row =>
            {
                int contractVersion = row.ParseNullableInt("ContractVersionNumber").Value;
                AllocationDeliveryEntryCategory itemType = (AllocationDeliveryEntryCategory) row.ParseNullableInt("ADCode").Value;
                string allocationNumber = row["AllocationNumber"];
                string deliveryOrgUkprn = row["DeliveryOrganisationUKPRN"] == "?" ? null : row["DeliveryOrganisationUKPRN"];
                string deliveryOrgProviderName = row["DeliveryOrganisationProvider"] == "?" ? null : row["DeliveryOrganisationProvider"];

                AllocationDeliveryEntry atomFeedItem = null;

                CheckResultPoller poller = new CheckResultPoller(() =>
                {
                    atomFeedItem = AllocationDeliveryEntryRepository.GetAllocationDeliveryEntries(itemType, allocationNumber, contractVersion).FirstOrDefault();
                    return atomFeedItem != null;
                }, maxNumChecks: 10, waitIntervalSeconds: 1);
                poller.CheckResultAndWaitTillCompleteOrOutOfTime();

                string feedItemsXml = atomFeedItem.GetAllocationDeliveryPerformanceXml();
                XDocument document = XDocument.Load(new StringReader(feedItemsXml));
                XmlNamespaceManager namespaceManager = new XmlNamespaceManager(new NameTable());
                XNamespace nameSpace = "urn:sfa:schemas:allocation-delivery-performance";
                namespaceManager.AddNamespace("ns", nameSpace.NamespaceName);
                XElement allocationOrganisationRelationshipsElement = document.XPathSelectElement("//ns:allocationOrganisationRelationships", namespaceManager);

                AllocationDeliveryPerformance allocationDeliveryPerformance = feedItemsXml.DeserializeXml<AllocationDeliveryPerformance>();

                if (deliveryOrgUkprn == null || deliveryOrgProviderName == null)
                {
                    Assert.IsNull(allocationOrganisationRelationshipsElement, $"Delivery org was populated when unexpected - {feedItemsXml}");
                }
                else
                {
                    Assert.IsNotNull(allocationOrganisationRelationshipsElement, $"The allocationOrganisationRelationships element has not been populated - {feedItemsXml}");
                    allocationOrganisationRelationshipsTYPE organisation = allocationDeliveryPerformance.allocationOrganisationRelationships;
                    Assert.IsNotNull(organisation, $"Delivery org was not populated when expected - {feedItemsXml}");
                    Assert.AreEqual(allocationNumber, organisation.contractAllocationNumber, $"Delivery org contractAllocationNumber was not populated correctly - {feedItemsXml}");
                    Assert.AreEqual(deliveryOrgUkprn, organisation.Organisation.alternativeOrganisationIdentifiers.AlternativeOrganisationIdentifier.OrganisationIdentifier, $"Delivery org ukprn was not populated when expected - {feedItemsXml}");
                }
            });
        }

        [Then(@"the Allocation Delivery feed includes the following event information")]
        public void ThenTheAllocationDeliveryFeedIncludesTheFollowingEventInformation(TransformedTable table)
        {
            const string urlSuffix = "/api/allocation-delivery/monitoring/notifications/all";

            table.Rows.ForEach(row =>
            {
                CheckResultPoller poller = new CheckResultPoller(checkResult: () =>
                {
                    IEnumerable<SyndicationItem> retrievedFeedItems = AtomFeedReader.EnumerateItems(
                        $"{ConfigurationManager.AppSettings["ContractManagementServiceUrl"]}{urlSuffix}",
                        AzureAuthenticator.GetAuthenticationConfig(),
                        "application/vnd.sfa.allocation-delivery.allocation-delivery-performance.v1+atom+xml");

                    return retrievedFeedItems.Any(feedItem =>
                    {
                        var allocationDeliveryPerformance = feedItem.GetContent<AllocationDeliveryPerformance>();

                        return
                            feedItem.Categories.Single().Name == row["CategoryTerm"] &&
                            feedItem.Categories.Single().Label == row["CategoryLabel"] &&
                            feedItem.Title.Text == row["Title"] &&
                            allocationDeliveryPerformance.Contract.contractNumber == row["ContractNumber"] &&
                            allocationDeliveryPerformance.Contract.contractVersionNumber == row.ParseInt("ContractVersion") &&
                            allocationDeliveryPerformance.Contract.contractSubVersionNumber == row.ParseInt("ContractSubVersion") &&
                            allocationDeliveryPerformance.Contractor.alternativeOrganisationIdentifiers.AlternativeOrganisationIdentifier.OrganisationIdentifier == row["UKPRN"];

                    });
                }, maxNumChecks: 10, waitIntervalSeconds: 3);

                bool foundExpectedItem = poller.CheckResultAndWaitTillCompleteOrOutOfTime();

                Assert.IsTrue(foundExpectedItem, $"Expected item not found on ALLOCATIONDELIVERYPERFORMANCE Atom Feed item for {row.ToHeaderAndValueString()}");
            });
        }

        [Then(@"the AllocationDelivery\.AllocationDeliveryEntry table does not contain an ItemType '(.*)' event for version '(.*)' of contract number '(.*)' and allocation number '(.*)'")]
        public void ThenTheAllocationDelivery_AllocationDeliveryEntryTableDoesNotContainAnItemTypeEventForVersionOfContractNumberAndAllocationNumber(int itemType, int version, string contractNumber, string allocationNumber)
        {
            bool arePresent = AllocationDeliveryEntryRepository.AreThereAdpEntriesForContract(
                allocationDeliveryEntryCategory: (AllocationDeliveryEntryCategory)itemType,
                contractNumber: contractNumber,
                versionNumber: version,
                allocationNumber: allocationNumber);

            Assert.IsFalse(arePresent, $"The are ADP entries for contract: {contractNumber}, version: {version}, itemType: {itemType}");

        }

        [Given(@"the Allocation Delivery Monitoring Service atom feed contains the following Planned data")]
        [Then(@"the Allocation Delivery Monitoring Service atom feed contains the following Planned data")]
        public void ThenTheAllocationDeliveryMonitoringServiceAtomFeedContainsTheFollowingPlannedData(TransformedTable table)
        {
            const string urlSuffix = "/api/allocation-delivery/monitoring/notifications/all";

            string failedMessage = string.Empty;
            table.Rows.ForEach(row =>
            {
                CheckResultPoller poller = new CheckResultPoller(checkResult: () =>
                {
                    IEnumerable<SyndicationItem> retrievedFeedItems = AtomFeedReader.EnumerateItems(
                        $"{ConfigurationManager.AppSettings["ContractManagementServiceUrl"]}{urlSuffix}",
                        AzureAuthenticator.GetAuthenticationConfig(),
                        "application/vnd.sfa.allocation-delivery.allocation-delivery-performance.v1+atom+xml");

                    return retrievedFeedItems.Any(feedItem =>
                    {
                        var allocationDeliveryPerformance = feedItem.GetContent<AllocationDeliveryPerformance>();
                        var flattenedDeliverables =
                            FlattenDeliverables(allocationDeliveryPerformance.ContractDeliverables);

                        var matchingDeliverable = flattenedDeliverables.SingleOrDefault(d =>
                            d.DeliverableCode == row.ParseInt("DeliverableCode"));
                        var matchingPeriod =
                            matchingDeliverable?.ContractDeliverablePeriods.SingleOrDefault(p =>
                                p.Period == row["Period"]);

                        var checks = new List<(Func<bool> check, string failureMessage)>
                            {
                                (() => feedItem.Categories.Single().Name == row["AllocationDeliveryEntryCategory"],
                                    "Category Incorrect"),
                                (() => allocationDeliveryPerformance.Contract.contractNumber == row["ContractNumber"],
                                    "Contract Number not correct"),
                                (() => allocationDeliveryPerformance.Contract.contractVersionNumber == row.ParseInt("VersionNumber"),
                                    "Version number not correct"),
                                (() => allocationDeliveryPerformance.contractAllocationNumber == row["AllocationNumber"],
                                    "Allocation Number not correct"),
                                (() => matchingDeliverable != null && matchingPeriod != null,
                                    "Deliverable and or period are not correct"),
                                (() => matchingPeriod.PlannedValue == row.ParseDecimal("PlannedValue") ,
                                    "Planned Value is not correct"),
                                (() => matchingPeriod.PlannedVolume == row.ParseDecimal("PlannedVolume"),
                                    "Planned Volume is not correct"),
                            };
                        var failedCheck = checks.FirstOrDefault(c => !c.check());
                        failedMessage = failedCheck.failureMessage;
                    return failedCheck.failureMessage == null;

                    });
                }, maxNumChecks: 10, waitIntervalSeconds: 3);

                bool foundExpectedItem = poller.CheckResultAndWaitTillCompleteOrOutOfTime();

                Assert.IsTrue(foundExpectedItem, $"Expected item not found on ALLOCATIONDELIVERYPERFORMANCE Atom Feed item for {row.ToHeaderAndValueString()}, column that failed: {failedMessage}");
            });
        }

        public static List<DeliverableTYPE> FlattenDeliverables(
            List<DeliverableTYPE> hierarchicalDeliverableList,
            List<DeliverableTYPE> flattenedList = null)
        {
            flattenedList = flattenedList ?? new List<DeliverableTYPE>();

            foreach (var deliverable in hierarchicalDeliverableList)
            {
                flattenedList.Add(deliverable);

                flattenedList = FlattenDeliverables(deliverable.ContractDeliverables, flattenedList);
            }

            return flattenedList;
        }

        private class AllocationDeliveryPerformanceKey
        {
            public AllocationDeliveryEntryCategory AllocationDeliveryEntryCategory { get; set; }

            public string AllocationNumber { get; set; }

            public int VersionNumber { get; set; }

            public string Period { get; set; }

            public int DeliverableCode { get; set; }

            public override string ToString()
            {
                return
                    $"AllocationDeliveryEntryCategory: {AllocationDeliveryEntryCategory}, AllocationNumber: {AllocationNumber}, " +
                    $"VersionNumber: {VersionNumber}, Period: {Period}, DeliverableCode: {DeliverableCode}";
            }
        }
    }
}
