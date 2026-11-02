namespace SFA.FCT.DocumentsDomain.DocumentGeneration.Tests.TsAndCs
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Common.Models;
    using ContractManagement.DataStore.Model;
    using ContractManagement.DataStore.Repositories;
    using CrossDomain.Integration.Entities.CorporateContract;
    using DocumentDefiner.DocumentConfiguration;
    using DocumentDefiner.DocumentPartCreators.TsAndCs;
    using FluentAssertions;
    using Integration;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;

    [TestClass]
    public class LevyTsAndCsAmendmentTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void LevyTsAndCsAmendmentTest_ShouldCreate2DocumentGenerationRequestsWhenAmendmentAndMergeRequired()
        {
            // arrange
            Mock<IFundingTypeFundingPeriodQueryRepository> fundingTypeFundingPeriodRepMock = new Mock<IFundingTypeFundingPeriodQueryRepository>();
            const string amendmentTemplatePrefix = "AmendmentTemplate";
            string amendmentTemplateName = amendmentTemplatePrefix + "last bit.docx";
            fundingTypeFundingPeriodRepMock.Setup(r => r.Get(It.IsAny<string>(), It.IsAny<string>()))
                .Returns(new FundingTypeFundingPeriod
                {
                    TemplateName = "TsAndCs",
                    AmendmentTemplate = amendmentTemplatePrefix
                });

            Mock<ITemplateRepository> templateRepositoryMock = new Mock<ITemplateRepository>();
            templateRepositoryMock.Setup(r =>
                    r.GetNameOfTemplateActiveOnDate(It.IsAny<string>(), amendmentTemplatePrefix, It.IsAny<DateTime>()))
                .Returns(amendmentTemplateName);

            LEVYTermsAndConditionsDocumentPartCreator creator = new LEVYTermsAndConditionsDocumentPartCreator(
                templateRepositoryMock.Object, 
                Mock.Of<IDocumentConfigurationSource>(),
                fundingTypeFundingPeriodRepMock.Object);

            // act
            var docGenRequestDictionary = creator.SupplyDocumentGenerationRequest("Master", new contractType
                {
                    IsAmendment = true,
                    contractAllocations = new List<contractAllocationsContractAllocation>
                    {
                        new contractAllocationsContractAllocation()
                    },
                    ShouldMergeAmendmentTemplate = true
                },
                "templateContainerName");

            // assert
            Assert.AreEqual(2, docGenRequestDictionary.Count);
            KeyValuePair<string, DocumentGenerationRequest>[] orderedDocs = docGenRequestDictionary.OrderBy(d => d.Key).ToArray();
            Assert.AreEqual(amendmentTemplateName, orderedDocs[0].Value.TemplateFilename, "The amendment template name should be first");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void LevyTsAndCsAmendmentTest_ShouldCreate1DocumentGenerationRequestUsingAmendmentTemplateWhenMergeNotRequired()
        {
            // arrange
            Mock<IFundingTypeFundingPeriodQueryRepository> fundingTypeFundingPeriodRepMock = new Mock<IFundingTypeFundingPeriodQueryRepository>();
            const string amendmentTemplatePrefix = "AmendmentTemplate";
            string templateName = amendmentTemplatePrefix + "last bit.docx";
            fundingTypeFundingPeriodRepMock.Setup(r => r.Get(It.IsAny<string>(), It.IsAny<string>()))
                .Returns(new FundingTypeFundingPeriod
                {
                    TemplateName = "TsAndCs",
                    AmendmentTemplate = amendmentTemplatePrefix
                });

            Mock<ITemplateRepository> templateRepositoryMock = new Mock<ITemplateRepository>();
            templateRepositoryMock.Setup(r =>
                    r.GetNameOfTemplateActiveOnDate(It.IsAny<string>(), amendmentTemplatePrefix, It.IsAny<DateTime>()))
                .Returns(templateName);

            LEVYTermsAndConditionsDocumentPartCreator creator = new LEVYTermsAndConditionsDocumentPartCreator(
                templateRepositoryMock.Object,
                Mock.Of<IDocumentConfigurationSource>(),
                fundingTypeFundingPeriodRepMock.Object);

            // act
            var docGenRequestDictionary = creator.SupplyDocumentGenerationRequest("Master", new contractType
                {
                    IsAmendment = true,
                    contractAllocations = new List<contractAllocationsContractAllocation>
                    {
                        new contractAllocationsContractAllocation()
                    },
                    ShouldMergeAmendmentTemplate = false
                },
                "templateContainerName");

            // assert
            Assert.AreEqual(1, docGenRequestDictionary.Count, "The number of doc gen requests is not correct");
            Assert.AreEqual(templateName, docGenRequestDictionary.First().Value.TemplateFilename, "The template is not correct");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void LevyTsAndCsAmendmentTest_SupplyDocumentGenerationRequest_ShouldUseOverrideWhenSpecified()
        {
            // arrange
            const string amendmentTemplatePrefix = "LEVY1799_Amendment"; // this is called AmendmentTemplate in the db
            const string standardLetter = "LEVY1799_Amendment.docx";
            const string amendmentTemplateOverridePrefix = "LEVY1799_Amendment2";
            const string amendmentTemplateOverride = "LEVY1799_Amendment2.docx";
            const string agreementPrefix = "T&C_LEVY"; // this is called Template name in the db
            const string standardAgreement = "T&C_LEVY_2017-05-01.docx";
            const string agreementOverridePrefix = "T&C_LEVY2";
            const string standardAgreementOverride = "T&C_LEVY2_2017-05-01.docx";
            Mock<IFundingTypeFundingPeriodQueryRepository> fundingTypeFundingPeriodRepMock = new Mock<IFundingTypeFundingPeriodQueryRepository>();
            
            fundingTypeFundingPeriodRepMock.Setup(r => r.Get(It.IsAny<string>(), It.IsAny<string>()))
                .Returns(new FundingTypeFundingPeriod
                {
                    TemplateName = agreementPrefix,
                    AmendmentTemplate = amendmentTemplatePrefix
                });

            Mock<ITemplateRepository> templateRepositoryMock = new Mock<ITemplateRepository>();
            templateRepositoryMock.Setup(r =>
                    r.GetNameOfTemplateActiveOnDate(It.IsAny<string>(), agreementPrefix, It.IsAny<DateTime>()))
                .Returns(standardAgreement);
            templateRepositoryMock.Setup(r =>
                    r.GetNameOfTemplateActiveOnDate(It.IsAny<string>(), amendmentTemplatePrefix, It.IsAny<DateTime>()))
                .Returns(standardLetter);
            templateRepositoryMock.Setup(r =>
                    r.GetNameOfTemplateActiveOnDate(It.IsAny<string>(), agreementOverridePrefix, It.IsAny<DateTime>()))
                .Returns(standardAgreementOverride);
            templateRepositoryMock.Setup(r =>
                    r.GetNameOfTemplateActiveOnDate(It.IsAny<string>(), amendmentTemplateOverridePrefix, It.IsAny<DateTime>()))
                .Returns(amendmentTemplateOverride);

            LEVYTermsAndConditionsDocumentPartCreator creator = new LEVYTermsAndConditionsDocumentPartCreator(
                templateRepositoryMock.Object,
                Mock.Of<IDocumentConfigurationSource>(),
                fundingTypeFundingPeriodRepMock.Object);
            var inputsWithResult =
                new List<(bool shouldMergeAmendmentTemplate,
                          string overrideLetterTemplate,
                          string overrideAgreementTemplate,
                          List<string> resultDocs)>
                {
                    (true, string.Empty, string.Empty, new List<string>{standardLetter, standardAgreement}),
                    (true, string.Empty, overrideAgreementTemplate: agreementOverridePrefix, new List<string>{standardLetter, standardAgreementOverride}),
                    (true, overrideLetterTemplate:amendmentTemplateOverridePrefix, overrideAgreementTemplate: string.Empty, new List<string>{amendmentTemplateOverride, standardAgreement}),
                    (true, overrideLetterTemplate:amendmentTemplateOverridePrefix, overrideAgreementTemplate: agreementOverridePrefix, new List<string>{amendmentTemplateOverride, standardAgreementOverride}),
                    (false, string.Empty, string.Empty, new List<string>{standardLetter}),
                    (false, string.Empty, overrideAgreementTemplate: agreementOverridePrefix, new List<string>{standardLetter}),
                    (false, overrideLetterTemplate:amendmentTemplateOverridePrefix, overrideAgreementTemplate: string.Empty, new List<string>{amendmentTemplateOverride}),
                    (false, overrideLetterTemplate:amendmentTemplateOverridePrefix, overrideAgreementTemplate: agreementOverridePrefix, new List<string>{amendmentTemplateOverride}),
                };

            // act
            inputsWithResult.ForEach(i =>
            {
                var docGenRequestDictionary = creator.SupplyDocumentGenerationRequest("Master", new contractType
                    {
                        IsAmendment = true,
                        contractAllocations = new List<contractAllocationsContractAllocation>
                        {
                            new contractAllocationsContractAllocation()
                        },
                        ShouldMergeAmendmentTemplate = i.shouldMergeAmendmentTemplate,
                        OverrideAmendmentTemplate = i.overrideLetterTemplate,
                        OverrideTemplateName = i.overrideAgreementTemplate
                },
                    "templateContainerName");

                // assert
                KeyValuePair<string, DocumentGenerationRequest>[] orderedDocs = docGenRequestDictionary.OrderBy(d => d.Key).ToArray();
                i.resultDocs.Select((doc, index) => new {doc, index}).ToList().ForEach(resultDoc =>
                {
                    resultDoc.doc.ShouldBeEquivalentTo(orderedDocs[resultDoc.index].Value.TemplateFilename, $"index of failure: {resultDoc.index}");
                });
            });
            
        }

        [TestMethod, TestCategory("UnitTest")]
        public void LevyTsAndCsAmendmentTest_SupplyDocumentGenerationRequest_ShouldPopulateTerminationDate_WhenLastApprovedUnderTermination()
        {
            // arrange
            const string overrideAmendmentTemplate = "OAT";
            const string overrideTemplateName = "OTN";
            const string amendmentTemplate = "AT";
            const string templateNamePrefix = "TsAndCs";
            DateTime terminationDate = new DateTime(2022, 01, 01);
            Mock<IFundingTypeFundingPeriodQueryRepository> fundingTypeFundingPeriodRepMock = new Mock<IFundingTypeFundingPeriodQueryRepository>();

            string amendmentTemplateName = overrideAmendmentTemplate + "last bit.docx";
            string templateName = templateNamePrefix + "last bit.docx";
            fundingTypeFundingPeriodRepMock.Setup(r => r.Get(It.IsAny<string>(), It.IsAny<string>()))
                .Returns(new FundingTypeFundingPeriod
                {
                    TemplateName = templateNamePrefix,
                    AmendmentTemplate = amendmentTemplate
                });

            Mock<ITemplateRepository> templateRepositoryMock = new Mock<ITemplateRepository>();
            templateRepositoryMock.Setup(r =>
                    r.GetNameOfTemplateActiveOnDate(It.IsAny<string>(), overrideAmendmentTemplate, It.IsAny<DateTime>()))
                .Returns(amendmentTemplateName);
            templateRepositoryMock.Setup(r =>
                    r.GetNameOfTemplateActiveOnDate(It.IsAny<string>(), overrideTemplateName, It.IsAny<DateTime>()))
                .Returns(templateName);

            LEVYTermsAndConditionsDocumentPartCreator creator = new LEVYTermsAndConditionsDocumentPartCreator(
                templateRepositoryMock.Object,
                Mock.Of<IDocumentConfigurationSource>(),
                fundingTypeFundingPeriodRepMock.Object);

            // act
            var docGenRequestDictionary = creator.SupplyDocumentGenerationRequest("Master", new contractType
            {
                IsAmendment = true,
                contractAllocations = new List<contractAllocationsContractAllocation>
                    {
                        new contractAllocationsContractAllocation()
                    },
                ShouldMergeAmendmentTemplate = true,
                OverrideAmendmentTemplate = overrideAmendmentTemplate,
                OverrideTemplateName = overrideTemplateName,
                IsLastApprovedUnderTermination = true,
                LastApprovedTerminationDate = terminationDate
            },
                "templateContainerName");

            // assert
            Assert.AreEqual(2, docGenRequestDictionary.Count);
            docGenRequestDictionary.First().Value.MergeData.MergeFields.Any(f => f.Name == "TerminationDate").Should()
                .BeTrue();
            docGenRequestDictionary.First().Value.MergeData.MergeFields.Single(f => f.Name == "TerminationDate").Value
                .Should().Be("1 January 2022");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void LevyTsAndCsAmendmentTest_SupplyDocumentGenerationRequest_ShouldPopulateTerminationDateWithEmpty_WhenLastApprovedNotUnderTermination()
        {
            // arrange
            const string overrideAmendmentTemplate = "OAT";
            const string overrideTemplateName = "OTN";
            const string amendmentTemplate = "AT";
            const string templateNamePrefix = "TsAndCs";
            DateTime terminationDate = new DateTime(2022, 01, 01);
            Mock<IFundingTypeFundingPeriodQueryRepository> fundingTypeFundingPeriodRepMock = new Mock<IFundingTypeFundingPeriodQueryRepository>();

            string amendmentTemplateName = overrideAmendmentTemplate + "last bit.docx";
            string templateName = templateNamePrefix + "last bit.docx";
            fundingTypeFundingPeriodRepMock.Setup(r => r.Get(It.IsAny<string>(), It.IsAny<string>()))
                .Returns(new FundingTypeFundingPeriod
                {
                    TemplateName = templateNamePrefix,
                    AmendmentTemplate = amendmentTemplate
                });

            Mock<ITemplateRepository> templateRepositoryMock = new Mock<ITemplateRepository>();
            templateRepositoryMock.Setup(r =>
                    r.GetNameOfTemplateActiveOnDate(It.IsAny<string>(), overrideAmendmentTemplate, It.IsAny<DateTime>()))
                .Returns(amendmentTemplateName);
            templateRepositoryMock.Setup(r =>
                    r.GetNameOfTemplateActiveOnDate(It.IsAny<string>(), overrideTemplateName, It.IsAny<DateTime>()))
                .Returns(templateName);

            LEVYTermsAndConditionsDocumentPartCreator creator = new LEVYTermsAndConditionsDocumentPartCreator(
                templateRepositoryMock.Object,
                Mock.Of<IDocumentConfigurationSource>(),
                fundingTypeFundingPeriodRepMock.Object);

            // act
            var docGenRequestDictionary = creator.SupplyDocumentGenerationRequest("Master", new contractType
            {
                IsAmendment = true,
                contractAllocations = new List<contractAllocationsContractAllocation>
                    {
                        new contractAllocationsContractAllocation()
                    },
                ShouldMergeAmendmentTemplate = true,
                OverrideAmendmentTemplate = overrideAmendmentTemplate,
                OverrideTemplateName = overrideTemplateName,
                IsLastApprovedUnderTermination = false
            },
                "templateContainerName");

            // assert
            Assert.AreEqual(2, docGenRequestDictionary.Count);
            docGenRequestDictionary.First().Value.MergeData.MergeFields.Any(f => f.Name == "TerminationDate").Should()
                .BeTrue();
            docGenRequestDictionary.First().Value.MergeData.MergeFields.Single(f => f.Name == "TerminationDate").Value
                .Should().Be(string.Empty);
        }
    }
}
