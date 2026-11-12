namespace SFA.FCT.DocumentsDomain.DocumentGeneration.Tests.Appendix_1
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Linq;
    using Castle.MicroKernel.Lifestyle;
    using Castle.Windsor;
    using Common.Models;
    using ContractManagement.DataStore.Repositories;
    using CrossDomain.Integration.Entities.CorporateContract;
    using DataStore;
    using DataStore.Models;
    using DataStore.Repositories;
    using DocumentDefiner.DocumentConfiguration;
    using DocumentDefiner.DocumentPartCreators.Appendix1;
    using Integration;
    using IoC;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using Optional;
    using SFA.FCT.DocumentsDomain.Common;
    using UnitTests.Common;
    using FundingStreamPeriod = DataStore.Models.FundingStreamPeriod;
    using FundingTypeFundingPeriod = ContractManagement.DataStore.Model.FundingTypeFundingPeriod;

    [TestClass]
    public class NlaAppendix1Tests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void NlaAppendix1_IsDocumentPartRequired_ShouldReturnTrue()
        {
            // arrange
            contractType corpContract = TestResource.FromJson<Contract>("SFA.FCT.DocumentsDomain.DocumentGeneration.Tests.Resources", "corpContractNla.json");
            NlaAppendix1 nLaAppendix1 = new NlaAppendix1(null, null, null, null);

            // act
            bool isDocumentPartRequired = nLaAppendix1.IsDocumentPartRequired(corpContract);

            // assert
            Assert.IsTrue(isDocumentPartRequired);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void NlaAppendix1_IsDocumentPartRequired_ShouldReturnTrueWhenFundingPeriodNONLEVY2018()
        {
            // arrange
            contractType corpContract = TestResource.FromJson<Contract>("SFA.FCT.DocumentsDomain.DocumentGeneration.Tests.Resources", "corpContractNla.json");
            NlaAppendix1 nLaAppendix1 = new NlaAppendix1(null, null, null, null);

            corpContract.period.periodType.periodTypeCode = periodTypeCodeType.NONLEVY;
            corpContract.period.period1 = "2018";

            // act
            bool isDocumentPartRequired = nLaAppendix1.IsDocumentPartRequired(corpContract);

            // assert
            Assert.IsTrue(isDocumentPartRequired);
        }

       
        [TestMethod, TestCategory("UnitTest")]
        public void NlaAppendix1_RequiredHeaderDocumentName_ShouldThrowApplicationException()
        {
            // Arrange
            var nLaAppendix1 = new NlaAppendix1(null, null, null, null);

            // Act & Assert
            Assert.ThrowsExactly<ApplicationException>(() =>
            {
                var _ = nLaAppendix1.RequiredHeaderDocumentName; // accessing the property should throw
            });
        }


        [TestMethod, TestCategory("UnitTest")]
        public void NlaAppendix1_IsHeaderDocumentRequired_ShouldReturnFalse()
        {
            // arrange
            NlaAppendix1 nLaAppendix1 = new NlaAppendix1(null, null, null, null);

            // act
            bool isHeaderDocumentRequired = nLaAppendix1.IsHeaderDocumentRequired;

            // assert
            Assert.IsFalse(isHeaderDocumentRequired);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void NlaAppendix1_ShouldUseConfigDefinedTemplate()
        {
            var fundingTypeFundingPeriodQueryRepositoryMock = new Mock<IFundingTypeFundingPeriodQueryRepository>();
            fundingTypeFundingPeriodQueryRepositoryMock
                .Setup(m => m.Get(It.IsAny<string>(), It.IsAny<string>()))
                .Returns(new FundingTypeFundingPeriod { TemplateName = "A1_NLA" });

            var templateRepository = new Mock<ITemplateRepository>();
            templateRepository
                .Setup(m => m.GetNameOfTemplateActiveOnDate(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<DateTime>()))
                .Returns((string containerName, string startsWith, DateTime contractStartDate) => startsWith);

            var nlapFundingConfigRepository = new Mock<INlapFundingConfigRepository>();
            nlapFundingConfigRepository
                .Setup(m => m.FindByUkprn(It.IsAny<int>()))
                .Returns(Option.Some(new NlapFundingConfig(12345, 1, 2, 3, 4)));

            // arrange
            NlaAppendix1 nlaAppendix1 = new NlaAppendix1(
                templateRepository.Object,
                Mock.Of<IDocumentConfigurationSource>(),
                fundingTypeFundingPeriodQueryRepositoryMock.Object,
                nlapFundingConfigRepository.Object);

            // act
            IDictionary<string, DocumentGenerationRequest> dictionary =
                nlaAppendix1.SupplyDocumentGenerationRequest("ESFA-1234", new contractType(), "template-container");

            // assert
            DocumentGenerationRequest documentGenerationRequest = dictionary.Single().Value;

            Assert.AreEqual("A1_NLA", documentGenerationRequest.TemplateFilename);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void NlaAppendix1_ShouldAddRepeatingSectionAndUseDefaultNlapFundingConfigWhenNlapFundingConfigEmpty()
        {
            var fundingTypeFundingPeriodQueryRepositoryMock = new Mock<IFundingTypeFundingPeriodQueryRepository>();
            fundingTypeFundingPeriodQueryRepositoryMock
                .Setup(m => m.Get(It.IsAny<string>(), It.IsAny<string>()))
                .Returns(new FundingTypeFundingPeriod { TemplateName = "A1_NLA" });

            var templateRepository = new Mock<ITemplateRepository>();
            templateRepository
                .Setup(m => m.GetNameOfTemplateActiveOnDate(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<DateTime>()))
                .Returns((string containerName, string startsWith, DateTime contractStartDate) => startsWith);

            var nlapFundingConfigRepository = new Mock<INlapFundingConfigRepository>();
            nlapFundingConfigRepository
                .Setup(m => m.FindByUkprn(It.IsAny<int>()))
                .Returns(Option.None<NlapFundingConfig>());

            // arrange
            NlaAppendix1 nlaAppendix1 = new NlaAppendix1(
                templateRepository.Object,
                Mock.Of<IDocumentConfigurationSource>(),
                fundingTypeFundingPeriodQueryRepositoryMock.Object,
                nlapFundingConfigRepository.Object);

            // act
            IDictionary<string, DocumentGenerationRequest> dictionary =
                nlaAppendix1.SupplyDocumentGenerationRequest("ESFA-1234", new contractType(), "template-container");

            // assert
            DocumentGenerationRequest documentGenerationRequest = dictionary.Single().Value;

            Assert.AreEqual(2, documentGenerationRequest.MergeData.RepeatingSections.Count, "Unexpected number of reprating sections");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void NlaAppendix1_SupplyDocumentGenerationRequest_ShouldReturnExpectedDocumentGenerationRequest()
        {
            // arrange
            contractType corpContract = TestResource.FromJson<Contract>("SFA.FCT.DocumentsDomain.DocumentGeneration.Tests.Resources", "corpContractNla.json");
            IDictionary<string, DocumentGenerationRequest> documentGenerationRequests;

            using (DocumentsDomainDbContext context = new DocumentsDomainDbContext())
            {
                context.NlapFundingConfigs.RemoveWhere(n => n.Ukprn == corpContract.contractor.ukprn);
                context.NlapFundingConfigs.Add(new NlapFundingConfig(
                    corpContract.contractor.ukprn, 100, 200, 300, 400));
                context.SaveChanges();
            }

            using (IWindsorContainer container = GetDocumentGenerationEndpointContainer())
            using (container.BeginScope())
            {
                NlaAppendix1 nLaAppendix1 = new NlaAppendix1(
                    container.Resolve<ITemplateRepository>(),
                    new TestDocumentConfigurationSource(container.Resolve<IFundingStreamPeriodRepository>(), container.Resolve<IFspDeliverableRepository>()),
                    container.Resolve<IFundingTypeFundingPeriodQueryRepository>(),
                    container.Resolve<INlapFundingConfigRepository>());

                // act
                documentGenerationRequests = nLaAppendix1.SupplyDocumentGenerationRequest("TestMasterContractNumber", corpContract, ConfigurationManager.AppSettings["DocumentGeneration.TemplateContainer"]);
            }

            // assert
            Assert.IsNotNull(documentGenerationRequests, "Return value was null");
            Assert.AreEqual(1, documentGenerationRequests.Count, "Unexpected number of requests returned");
            Assert.IsTrue(documentGenerationRequests.ContainsKey("1000"), "Request keyed by 1000 was not returned");

            List<MergeFieldType> mergeFields = documentGenerationRequests["1000"].MergeData.MergeFields;

            Assert.AreEqual("100639.00", mergeFields.Single(x => x.Name == "ContractTotal").Value, "Incorrect value for 'Total Funding for this contract'");
            Assert.AreEqual("TestMasterContractNumber", mergeFields.Single(x => x.Name == "MasterContractRef").Value, "Incorrect value for 'Master Contract ref:'");
            Assert.AreEqual("10000123", mergeFields.Single(x => x.Name == "UKPRN").Value, "Incorrect value for 'UKPRN'");
            Assert.AreEqual("TEST TRAINING COLLEGE", mergeFields.Single(x => x.Name == "OrgName").Value, "Incorrect value for 'Organisation Name'");

            List<RowType> mainTableRows = documentGenerationRequests["1000"].MergeData.RepeatingSections.Single(rs => rs.Name == "MainTable").Rows;
            Assert.AreEqual(2, mainTableRows.Count, "The number of rows in the MainTable is incorrect");

            RowType row1618NonLevyApprenticeshipsMainTable = mainTableRows[0];
            Assert.AreEqual($"16-18 Non-Levy Apprenticeships{Environment.NewLine}{Constants.IndentTextMarker}of which New Starts", row1618NonLevyApprenticeshipsMainTable.MergeFields.Single(mf => mf.Name == "AllocName").Value, "Incorrect allocation name for allocation '16-18 Non-Levy Apprenticeships'");
            Assert.AreEqual("YNLP-1000", row1618NonLevyApprenticeshipsMainTable.MergeFields.Single(mf => mf.Name == "AllocRef").Value, "Incorrect Contract Ref for allocation '16-18 Non-Levy Apprenticeships'");
            Assert.AreEqual("8109.00", row1618NonLevyApprenticeshipsMainTable.MergeFields.Single(mf => mf.Name == "Jan18ToMar18").Value, "Incorrect value for 'Jan 18 - Mar 18' value  for allocation '16-18 Non-Levy Apprenticeships'");
            Assert.AreEqual("21299.00", row1618NonLevyApprenticeshipsMainTable.MergeFields.Single(mf => mf.Name == "Apr18ToMar19").Value, "Incorrect value for 'Apr 18 - Mar 19' value for allocation '16-18 Non-Levy Apprenticeships'");
            Assert.AreEqual("21300.00", row1618NonLevyApprenticeshipsMainTable.MergeFields.Single(mf => mf.Name == "Apr19ToMar20").Value, "Incorrect value for 'Apr 19 - Mar 20' value for allocation '16-18 Non-Levy Apprenticeships'");
            Assert.AreEqual($"£0{Environment.NewLine}£100", row1618NonLevyApprenticeshipsMainTable.MergeFields.Single(mf => mf.Name == "Apr20ToMar21").Value, "Incorrect value for 'Apr 20 - Mar 21' value for allocation '16-18 Non-Levy Apprenticeships'");
            Assert.AreEqual($"£50,708{Environment.NewLine}£100", row1618NonLevyApprenticeshipsMainTable.MergeFields.Single(mf => mf.Name == "TotalFunding").Value, "Incorrect value for 'Total' value for allocation '16-18 Non-Levy Apprenticeships'");

            RowType rowAdultNonLevyApprenticeshipsMainTable = mainTableRows[1];
            Assert.AreEqual($"Adult Non-Levy Apprenticeships{Environment.NewLine}{Constants.IndentTextMarker}of which New Starts", rowAdultNonLevyApprenticeshipsMainTable.MergeFields.Single(mf => mf.Name == "AllocName").Value, "Incorrect allocation name for allocation 'Adult Non-Levy Apprenticeships'");
            Assert.AreEqual("ANLP-1000", rowAdultNonLevyApprenticeshipsMainTable.MergeFields.Single(mf => mf.Name == "AllocRef").Value, "Incorrect Contract Ref for allocation 'Adult Non-Levy Apprenticeships'");
            Assert.AreEqual("9748.00", rowAdultNonLevyApprenticeshipsMainTable.MergeFields.Single(mf => mf.Name == "Jan18ToMar18").Value, "Incorrect value for 'Jan 18 - Mar 18' value for allocation 'Adult Non-Levy Apprenticeships'");
            Assert.AreEqual("20091.00", rowAdultNonLevyApprenticeshipsMainTable.MergeFields.Single(mf => mf.Name == "Apr18ToMar19").Value, "Incorrect value for 'Apr 18 - Mar 19' value for allocation 'Adult Non-Levy Apprenticeships'");
            Assert.AreEqual("20092.00", rowAdultNonLevyApprenticeshipsMainTable.MergeFields.Single(mf => mf.Name == "Apr19ToMar20").Value, "Incorrect value for 'Apr 19 - Mar 20' value for allocation 'Adult Non-Levy Apprenticeships'");
            Assert.AreEqual($"£0{Environment.NewLine}£200", rowAdultNonLevyApprenticeshipsMainTable.MergeFields.Single(mf => mf.Name == "Apr20ToMar21").Value, "Incorrect value for 'Apr 20 - Mar 21' value for allocation 'Adult Non-Levy Apprenticeships'");
            Assert.AreEqual($"£49,931{Environment.NewLine}£200", rowAdultNonLevyApprenticeshipsMainTable.MergeFields.Single(mf => mf.Name == "TotalFunding").Value, "Incorrect value for 'Total' value for allocation 'Adult Non-Levy Apprenticeships'");

            List<RowType> futureFundingTableRows = documentGenerationRequests["1000"].MergeData.RepeatingSections.Single(rs => rs.Name == "FutureFundingTable").Rows;
            Assert.AreEqual(2, futureFundingTableRows.Count, "The number of rows in the FutureFundingTable is incorrect");

            RowType row1618NonLevyApprenticeshipsFutureFundingTable = futureFundingTableRows[0];
            Assert.AreEqual("16-18 Non-Levy Apprenticeships", row1618NonLevyApprenticeshipsFutureFundingTable.MergeFields.Single(mf => mf.Name == "AllocName").Value, "Incorrect AllocName mergefield for allocation '16-18 Non-Levy Apprenticeships' in Future Funding table");
            Assert.AreEqual("300.00", row1618NonLevyApprenticeshipsFutureFundingTable.MergeFields.Single(mf => mf.Name == "FutureFundingNewStarts").Value, "Incorrect FutureFundingNewStarts mergefield for allocation '16-18 Non-Levy Apprenticeships' in Future Funding table");

            RowType rowAdultNonLevyApprenticeshipsFutureFundingTable = futureFundingTableRows[1];
            Assert.AreEqual("Adult Non-Levy Apprenticeships", rowAdultNonLevyApprenticeshipsFutureFundingTable.MergeFields.Single(mf => mf.Name == "AllocName").Value, "Incorrect AllocName mergefield for allocation 'Adult Non-Levy Apprenticeships' in Future Funding table");
            Assert.AreEqual("400.00", rowAdultNonLevyApprenticeshipsFutureFundingTable.MergeFields.Single(mf => mf.Name == "FutureFundingNewStarts").Value, "Incorrect FutureFundingNewStarts mergefield for allocation 'Adult Non-Levy Apprenticeships' in Future Funding table");

            using (DocumentsDomainDbContext context = new DocumentsDomainDbContext())
            {
                context.NlapFundingConfigs.RemoveWhere(n => n.Ukprn == corpContract.contractor.ukprn);
                context.SaveChanges();
            }
        }

        private static IWindsorContainer GetDocumentGenerationEndpointContainer()
        {
            return WindsorInstallerForDocumentGenerator.Container;
        }

        private class TestDocumentConfigurationSource : DocumentConfigurationSource
        {
            public TestDocumentConfigurationSource(IFundingStreamPeriodRepository fundingStreamPeriodRepository, IFspDeliverableRepository fspDeliverableRepository) : base(fundingStreamPeriodRepository, fspDeliverableRepository, new FundingTypeFundingPeriodRepository(new DocumentsDomainDbContext()))
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
