namespace SFA.FCT.Contracts.AcceptanceTests.Steps
{
    using System;
    using System.Xml;
    using System.Xml.Linq;
    using System.Xml.XPath;
    using System.Linq;
    using ContractManagement.DataStore;
    using CrossDomain.Integration.Entities.CorporateSchema.Contract;
    using TechTalk.SpecFlow;
    using System.Collections.Generic;
    using System.IO;
    using ContractManagement.DataStore.Model;
    using CrossDomain.Integration.Common;
    using CrossDomain.Integration.Common.Serializers;
    using Extensions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Utilities;
    using XmlSerializer = System.Xml.Serialization.XmlSerializer;
    using NUnit.Framework.Legacy;

    [Binding]
    public class PublishFeedSteps
    {
        [Then(@"the Legal Contract Feed includes the following values")]
        public void AndTheLegalContractFeedIncludesTheFollowingValues(Table table)
        {
            IList<ContractFeedItemExpectedValues> feedItemExpectedValues = RetrieveExpectedValuesFromTable(table);
            var expectedValuesGrouped = feedItemExpectedValues.GroupBy(f => new { f.ContractNumber, f.ContractVersion, f.ItemType });

            foreach (var groupedWithManyAllocationTestRows in expectedValuesGrouped)
            {
                string businessKey = $"{groupedWithManyAllocationTestRows.Key.ContractNumber}:{groupedWithManyAllocationTestRows.Key.ContractVersion}.0";

                AtomFeedItem feedItem = null;
                CheckResultPoller poller = new CheckResultPoller(() =>
                {
                    feedItem = GetAtomFeedItem(businessKey, groupedWithManyAllocationTestRows.Key.ItemType);
                    return feedItem != null;
                }, maxNumChecks: 15, waitIntervalSeconds: 1);
                poller.CheckResultAndWaitTillCompleteOrOutOfTime();

                string corpSchemaXml = ZipHelper.ToStringFromZippedBytes(feedItem.AtomFeedItemBytes);
                Contract contract = Deserialize(corpSchemaXml);
                int numberOfDeliveryOrgsInGivenXml = GetNumberOfDeliveryOrgsInGivenXml(corpSchemaXml);

                foreach (var allocationTestRow in groupedWithManyAllocationTestRows)
                {
                    var allocation = contract.contracts[0].contractAllocations.Single(a => a.contractAllocationNumber == allocationTestRow.AllocationRef);

                    if (allocationTestRow.DeliveryOrganisationUkprn == null || allocationTestRow.DeliveryOrganisationProvider == null)
                    {
                        ClassicAssert.AreEqual(0, numberOfDeliveryOrgsInGivenXml);
                        ClassicAssert.IsNull(allocation.allocationOrganisationRelationships.Organisation,
                            $"DeliveryOrganisation had a value when not expected - {contract.SerializeToXml()}");
                    }
                    else
                    {
                        ClassicAssert.AreEqual(allocationTestRow.DeliveryOrganisationUkprn, allocation.allocationOrganisationRelationships.Organisation.ukprn.ToString(),
                            $"Unexpected ukprn set in delivery org of allocation - {contract.SerializeToXml()}");
                        ClassicAssert.AreEqual(allocationTestRow.DeliveryOrganisationProvider, allocation.allocationOrganisationRelationships.Organisation.legalName,
                            $"Unexpected ukprn set in delivery org of allocation - {contract.SerializeToXml()}");
                        ClassicAssert.AreEqual(allocationTestRow.AllocationRef, allocation.allocationOrganisationRelationships.contractAllocationNumber,
                            $"Unexpected contractAllocationNumber  in delivery org of allocation - {contract.SerializeToXml()}");
                    }
                }
            }
        }

        [Given(@"the Contract Management atom feed is empty")]
        public void GivenTheContractAtomFeedIsEmpty()
        {
            using (var context = new ContractManagementDbContext())
            {
                context.Database.ExecuteSqlCommand("truncate table [ContractManagement].[AtomFeedItem]");
            }
        }

        private static int GetNumberOfDeliveryOrgsInGivenXml(string corpSchemaXml)
        {
            XDocument document = XDocument.Load(new StringReader(corpSchemaXml));
            XmlNamespaceManager namespaceManager = new XmlNamespaceManager(new NameTable());
            XNamespace nameSpace = "urn:sfa:schemas:contract";
            namespaceManager.AddNamespace("ns", nameSpace.NamespaceName);
            return document.XPathSelectElements("//ns:contractAllocation//ns:allocationOrganisationRelationships", namespaceManager).ToList().Count();
        }

        private static AtomFeedItem GetAtomFeedItem(string businessKey, AtomItemType itemType)
        {
            using (var context = new ContractManagementDbContext())
            {
                return context.AtomFeedItems.Single(a => a.BusinessKey == businessKey && a.ItemType == itemType);
            }
        }

        private static Contract Deserialize(string xml)
        {
            XmlSerializer xs = new XmlSerializer(typeof(Contract));
            return xs.Deserialize(new StringReader(xml)) as Contract;
        }

        private IList<ContractFeedItemExpectedValues> RetrieveExpectedValuesFromTable(Table table)
        {
            IList<ContractFeedItemExpectedValues> feedItemExpectedValues = new List<ContractFeedItemExpectedValues>();

            foreach (TableRow row in table.Rows)
            {
                string ukprn = row["UKPRN"];
                string contractNumber = row["ContractNumber"];
                int contractVersion = row.ParseNullableInt("ContractVersion").Value;
                AtomItemType itemType = (AtomItemType)Enum.Parse(typeof(AtomItemType), row["ItemType"], true);
                string allocationRef = row["AllocationRef"];
                string deliveryOrganisationUkprn = row["DeliveryOrganisationUKPRN"] == "?" ? null : row["DeliveryOrganisationUKPRN"];
                string deliveryOrganisationProvider = row["DeliveryOrganisationProvider"] == "?" ? null : row["DeliveryOrganisationProvider"];

                feedItemExpectedValues
                    .Add(new ContractFeedItemExpectedValues(ukprn, contractNumber, contractVersion, itemType,
                        allocationRef, deliveryOrganisationUkprn, deliveryOrganisationProvider));
            }

            return feedItemExpectedValues;
        }

        private class ContractFeedItemExpectedValues
        {
            public ContractFeedItemExpectedValues(string ukprn, string contractNumber, int contractVersion,
                AtomItemType itemType, string allocationRef, string deliveryOrganisationUkprn,
                string deliveryOrganisationProvider)
            {
                Ukprn = ukprn;
                ContractNumber = contractNumber;
                ContractVersion = contractVersion;
                ItemType = itemType;
                AllocationRef = allocationRef;
                DeliveryOrganisationUkprn = deliveryOrganisationUkprn;
                DeliveryOrganisationProvider = deliveryOrganisationProvider;
            }

            public string Ukprn { get; }
            public string ContractNumber { get; }
            public int ContractVersion { get; }
            public AtomItemType ItemType { get; }
            public string AllocationRef { get; }
            public string DeliveryOrganisationUkprn { get; }
            public string DeliveryOrganisationProvider { get; }

            public override string ToString()
            {
                return $"Ukprn: {Ukprn}, ContractNumber: {ContractNumber}, ContractVersion: {ContractVersion}, ItemType: {ItemType}, AllocationRef: {AllocationRef}, DeliveryOrganisationUKPRN: {DeliveryOrganisationUkprn}, DeliveryOrganisationProvider: {DeliveryOrganisationProvider}";
            }
        }
    }
}

