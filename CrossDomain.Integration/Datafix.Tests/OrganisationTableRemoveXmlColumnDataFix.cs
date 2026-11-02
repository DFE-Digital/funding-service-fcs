namespace Datafix.Tests
{
    using System;
    using System.Collections.Concurrent;
    using System.Collections.Generic;
    using System.Data.Entity.Infrastructure;
    using System.Diagnostics.CodeAnalysis;
    using System.Linq;
    using System.Xml.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using MoreLinq;
    using OrganisationDomain.Integration.DataStore;
    using OrganisationDomain.Integration.DataStore.Model;

    [TestClass]
    public class OrganisationTableRemoveXmlColumnDataFix
    {
        private static readonly XNamespace CpdsXmlNamespace = "http://xpims.lsc.gov.uk/ProviderDataSetV2";
        private readonly BlockingCollection<int> _orgsWithXmlParseFailures = new BlockingCollection<int>();

        [TestMethod, TestCategory("DataFix_R47")]
        public void OrganisationTable_ShouldCopyStatusAndTypeToNewColumns()
        {
            IReadOnlyCollection<int> idsFromTable = GetIdsFromTable();
            const int numberOfThreads = 4;
            const int batchSize = 10;

            idsFromTable.Batch(batchSize)
                .AsParallel()
                .WithDegreeOfParallelism(numberOfThreads);
            //  Following line commented out due to removal of CpdsData column
            //  .ForEach(CopyStatusAndTypeToNewColumn);

            Assert.AreEqual(0, _orgsWithXmlParseFailures.Count, $"We have had some xml parse failures for these org Ids {string.Join(", ", _orgsWithXmlParseFailures)}");
        }

        //  Following method commented out due to removal of CpdsData column
        //private void CopyStatusAndTypeToNewColumn(IEnumerable<int> batchOfIds)
        //{
        //    using (var context = new OrganisationDomainDbContext())
        //    {
        //        IReadOnlyCollection<SimpleOrg> batchOfSimpleOrgs = context.Organisations
        //            .Where(o => batchOfIds.Contains(o.OrganisationId))
        //            .Select(o => new {o.CpdsData, o.OrganisationId})
        //            .AsEnumerable()
        //            .Select(org => TranslateToSimpleOrg(org.CpdsData, org.OrganisationId))
        //            .ToList();

        //        UpdateOrganisationTableWithBatchOfSimpleOrgs(batchOfSimpleOrgs);
        //    }
        //}

        private void UpdateOrganisationTableWithBatchOfSimpleOrgs(IReadOnlyCollection<SimpleOrg> batchOfSimpleOrgs)
        {
            using (var context = new OrganisationDomainDbContext())
            {
                context.Configuration.ValidateOnSaveEnabled = false;

                batchOfSimpleOrgs.Where(so => so != null).Select(simpleOrg => new Organisation
                {
                    OrganisationId = simpleOrg.OrganisationId,
                    Status = simpleOrg.Status,
                    Type = simpleOrg.Type
                })
                .ForEach(o =>
                    { 
                        context.Organisations.Attach(o);
                        DbEntityEntry<Organisation> orgEntry = context.Entry(o);
                        orgEntry.Property(oe => oe.Type).IsModified = true;
                        orgEntry.Property(oe => oe.Status).IsModified = true;
                    });

                context.SaveChanges();
            }
        }

        private SimpleOrg TranslateToSimpleOrg(string cpdsXml, int organisationId)
        {
            try
            {
                var cpdsXmlDocument = XDocument.Parse(cpdsXml);

                string type = GetTypeFromXDocument(cpdsXmlDocument);

                string status = GetStatusFromXDocument(cpdsXmlDocument);

                return new SimpleOrg(organisationId: organisationId, status: status, type: type);
            }
            catch (Exception)
            {
                _orgsWithXmlParseFailures.Add(organisationId);
            }

            return null;
        }

        [SuppressMessage("ReSharper", "PossibleNullReferenceException")]
        private static string GetTypeFromXDocument(XDocument cpdsXmlDocument)
        {
            const string providerElement = "Provider";
            const string providerTypeElement = "ProviderType";

            return cpdsXmlDocument.Root.Element(CpdsXmlNamespace + providerElement)
                .Element(CpdsXmlNamespace + providerTypeElement).Element(CpdsXmlNamespace + providerTypeElement).Value;
        }

        [SuppressMessage("ReSharper", "PossibleNullReferenceException")]
        private static string GetStatusFromXDocument(XDocument cpdsXmlDocument)
        {
            const string providerElementName = "Provider";
            const string codesElement = "Codes";
            const string codeTypeElement = "CodeType";
            const string codeValueDescElement = "CodeValueDesc";

            var providerElement = cpdsXmlDocument.Root.Element(CpdsXmlNamespace + providerElementName);

            return providerElement.Elements(CpdsXmlNamespace + codesElement)
                .Where(x => x.Element(CpdsXmlNamespace + codeTypeElement).Attribute("id").Value == "91")
                .Descendants(CpdsXmlNamespace + codeValueDescElement).Single().Value;
        }

        private static IReadOnlyCollection<int> GetIdsFromTable()
        {
            using (var context = new OrganisationDomainDbContext())
            {
                return context.Organisations
                    .Select(o => o.OrganisationId).ToList();
            }
        }

        private class SimpleOrg
        {
            public SimpleOrg(int organisationId, string type, string status)
            {
                OrganisationId = organisationId;
                Type = type;
                Status = status;
            }

            public int OrganisationId { get; }

            public string Type { get; }

            public string Status { get; }
        }
    }
}
