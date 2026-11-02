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
    public class DocumentsFspGroupDocumentTemplateWriterTests
    {
        private const string FundingTypeCode = "FTYPE_CODE";
        private const string FundingPeriodCode = "FPERIOD_CODE";
        private const string DocumentComponentCode = "DOCUMENTCOMPONENT_CODE";
        private const string ContractType = "CONTRACTTYPE_CODE";
        private const string Template = "TEMPLATE";
        private const string FspGroup = "Fsp G";

        [TestInitialize]
        public void CleanUp()
        {
            using (var context = new DocumentsDomainDbContext())
            {
                FspGroupDocumentTemplate dt = context.FspGroupDocumentTemplates.SingleOrDefault(d => d.FundingTypeCode == FundingTypeCode 
                                       && d.FundingPeriodCode == FundingPeriodCode
                                       && d.DocumentComponentCode == DocumentComponentCode
                                       && d.ContractType == ContractType
                                       && d.FSPGroupCode == FspGroup);

                if (dt != null)
                {
                    context.FspGroupDocumentTemplates.Remove(dt);
                    context.SaveChanges();
                }
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void DocumentsDomainDocumentTemplateWriter_NewDocumentsDomainDocumentTemplate()
        {
            // Arrange
            FspGroupDocumentTemplateSheetType fspGroupDocumentTemplateSheetTypeEntry = new FspGroupDocumentTemplateSheetType
            {
                FundingTypeCode = FundingTypeCode,
                FundingPeriodCode = FundingPeriodCode,
                DocumentComponentCode = DocumentComponentCode,
                ContractType = ContractType,
                FspGroupCode = FspGroup,
                Template = Template,
                PolicyStatus = PolicyStatus.Approved
            };

            List<FspGroupDocumentTemplateSheetType> updatedDocumentTemplates = new List<FspGroupDocumentTemplateSheetType>
            {
                fspGroupDocumentTemplateSheetTypeEntry
            };

            UpsertFspGroup(FspGroup);

            // Act
            DocumentsDomainFspGroupDocumentTemplateWriter.WriteToPaaSDatabase(updatedDocumentTemplates, WriterBehaviour.AddOrUpdate);

            // Assert
            using (var context = new DocumentsDomainDbContext())
            {
                FspGroupDocumentTemplate testedDt = context.FspGroupDocumentTemplates.SingleOrDefault(d => d.FundingTypeCode == FundingTypeCode
                                                                                     && d.FundingPeriodCode == FundingPeriodCode
                                                                                     && d.DocumentComponentCode == DocumentComponentCode
                                                                                     && d.FSPGroupCode == FspGroup
                                                                                     && d.ContractType == ContractType);

                Assert.IsNotNull(testedDt);
                Assert.AreEqual(Template, testedDt.Template, "Incorrect Template");
            }
            ClearDownFspGroupCode(FspGroup);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void DocumentsDomainDocumentTemplateWriter_UpdateDocumentsDomainDocumentTemplate()
        {
            // Arrange
            UpsertFspGroup(FspGroup);

            FspGroupDocumentTemplate documentTemplateBefore = new FspGroupDocumentTemplate
            (
                FundingTypeCode,
                FundingPeriodCode,
                DocumentComponentCode,
                FspGroup,
                ContractType,
                Template + "_before"
            );
            
            using (var context = new DocumentsDomainDbContext())
            {
                context.FspGroupDocumentTemplates.Add(documentTemplateBefore);
                context.SaveChanges();
            }

            FspGroupDocumentTemplateSheetType fspGroupDocumentTemplateSheetTypeEntry = new FspGroupDocumentTemplateSheetType
            {
                FundingTypeCode = FundingTypeCode,
                FundingPeriodCode = FundingPeriodCode,
                DocumentComponentCode = DocumentComponentCode,
                ContractType = ContractType,
                Template = Template + "_after",
                FspGroupCode = FspGroup,
                PolicyStatus = PolicyStatus.Approved
            };

            List<FspGroupDocumentTemplateSheetType> updatedDocumentTemplates = new List<FspGroupDocumentTemplateSheetType>
            {
                fspGroupDocumentTemplateSheetTypeEntry
            };

            // Act
            DocumentsDomainFspGroupDocumentTemplateWriter.WriteToPaaSDatabase(updatedDocumentTemplates, WriterBehaviour.AddOrUpdate);

            // Assert
            using (var context = new DocumentsDomainDbContext())
            {
                FspGroupDocumentTemplate testedDt = context.FspGroupDocumentTemplates.SingleOrDefault(d => d.FundingTypeCode == FundingTypeCode
                                                                                           && d.FundingPeriodCode == FundingPeriodCode
                                                                                           && d.DocumentComponentCode == DocumentComponentCode
                                                                                           && d.FSPGroupCode == FspGroup
                                                                                           && d.ContractType == ContractType);

                Assert.IsNotNull(testedDt);
                Assert.AreEqual(Template + "_after", testedDt.Template, "Incorrect Template");
            }
            ClearDownFspGroupCode(FspGroup);
        }

        private static void UpsertFspGroup(string fspGroupCode)
        {
            using (var context = new DocumentsDomainDbContext())
            {
                if (!context.FSPGroups.Any(g => g.FSPGroupCode == fspGroupCode))
                {
                    context.FSPGroups.Add(new FSPGroup(fspGroupCode, "name", 11));

                    context.SaveChanges();
                }
            }
        }

        private void ClearDownFspGroupCode(string fspGroupCode)
        {
            using (var context = new DocumentsDomainDbContext())
            {
                context.FSPGroups.Where(fspg => fspg.FSPGroupCode == fspGroupCode).ToList()
                    .ForEach(fspg => context.FSPGroups.Remove(fspg));

                context.SaveChanges();
            }
        }
    }
}