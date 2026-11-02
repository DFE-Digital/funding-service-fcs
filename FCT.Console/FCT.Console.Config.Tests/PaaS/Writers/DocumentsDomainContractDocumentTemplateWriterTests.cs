namespace FCT.Console.Config.Tests.PaaS.Writers
{
    using System.Collections.Generic;
    using System.Linq;
    using ExcelTypes;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.DocumentsDomain.DataStore;
    using SFA.FCT.DocumentsDomain.DataStore.Models;
    using Synchronizers.Writers;
    using Synchronizers.Writers.PAAS;

    [TestClass]
    public class DocumentsDomainContractDocumentTemplateWriterTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void DocumentsDomainContractDocumentTemplateWriter_ShouldUpdateExisting()
        {
            // arrange
            const string fundingTypeCode = "FTC";
            const string fundingPeriodCode = "FPC";
            const string documentComponentCode = "DCC";
            const string contractType = "CT";
            const string template = "Some template";

            RemoveContractDocumentTemplate(fundingTypeCode);

            using (var context = new DocumentsDomainDbContext())
            {
                context.ContractDocumentTemplates.Add(new ContractDocumentTemplate(fundingTypeCode, fundingPeriodCode,
                    documentComponentCode, contractType, template));

                context.SaveChanges();
            }

            List<ContractDocumentTemplateSheetType> rows = new List<ContractDocumentTemplateSheetType>
            {
                new ContractDocumentTemplateSheetType
                {
                    ContractType = contractType,
                    DocumentComponentCode = documentComponentCode,
                    FundingTypeCode = fundingTypeCode,
                    FundingPeriodCode = fundingPeriodCode,
                    PolicyStatus = PolicyStatus.Approved,
                    Template = "new template"
                }
            };

            // act
            DocumentsDomainContractDocumentTemplateWriter.WriteToPaaSDatabase(rows, WriterBehaviour.AddOrUpdate);

            // assert
            using (var context = new DocumentsDomainDbContext())
            {
                var retrieved = context.ContractDocumentTemplates.SingleOrDefault(c => c.ContractType == contractType 
                                                                       && c.FundingTypeCode == fundingTypeCode
                                                                       && c.FundingPeriodCode == fundingPeriodCode
                                                                       && c.DocumentComponentCode == documentComponentCode);
                    
                Assert.IsNotNull(retrieved, "We have removed the row");
                Assert.AreEqual( rows.First().Template,  retrieved.Template, "The template has not been updated");
            }

            RemoveContractDocumentTemplate(fundingTypeCode);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void DocumentsDomainContractDocumentTemplateWriter_ShouldInsertNew()
        {
            // arrange
            const string fundingTypeCode = "FTC";
            const string fundingPeriodCode = "FPC";
            const string documentComponentCode = "DCC";
            const string contractType = "CT";

            RemoveContractDocumentTemplate(fundingTypeCode);

            List<ContractDocumentTemplateSheetType> rows = new List<ContractDocumentTemplateSheetType>
            {
                new ContractDocumentTemplateSheetType
                {
                    ContractType = contractType,
                    DocumentComponentCode = documentComponentCode,
                    FundingTypeCode = fundingTypeCode,
                    FundingPeriodCode = fundingPeriodCode,
                    PolicyStatus = PolicyStatus.Approved,
                    Template = "new template"
                }
            };

            // act
            DocumentsDomainContractDocumentTemplateWriter.WriteToPaaSDatabase(rows, WriterBehaviour.AddOrUpdate);

            // assert
            using (var context = new DocumentsDomainDbContext())
            {
                var retrieved = context.ContractDocumentTemplates.SingleOrDefault(c => c.ContractType == contractType
                                                                       && c.FundingTypeCode == fundingTypeCode
                                                                       && c.FundingPeriodCode == fundingPeriodCode
                                                                       && c.DocumentComponentCode == documentComponentCode);

                Assert.IsNotNull(retrieved, "We have removed the row");
                Assert.AreEqual(rows.First().Template, retrieved.Template, "The template is not correct");
                Assert.AreEqual(rows.First().ContractType, retrieved.ContractType, "The ContractType is not correct");
                Assert.AreEqual(rows.First().DocumentComponentCode, retrieved.DocumentComponentCode, "The DocumentComponentCode is not correct");
                Assert.AreEqual(rows.First().FundingPeriodCode, retrieved.FundingPeriodCode, "The FundingPeriodCode is not correct");
                Assert.AreEqual(rows.First().FundingTypeCode, retrieved.FundingTypeCode, "The FundingTypeCode is not correct");
            }

            RemoveContractDocumentTemplate(fundingTypeCode);
        }

        private static void RemoveContractDocumentTemplate(string fundingTypeCode)
        {
            using (var context = new DocumentsDomainDbContext())
            {
                context.ContractDocumentTemplates.Where(c => c.FundingTypeCode == fundingTypeCode)
                    .ToList()
                    .ForEach(c => context.ContractDocumentTemplates.Remove(c));

                context.SaveChanges();
            }
        }
    }
}
