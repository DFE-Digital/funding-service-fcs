namespace SFA.FCT.DocumentsDomain.Integration.DocumentGenEndpoint.Tests.Integration
{
    using System.Linq;
    using DataStore;
    using DataStore.Models;
    using DataStore.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class FspGroupDocumentTemplateRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void FspGroupDocumentTemplateRepository_ShouldGetByKeyOrUseDefaultForContractType()
        {
            // arrange
            const string fspGroup = "Some FSPG";
            const string fundingTypeCode = "FT";
            const string fundingPeriod = "FP";
            const string documentComponentCode = "S1";
            const string contractType = "DEFAULT";
            const string template = "TT";

            UpsertFspGroup(fspGroup);
            RemoveFspGroupDocumentTemplate(fspGroup);

            using (var context = new DocumentsDomainDbContext())
            {
                context.FspGroupDocumentTemplates.Add(new FspGroupDocumentTemplate(fundingTypeCode, fundingPeriod,
                    documentComponentCode, fspGroup, contractType, template));

                context.SaveChanges();
            }

            // act
            FspGroupDocumentTemplate fspGroupDocumentTemplate = new FspGroupDocumentTemplateRepository(new DocumentsDomainDbContext()).GetByKeyOrUseDefaultForContractType(
                fundingTypeCode: fundingTypeCode,
                fundingPeriodCode: fundingPeriod,
                documentComponentCode: documentComponentCode,
                contractType: "SOME CT",
                fspGroupCode: fspGroup);

            // assert
            Assert.IsNotNull(fspGroupDocumentTemplate, "the template is null");
            Assert.AreEqual(template, fspGroupDocumentTemplate.Template, "The template name is not correct");
            ClearDownFspGroupCode(fspGroup);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FspGroupDocumentTemplateRepository_ShouldGetByKey()
        {
            // arrange
            const string fspGroup = "Some FSPG";
            const string fundingTypeCode = "FT";
            const string fundingPeriod = "FP";
            const string documentComponentCode = "S1";
            const string contractType = "CT";
            const string template = "TT";

            UpsertFspGroup(fspGroup);
            RemoveFspGroupDocumentTemplate(fspGroup);

            using (var context = new DocumentsDomainDbContext())
            {
                context.FspGroupDocumentTemplates.Add(new FspGroupDocumentTemplate(fundingTypeCode, fundingPeriod,
                    documentComponentCode, fspGroup, contractType, template));

                context.SaveChanges();
            }

            // act
            FspGroupDocumentTemplate fspGroupDocumentTemplate = new FspGroupDocumentTemplateRepository(new DocumentsDomainDbContext()).GetByKeyOrUseDefaultForContractType(
                fundingTypeCode: fundingTypeCode,
                fundingPeriodCode: fundingPeriod,
                documentComponentCode: documentComponentCode,
                contractType: contractType,
                fspGroupCode: fspGroup);

            // assert
            Assert.IsNotNull(fspGroupDocumentTemplate, "the template is null");
            Assert.AreEqual(template, fspGroupDocumentTemplate.Template, "The template name is not correct");
            ClearDownFspGroupCode(fspGroup);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FspGroupDocumentTemplateRepository_GetByKeyOrUseDefaultForContractType_ShouldGetByKeyFromCacheAndNotDatabase()
        {
            // arrange
            const string fspGroup = "Some FSPG_cache";
            const string fundingTypeCode = "FT_cache";
            const string fundingPeriod = "FP_cache";
            const string documentComponentCode = "S1_cache";
            const string contractType = "CT_cache";
            const string template = "TT_cache";

            UpsertFspGroup(fspGroup);
            RemoveFspGroupDocumentTemplate(fspGroup);

            using (var context = new DocumentsDomainDbContext())
            {
                context.FspGroupDocumentTemplates.Add(new FspGroupDocumentTemplate(fundingTypeCode, fundingPeriod,
                    documentComponentCode, fspGroup, contractType, template));

                context.SaveChanges();
            }

            var repository = new FspGroupDocumentTemplateRepository(new DocumentsDomainDbContext());

            var fspGroupDocumentTemplateArrange = repository.GetByKeyOrUseDefaultForContractType(
                fundingTypeCode: fundingTypeCode,
                fundingPeriodCode: fundingPeriod,
                documentComponentCode: documentComponentCode,
                contractType: contractType,
                fspGroupCode: fspGroup);

            Assert.IsNotNull(fspGroupDocumentTemplateArrange, "the template is null");
            Assert.AreEqual(template, fspGroupDocumentTemplateArrange.Template, "The template name is not correct");

            RemoveFspGroupDocumentTemplate(fspGroup);

            // act
            var fspGroupDocumentTemplateAct = repository.GetByKeyOrUseDefaultForContractType(
                fundingTypeCode: fundingTypeCode,
                fundingPeriodCode: fundingPeriod,
                documentComponentCode: documentComponentCode,
                contractType: contractType,
                fspGroupCode: fspGroup);

            // assert
            Assert.IsNotNull(fspGroupDocumentTemplateAct, "the template is null");
            Assert.AreEqual(template, fspGroupDocumentTemplateAct.Template, "The template name is not correct");
            ClearDownFspGroupCode(fspGroup);
        }

        private static void UpsertFspGroup(string fspGroup)
        {
            using (var context = new DocumentsDomainDbContext())
            {
                if (!context.FSPGroups.Any(g => g.FSPGroupCode == fspGroup))
                {
                    context.FSPGroups.Add(new FSPGroup(fspGroup, "dn", 1));

                    context.SaveChanges();
                }
            }
        }

        private static void RemoveFspGroupDocumentTemplate(string fspGroup)
        {
            using (var context = new DocumentsDomainDbContext())
            {
                context.FspGroupDocumentTemplates.Where(t => t.FSPGroupCode == fspGroup)
                    .ToList()
                    .ForEach(t => context.FspGroupDocumentTemplates.Remove(t));

                context.SaveChanges();
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
