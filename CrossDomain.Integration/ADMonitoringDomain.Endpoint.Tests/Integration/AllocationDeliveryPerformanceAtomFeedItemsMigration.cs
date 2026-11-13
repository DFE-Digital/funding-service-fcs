namespace ADMonitoringDomain.Endpoint.Tests.Integration
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using System.Collections.Generic;
    using System.Linq;
    using SFA.FCT.AllocationDelivery.DataStore;
    using System.IO;
    using ADMonitoringDomain.Endpoint.BusinessLogic;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
    using System.Data.Entity;
    using System.Reflection;
    using System.Xml.Linq;
    using System.Xml;
    using System.Xml.Schema;
    using System.Xml.Serialization;
    using System.Xml.XPath;
    using SFA.FCT.CrossDomain.Integration.Common.Serializers;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using System.Data.SqlClient;
    using System.Diagnostics;
    using System;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Model;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using ADMonitoringDomain.Endpoint.Tests.Integration.LegacyCorporateSchemas;

    [TestClass]
    public class AllocationDeliveryPerformanceAtomFeedItemsMigration
    {
        private const string AssemblyName = "CrossDomain.Integration.Entities.dll";
        private const string EmbeddedResourceName = "SFA.FCT.CrossDomain.Integration.Entities.AllocationDeliveryPerformance.allocation-delivery-performance-schema.xsd";
        private const string SchemaNamespace = "urn:sfa:schemas:allocation-delivery-performance";

        private const string DoatConnectionString = "";//use this connection string when running the test for real, but be careful as it will update the data in the database

        private const string AtConnectionString = "";//use this connection string when running the test for real, but be careful as it will update the data in the database

        private const string OATConnectionString ="";//use this connection string when running the test for real, but be careful as it will update the data in the database

        private List<LocalAllocation> LocalAllocations;
        private List<LocalDeliverablePayment> LocalDeliverablePayments;
        private List<FundingStreamPeriodDeliverable> LocalFundingStreamPeriodDeliverables;

        // Use this connection string when running the test for real.
        
        [TestMethod, TestCategory("DataFix_R11a")]
        public void Migrate_AllocationDeliveryPerformanceAtomFeedItems_From_V1_01_To_V1_03()
        {
            int pageSize = 100;

            // Update this next line with the correct connection string property
            string connectionString = OATConnectionString;

            PaymentSchedulePolicyContext paymentSchedulePolicyContext = new PaymentSchedulePolicyContext();
            ResetConnectionString(paymentSchedulePolicyContext, connectionString);
            MonitoringDeliverablesDbContext mdContext = new MonitoringDeliverablesDbContext();
            ResetConnectionString(mdContext, connectionString);

            LocalAllocations = paymentSchedulePolicyContext.Allocations
                .Select(x=> new LocalAllocation()
                {
                    AllocationNumber = x.AllocationNumber,
                    ContractNumber = x.ContractNumber,
                    VersionNumber = x.ContractVersionNumber,
                    FundingStreamPeriodCode = x.FundingStreamPeriodCode
                }).ToList();

            LocalDeliverablePayments = paymentSchedulePolicyContext.DeliverablePayments.
                Select(x => new LocalDeliverablePayment()
                {
                    AllocationNumber = x.AllocationNumber,
                    VersionNumber = x.VersionNumber,
                    DeliverableCode = x.DeliverableCode,
                    Period = x.Period,
                    PlannedValue = x.PlannedValue,
                    PlannedVolume = x.PlannedVolume
                }).ToList();

            LocalFundingStreamPeriodDeliverables = mdContext.FundingStreamPeriodDeliverables.ToList();

            using (var context = new AllocationDeliveryDbContext())
            {
                Debug.Print($"{DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss")}");

                ResetConnectionString(context, connectionString);
                var entriesTaken = context.AllocationDeliveryEntries.First();
                Assert.IsNotNull(entriesTaken);
                int processedRows = 0;
                do
                {
                    Assert.IsNotNull(entriesTaken);
                    var oldSchemaItems = context.AllocationDeliveryEntries.Where(a => a.SchemaVersion == string.Empty)
                        .OrderBy(a => a.ID).Take(pageSize)
                        .Select(a => new { a.ID, CorporateAllocationDeliveryXml = a.GetAllocationDeliveryPerformanceXml(), a.AllocationNumber, a.VersionNumber }).ToList();

                    processedRows = 0;

                    foreach (var oldSchemaItem in oldSchemaItems)
                    {
                        XDocument doc = XDocument.Load(new XmlTextReader(new StringReader(oldSchemaItem.CorporateAllocationDeliveryXml)));
                        XNamespace adpNamespace = "";
                        XmlNamespaceManager nsmgr = new XmlNamespaceManager(new NameTable());
                        nsmgr.AddNamespace("ns", "urn:sfa:schemas:allocation-delivery-performance");

                        int indexOfBeginning = oldSchemaItem.CorporateAllocationDeliveryXml.IndexOf("<ContractDeliverables");
                        string startOfOld = oldSchemaItem.CorporateAllocationDeliveryXml.Substring(0, indexOfBeginning);

                        string endElement = "</ContractDeliverables>";
                        int indexOfEnd = oldSchemaItem.CorporateAllocationDeliveryXml.LastIndexOf(endElement);
                        string endOfOld = oldSchemaItem.CorporateAllocationDeliveryXml.Substring(indexOfEnd + endElement.Length);

                        ContractDeliverables contractDeliverables = new ContractDeliverables
                        {
                            DeliverableTypes = GetDeliverables(oldSchemaItem.AllocationNumber, oldSchemaItem.VersionNumber.Value)
                        };

                        var newXml = contractDeliverables.SerializeToXml();
                        newXml = RemoveRootElement(newXml);

                        const string xmlHeader = "<?xml version=\"1.0\"?>";
                        newXml = newXml.Replace(xmlHeader, "");
                        newXml = newXml.Replace("\"", "");
                        newXml = newXml.Replace(@"xmlns=urn:sfa:schemas:allocation-delivery-performance", string.Empty);
                        const string namespaceBits = " xmlns:xsi=http://www.w3.org/2001/XMLSchema-instance xmlns:xsd=http://www.w3.org/2001/XMLSchema";
                        newXml = newXml.Replace(namespaceBits, "");
                        newXml = newXml.Replace("<ContractDeliverables  />", "");
                        startOfOld = startOfOld.Replace("1.01", "1.03");
                        string newSchemaItem = startOfOld + newXml + endOfOld;

                        int indexOfAPP = newSchemaItem.IndexOf("<AggregatedPaymentPeriods");
                        if (indexOfAPP != -1)
                        {
                            string aggregatedPaymentPeriodsOnwards = newSchemaItem.Substring(indexOfAPP);
                            string amendedAggregatedPaymentPeriodsOnwards = aggregatedPaymentPeriodsOnwards.Replace("DeliverableCode", "DeliverableReference");
                            newSchemaItem = newSchemaItem.Replace(aggregatedPaymentPeriodsOnwards,
                                amendedAggregatedPaymentPeriodsOnwards);
                        }

                        newSchemaItem = newSchemaItem.Replace("<ActualsPeriods />", "");
                        newSchemaItem = newSchemaItem.Replace("<ScheduledPaymentPeriods />", "");
                        newSchemaItem = newSchemaItem.Replace("<AggregatedPaymentPeriods />", "");

                        bool isValid = IsValid(AssemblyName, EmbeddedResourceName, SchemaNamespace, newSchemaItem);

                        Assert.IsTrue(isValid);

                        var sql = @"UPDATE [AllocationDelivery].[AllocationDeliveryEntry] SET [CorporateAllocationDeliveryXml] = @newValue, [SchemaVersion] = '1.03' WHERE [ID] = @id";
                        context.Database.ExecuteSqlCommand(sql,
                            new SqlParameter("@newValue", newSchemaItem),
                            new SqlParameter("@id", oldSchemaItem.ID));

                        processedRows++;
                    }

                } while (processedRows > 0);
            }
        }

        private List<DeliverableTYPE> GetDeliverables(string allocationNumber, int contractVersionNumber)
        {
            var results = from d in LocalDeliverablePayments
                          join a in LocalAllocations on
                              new { d.AllocationNumber, d.VersionNumber } equals
                              new { a.AllocationNumber, a.VersionNumber }
                          where d.AllocationNumber == allocationNumber && d.VersionNumber == contractVersionNumber
                          select new
                          {
                              a.FundingStreamPeriodCode,
                              a.ContractNumber,
                              a.VersionNumber,
                              d.DeliverableCode,
                              d.PlannedValue,
                              d.PlannedVolume,
                              d.Period
                          };

            var resultsJoin = results.ToList().Select(r => new DeliverablePeriodSummary
            {
                FundingStreamPeriodDeliverable = GetFsc(r.FundingStreamPeriodCode, r.DeliverableCode),
                FundingStreamPeriodCode = r.FundingStreamPeriodCode,
                ContractNumber = r.ContractNumber,
                ContractVersionNumber = r.VersionNumber,
                DeliverableCode = r.DeliverableCode,
                Period = r.Period,
                PlannedValue = r.PlannedValue,
                PlannedVolumne = r.PlannedVolume
            });

            var resultsCombined = resultsJoin.ToList().Distinct();

            return null;//resultsCombined.Any() ? AtomItemMapper.MapDeliverablesTypes(resultsCombined) : null;
        }

        private FundingStreamPeriodDeliverable GetFsc(string fundingStreamPeriodCode, int deliverableCode)
        {
            var results =
                LocalFundingStreamPeriodDeliverables.FirstOrDefault(
                    a => a.FundingStreamPeriodCode == fundingStreamPeriodCode && a.DeliverableCode == deliverableCode);
            return results;
        }

        public static bool IsValid(string assemblyName, string schemaResource, string schemaNameSpace,
            string xmlToValidate)
        {
            XmlSchemaSet schemas = new XmlSchemaSet();
            List<string> validationErrors = new List<string>();
            using (Stream stream = Assembly.LoadFrom(assemblyName).GetManifestResourceStream(schemaResource))
            {
                schemas.Add(schemaNameSpace, new XmlTextReader(stream));
            }

            // act
            XDocument
                .Parse(xmlToValidate, LoadOptions.PreserveWhitespace | LoadOptions.SetLineInfo)
                .Validate(schemas, (sender, e) => validationErrors.Add($"Error: {e.Exception.Message} at line {e.Exception.LineNumber}"));

            return !validationErrors.Any();
        }

        private string RemoveRootElement(string xml)
        {
            XDocument doc = XDocument.Load(new XmlTextReader(new StringReader(xml)));
            return doc.Root.XPathSelectElement("//Shell/ContractDeliverables").ToString();
        }

        [XmlRoot("Shell")]
        public class ContractDeliverables
        {
            [XmlArray("ContractDeliverables")]
            [XmlArrayItem("ContractDeliverable")]
            public List<DeliverableTYPE> DeliverableTypes { get; set; }
        }

        private void ResetConnectionString(DbContext context, string connectionString)
        {
            context.Database.Connection.ConnectionString = connectionString;
        }

    }

    internal class LocalDeliverablePayment
    {
        public string AllocationNumber { get; set; }
        public int VersionNumber { get; set; }
        public int DeliverableCode { get; set; }
        public decimal? PlannedValue { get; set; }
        public int? PlannedVolume { get; set; }
        public string Period { get; set; } 
    }

    internal class LocalAllocation
    {
        public string AllocationNumber { get; set; }
        public string FundingStreamPeriodCode { get; set; }
        public string ContractNumber { get; set; }
        public int VersionNumber { get; set; }
    }
}
