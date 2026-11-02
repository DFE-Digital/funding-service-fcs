namespace SFA.FCT.DocumentsDomain.DocumentGeneration.Tests.TsAndCs
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Common.Models;
    using CrossDomain.Integration.Entities.CorporateContract;
    using DataStore.Models;
    using DataStore.Repositories;
    using DocumentDefiner.DocumentConfiguration;
    using DocumentDefiner.DocumentPartCreators.TsAndCs;
    using DocumentGeneration.Repositories;
    using Integration;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using Castle.MicroKernel.Lifestyle;
    using Castle.Windsor;
    using DocumentGeneration.Services;
    
    [TestClass]
    public class EdskSchedule2DocumentPartCreatorTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void EdskSchedule2DocumentPartCreator_ShouldResolve()
        {
            IWindsorContainer container = SFA.FCT.DocumentsDomain.DocumentGeneration.IoC
                .WindsorInstallerForDocumentGenerator.Container;
            container.BeginScope();

            // act
            var docPartCreator = container.Resolve<EdskSchedule2DocumentPartCreator>();

            Assert.IsNotNull(docPartCreator);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void EdskSchedule2DocumentPartCreator_SupplyDocumentGenerationRequest_ShouldReturnDocumentGenerationRequestWithOne()
        {
            // arrange
            var documentTemplateRepositoryMock = new Mock<IFspGroupDocumentTemplateRepository>();
            documentTemplateRepositoryMock
                .Setup(m => m.GetByKeyOrUseDefaultForContractType(It.IsAny<string>(), It.IsAny<string>(),
                    It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>()))
                .Returns(new FspGroupDocumentTemplate(string.Empty, string.Empty, string.Empty,
                    string.Empty, string.Empty, string.Empty));


            var templateRepositoryMock = new Mock<ITemplateRepository>();
            templateRepositoryMock
                .Setup(m => m.GetNameOfTemplateActiveOnDate(string.Empty, string.Empty,
                    DateTime.Now))
                .Returns(string.Empty);

            var templateVersionCheckerMock = new Mock<ITemplateVersionChecker>();
            templateVersionCheckerMock
                .Setup(c => c.ShouldIncludeTemplate(It.IsAny<string>(), It.IsAny<DateTime?>(), It.IsAny<bool>()))
                .Returns(true);

            var fundingStreamPeriodRepositoryMock = new Mock<IFundingStreamPeriodRepository>();
            fundingStreamPeriodRepositoryMock.Setup(r => r.GetFspGroups(It.IsAny<IReadOnlyCollection<string>>()))
                .Returns(new List<FSPGroup> { new FSPGroup("", "", 1) });

            var creator = new EdskSchedule2DocumentPartCreator(
                templateRepositoryMock.Object,
                Mock.Of<IDocumentConfigurationSource>(),
                documentTemplateRepositoryMock.Object,
                Mock.Of<IFundingTypeFundingPeriodContractTypeRepository>(),
                fundingStreamPeriodRepositoryMock.Object,
                templateVersionCheckerMock.Object);

            // act
            IDictionary<string, DocumentGenerationRequest> documentGenerationRequests = creator.SupplyDocumentGenerationRequest(
                "MASTER-123",
                new contractType
                {
                    fundingType = new fundingType(),
                    period = new period(),
                    startDate = DateTime.Now,
                    contractType1 = string.Empty
                },
                string.Empty);

            // assert
            Assert.IsNotNull(documentGenerationRequests, "Unexpected null result returned");
            Assert.AreEqual(1, documentGenerationRequests.Count, "Unexpected number of DocumentGenerationRequest instances returned");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void EdskSchedule2DocumentPartCreator_SupplyDocumentGenerationRequest_ShouldReturnDocumentGenerationRequestWithNone()
        {
            // arrange
            var documentTemplateRepositoryMock = new Mock<IFspGroupDocumentTemplateRepository>();
            documentTemplateRepositoryMock
                .Setup(m => m.GetByKeyOrUseDefaultForContractType(It.IsAny<string>(), It.IsAny<string>(),
                    It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>()))
                .Returns(new FspGroupDocumentTemplate(string.Empty, string.Empty, string.Empty,
                    string.Empty, string.Empty, string.Empty));


            var templateRepositoryMock = new Mock<ITemplateRepository>();
            templateRepositoryMock
                .Setup(m => m.GetNameOfTemplateActiveOnDate(string.Empty, string.Empty,
                    DateTime.Now))
                .Returns(string.Empty);

            var templateVersionCheckerMock = new Mock<ITemplateVersionChecker>();
            templateVersionCheckerMock
                .Setup(c => c.ShouldIncludeTemplate(It.IsAny<string>(), It.IsAny<DateTime?>(), It.IsAny<bool>()))
                .Returns(false);

            var fundingStreamPeriodRepositoryMock = new Mock<IFundingStreamPeriodRepository>();
            fundingStreamPeriodRepositoryMock.Setup(r => r.GetFspGroups(It.IsAny<IReadOnlyCollection<string>>()))
                .Returns(new List<FSPGroup> { new FSPGroup("", "", 1) });

            var creator = new EdskSchedule2DocumentPartCreator(
                templateRepositoryMock.Object,
                Mock.Of<IDocumentConfigurationSource>(),
                documentTemplateRepositoryMock.Object,
                Mock.Of<IFundingTypeFundingPeriodContractTypeRepository>(),
                fundingStreamPeriodRepositoryMock.Object,
                templateVersionCheckerMock.Object);

            // act
            IDictionary<string, DocumentGenerationRequest> documentGenerationRequests = creator.SupplyDocumentGenerationRequest(
                "MASTER-123",
                new contractType
                {
                    fundingType = new fundingType(),
                    period = new period(),
                    startDate = DateTime.Now,
                    contractType1 = string.Empty
                },
                string.Empty);

            // assert
            Assert.IsNotNull(documentGenerationRequests, "Unexpected null result returned");
            Assert.AreEqual(0, documentGenerationRequests.Count, "Unexpected number of DocumentGenerationRequest instances returned");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void EdskSchedule2DocumentPartCreator_IsDocumentPartRequired_ShouldReturnTrueWhenFundingTypeIsDadaAndIsAmendmentIsTrue()
        {
            // arrange
            EdskSchedule2DocumentPartCreator creator = new EdskSchedule2DocumentPartCreator(
                Mock.Of<ITemplateRepository>(),
                Mock.Of<IDocumentConfigurationSource>(),
                Mock.Of<IFspGroupDocumentTemplateRepository>(),
                Mock.Of<IFundingTypeFundingPeriodContractTypeRepository>(),
                Mock.Of<IFundingStreamPeriodRepository>(),
                Mock.Of<ITemplateVersionChecker>());

            // act
            bool isDocumentPartRequired = creator.IsDocumentPartRequired(new contractType
            {
                IsAmendment = true,
                fundingType = new fundingType
                {
                    fundingTypeCode = "DADA"
                }
            });

            // assert
            Assert.IsTrue(isDocumentPartRequired);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void EdskSchedule2DocumentPartCreator_IsDocumentPartRequired_ShouldReturnTrueWhenFundingTypeIsDadaAndIsNewRevisedNewOrUpdateDraftIsTrue()
        {
            // arrange
            EdskSchedule2DocumentPartCreator creator = new EdskSchedule2DocumentPartCreator(
                Mock.Of<ITemplateRepository>(),
                Mock.Of<IDocumentConfigurationSource>(),
                Mock.Of<IFspGroupDocumentTemplateRepository>(),
                Mock.Of<IFundingTypeFundingPeriodContractTypeRepository>(),
                Mock.Of<IFundingStreamPeriodRepository>(),
                Mock.Of<ITemplateVersionChecker>());

            // act
            bool isDocumentPartRequired = creator.IsDocumentPartRequired(new contractType
            {
                IsNewRevisedNewOrUpdateDraft = true,
                fundingType = new fundingType
                {
                    fundingTypeCode = "DADA"
                }
            });

            // assert
            Assert.IsTrue(isDocumentPartRequired);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void EdskSchedule2DocumentPartCreator_IsDocumentPartRequired_ShouldReturnFalseWhenFundingTypeIsDadaAndBothIsAmendmentAndIsNewRevisedNewOrUpdateDraftAreFalse()
        {
            // arrange
            EdskSchedule2DocumentPartCreator creator = new EdskSchedule2DocumentPartCreator(
                Mock.Of<ITemplateRepository>(),
                Mock.Of<IDocumentConfigurationSource>(),
                Mock.Of<IFspGroupDocumentTemplateRepository>(),
                Mock.Of<IFundingTypeFundingPeriodContractTypeRepository>(),
                Mock.Of<IFundingStreamPeriodRepository>(),
                Mock.Of<ITemplateVersionChecker>());

            // act
            bool isDocumentPartRequired = creator.IsDocumentPartRequired(new contractType
            {
                IsAmendment = false,
                IsNewRevisedNewOrUpdateDraft = false,
                fundingType = new fundingType
                {
                    fundingTypeCode = "DADA"
                }
            });

            // assert
            Assert.IsFalse(isDocumentPartRequired);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void EdskSchedule2DocumentPartCreator_SupplyDocumentGenerationRequest_ShouldReturnDocPartWhenFspGroupAddedSinceLastApprovedContract()
        {
            // arrange
            const string fspCode1 = "FSP1";
            const string fspCode2 = "FSP2";
            const string fspGroupCode1 = "FSPGROUP1";
            const string fspGroupCode2 = "FSPGROUP2";

            Mock<IFspGroupDocumentTemplateRepository> documentTemplateRepositoryMock = new Mock<IFspGroupDocumentTemplateRepository>();
            documentTemplateRepositoryMock
                .Setup(m => m.GetByKeyOrUseDefaultForContractType(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>()))
                .Returns(new FspGroupDocumentTemplate("EDSK", "AY2021", "S1", fspGroupCode1, "", ""));

            Mock<IFundingStreamPeriodRepository> fundingStreamPeriodRepositoryMock = new Mock<IFundingStreamPeriodRepository>();
            fundingStreamPeriodRepositoryMock
                .Setup(m => m.GetFspGroups(It.IsAny<IReadOnlyCollection<string>>()))
                .Returns(new List<FSPGroup>
                {
                    new FSPGroup(fspGroupCode1, "", 1),
                    new FSPGroup(fspGroupCode2, "", 2)
                });
            fundingStreamPeriodRepositoryMock
                .Setup(m => m.GetFspsWithGroups(It.IsAny<IEnumerable<string>>()))
                .Returns(new List<DataStore.Models.FundingStreamPeriod>
                {
                    new DataStore.Models.FundingStreamPeriod(fspCode1, "", 1, true, true, "", "", fspGroupCode1, "") {FspGroup = new FSPGroup(fspGroupCode1, "", 1)},
                    new DataStore.Models.FundingStreamPeriod(fspCode2, "", 1, true, true, "", "", fspGroupCode2, "") {FspGroup = new FSPGroup(fspGroupCode2, "", 1)}
                }); ;

            Mock<ITemplateVersionChecker> templateVersionCheckerMock = new Mock<ITemplateVersionChecker>();
            templateVersionCheckerMock
                .Setup(c => c.ShouldIncludeTemplate(It.IsAny<string>(), It.IsAny<DateTime?>(), It.IsAny<bool>()))
                .Returns(false);

            EdskSchedule2DocumentPartCreator creator = new EdskSchedule2DocumentPartCreator(
                Mock.Of<ITemplateRepository>(),
                Mock.Of<IDocumentConfigurationSource>(),
                documentTemplateRepositoryMock.Object,
                Mock.Of<IFundingTypeFundingPeriodContractTypeRepository>(),
                fundingStreamPeriodRepositoryMock.Object,
                templateVersionCheckerMock.Object);

            contractType contract = new contractType
            {
                fundingType = new fundingType { fundingTypeCode = "EDSK" },
                period = new period
                {
                    periodType = new periodTypeType { periodTypeCode = periodTypeCodeType.AY },
                    period1 = "2021"
                },
                startDate = new DateTime(2020, 08, 01, 0, 0, 0, DateTimeKind.Utc),
                contractType1 = "Conditions of Funding (Grant) (College)",
                IsAmendment = true,
                IsVariation = true,
                contractAllocations = new List<contractAllocationsContractAllocation>
                {
                    new contractAllocationsContractAllocation {fundingStreamPeriodCode = fspCode1, HasBeenAdded = false},
                    new contractAllocationsContractAllocation {fundingStreamPeriodCode = fspCode2, HasBeenAdded = true}
                }
            };

            // act
            IDictionary<string, DocumentGenerationRequest> documentGenerationRequests =
                creator.SupplyDocumentGenerationRequest("MASTER-123", contract, "TEMPLATE-CONTAINER");

            // assert
            Assert.IsFalse(documentGenerationRequests.Any(d => d.Value.FspGroupCode == fspGroupCode1), "A document part was returned for an FSP Group that was on the last approved contract");
            Assert.IsTrue(documentGenerationRequests.Any(d => d.Value.FspGroupCode == fspGroupCode2), "A document part was not returned for an FSP Group that was not on the last approved contract");
        }

        //    [TestMethod, TestCategory("UnitTest")]
        //    public void EdskSchedule2DocumentPartCreator_IsHeaderDocumentRequired_ShouldReturnFalse()
        //    {
        //        // arrange
        //        EdskSchedule2DocumentPartCreator creator = new EdskSchedule2DocumentPartCreator(
        //            Mock.Of<ITemplateRepository>(),
        //            Mock.Of<IDocumentConfigurationSource>(),
        //            Mock.Of<IDocumentTemplateRepository>(),
        //            Mock.Of<IFundingTypeFundingPeriodContractTypeRepository>());

        //        // act
        //        bool isHeaderDocumentRequired = creator.IsHeaderDocumentRequired;

        //        // assert
        //        Assert.IsFalse(isHeaderDocumentRequired);
        //    }

        //    [TestMethod, TestCategory("UnitTest")]
        //    public void EdskSchedule2DocumentPartCreator_RequiredHeaderDocumentName_ShouldThrowApplicationException()
        //    {
        //        // arrange
        //        EdskSchedule2DocumentPartCreator creator = new EdskSchedule2DocumentPartCreator(
        //            Mock.Of<ITemplateRepository>(),
        //            Mock.Of<IDocumentConfigurationSource>(),
        //            Mock.Of<IDocumentTemplateRepository>(),
        //            Mock.Of<IFundingTypeFundingPeriodContractTypeRepository>());

        //        bool expectedExceptionThrown = false;

        //        // act
        //        try
        //        {
        //            string requiredHeaderDocumentName = creator.RequiredHeaderDocumentName;
        //        }
        //        catch (ApplicationException)
        //        {
        //            expectedExceptionThrown = true;
        //        }

        //        // assert
        //        Assert.IsTrue(expectedExceptionThrown);
        //    }

        //    [TestMethod, TestCategory("UnitTest")]
        //    public void EdskSchedule2DocumentPartCreator_IsDocumentPartRequired_ShouldReturnTrueWhenFundingTypeIsEdskAndIsNewRevisedNewOrUpdateDraftIsTrue()
        //    {
        //        // arrange
        //        EdskSchedule2DocumentPartCreator creator = new EdskSchedule2DocumentPartCreator(
        //            Mock.Of<ITemplateRepository>(),
        //            Mock.Of<IDocumentConfigurationSource>(),
        //            Mock.Of<IDocumentTemplateRepository>(),
        //            Mock.Of<IFundingTypeFundingPeriodContractTypeRepository>());

        //        // act
        //        bool isDocumentPartRequired = creator.IsDocumentPartRequired(new contractType
        //        {
        //            IsNewRevisedNewOrUpdateDraft = true,
        //            fundingType = new fundingType
        //            {
        //                fundingTypeCode = "EDSK",
        //            }
        //        });

        //        // assert
        //        Assert.IsTrue(isDocumentPartRequired);
        //    }

        //    [TestMethod, TestCategory("UnitTest")]
        //    public void EdskSchedule2DocumentPartCreator_IsDocumentPartRequired_ShouldReturnFalseWhenFundingTypeIsEdskAndIsNewRevisedNewOrUpdateDraftIsFalse()
        //    {
        //        // arrange
        //        EdskSchedule2DocumentPartCreator creator = new EdskSchedule2DocumentPartCreator(
        //            Mock.Of<ITemplateRepository>(),
        //            Mock.Of<IDocumentConfigurationSource>(),
        //            Mock.Of<IDocumentTemplateRepository>(),
        //            Mock.Of<IFundingTypeFundingPeriodContractTypeRepository>());

        //        // act
        //        bool isDocumentPartRequired = creator.IsDocumentPartRequired(new contractType
        //        {
        //            IsNewRevisedNewOrUpdateDraft = false,
        //            fundingType = new fundingType
        //            {
        //                fundingTypeCode = "EDSK"
        //            }
        //        });

        //        // assert
        //        Assert.IsFalse(isDocumentPartRequired);
        //    }

        //    [TestMethod, TestCategory("UnitTest")]
        //    public void EdskSchedule2DocumentPartCreator_IsDocumentPartRequired_ShouldReturnFalseWhenFundingTypeIsMain()
        //    {
        //        // arrange
        //        EdskSchedule2DocumentPartCreator creator = new EdskSchedule2DocumentPartCreator(
        //            Mock.Of<ITemplateRepository>(),
        //            Mock.Of<IDocumentConfigurationSource>(),
        //            Mock.Of<IDocumentTemplateRepository>(),
        //            Mock.Of<IFundingTypeFundingPeriodContractTypeRepository>());

        //        // act
        //        bool isDocumentPartRequired = creator.IsDocumentPartRequired(new contractType
        //        {
        //            fundingType = new fundingType
        //            {
        //                fundingTypeCode = "MAIN"
        //            }
        //        });

        //        // assert
        //        Assert.IsFalse(isDocumentPartRequired);
        //    }

        //    [TestMethod, TestCategory("UnitTest")]
        //    public void EdskTermsAndConditionsDocumentPartCreator_SupplyDocumentGenerationRequest_ShouldReturnExpectedDocumentGenerationRequest()
        //    {
        //        // arrange
        //        DateTime contractStartDate = new DateTime(2019, 08, 01, 0, 0, 0, DateTimeKind.Utc);

        //        Mock<IDocumentTemplateRepository> documentTemplateRepositoryMock = new Mock<IDocumentTemplateRepository>();
        //        documentTemplateRepositoryMock
        //            .Setup(m => m.GetByKeyOrUseDefaultForContractType(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>()))
        //            .Returns(new DocumentTemplate("EDSK", "AY1920", "S2", "Conditions of Funding (Grant) (College)", "EDSK1920_S2_LOANS_COFG"));

        //        Mock<ITemplateRepository> templateRepositoryMock = new Mock<ITemplateRepository>();
        //        templateRepositoryMock
        //            .Setup(m => m.GetNameOfTemplateActiveOnDate("TEMPLATE-CONTAINER", "EDSK1920_S2_LOANS_COFG", contractStartDate))
        //            .Returns("TEMPLATE-FILENAME");

        //        Mock<IFundingTypeFundingPeriodContractTypeRepository> fundingTypeFundingPeriodContractTypeRepositoryMock = new Mock<IFundingTypeFundingPeriodContractTypeRepository>();
        //        fundingTypeFundingPeriodContractTypeRepositoryMock
        //            .Setup(m => m.GetDefinedContractTermForProvider(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>()))
        //            .Returns("PROVIDER_TERM");


        //        EdskSchedule2DocumentPartCreator creator = new EdskSchedule2DocumentPartCreator(
        //templateRepositoryMock.Object,
        //Mock.Of<IDocumentConfigurationSource>(),
        //documentTemplateRepositoryMock.Object,
        //fundingTypeFundingPeriodContractTypeRepositoryMock.Object);

        //        // act
        //        IDictionary<string, DocumentGenerationRequest> documentGenerationRequests = creator.SupplyDocumentGenerationRequest(
        //            "MASTER-123",
        //            new contractType
        //            {
        //                fundingType = new fundingType
        //                {
        //                    fundingTypeCode = "EDSK"
        //                },
        //                period = new period
        //                {
        //                    periodType = new periodTypeType
        //                    {
        //                        periodTypeCode = periodTypeCodeType.AY
        //                    },
        //                    period1 = "1920"
        //                },
        //                startDate = contractStartDate,
        //                contractType1 = "Conditions of Funding (Grant) (College)"

        //            },
        //            "TEMPLATE-CONTAINER");

        //        // assert
        //        Assert.IsNotNull(documentGenerationRequests, "Unexpected null result returned");
        //        Assert.AreEqual(1, documentGenerationRequests.Count, "Unexpected number of DocumentGenerationRequest instances returned");
        //        Assert.AreEqual("1540", documentGenerationRequests.Single().Key, "Unexpected order string returned");

        //        DocumentGenerationRequest documentGenerationRequest = documentGenerationRequests.Single().Value;
        //        Assert.AreEqual("TEMPLATE-CONTAINER", documentGenerationRequest.TemplateContainer, "Unexpected TemplateContainer returned");
        //        Assert.AreEqual("TEMPLATE-FILENAME", documentGenerationRequest.TemplateFilename, "Unexpected TemplateFilename returned");
        //        Assert.IsNotNull(documentGenerationRequest.MergeData, "Unexpected null merge data returned");

        //        DocumentGenerationRequestMergeData mergeData = documentGenerationRequest.MergeData;
        //        Assert.AreEqual("PROVIDER_TERM", mergeData.MergeFields.SingleOrDefault(mf => mf.Name == "ProviderTerm")?.Value, "Incorrect ProviderTerm MergeField");

        //    }

        //    [TestMethod, TestCategory("UnitTest")]
        //    public void EdskSchedule2DocumentPartCreator_SupplyDocumentGenerationRequest_ShouldReturnCorrectTemplateFilenameForContractType()
        //    {
        //        // arrange
        //        Mock<IDocumentTemplateRepository> documentTemplateRepositoryMock = new Mock<IDocumentTemplateRepository>();
        //        documentTemplateRepositoryMock
        //            .Setup(m => m.GetByKeyOrUseDefaultForContractType("EDSK", "AY1920", "S2", "Conditions of Funding (Grant) (College)"))
        //            .Returns(new DocumentTemplate("EDSK", "AY1920", "S2", "Conditions of Funding (Grant) (College)", "EDSK1920_S2_LOANS_COFG"));

        //        Mock<ITemplateRepository> templateRepositoryMock = new Mock<ITemplateRepository>();
        //        templateRepositoryMock
        //            .Setup(m => m.GetNameOfTemplateActiveOnDate(It.IsAny<string>(), "EDSK1920_S2_LOANS_COFG", It.IsAny<DateTime>()))
        //            .Returns("EDSK1920_S2_LOANS_COFG_2019-08-01.docx");

        //        EdskSchedule2DocumentPartCreator creator = new EdskSchedule2DocumentPartCreator(
        //            templateRepositoryMock.Object,
        //            Mock.Of<IDocumentConfigurationSource>(),
        //            documentTemplateRepositoryMock.Object,
        //            Mock.Of<IFundingTypeFundingPeriodContractTypeRepository>());

        //        // act
        //        IDictionary<string, DocumentGenerationRequest> documentGenerationRequests = creator.SupplyDocumentGenerationRequest(
        //            "MASTER-123",
        //            new contractType
        //            {
        //                fundingType = new fundingType
        //                {
        //                    fundingTypeCode = "EDSK"
        //                },
        //                period = new period
        //                {
        //                    periodType = new periodTypeType
        //                    {
        //                        periodTypeCode = periodTypeCodeType.AY
        //                    },
        //                    period1 = "1920"
        //                },
        //                startDate = new DateTime(2019, 08, 01, 0, 0, 0, DateTimeKind.Utc),
        //                contractType1 = "Conditions of Funding (Grant) (College)"
        //            },
        //            "TEMPLATE-CONTAINER");

        //        // assert
        //        DocumentGenerationRequest documentGenerationRequest = documentGenerationRequests.Single().Value;
        //        Assert.AreEqual("EDSK1920_S2_LOANS_COFG_2019-08-01.docx", documentGenerationRequest.TemplateFilename, "Unexpected TemplateFilename returned");
        //    }
    }
}