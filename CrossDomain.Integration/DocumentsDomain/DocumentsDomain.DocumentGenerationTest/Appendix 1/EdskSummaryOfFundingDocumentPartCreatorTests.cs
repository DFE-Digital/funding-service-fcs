namespace SFA.FCT.DocumentsDomain.DocumentGeneration.Tests.Appendix_1
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Linq;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Common.Models;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Repositories;
    using CrossDomain.Integration.Entities.CorporateContract;
    using CrossDomain.Integration.Entities.Data;
    using CrossDomain.Integration.Messages.Commands;
    using DataStore;
    using DataStore.Repositories;
    using DocumentDefiner;
    using DocumentDefiner.DocumentConfiguration;
    using DocumentDefiner.DocumentPartCreators.Appendix1;
    using Framework.Logging;
    using Integration;
    using IoC;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using PaymentManagementDomain.PolicyCache.DataStore;
    using PaymentManagementDomain.PolicyCache.DataStore.Model;
    using PaymentManagementDomain.PolicyCache.DataStore.Repositories;
    using SFA.FCT.DocumentsDomain.DocumentGeneration.Repositories;
    using UnitTests.Common;

    [TestClass]
    public class EdskSummaryOfFundingDocumentPartCreatorTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void EdskSummaryOfFundingDocumentPartCreator_IsHeaderDocumentRequired_ShouldReturnFalse()
        {
            // arrange
            EdskSummaryOfFundingDocumentPartCreator creator = new EdskSummaryOfFundingDocumentPartCreator(
                Mock.Of<ITemplateRepository>(),
                Mock.Of<IDocumentConfigurationSource>(),
                Mock.Of<IFundingTypeFundingPeriodQueryRepository>(),
                Mock.Of<IPayCalcPolicyQueryRepository>(),
                Mock.Of<IFundingStreamPeriodRepository>(),
                Mock.Of<IContractReferenceConfigRepository>());

            // act
            bool isHeaderDocumentRequired = creator.IsHeaderDocumentRequired;

            // assert
            Assert.IsFalse(isHeaderDocumentRequired);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void EdskSummaryOfFundingDocumentPartCreator_RequiredHeaderDocumentName_ShouldThrowApplicationException()
        {
            // arrange
            EdskSummaryOfFundingDocumentPartCreator creator = new EdskSummaryOfFundingDocumentPartCreator(
                Mock.Of<ITemplateRepository>(),
                Mock.Of<IDocumentConfigurationSource>(),
                Mock.Of<IFundingTypeFundingPeriodQueryRepository>(),
                Mock.Of<IPayCalcPolicyQueryRepository>(),
                Mock.Of<IFundingStreamPeriodRepository>(),
                Mock.Of<IContractReferenceConfigRepository>());


            bool expectedExceptionThrown = false;

            // act
            try
            {
                string requiredHeaderDocumentName = creator.RequiredHeaderDocumentName;
            }
            catch (ApplicationException)
            {
                expectedExceptionThrown = true;
            }

            // assert
            Assert.IsTrue(expectedExceptionThrown);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void EdskSummaryOfFundingDocumentPartCreator_IsDocumentPartRequired_ShouldReturnTrueWhenFundingTypeIsEdsk()
        {
            // arrange
            EdskSummaryOfFundingDocumentPartCreator creator = new EdskSummaryOfFundingDocumentPartCreator(
                Mock.Of<ITemplateRepository>(),
                Mock.Of<IDocumentConfigurationSource>(),
                Mock.Of<IFundingTypeFundingPeriodQueryRepository>(),
                Mock.Of<IPayCalcPolicyQueryRepository>(),
                Mock.Of<IFundingStreamPeriodRepository>(),
                Mock.Of<IContractReferenceConfigRepository>());

            // act
            bool isDocumentPartRequired = creator.IsDocumentPartRequired(new contractType
            {
                fundingType = new fundingType
                {
                    fundingTypeCode = "EDSK"
                }
            });

            // assert
            Assert.IsTrue(isDocumentPartRequired);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void EdskSummaryOfFundingDocumentPartCreator_IsDocumentPartRequired_ShouldReturnFalseWhenFundingTypeIsMain()
        {
            // arrange
            EdskSummaryOfFundingDocumentPartCreator creator = new EdskSummaryOfFundingDocumentPartCreator(
                Mock.Of<ITemplateRepository>(),
                Mock.Of<IDocumentConfigurationSource>(),
                Mock.Of<IFundingTypeFundingPeriodQueryRepository>(),
                Mock.Of<IPayCalcPolicyQueryRepository>(),
                Mock.Of<IFundingStreamPeriodRepository>(),
                Mock.Of<IContractReferenceConfigRepository>());

            // act
            bool isDocumentPartRequired = creator.IsDocumentPartRequired(new contractType
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
        public void EdskSummaryOfFundingDocumentPartCreator_SupplyDocumentGenerationRequest_ShouldReturnAllocationsInExpectedSortOrder()
        {
            // arrange
            Mock<IDocumentConfigurationSource> documentConfigurationSourceMock = new Mock<IDocumentConfigurationSource>();
            documentConfigurationSourceMock
                .Setup(m => m.GetAllocationName(It.IsAny<contractAllocationsContractAllocation>()))
                .Returns<contractAllocationsContractAllocation>(ca => ca.fundingStreamPeriodCode);

            Mock<IPayCalcPolicyQueryRepository> payCalcQueryRepositoryMock = new Mock<IPayCalcPolicyQueryRepository>();
            payCalcQueryRepositoryMock
                .Setup(m => m.GetFundingStreamPeriodDeliverablesNonConnectionInfo("FSP1"))
                .Returns(new List<PolicyDeliverable>
                {
                    new PolicyDeliverable {FundingStreamPeriod = "FSP1", DeliverableCode = 1, ParentDeliverableCode = null}
                });
            payCalcQueryRepositoryMock
                .Setup(m => m.GetFundingStreamPeriodDeliverablesNonConnectionInfo("FSP2"))
                .Returns(new List<PolicyDeliverable>
                {
                    new PolicyDeliverable {FundingStreamPeriod = "FSP2", DeliverableCode = 1, ParentDeliverableCode = null}
                });

            Mock<IFundingTypeFundingPeriodQueryRepository> fundTypeFundingPeriodQueryRepositoryMock = new Mock<IFundingTypeFundingPeriodQueryRepository>();
            fundTypeFundingPeriodQueryRepositoryMock
                .Setup(m => m.Get(It.IsAny<string>(), It.IsAny<string>()))
                .Returns(new ContractManagement.DataStore.Model.FundingTypeFundingPeriod());

            Mock<IFundingStreamPeriodRepository> fundingStreamPeriodRepMock = new Mock<IFundingStreamPeriodRepository>();
            fundingStreamPeriodRepMock.Setup(r => r.GetByKey(It.IsAny<string>())).Returns((string fsp) =>
            {
                return new SFA.FCT.DocumentsDomain.DataStore.Models.FundingStreamPeriod(
                    fsp,
                    "",
                    int.Parse(fsp.Substring(fsp.Length-1)),
                    false,
                    false,
                    "",
                    "",
                    "",
                    "");
            });


            EdskSummaryOfFundingDocumentPartCreator creator = new EdskSummaryOfFundingDocumentPartCreator(
                Mock.Of<ITemplateRepository>(),
                documentConfigurationSourceMock.Object,
                fundTypeFundingPeriodQueryRepositoryMock.Object,
                payCalcQueryRepositoryMock.Object,
                fundingStreamPeriodRepMock.Object,
                Mock.Of<IContractReferenceConfigRepository>());

            // act
            IDictionary<string, DocumentGenerationRequest> documentGenerationRequests = creator.SupplyDocumentGenerationRequest(
                "MASTER-123",
                new Contract
                {
                    startDate = new DateTime(2019, 08, 01),
                    period = new Period
                    {
                        period1 = "1920"
                    },
                    contractor = new Contractor
                    {
                        ukprn = 1,
                        legalName = "CONTRACTING ORG"
                    },
                    contractAllocations = new List<contractAllocationsContractAllocation>
                    {
                        new contractAllocationsContractAllocation
                        {
                            contractAllocationNumber = "FSP2-1",
                            fundingStreamPeriodCode = "FSP2",
                            DeliveryOrganisationDetail = new Contractor // DeliveryOrganisationDetail appears to be populated for the contracting org when there are other delivery orgs present
                            {
                                ukprn = 1,
                                legalName = "CONTRACTING ORG"
                            }
                        },
                        new contractAllocationsContractAllocation
                        {
                            contractAllocationNumber = "FSP2-2",
                            fundingStreamPeriodCode = "FSP2",
                            DeliveryOrganisationDetail = new Contractor
                            {
                                ukprn = 2,
                                legalName = "XYZ DELIVERY ORG"
                            }
                        },
                        new contractAllocationsContractAllocation
                        {
                            contractAllocationNumber = "FSP2-3",
                            fundingStreamPeriodCode = "FSP2",
                            DeliveryOrganisationDetail = new Contractor
                            {
                                ukprn = 3,
                                legalName = "ABC DELIVERY ORG"
                            }
                        },
                        new contractAllocationsContractAllocation
                        {
                            contractAllocationNumber = "FSP1-1",
                            fundingStreamPeriodCode = "FSP1",
                            DeliveryOrganisationDetail = new Contractor
                            {
                                ukprn = 1,
                                legalName = "CONTRACTING ORG"
                            }
                        },
                        new contractAllocationsContractAllocation
                        {
                            contractAllocationNumber = "FSP1-2",
                            fundingStreamPeriodCode = "FSP1",
                            DeliveryOrganisationDetail = new Contractor
                            {
                                ukprn = 2,
                                legalName = "XYZ DELIVERY ORG"
                            }
                        },
                        new contractAllocationsContractAllocation
                        {
                            contractAllocationNumber = "FSP1-3",
                            fundingStreamPeriodCode = "FSP1",
                            DeliveryOrganisationDetail = new Contractor
                            {
                                ukprn = 3,
                                legalName = "ABC DELIVERY ORG"
                            }
                        }
                    }
                },
                "TEMPLATE-CONTAINER");

            // assert
            DocumentGenerationRequestMergeData mergeData = documentGenerationRequests.Single().Value.MergeData;
            RepeatingSectionType repeatingSection = mergeData.RepeatingSections.Single();

            Assert.AreEqual(8, repeatingSection.Rows.Count, "Unexpected number of RepeatingSections.Rows returned");

            Assert.AreEqual("FSP1", repeatingSection.Rows.First().MergeFields.Single(mf => mf.Name == "FundingStreamName")?.Value, "Funding Streams are not in the expected sort order");
            Assert.AreEqual("CONTRACTING ORG", repeatingSection.Rows.Skip(1).First().MergeFields.Single(mf => mf.Name == "OrgName")?.Value, "Allocations are not in the expected sort order");
            Assert.AreEqual("ABC DELIVERY ORG", repeatingSection.Rows.Skip(2).First().MergeFields.Single(mf => mf.Name == "OrgName")?.Value, "Allocations are not in the expected sort order");
            Assert.AreEqual("XYZ DELIVERY ORG", repeatingSection.Rows.Skip(3).First().MergeFields.Single(mf => mf.Name == "OrgName")?.Value, "Allocations are not in the expected sort order");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void EdskSummaryOfFundingDocumentPartCreator_SupplyDocumentGenerationRequest_ShouldReturnExpectedDocumentGenerationRequest()
        {
            // arrange
            IWindsorContainer container = WindsorInstallerForDocumentGenerator.Container;
            container.BeginScope();

            EdskSummaryOfFundingDocumentPartCreator creator = container.ResolveAll<DocumentPartCreator>()
                .OfType<EdskSummaryOfFundingDocumentPartCreator>()
                .Single();

            Contract contract = TestResource.FromJson<DocumentGenerationCommand>(
                "SFA.FCT.DocumentsDomain.DocumentGeneration.Tests.Resources",
                "DocGenCommandEdskWithAllocationsForContractingAndDeliveryOrgs.json").CorporateContract;

            string templateContainer = ConfigurationManager.AppSettings["DocumentGeneration.TemplateContainer"];

            // act
            IDictionary<string, DocumentGenerationRequest> documentGenerationRequests = creator.SupplyDocumentGenerationRequest(
                "ESFA-127129", contract, templateContainer);

            // assert
            Assert.IsNotNull(documentGenerationRequests, "Unexpected null result returned");
            Assert.AreEqual(1, documentGenerationRequests.Count, "Unexpected number of DocumentGenerationRequest instances returned");
            Assert.AreEqual("1000", documentGenerationRequests.Single().Key, "Unexpected order string returned");

            DocumentGenerationRequest documentGenerationRequest = documentGenerationRequests.Single().Value;
            Assert.AreEqual(templateContainer, documentGenerationRequest.TemplateContainer, "Unexpected TemplateContainer returned");
            Assert.AreEqual("SOF_EDSK_2019-08-01.docx", documentGenerationRequest.TemplateFilename, "Unexpected TemplateFilename returned");
            Assert.IsNotNull(documentGenerationRequest.MergeData, "Unexpected null merge data returned");

            DocumentGenerationRequestMergeData mergeData = documentGenerationRequest.MergeData;
            Assert.AreEqual("10017879 Co Ltd", mergeData.MergeFields.SingleOrDefault(mf => mf.Name == "ContractingOrgName")?.Value, "Incorrect ContractingOrgName MergeField returned");
            Assert.AreEqual("10017879", mergeData.MergeFields.SingleOrDefault(mf => mf.Name == "ContractingOrgUkprn")?.Value, "Incorrect ContractingOrgUkprn MergeField returned");
            Assert.AreEqual("ESFA-127129", mergeData.MergeFields.SingleOrDefault(mf => mf.Name == "MasterContractRef")?.Value, "Incorrect MasterContractRef MergeField returned");
            Assert.AreEqual("£255,934", mergeData.MergeFields.SingleOrDefault(mf => mf.Name == "ContractTotal")?.Value, "Incorrect ContractTotal MergeField returned");
            Assert.AreEqual(1, documentGenerationRequest.MergeData.RepeatingSections.Count, "Unexpected number of RepeatingSection instances returned");

            RepeatingSectionType mainTableRepeatingSection = documentGenerationRequest.MergeData.RepeatingSections.SingleOrDefault(rs => rs.Name == "MainTable");
            Assert.IsNotNull(mainTableRepeatingSection, "MainTable RepeatingSection not returned");
            Assert.AreEqual(6, mainTableRepeatingSection.Rows.Count, "Unexpected number of MainTable RepeatingSection Rows returned");

            Assert.AreEqual("Advanced Learner Loans Facility", mainTableRepeatingSection.Rows.First().MergeFields.SingleOrDefault(mf => mf.Name == "FundingStreamName")?.Value, "FundingStreamName is not set for heading row");
            Assert.IsNull(mainTableRepeatingSection.Rows.Skip(1).First().MergeFields.SingleOrDefault(mf => mf.Name == "IsFundingStreamTitleRow"), "FundingStreamName is set for non-heading row");
        }
    }
}
