namespace SFA.FCT.DocumentsDomain.DocumentGeneration.Tests.TsAndCs
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Entities.CorporateContract;
    using DataStore.Models;
    using DataStore.Repositories;
    using DocumentDefiner.DocumentConfiguration;
    using DocumentDefiner.DocumentPartCreators.TsAndCs;
    using DocumentGeneration.Repositories;
    using Integration;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.DocumentsDomain.DocumentGeneration.Services;

    [TestClass]
    public class EdskTermsAndConditionsDocumentPartCreatorTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void EdskTermsAndConditionsDocumentPartCreator_IsHeaderDocumentRequired_ShouldReturnFalse()
        {
            // arrange
            var creator = new EdskTermsAndConditionsDocumentPartCreator(
                Mock.Of<ITemplateRepository>(),
                Mock.Of<IDocumentConfigurationSource>(),
                Mock.Of<IContractDocumentTemplateRepository>(),
                Mock.Of<IFundingTypeFundingPeriodContractTypeRepository>(),
                Mock.Of<IFundingStreamPeriodRepository>(),
                Mock.Of<ITemplateVersionChecker>());

            // act
            var isHeaderDocumentRequired = creator.IsHeaderDocumentRequired;

            // assert
            Assert.IsFalse(isHeaderDocumentRequired);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void EdskTermsAndConditionsDocumentPartCreator_RequiredHeaderDocumentName_ShouldThrowApplicationException()
        {
            // arrange
            var creator = new EdskTermsAndConditionsDocumentPartCreator(
                Mock.Of<ITemplateRepository>(),
                Mock.Of<IDocumentConfigurationSource>(),
                Mock.Of<IContractDocumentTemplateRepository>(),
                Mock.Of<IFundingTypeFundingPeriodContractTypeRepository>(),
                Mock.Of<IFundingStreamPeriodRepository>(),
                Mock.Of<ITemplateVersionChecker>());

            var expectedExceptionThrown = false;

            // act
            try
            {
                var requiredHeaderDocumentName = creator.RequiredHeaderDocumentName;
            }
            catch (ApplicationException)
            {
                expectedExceptionThrown = true;
            }

            // assert
            Assert.IsTrue(expectedExceptionThrown);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void EdskTermsAndConditionsDocumentPartCreator_IsDocumentPartRequired_ShouldReturnTrueWhenFundingTypeIsEdskAndIsNewRevisedNewOrUpdateDraftIsTrue()
        {
            // arrange
            var creator = new EdskTermsAndConditionsDocumentPartCreator(
                Mock.Of<ITemplateRepository>(),
                Mock.Of<IDocumentConfigurationSource>(),
                Mock.Of<IContractDocumentTemplateRepository>(),
                Mock.Of<IFundingTypeFundingPeriodContractTypeRepository>(),
                Mock.Of<IFundingStreamPeriodRepository>(),
                Mock.Of<ITemplateVersionChecker>());

            // act
            var isDocumentPartRequired = creator.IsDocumentPartRequired(new contractType
            {
                IsNewRevisedNewOrUpdateDraft = true,
                fundingType = new fundingType
                {
                    fundingTypeCode = "EDSK",
                }
            });

            // assert
            Assert.IsTrue(isDocumentPartRequired);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void EdskTermsAndConditionsDocumentPartCreator_IsDocumentPartRequired_ShouldReturnFalseWhenFundingTypeIsEdskPeriodIs2021AndNotification()
        {
            // arrange
            var creator = new EdskTermsAndConditionsDocumentPartCreator(
                Mock.Of<ITemplateRepository>(),
                Mock.Of<IDocumentConfigurationSource>(),
                Mock.Of<IContractDocumentTemplateRepository>(),
                Mock.Of<IFundingTypeFundingPeriodContractTypeRepository>(),
                Mock.Of<IFundingStreamPeriodRepository>(),
                Mock.Of<ITemplateVersionChecker>());

            // act
            var isDocumentPartRequired = creator.IsDocumentPartRequired(new contractType
            {
                IsAmendment = true,
                fundingType = new fundingType
                {
                    fundingTypeCode = "EDSK",
                },
                period = new period
                {
                    period1 = "2021"
                },
                IsVariation = false
            });

            // assert
            Assert.IsFalse(isDocumentPartRequired);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void EdskTermsAndConditionsDocumentPartCreator_IsDocumentPartRequired_ShouldReturnFalseWhenFundingTypeIsEdskAndIsNewRevisedNewOrUpdateDraftIsFalse_1920()
        {
            // arrange
            var creator = new EdskTermsAndConditionsDocumentPartCreator(
                Mock.Of<ITemplateRepository>(),
                Mock.Of<IDocumentConfigurationSource>(),
                Mock.Of<IContractDocumentTemplateRepository>(),
                Mock.Of<IFundingTypeFundingPeriodContractTypeRepository>(),
                Mock.Of<IFundingStreamPeriodRepository>(),
                Mock.Of<ITemplateVersionChecker>());

            // act
            var isDocumentPartRequired = creator.IsDocumentPartRequired(new contractType
            {
                IsNewRevisedNewOrUpdateDraft = false,
                fundingType = new fundingType
                {
                    fundingTypeCode = "EDSK"
                },
                period = new period
                {
                    period1 = "1920"
                }
            });

            // assert
            Assert.IsFalse(isDocumentPartRequired);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void EdskTermsAndConditionsDocumentPartCreator_IsDocumentPartRequired_ShouldReturnTrueWhenFundingTypeIsEdskAndIsNewRevisedNewOrUpdateDraftIsFalse_2021Variation()
        {
            // arrange
            var creator = new EdskTermsAndConditionsDocumentPartCreator(
                Mock.Of<ITemplateRepository>(),
                Mock.Of<IDocumentConfigurationSource>(),
                Mock.Of<IContractDocumentTemplateRepository>(),
                Mock.Of<IFundingTypeFundingPeriodContractTypeRepository>(),
                Mock.Of<IFundingStreamPeriodRepository>(),
                Mock.Of<ITemplateVersionChecker>());

            // act
            var isDocumentPartRequired = creator.IsDocumentPartRequired(new contractType
            {
                IsNewRevisedNewOrUpdateDraft = false,
                fundingType = new fundingType
                {
                    fundingTypeCode = "EDSK"
                },
                period = new period
                {
                    period1 = "2021"
                },
                IsVariation = true
            });

            // assert
            Assert.IsTrue(isDocumentPartRequired);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void EdskTermsAndConditionsDocumentPartCreator_IsDocumentPartRequired_ShouldReturnTrueWhenFundingTypeIsDadaAndIsNewRevisedNewOrUpdateDraftIsTrue()
        {
            // arrange
            var creator = new EdskTermsAndConditionsDocumentPartCreator(
                Mock.Of<ITemplateRepository>(),
                Mock.Of<IDocumentConfigurationSource>(),
                Mock.Of<IContractDocumentTemplateRepository>(),
                Mock.Of<IFundingTypeFundingPeriodContractTypeRepository>(),
                Mock.Of<IFundingStreamPeriodRepository>(),
                Mock.Of<ITemplateVersionChecker>());

            // act
            var isDocumentPartRequired = creator.IsDocumentPartRequired(new contractType
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
        public void EdskTermsAndConditionsDocumentPartCreator_IsDocumentPartRequired_ShouldReturnTrueWhenFundingTypeIsDadaAndIsVariationAmendmentFrom2021Onward()
        {
            // arrange
            var creator = new EdskTermsAndConditionsDocumentPartCreator(
                Mock.Of<ITemplateRepository>(),
                Mock.Of<IDocumentConfigurationSource>(),
                Mock.Of<IContractDocumentTemplateRepository>(),
                Mock.Of<IFundingTypeFundingPeriodContractTypeRepository>(),
                Mock.Of<IFundingStreamPeriodRepository>(),
                Mock.Of<ITemplateVersionChecker>());

            // act
            var isDocumentPartRequired = creator.IsDocumentPartRequired(new contractType
            {
                IsAmendment = true,
                IsVariation = true,
                fundingType = new fundingType
                {
                    fundingTypeCode = "DADA"
                },
                period = new period
                {
                    period1 = "2021"
                }
            });

            // assert
            Assert.IsTrue(isDocumentPartRequired);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void EdskTermsAndConditionsDocumentPartCreator_IsDocumentPartRequired_ShouldReturnFalseWhenFundingTypeIsDadaAndIsNewRevisedNewOrUpdateDraftIsFalseAndIsNotVariationAmendment()
        {
            // arrange
            var creator = new EdskTermsAndConditionsDocumentPartCreator(
                Mock.Of<ITemplateRepository>(),
                Mock.Of<IDocumentConfigurationSource>(),
                Mock.Of<IContractDocumentTemplateRepository>(),
                Mock.Of<IFundingTypeFundingPeriodContractTypeRepository>(),
                Mock.Of<IFundingStreamPeriodRepository>(),
                Mock.Of<ITemplateVersionChecker>());

            // act
            var isDocumentPartRequired = creator.IsDocumentPartRequired(new contractType
            {
                IsNewRevisedNewOrUpdateDraft = false,
                IsAmendment = false,
                fundingType = new fundingType
                {
                    fundingTypeCode = "DADA"
                }
            });

            // assert
            Assert.IsFalse(isDocumentPartRequired);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void EdskTermsAndConditionsDocumentPartCreator_IsDocumentPartRequired_ShouldReturnFalseWhenFundingTypeIsDadaAndIsNotificationAmendment()
        {
            // arrange
            var creator = new EdskTermsAndConditionsDocumentPartCreator(
                Mock.Of<ITemplateRepository>(),
                Mock.Of<IDocumentConfigurationSource>(),
                Mock.Of<IContractDocumentTemplateRepository>(),
                Mock.Of<IFundingTypeFundingPeriodContractTypeRepository>(),
                Mock.Of<IFundingStreamPeriodRepository>(),
                Mock.Of<ITemplateVersionChecker>());

            // act
            var isDocumentPartRequired = creator.IsDocumentPartRequired(new contractType
            {
                IsAmendment = true,
                IsVariation = false,
                fundingType = new fundingType
                {
                    fundingTypeCode = "DADA"
                }
            });

            // assert
            Assert.IsFalse(isDocumentPartRequired);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void EdskTermsAndConditionsDocumentPartCreator_IsDocumentPartRequired_ShouldReturnFalseWhenFundingTypeIsMain()
        {
            // arrange
            var creator = new EdskTermsAndConditionsDocumentPartCreator(
                Mock.Of<ITemplateRepository>(),
                Mock.Of<IDocumentConfigurationSource>(),
                Mock.Of<IContractDocumentTemplateRepository>(),
                Mock.Of<IFundingTypeFundingPeriodContractTypeRepository>(),
                Mock.Of<IFundingStreamPeriodRepository>(),
                Mock.Of<ITemplateVersionChecker>());

            // act
            var isDocumentPartRequired = creator.IsDocumentPartRequired(new contractType
            {
                fundingType = new fundingType
                {
                    fundingTypeCode = "MAIN"
                }
            });

            // assert
            Assert.IsFalse(isDocumentPartRequired);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void EdskTermsAndConditionsDocumentPartCreator_IsDocumentPartRequired_ShouldReturnTrueWhenFundingTypeIs19TRN2020()
        {
            // arrange
            var creator = new EdskTermsAndConditionsDocumentPartCreator(
                Mock.Of<ITemplateRepository>(),
                Mock.Of<IDocumentConfigurationSource>(),
                Mock.Of<IContractDocumentTemplateRepository>(),
                Mock.Of<IFundingTypeFundingPeriodContractTypeRepository>(),
                Mock.Of<IFundingStreamPeriodRepository>(),
                Mock.Of<ITemplateVersionChecker>());

            // act
            var isDocumentPartRequired = creator.IsDocumentPartRequired(new contractType
            {
                fundingType = new fundingType
                {
                    fundingTypeCode = "19TRN2020"
                },
                IsNewRevisedNewOrUpdateDraft = true
            });

            // assert
            Assert.IsTrue(isDocumentPartRequired);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void EdskTermsAndConditionsDocumentPartCreator_SupplyDocumentGenerationRequest_ShouldReturnExpectedDocumentGenerationRequest()
        {
            // arrange
            const string expectedAddressField = "PROVIDER ADDRESS LINE 1\r\nPROVIDER ADDRESS LINE 2\r\nPROVIDER ADDRESS LINE 3\r\nPROVIDER ADDRESS LINE 4\r\nPROVIDER TOWN\r\nPROVIDER COUNTY\r\nPROVIDER POSTCODE\r\n";
            var contractStartDate = new DateTime(2019, 08, 01, 0, 0, 0, DateTimeKind.Utc);

            var documentTemplateRepositoryMock = new Mock<IContractDocumentTemplateRepository>();
            documentTemplateRepositoryMock
                .Setup(m => m.GetByKey(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>()))
                .Returns(new ContractDocumentTemplate("EDSK",
                    "AY1920",
                    "TAC",
                    "Contract for Services",
                    "TAC_CFS_EDSK1920"));

            var templateRepositoryMock = new Mock<ITemplateRepository>();
            templateRepositoryMock
                .Setup(m => m.GetNameOfTemplateActiveOnDate("TEMPLATE-CONTAINER", "TAC_CFS_EDSK1920", contractStartDate))
                .Returns("TEMPLATE-FILENAME");

            var fundingStreamPeriodRepositoryMock = new Mock<IFundingStreamPeriodRepository>();
            fundingStreamPeriodRepositoryMock
                .Setup(m => m.GetFspGroupDisplayNames(It.IsAny<IReadOnlyCollection<string>>()))
                .Returns(new List<string> { "FSPGroup1", "FSPGroup2" });

            var templateVersionCheckerMock = new Mock<ITemplateVersionChecker>();
            templateVersionCheckerMock
                .Setup(c => c.ShouldIncludeTemplate(It.IsAny<string>(), It.IsAny<DateTime?>(), It.IsAny<bool>()))
                .Returns(true);

            var creator = new EdskTermsAndConditionsDocumentPartCreator(
                templateRepositoryMock.Object,
                Mock.Of<IDocumentConfigurationSource>(),
                documentTemplateRepositoryMock.Object,
                Mock.Of<IFundingTypeFundingPeriodContractTypeRepository>(),
                fundingStreamPeriodRepositoryMock.Object,
                templateVersionCheckerMock.Object);

            // act
            var documentGenerationRequests = creator.SupplyDocumentGenerationRequest(
                "MASTER-123",
                new contractType
                {
                    fundingType = new fundingType
                    {
                        fundingTypeCode = "EDSK"
                    },
                    period = new period
                    {
                        periodType = new periodTypeType
                        {
                            periodTypeCode = periodTypeCodeType.AY
                        },
                        period1 = "1920"
                    },
                    startDate = contractStartDate,
                    contractor = new contractor
                    {
                        legalName = "PROVIDER NAME",
                        addressLine1 = "PROVIDER ADDRESS LINE 1",
                        addressLine2 = "PROVIDER ADDRESS LINE 2",
                        addressLine3 = "PROVIDER ADDRESS LINE 3",
                        addressLine4 = "PROVIDER ADDRESS LINE 4",
                        town = "PROVIDER TOWN",
                        county = "PROVIDER COUNTY",
                        postcode = "PROVIDER POSTCODE",
                        registeredCompanyNumber = "PROVIDER COMPANY NO"
                    }
                },
                "TEMPLATE-CONTAINER");

            // assert
            Assert.IsNotNull(documentGenerationRequests, "Unexpected null result returned");
            Assert.AreEqual(1, documentGenerationRequests.Count, "Unexpected number of DocumentGenerationRequest instances returned");
            Assert.AreEqual("1500", documentGenerationRequests.Single().Key, "Unexpected order string returned");

            var documentGenerationRequest = documentGenerationRequests.Single().Value;
            Assert.AreEqual("TEMPLATE-CONTAINER", documentGenerationRequest.TemplateContainer, "Unexpected TemplateContainer returned");
            Assert.AreEqual("TEMPLATE-FILENAME", documentGenerationRequest.TemplateFilename, "Unexpected TemplateFilename returned");
            Assert.IsNotNull(documentGenerationRequest.MergeData, "Unexpected null merge data returned");

            var mergeData = documentGenerationRequest.MergeData;
            Assert.AreEqual("MASTER-123", mergeData.MergeFields.SingleOrDefault(mf => mf.Name == "MasterContractRef")?.Value, "Incorrect MasterContractRef MergeField");
            Assert.AreEqual("PROVIDER NAME", mergeData.MergeFields.SingleOrDefault(mf => mf.Name == "ProviderName")?.Value, "Incorrect ProviderName MergeField");
            Assert.AreEqual(expectedAddressField, mergeData.MergeFields.SingleOrDefault(mf => mf.Name == "ProviderAddress")?.Value, "Incorrect ProviderAddress1 MergeField");
            Assert.AreEqual("Company No: PROVIDER COMPANY NO", mergeData.MergeFields.SingleOrDefault(mf => mf.Name == "ProviderCompanyNo")?.Value, "Incorrect ProviderCompanyNo MergeField");

            var expectedFormattedFspGroupDisplayNames = "FSPGroup1" + Environment.NewLine + "FSPGroup2";
            Assert.AreEqual(expectedFormattedFspGroupDisplayNames, mergeData.MergeFields.SingleOrDefault(mf => mf.Name == "FSPGroupList")?.Value, "Incorrect FSPGroupList MergeField");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void EdskTermsAndConditionsDocumentPartCreator_SupplyDocumentGenerationRequest_AddressLineMerge_ShouldReturnCorrectMergedAddressWhenAllAddressLinesContainText()
        {
            // arrange
            const string expectedAddressField = "PROVIDER ADDRESS LINE 1\r\nPROVIDER ADDRESS LINE 2\r\nPROVIDER ADDRESS LINE 3\r\nPROVIDER ADDRESS LINE 4\r\nPROVIDER TOWN\r\nPROVIDER COUNTY\r\nPROVIDER POSTCODE\r\n";
            var contractStartDate = new DateTime(2019, 08, 01, 0, 0, 0, DateTimeKind.Utc);

            var documentTemplateRepositoryMock = new Mock<IContractDocumentTemplateRepository>();
            documentTemplateRepositoryMock
                .Setup(m => m.GetByKey(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>()))
                .Returns(new ContractDocumentTemplate("EDSK",
                    "AY1920",
                    "TAC",
                    "Contract for Services",
                    "TAC_CFS_EDSK1920"));

            var fundingStreamPeriodRepositoryMock = new Mock<IFundingStreamPeriodRepository>();
            fundingStreamPeriodRepositoryMock
                .Setup(m => m.GetFspGroupDisplayNames(It.IsAny<IReadOnlyCollection<string>>()))
                .Returns(new List<string> { "FSPGroup1", "FSPGroup2" });

            var templateVersionCheckerMock = new Mock<ITemplateVersionChecker>();
            templateVersionCheckerMock
                .Setup(c => c.ShouldIncludeTemplate(It.IsAny<string>(), It.IsAny<DateTime?>(), It.IsAny<bool>()))
                .Returns(true);

            var creator = new EdskTermsAndConditionsDocumentPartCreator(
                Mock.Of<ITemplateRepository>(),
                Mock.Of<IDocumentConfigurationSource>(),
                documentTemplateRepositoryMock.Object,
                Mock.Of<IFundingTypeFundingPeriodContractTypeRepository>(),
                fundingStreamPeriodRepositoryMock.Object,
                templateVersionCheckerMock.Object);

            // act
            var documentGenerationRequests = creator.SupplyDocumentGenerationRequest(
                masterContractNumber: string.Empty,
                contract: new contractType
                {
                    startDate = contractStartDate,
                    contractor = new contractor
                    {
                        addressLine1 = "PROVIDER ADDRESS LINE 1",
                        addressLine2 = "PROVIDER ADDRESS LINE 2",
                        addressLine3 = "PROVIDER ADDRESS LINE 3",
                        addressLine4 = "PROVIDER ADDRESS LINE 4",
                        town = "PROVIDER TOWN",
                        county = "PROVIDER COUNTY",
                        postcode = "PROVIDER POSTCODE"
                    }
                }, templateContainer: string.Empty);

            // assert
            Assert.IsNotNull(documentGenerationRequests, "Unexpected null result returned");

            var mergeData = documentGenerationRequests.Single().Value.MergeData;
            Assert.AreEqual(expectedAddressField, mergeData.MergeFields.SingleOrDefault(mf => mf.Name == "ProviderAddress")?.Value,
                "Incorrect ProviderAddress MergeField. Should include all address lines");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void EdskTermsAndConditionsDocumentPartCreator_SupplyDocumentGenerationRequest_AddressLineMerge_ShouldReturnCorrectMergedAddressWhenFirstAddressLineIsBlank()
        {
            // arrange
            const string expectedAddressField = "PROVIDER ADDRESS LINE 2\r\nPROVIDER ADDRESS LINE 3\r\nPROVIDER ADDRESS LINE 4\r\nPROVIDER TOWN\r\nPROVIDER COUNTY\r\nPROVIDER POSTCODE\r\n";
            var contractStartDate = new DateTime(2019, 08, 01, 0, 0, 0, DateTimeKind.Utc);

            var documentTemplateRepositoryMock = new Mock<IContractDocumentTemplateRepository>();
            documentTemplateRepositoryMock
                .Setup(m => m.GetByKey(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>()))
                .Returns(new ContractDocumentTemplate("EDSK",
                    "AY1920",
                    "TAC",
                    "Contract for Services",
                    "TAC_CFS_EDSK1920"));

            var fundingStreamPeriodRepositoryMock = new Mock<IFundingStreamPeriodRepository>();
            fundingStreamPeriodRepositoryMock
                .Setup(m => m.GetFspGroupDisplayNames(It.IsAny<IReadOnlyCollection<string>>()))
                .Returns(new List<string> { "FSPGroup1", "FSPGroup2" });

            var templateVersionCheckerMock = new Mock<ITemplateVersionChecker>();
            templateVersionCheckerMock
                .Setup(c => c.ShouldIncludeTemplate(It.IsAny<string>(), It.IsAny<DateTime?>(), It.IsAny<bool>()))
                .Returns(true);

            var creator = new EdskTermsAndConditionsDocumentPartCreator(
                Mock.Of<ITemplateRepository>(),
                Mock.Of<IDocumentConfigurationSource>(),
                documentTemplateRepositoryMock.Object,
                Mock.Of<IFundingTypeFundingPeriodContractTypeRepository>(),
                fundingStreamPeriodRepositoryMock.Object,
                templateVersionCheckerMock.Object);

            // act
            var documentGenerationRequests = creator.SupplyDocumentGenerationRequest(
                masterContractNumber: string.Empty,
                contract: new contractType
                {
                    startDate = contractStartDate,
                    contractor = new contractor
                    {
                        //                        addressLine1 = "PROVIDER ADDRESS LINE 1",
                        addressLine2 = "PROVIDER ADDRESS LINE 2",
                        addressLine3 = "PROVIDER ADDRESS LINE 3",
                        addressLine4 = "PROVIDER ADDRESS LINE 4",
                        town = "PROVIDER TOWN",
                        county = "PROVIDER COUNTY",
                        postcode = "PROVIDER POSTCODE"
                    }
                }, templateContainer: string.Empty);

            // assert
            Assert.IsNotNull(documentGenerationRequests, "Unexpected null result returned");

            var mergeData = documentGenerationRequests.Single().Value.MergeData;

            Assert.AreEqual(expectedAddressField, mergeData.MergeFields.SingleOrDefault(mf => mf.Name == "ProviderAddress")?.Value,
                "Incorrect ProviderAddress MergeField. Should exclude first address line");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void EdskTermsAndConditionsDocumentPartCreator_SupplyDocumentGenerationRequest_AddressLineMerge_ShouldReturnCorrectMergedAddressWhenLastAddressLineIsBlank()
        {
            // arrange
            const string expectedAddressField = "PROVIDER ADDRESS LINE 1\r\nPROVIDER ADDRESS LINE 2\r\nPROVIDER ADDRESS LINE 3\r\nPROVIDER ADDRESS LINE 4\r\nPROVIDER TOWN\r\nPROVIDER COUNTY\r\n";
            var contractStartDate = new DateTime(2019, 08, 01, 0, 0, 0, DateTimeKind.Utc);

            var documentTemplateRepositoryMock = new Mock<IContractDocumentTemplateRepository>();
            documentTemplateRepositoryMock
                .Setup(m => m.GetByKey(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>()))
                .Returns(new ContractDocumentTemplate("EDSK",
                    "AY1920",
                    "TAC",
                    "Contract for Services",
                    "TAC_CFS_EDSK1920"));

            var fundingStreamPeriodRepositoryMock = new Mock<IFundingStreamPeriodRepository>();
            fundingStreamPeriodRepositoryMock
                .Setup(m => m.GetFspGroupDisplayNames(It.IsAny<IReadOnlyCollection<string>>()))
                .Returns(new List<string> { "FSPGroup1", "FSPGroup2" });

            var templateVersionCheckerMock = new Mock<ITemplateVersionChecker>();
            templateVersionCheckerMock
                .Setup(c => c.ShouldIncludeTemplate(It.IsAny<string>(), It.IsAny<DateTime?>(), It.IsAny<bool>()))
                .Returns(true);

            var creator = new EdskTermsAndConditionsDocumentPartCreator(
                Mock.Of<ITemplateRepository>(),
                Mock.Of<IDocumentConfigurationSource>(),
                documentTemplateRepositoryMock.Object,
                Mock.Of<IFundingTypeFundingPeriodContractTypeRepository>(),
                fundingStreamPeriodRepositoryMock.Object,
                templateVersionCheckerMock.Object);

            // act
            var documentGenerationRequests = creator.SupplyDocumentGenerationRequest(
                masterContractNumber: string.Empty,
                contract: new contractType
                {
                    startDate = contractStartDate,
                    contractor = new contractor
                    {
                        addressLine1 = "PROVIDER ADDRESS LINE 1",
                        addressLine2 = "PROVIDER ADDRESS LINE 2",
                        addressLine3 = "PROVIDER ADDRESS LINE 3",
                        addressLine4 = "PROVIDER ADDRESS LINE 4",
                        town = "PROVIDER TOWN",
                        county = "PROVIDER COUNTY",
                        //postcode = "PROVIDER POSTCODE"
                    }
                }, templateContainer: string.Empty);

            // assert
            Assert.IsNotNull(documentGenerationRequests, "Unexpected null result returned");

            var mergeData = documentGenerationRequests.Single().Value.MergeData;
            Assert.AreEqual(expectedAddressField, mergeData.MergeFields.SingleOrDefault(mf => mf.Name == "ProviderAddress")?.Value,
                "Incorrect ProviderAddress MergeField. Should exclude last address line");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void EdskTermsAndConditionsDocumentPartCreator_SupplyDocumentGenerationRequest_AddressLineMerge_ShouldReturnCorrectMergedAddressWhenOneMiddleAddressLineIsBlank()
        {
            // arrange
            const string expectedAddressField = "PROVIDER ADDRESS LINE 1\r\nPROVIDER ADDRESS LINE 2\r\nPROVIDER ADDRESS LINE 4\r\nPROVIDER TOWN\r\nPROVIDER COUNTY\r\nPROVIDER POSTCODE\r\n";
            var contractStartDate = new DateTime(2019, 08, 01, 0, 0, 0, DateTimeKind.Utc);

            var documentTemplateRepositoryMock = new Mock<IContractDocumentTemplateRepository>();
            documentTemplateRepositoryMock
                .Setup(m => m.GetByKey(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>()))
                .Returns(new ContractDocumentTemplate("EDSK",
                    "AY1920",
                    "TAC",
                    "Contract for Services",
                    "TAC_CFS_EDSK1920"));

            var fundingStreamPeriodRepositoryMock = new Mock<IFundingStreamPeriodRepository>();
            fundingStreamPeriodRepositoryMock
                .Setup(m => m.GetFspGroupDisplayNames(It.IsAny<IReadOnlyCollection<string>>()))
                .Returns(new List<string> { "FSPGroup1", "FSPGroup2" });

            var templateVersionCheckerMock = new Mock<ITemplateVersionChecker>();
            templateVersionCheckerMock
                .Setup(c => c.ShouldIncludeTemplate(It.IsAny<string>(), It.IsAny<DateTime?>(), It.IsAny<bool>()))
                .Returns(true);

            var creator = new EdskTermsAndConditionsDocumentPartCreator(
                Mock.Of<ITemplateRepository>(),
                Mock.Of<IDocumentConfigurationSource>(),
                documentTemplateRepositoryMock.Object,
                Mock.Of<IFundingTypeFundingPeriodContractTypeRepository>(),
                fundingStreamPeriodRepositoryMock.Object,
                templateVersionCheckerMock.Object);

            // act
            var documentGenerationRequests = creator.SupplyDocumentGenerationRequest(
                masterContractNumber: string.Empty,
                contract: new contractType
                {
                    startDate = contractStartDate,
                    contractor = new contractor
                    {
                        addressLine1 = "PROVIDER ADDRESS LINE 1",
                        addressLine2 = "PROVIDER ADDRESS LINE 2",
                        addressLine3 = "",
                        addressLine4 = "PROVIDER ADDRESS LINE 4",
                        town = "PROVIDER TOWN",
                        county = "PROVIDER COUNTY",
                        postcode = "PROVIDER POSTCODE"
                    }
                }, templateContainer: string.Empty);

            // assert
            Assert.IsNotNull(documentGenerationRequests, "Unexpected null result returned");

            var mergeData = documentGenerationRequests.Single().Value.MergeData;
            Assert.AreEqual(expectedAddressField, mergeData.MergeFields.SingleOrDefault(mf => mf.Name == "ProviderAddress")?.Value,
                "Incorrect ProviderAddress MergeField. Should exclude address line 3");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void EdskTermsAndConditionsDocumentPartCreator_SupplyDocumentGenerationRequest_AddressLineMerge_ShouldReturnCorrectMergedAddressWhenTwoMiddleAddressLinesAreBlank()
        {
            // arrange
            const string expectedAddressField = "PROVIDER ADDRESS LINE 1\r\nPROVIDER ADDRESS LINE 3\r\nPROVIDER ADDRESS LINE 4\r\nPROVIDER COUNTY\r\nPROVIDER POSTCODE\r\n";
            var contractStartDate = new DateTime(2019, 08, 01, 0, 0, 0, DateTimeKind.Utc);

            var documentTemplateRepositoryMock = new Mock<IContractDocumentTemplateRepository>();
            documentTemplateRepositoryMock
                .Setup(m => m.GetByKey(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>()))
                .Returns(new ContractDocumentTemplate("EDSK",
                    "AY1920",
                    "TAC",
                    "Contract for Services",
                    "TAC_CFS_EDSK1920"));

            var fundingStreamPeriodRepositoryMock = new Mock<IFundingStreamPeriodRepository>();
            fundingStreamPeriodRepositoryMock
                .Setup(m => m.GetFspGroupDisplayNames(It.IsAny<IReadOnlyCollection<string>>()))
                .Returns(new List<string> { "FSPGroup1", "FSPGroup2" });

            var templateVersionCheckerMock = new Mock<ITemplateVersionChecker>();
            templateVersionCheckerMock
                .Setup(c => c.ShouldIncludeTemplate(It.IsAny<string>(), It.IsAny<DateTime?>(), It.IsAny<bool>()))
                .Returns(true);

            var creator = new EdskTermsAndConditionsDocumentPartCreator(
                Mock.Of<ITemplateRepository>(),
                Mock.Of<IDocumentConfigurationSource>(),
                documentTemplateRepositoryMock.Object,
                Mock.Of<IFundingTypeFundingPeriodContractTypeRepository>(),
                fundingStreamPeriodRepositoryMock.Object,
                templateVersionCheckerMock.Object);

            // act
            var documentGenerationRequests = creator.SupplyDocumentGenerationRequest(
                masterContractNumber: string.Empty,
                contract: new contractType
                {
                    startDate = contractStartDate,
                    contractor = new contractor
                    {
                        addressLine1 = "PROVIDER ADDRESS LINE 1",
                        addressLine2 = "",
                        addressLine3 = "PROVIDER ADDRESS LINE 3",
                        addressLine4 = "PROVIDER ADDRESS LINE 4",
                        //town = "PROVIDER TOWN",
                        county = "PROVIDER COUNTY",
                        postcode = "PROVIDER POSTCODE"
                    }
                }, templateContainer: string.Empty);

            // assert
            Assert.IsNotNull(documentGenerationRequests, "Unexpected null result returned");

            var mergeData = documentGenerationRequests.Single().Value.MergeData;
            Assert.AreEqual(expectedAddressField, mergeData.MergeFields.SingleOrDefault(mf => mf.Name == "ProviderAddress")?.Value,
                "Incorrect ProviderAddress MergeField. Should include all address line 3 & 4");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void EdskTermsAndConditionsDocumentPartCreator_SupplyDocumentGenerationRequest_ShouldReturnCorrectCompanyNoTextWhenThereIsARegisteredCompanyNumber()
        {
            // arrange
            const string registeredCompanyNumber = "PROVIDER COMPANY NO";
            const string expectedCompanyNoField = "Company No: " + registeredCompanyNumber;
            var contractStartDate = new DateTime(2019, 08, 01, 0, 0, 0, DateTimeKind.Utc);

            var documentTemplateRepositoryMock = new Mock<IContractDocumentTemplateRepository>();
            documentTemplateRepositoryMock
                .Setup(m => m.GetByKey(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>()))
                .Returns(new ContractDocumentTemplate("EDSK",
                    "AY1920",
                    "TAC",
                    "Contract for Services",
                    "TAC_CFS_EDSK1920"));

            var fundingStreamPeriodRepositoryMock = new Mock<IFundingStreamPeriodRepository>();
            fundingStreamPeriodRepositoryMock
                .Setup(m => m.GetFspGroupDisplayNames(It.IsAny<IReadOnlyCollection<string>>()))
                .Returns(new List<string> { "FSPGroup1", "FSPGroup2" });

            var templateVersionCheckerMock = new Mock<ITemplateVersionChecker>();
            templateVersionCheckerMock
                .Setup(c => c.ShouldIncludeTemplate(It.IsAny<string>(), It.IsAny<DateTime?>(), It.IsAny<bool>()))
                .Returns(true);

            var creator = new EdskTermsAndConditionsDocumentPartCreator(
                Mock.Of<ITemplateRepository>(),
                Mock.Of<IDocumentConfigurationSource>(),
                documentTemplateRepositoryMock.Object,
                Mock.Of<IFundingTypeFundingPeriodContractTypeRepository>(),
                fundingStreamPeriodRepositoryMock.Object,
                templateVersionCheckerMock.Object);

            // act
            var documentGenerationRequests = creator.SupplyDocumentGenerationRequest(
                masterContractNumber: string.Empty,
                contract: new contractType
                {
                    startDate = contractStartDate,
                    contractor = new contractor
                    {
                        registeredCompanyNumber = "PROVIDER COMPANY NO"
                    }
                }, templateContainer: string.Empty);

            // assert
            Assert.IsNotNull(documentGenerationRequests, "Unexpected null result returned");

            var mergeData = documentGenerationRequests.Single().Value.MergeData;
            Assert.AreEqual(expectedCompanyNoField, mergeData.MergeFields.SingleOrDefault(mf => mf.Name == "ProviderCompanyNo")?.Value,
                "Incorrect ProviderCompanyNo field");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void EdskTermsAndConditionsDocumentPartCreator_SupplyDocumentGenerationRequest_ShouldReturnBlankCompanyNoTextWhenThereIsNoRegisteredCompanyNumber()
        {
            // arrange
            var contractStartDate = new DateTime(2019, 08, 01, 0, 0, 0, DateTimeKind.Utc);

            var documentTemplateRepositoryMock = new Mock<IContractDocumentTemplateRepository>();
            documentTemplateRepositoryMock
                .Setup(m => m.GetByKey(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>()))
                .Returns(new ContractDocumentTemplate("EDSK",
                    "AY1920",
                    "TAC",
                    "Contract for Services",
                    "TAC_CFS_EDSK1920"));

            var fundingStreamPeriodRepositoryMock = new Mock<IFundingStreamPeriodRepository>();
            fundingStreamPeriodRepositoryMock
                .Setup(m => m.GetFspGroupDisplayNames(It.IsAny<IReadOnlyCollection<string>>()))
                .Returns(new List<string> { "FSPGroup1", "FSPGroup2" });

            var templateVersionCheckerMock = new Mock<ITemplateVersionChecker>();
            templateVersionCheckerMock
                .Setup(c => c.ShouldIncludeTemplate(It.IsAny<string>(), It.IsAny<DateTime?>(), It.IsAny<bool>()))
                .Returns(true);

            var creator = new EdskTermsAndConditionsDocumentPartCreator(
                Mock.Of<ITemplateRepository>(),
                Mock.Of<IDocumentConfigurationSource>(),
                documentTemplateRepositoryMock.Object,
                Mock.Of<IFundingTypeFundingPeriodContractTypeRepository>(),
                fundingStreamPeriodRepositoryMock.Object,
                templateVersionCheckerMock.Object);

            // act
            var documentGenerationRequests = creator.SupplyDocumentGenerationRequest(
                masterContractNumber: string.Empty,
                contract: new contractType
                {
                    startDate = contractStartDate,
                    contractor = new contractor
                    {
                        registeredCompanyNumber = ""
                    }
                }, templateContainer: string.Empty);

            // assert
            Assert.IsNotNull(documentGenerationRequests, "Unexpected null result returned");

            var mergeData = documentGenerationRequests.Single().Value.MergeData;
            Assert.AreEqual(string.Empty, mergeData.MergeFields.SingleOrDefault(mf => mf.Name == "ProviderCompanyNo")?.Value,
                "Incorrect ProviderCompanyNo field");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void EdskTermsAndConditionsDocumentPartCreator_SupplyDocumentGenerationRequest_ShouldReturnCorrectTemplateFilenameForContractType()
        {
            // arrange
            var documentTemplateRepositoryMock = new Mock<IContractDocumentTemplateRepository>();
            documentTemplateRepositoryMock
                .Setup(m => m.GetByKey("EDSK", "AY1920", "TAC", "Conditions of Funding (Grant) (College)"))
                .Returns(new ContractDocumentTemplate("EDSK",
                    "AY1920",
                    "TAC",
                    "Conditions of Funding (Grant) (College)",
                    "EDSK1920_S1_LOANS_COFG"));

            var templateRepositoryMock = new Mock<ITemplateRepository>();
            templateRepositoryMock
                .Setup(m => m.GetNameOfTemplateActiveOnDate(It.IsAny<string>(), "EDSK1920_S1_LOANS_COFG", It.IsAny<DateTime>()))
                .Returns("EDSK1920_S1_LOANS_COFG_2019-08-01.docx");

            var fundingStreamPeriodRepositoryMock = new Mock<IFundingStreamPeriodRepository>();
            fundingStreamPeriodRepositoryMock
                .Setup(m => m.GetFspGroupDisplayNames(It.IsAny<IReadOnlyCollection<string>>()))
                .Returns(new List<string> { "FSPGroup1", "FSPGroup2" });

            var templateVersionCheckerMock = new Mock<ITemplateVersionChecker>();
            templateVersionCheckerMock
                .Setup(c => c.ShouldIncludeTemplate(It.IsAny<string>(), It.IsAny<DateTime?>(), It.IsAny<bool>()))
                .Returns(true);

            var creator = new EdskTermsAndConditionsDocumentPartCreator(
                templateRepositoryMock.Object,
                Mock.Of<IDocumentConfigurationSource>(),
                documentTemplateRepositoryMock.Object,
                Mock.Of<IFundingTypeFundingPeriodContractTypeRepository>(),
                fundingStreamPeriodRepositoryMock.Object,
                templateVersionCheckerMock.Object);

            // act
            var documentGenerationRequests = creator.SupplyDocumentGenerationRequest(
                "MASTER-123",
                new contractType
                {
                    fundingType = new fundingType
                    {
                        fundingTypeCode = "EDSK"
                    },
                    period = new period
                    {
                        periodType = new periodTypeType
                        {
                            periodTypeCode = periodTypeCodeType.AY
                        },
                        period1 = "1920"
                    },
                    startDate = new DateTime(2019, 08, 01, 0, 0, 0, DateTimeKind.Utc),
                    contractType1 = "Conditions of Funding (Grant) (College)"
                },
                "TEMPLATE-CONTAINER");

            // assert
            var documentGenerationRequest = documentGenerationRequests.Single().Value;
            Assert.AreEqual("EDSK1920_S1_LOANS_COFG_2019-08-01.docx", documentGenerationRequest.TemplateFilename, "Unexpected TemplateFilename returned");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void EdskTermsAndConditionsDocumentPartCreator_SupplyDocumentGenerationRequest_ShouldReturnDocumentGenerationRequestWithOne()
        {
            // arrange
            var documentTemplateRepositoryMock = new Mock<IContractDocumentTemplateRepository>();
            documentTemplateRepositoryMock
                .Setup(m => m.GetByKey("EDSK", "AY1920", "TAC", "Conditions of Funding (Grant) (College)"))
                .Returns(new ContractDocumentTemplate(string.Empty, string.Empty, string.Empty, string.Empty, string.Empty));

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
            fundingStreamPeriodRepositoryMock.Setup(r => r.GetFspGroupDisplayNames(It.IsAny<IReadOnlyCollection<string>>()))
                .Returns(new List<string>());

            var fundingTypeFundingPeriodContractTypeRepositoryMock = new Mock<IFundingTypeFundingPeriodContractTypeRepository>();
            fundingTypeFundingPeriodContractTypeRepositoryMock.Setup(m => 
                    m.GetDefinedContractTermForProvider(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>()))
                .Returns(string.Empty);

            var creator = new EdskTermsAndConditionsDocumentPartCreator(
                templateRepositoryMock.Object,
                Mock.Of<IDocumentConfigurationSource>(),
                documentTemplateRepositoryMock.Object,
                Mock.Of<IFundingTypeFundingPeriodContractTypeRepository>(),
                fundingStreamPeriodRepositoryMock.Object,
                templateVersionCheckerMock.Object);

            // act
            var documentGenerationRequests = creator.SupplyDocumentGenerationRequest(
                "MASTER-123",
                new contractType
                {
                    fundingType = new fundingType
                    {
                        fundingTypeCode = "EDSK"
                    },
                    period = new period
                    {
                        periodType = new periodTypeType
                        {
                            periodTypeCode = periodTypeCodeType.AY
                        },
                        period1 = "1920"
                    },
                    startDate = new DateTime(2019, 08, 01, 0, 0, 0, DateTimeKind.Utc),
                    contractType1 = "Conditions of Funding (Grant) (College)"
                },
                "TEMPLATE-CONTAINER");

            // assert
            Assert.IsNotNull(documentGenerationRequests, "Unexpected null result returned");
            Assert.AreEqual(1, documentGenerationRequests.Count, "Unexpected number of DocumentGenerationRequest instances returned");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void EdskTermsAndConditionsDocumentPartCreator_SupplyDocumentGenerationRequest_ShouldReturnDocumentGenerationRequestWithNone()
        {
            // arrange
            var documentTemplateRepositoryMock = new Mock<IContractDocumentTemplateRepository>();
            documentTemplateRepositoryMock
                .Setup(m => m.GetByKey("EDSK", "AY1920", "TAC", "Conditions of Funding (Grant) (College)"))
                .Returns(new ContractDocumentTemplate(string.Empty, string.Empty, string.Empty, string.Empty, string.Empty));

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
            fundingStreamPeriodRepositoryMock.Setup(r => r.GetFspGroupDisplayNames(It.IsAny<IReadOnlyCollection<string>>()))
                .Returns(new List<string>());

            var fundingTypeFundingPeriodContractTypeRepositoryMock = new Mock<IFundingTypeFundingPeriodContractTypeRepository>();
            fundingTypeFundingPeriodContractTypeRepositoryMock.Setup(m =>
                    m.GetDefinedContractTermForProvider(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>()))
                .Returns(string.Empty);

            var creator = new EdskTermsAndConditionsDocumentPartCreator(
                templateRepositoryMock.Object,
                Mock.Of<IDocumentConfigurationSource>(),
                documentTemplateRepositoryMock.Object,
                Mock.Of<IFundingTypeFundingPeriodContractTypeRepository>(),
                fundingStreamPeriodRepositoryMock.Object,
                templateVersionCheckerMock.Object);

            // act
            var documentGenerationRequests = creator.SupplyDocumentGenerationRequest(
                "MASTER-123",
                new contractType
                {
                    fundingType = new fundingType
                    {
                        fundingTypeCode = "EDSK"
                    },
                    period = new period
                    {
                        periodType = new periodTypeType
                        {
                            periodTypeCode = periodTypeCodeType.AY
                        },
                        period1 = "1920"
                    },
                    startDate = new DateTime(2019, 08, 01, 0, 0, 0, DateTimeKind.Utc),
                    contractType1 = "Conditions of Funding (Grant) (College)"
                },
                "TEMPLATE-CONTAINER");

            // assert
            Assert.IsNotNull(documentGenerationRequests, "Unexpected null result returned");
            Assert.AreEqual(0, documentGenerationRequests.Count, "Unexpected number of DocumentGenerationRequest instances returned");
        }
    }
}
