namespace SFA.FCT.DocumentsDomain.Integration.DocumentGenEndpoint.Tests.Integration
{
    using DataStore;
    using DataStore.Models;
    using DataStore.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using UnitTests.Common;

    [TestClass]
    public class ContractDocumentTemplateRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void DocumentTemplateRepository_GetByKey_ShouldReturnDocumentTemplateEntityForKey()
        {
            const string fundingTypeCode = "TEST_FT";
            const string fundingPeriodCode = "TEST_FP";
            const string documentComponentCode = "TEST_DC";
            const string contractType1 = "TEST_CT1";
            const string contractType2 = "TEST_CT2";
            const string templateName1 = "TEST_TEMPLATE_1";
            const string templateName2 = "TEST_TEMPLATE_2";

            // arrange
            using (DocumentsDomainDbContext context = new DocumentsDomainDbContext())
            {
                context.ContractDocumentTemplates.RemoveWhere(dt => dt.FundingTypeCode == "TEST_FT");
                context.ContractDocumentTemplates.Add(new ContractDocumentTemplate(fundingTypeCode, fundingPeriodCode, documentComponentCode, contractType1, templateName1));
                context.ContractDocumentTemplates.Add(new ContractDocumentTemplate(fundingTypeCode, fundingPeriodCode, documentComponentCode, contractType2, templateName2));
                context.SaveChanges();
            }

            ContractDocumentTemplate foundDocumentTemplate;

            // act
            using (DocumentsDomainDbContext context = new DocumentsDomainDbContext())
            {
                ContractDocumentTemplateRepository repository = new ContractDocumentTemplateRepository(context);
                foundDocumentTemplate = repository.GetByKey(fundingTypeCode, fundingPeriodCode, documentComponentCode, contractType2);
            }

            // assert
            Assert.IsNotNull(foundDocumentTemplate, "Unexpected null returned");
            Assert.AreEqual(templateName2, foundDocumentTemplate.Template, "Unexpected template returned");
        }
    }
}
