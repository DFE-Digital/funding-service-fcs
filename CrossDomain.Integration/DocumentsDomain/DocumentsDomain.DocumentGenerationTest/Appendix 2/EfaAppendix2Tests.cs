namespace SFA.FCT.DocumentsDomain.DocumentGeneration.Tests.Appendix_2
{
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using Common.Commands;
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
    using FundingStreamPeriod = DataStore.Models.FundingStreamPeriod;

    [TestClass]
    public class EfaAppendix2Tests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void EfaAppendix2_ShouldNotHaveZerosWhenPeriodColumnsAreNotPopulated()
        {
            // arrange
            Mock<ITemplateRepository> templateRepository = new Mock<ITemplateRepository>();

            IDictionary<string, DocumentGenerationRequest> requests;
            Contract contract = GetCorporateContract();

            using (var documentDomainDbContext = new DocumentsDomainDbContext())
            {
                Appendix2DocumentCreator appendix2DocumentCreator = new Appendix2DocumentCreator(
                    templateRepository.Object,
                        new TestDocumentConfigurationSource(new FundingStreamPeriodRepository(documentDomainDbContext),
                        new FspDeliverableRepository(documentDomainDbContext)),
                        new FundingStreamPeriodRepository(documentDomainDbContext));

                // act
                requests = appendix2DocumentCreator.SupplyDocumentGenerationRequest("", contract, "");
            }

            // assert
            string totalValueFirstColumn = requests.Values.First().MergeData.MergeFields.First(mf => mf.Name == "T1").Value;
            string totalTotalValue = requests.Values.First().MergeData.MergeFields.First(mf => mf.Name == "TCash").Value;
            Assert.AreEqual(String.Empty, totalValueFirstColumn, "The total value is not empty");
            Assert.AreNotEqual(String.Empty, totalTotalValue, "The total total value is empty");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void EfaAppendix2_ShouldHaveZerosWithinBoundsOfContract()
        {
            // arrange
            Mock<ITemplateRepository> templateRepository = new Mock<ITemplateRepository>();
           
            IDictionary<string, DocumentGenerationRequest> requests;
            DocumentSaveCommand documentSaveCommand = GetSaveCommand();

            using (var documentDomainDbContext = new DocumentsDomainDbContext())
            {
                Appendix2DocumentCreator appendix2DocumentCreator = new Appendix2DocumentCreator(
                    templateRepository.Object,
                    new TestDocumentConfigurationSource(new FundingStreamPeriodRepository(documentDomainDbContext),
                    new FspDeliverableRepository(documentDomainDbContext)), 
                    new FundingStreamPeriodRepository(documentDomainDbContext));

                // act
                requests = appendix2DocumentCreator.SupplyDocumentGenerationRequest("", documentSaveCommand.Contract, "");
            }

            // assert
            string t2Column = requests.Values.ToList()[2].MergeData.MergeFields.First(mf => mf.Name == "T2").Value;
           
            Assert.AreEqual("0.00", t2Column, "The total value is not zero");
        }

        private Contract GetCorporateContract()
        {
            using (var resource = new TestResource("SFA.FCT.DocumentsDomain.DocumentGeneration.Tests", @"Resources.shortCorpContractEfa.json"))
            {
                return
                    (Contract)
                        new JsonSerializer().Deserialize(new StreamReader(resource.Stream), typeof(Contract));
            }
        }

        private DocumentSaveCommand GetSaveCommand()
        {
            using (var resource = new TestResource("SFA.FCT.DocumentsDomain.DocumentGeneration.Tests", @"Resources.DocumentSaveCommandEfa.json"))
            {
                return
                    (DocumentSaveCommand)
                        new JsonSerializer().Deserialize(new StreamReader(resource.Stream), typeof(DocumentSaveCommand));
            }
        }

        private class TestDocumentConfigurationSource : DocumentConfigurationSource
        {
            public TestDocumentConfigurationSource(IFundingStreamPeriodRepository fundingStreamPeriodRepository, IFspDeliverableRepository fspDeliverableRepository) : 
                base(fundingStreamPeriodRepository, fspDeliverableRepository, new FundingTypeFundingPeriodRepository(new DocumentsDomainDbContext()))
            {               
            }

            protected override IDictionary<string, FundingStreamPeriod> AllocationSettingsForSummaryOfFunding
            {
                get
                {
                    using (var documentDomainDbContext = new DocumentsDomainDbContext())
                    {
                        return new FundingStreamPeriodRepository(documentDomainDbContext).GetAll().ToDictionary(fsp => fsp.FundingStreamPeriodCode);
                    }                    
                }
            }
        }
    }
}
