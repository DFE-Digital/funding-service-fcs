namespace SFA.FCT.DocumentsDomain.DocumentGeneration.Tests.Appendix_2
{
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using Common.Models;
    using CrossDomain.Integration.Entities.CorporateContract;
    using DataStore;
    using DataStore.Repositories;
    using DocumentDefiner.DocumentConfiguration;
    using DocumentDefiner.DocumentPartCreators.Appendix2;
    using Integration;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using Newtonsoft.Json;
    using UnitTests.Common;

    [TestClass]
    public class LoansAppendix2Tests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void LoansAppendix2_ShouldGetCorrectMergeFields()
        {
            // arrange
            Mock<ITemplateRepository> templateRepository = new Mock<ITemplateRepository>();
            IDictionary<string, DocumentGenerationRequest> requests;
            contract contract = GetCorporateContract("DocGenCommand_ALLF1819.json");

            using (var documentDomainDbContext = new DocumentsDomainDbContext())
            {
                Appendix2DocumentCreator apendix2 = new Appendix2DocumentCreator(
                templateRepository.Object,
                new DocumentConfigurationSource(new FundingStreamPeriodRepository(documentDomainDbContext),
                    new FspDeliverableRepository(documentDomainDbContext),
                    new FundingTypeFundingPeriodRepository(documentDomainDbContext))
                , new FundingStreamPeriodRepository(documentDomainDbContext));

                // act
                requests = apendix2.SupplyDocumentGenerationRequest("", contract, "");
            }

            // assert
            RepeatingSectionType mainTable =
                requests.Values.First().MergeData.RepeatingSections.First(rs => rs.Name == "MainTable");
               
            Assert.IsTrue(mainTable.Rows.Any(), $"There should be some rows in the MainTable");

            Assert.IsFalse(requests.Values.Any(v => v.GroupId.Contains("ALLF")), "We should not have included the ALLF allocation");
        }

        private contract GetCorporateContract(string fileName)
        {
            using (var resource = new TestResource("SFA.FCT.DocumentsDomain.DocumentGeneration.Tests", $@"Resources.{fileName}"))
            {
                return
                    (contract)
                        new JsonSerializer().Deserialize(new StreamReader(resource.Stream), typeof(contract));
            }
        }
    }
}
