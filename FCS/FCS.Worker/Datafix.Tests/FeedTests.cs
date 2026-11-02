using System.Collections.Generic;
using System.Globalization;

namespace Datafix.Tests
{
    using System.IO;
    using System.Linq;
    using System.Xml;
    using System.Xml.Linq;
    using System.Xml.Schema;
    using Castle.Core.Internal;
    using ContractManagement.DataStore.Model;
    using Infrastructure;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Repositories;
    using SFA.FCT.CrossDomain.Integration.Common.Extensions;

    [TestClass]
    public class FeedTests
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void DeliverablesOnFeed_FindContractsWithIncorrectDeliverables()
        {
            var contracts = AtomFeedItemRepository.GetContracts();

            var contractsWithMissingDeliverables =
                contracts.Where(c => c.Allocations.All(a => !AreDeliverablesCorrectOnAllocation(a)))
                    .Where(c => !c.Identity.StartsWith("APPLE")).ToList(); // we ignore APPLEVY as these do not follow the rule.
            var allocations = contractsWithMissingDeliverables.SelectMany(c => c.Allocations.Select(a =>
                new AllocationWithDeliverableInfo(
                    c.ContractNumber,
                    c.Version,
                    c.SubVersion,
                    a.AllocationRef,
                    a.FspCode,
                    c.CreatedDate.ToString("g", new CultureInfo("en-GB")),
                    ((AtomItemType) c.ItemType).ToString()))).ToList();
            CsvWriter<AllocationWithDeliverableInfo> csvWriter = new CsvWriter<AllocationWithDeliverableInfo>();
            var csv = csvWriter.CreateCsv(allocations);

            var all = string.Join(", ", contractsWithMissingDeliverables.Select(c => c.ToString()));

            Assert.IsTrue(contractsWithMissingDeliverables.Empty());
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void FeedItems_ShouldBeValid()
        {
            const int totalRows = 119133;
            const int pageSize = 1000;
            int totalPages = (totalRows / 1000) + 1;
            List<string> invalidContractsForAllPages = new List<string>();
            Enumerable.Range(0, totalPages).ToList()
                .ForEach(pageNumber =>
                {
                    int startIndex = 1 + (pageNumber * pageSize);
                    var contracts = AtomFeedItemRepository.GetContractsAsXml(startIndex, startIndex + pageSize - 1);
                    var invalidContracts = contracts.Where(contractXml => !IsContractXmlValid(contractXml)).ToList();
                    invalidContractsForAllPages.AddRange(invalidContracts);
                });

            Assert.IsTrue(invalidContractsForAllPages.IsNullOrEmpty(), "We have some invalid contracts");
        }

        private static bool IsContractXmlValid(string xml)
        {
            var xDocument = XDocument.Parse(xml);
            var schemas = new XmlSchemaSet();
            Stream xsdStream = GetCorporateSchemaXsdFile();
            schemas.Add("urn:sfa:schemas:contract", new XmlTextReader(xsdStream));

            bool isValid = true;
            try
            {
                xDocument.Validate(schemas, (o, e) =>
                {
                    if (e.Message != "The value of the 'schemaVersion' attribute does not equal its fixed value.")
                    {
                        isValid = false;
                    }
                });
            }
            catch (XmlSchemaValidationException)
            {
                return isValid = false;
            }

            return isValid;
        }

        private static Stream GetCorporateSchemaXsdFile()
        {
           const string corpContractSchemaResourceName = "SFA.FCT.CrossDomain.Integration.Entities.CorporateSchema.contract_corporate_schema_v11.06.xsd";

           return typeof(SFA.FCT.CrossDomain.Integration.Entities.CorporateSchema.Contract.contract).Assembly.GetManifestResourceStream(corpContractSchemaResourceName);
        }

        private bool AreDeliverablesCorrectOnAllocation(AllocationWithDeliverables allocation)
        {
            var expectedDeliverables = LegalDeliverableRepository.GetLegalDeliverablesForFsp(allocation.FspCode);

            var isOk = expectedDeliverables.All(expectedDeliverable =>
            {
                var allocationDeliverables =
                    allocation.DeliverableInfos.Where(d => d.Code == expectedDeliverable.DeliverableCode).ToList();

                if (allocationDeliverables.Count == 1)
                {
                    return allocationDeliverables.Single().Name == expectedDeliverable.DeliverableName;
                }

                return false;
            });

            return isOk;
        }

        public class AllocationWithDeliverableInfo
        {
            public AllocationWithDeliverableInfo(string contractNumber, int version, int subVersion, string allocationRef, string fsp, string createdDate, string category)
            {
                ContractNumber = contractNumber;
                Version = version;
                SubVersion = subVersion;
                AllocationRef = allocationRef;
                Fsp = fsp;
                CreatedDate = createdDate;
                Category = category;
            }

            public string ContractNumber { get; }
            public int Version { get; }
            public int SubVersion { get; }
            public string AllocationRef { get; }
            public string Fsp { get; }
            public string CreatedDate { get; }
            public string Category { get; }
        }
    }
}
