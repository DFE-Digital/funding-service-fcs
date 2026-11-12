namespace SFA.FCT.DocumentsDomain.DocumentGeneration.Tests.Appendix_1
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Linq;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Common;
    using Common.Models;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Repositories;
    using CrossDomain.Integration.Entities.CorporateContract;
    using CrossDomain.Integration.Messages.Commands;
    using DataStore;
    using DataStore.Repositories;
    using DocumentDefiner.DocumentConfiguration;
    using DocumentDefiner.DocumentPartCreators.Appendix1;
    using Framework.Logging;
    using Integration;
    using IoC;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using PaymentManagementDomain.PolicyCache.DataStore;
    using UnitTests.Common;

    [TestClass]
    public class DeliveryOrgAppendix1Tests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void DeliveryOrgAppendix1_ShouldBeRequiredIfContractIsMainstreamAndAnAllocHasANonContractingDeliveryOrg()
        {
            // arrange
            var mainstreamContract = new contractType
            {
                fundingType = new fundingType
                {
                    fundingTypeCode = "MAIN"
                },
                contractor = new Contractor
                {
                    ukprn = 87654321,
                    legalName = "CONTRACTING ORG"
                },
                contractAllocations = new List<contractAllocationsContractAllocation>
                {
                    new contractAllocationsContractAllocation
                    {
                        DeliveryOrganisation = "12345678",
                        DeliveryOrganisationDetail = new Contractor
                        {
                            ukprn = 12345678,
                            legalName = "DELIVERY ORG 1"
                        }
                    }
                }
            };

            DeliveryOrgAppendix1 deliveryOrgAppendix1 = new DeliveryOrgAppendix1(Mock.Of<ITemplateRepository>(),
                Mock.Of<IDocumentConfigurationSource>(), Mock.Of<IFundingTypeFundingPeriodQueryRepository>(),
                Mock.Of<IPaymentManagementPolicyContext>());

            // act, assert
            Assert.IsTrue(deliveryOrgAppendix1.IsDocumentPartRequired(mainstreamContract),
                "Document part should be required for Mainstream contract with non contracting delivery org");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DeliveryOrgAppendix1_ShouldBeRequiredIfContractIsLoansAndAnAllocHasANonContractingDeliveryOrg()
        {
            // arrange
            var mainstreamContract = new contractType
            {
                fundingType = new fundingType
                {
                    fundingTypeCode = "LOANS"
                },
                contractor = new Contractor
                {
                    ukprn = 87654321,
                    legalName = "CONTRACTING ORG"
                },
                contractAllocations = new List<contractAllocationsContractAllocation>
                {
                    new contractAllocationsContractAllocation
                    {
                        DeliveryOrganisation = "12345678",
                        DeliveryOrganisationDetail = new Contractor
                        {
                            ukprn = 12345678,
                            legalName = "DELIVERY ORG 1"
                        }
                    }
                }
            };

            DeliveryOrgAppendix1 deliveryOrgAppendix1 = new DeliveryOrgAppendix1(Mock.Of<ITemplateRepository>(),
                Mock.Of<IDocumentConfigurationSource>(), Mock.Of<IFundingTypeFundingPeriodQueryRepository>(),
                Mock.Of<IPaymentManagementPolicyContext>());

            // act, assert
            Assert.IsTrue(deliveryOrgAppendix1.IsDocumentPartRequired(mainstreamContract),
                "Document part should be required for Loans contract with non contracting delivery org");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DeliveryOrgAppendix1_ShouldBeRequiredIfContractIsAebAndAnAllocHasANonContractingDeliveryOrg()
        {
            // arrange
            var mainstreamContract = new contractType
            {
                fundingType = new fundingType
                {
                    fundingTypeCode = "AEB"
                },
                contractor = new Contractor
                {
                    ukprn = 87654321,
                    legalName = "CONTRACTING ORG"
                },
                contractAllocations = new List<contractAllocationsContractAllocation>
                {
                    new contractAllocationsContractAllocation
                    {
                        DeliveryOrganisation = "12345678",
                        DeliveryOrganisationDetail = new Contractor
                        {
                            ukprn = 12345678,
                            legalName = "DELIVERY ORG 1"
                        }
                    }
                }
            };

            DeliveryOrgAppendix1 deliveryOrgAppendix1 = new DeliveryOrgAppendix1(Mock.Of<ITemplateRepository>(),
                Mock.Of<IDocumentConfigurationSource>(), Mock.Of<IFundingTypeFundingPeriodQueryRepository>(),
                Mock.Of<IPaymentManagementPolicyContext>());

            // act, assert
            Assert.IsTrue(deliveryOrgAppendix1.IsDocumentPartRequired(mainstreamContract),
                "Document part should be required for AEB contract with non contracting delivery org");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DeliveryOrgAppendix1_ShouldNotBeRequiredIfContractIsMainstreamAndNoAllocsHaveDeliveryOrgs()
        {
            // arrange
            var mainstreamContract = new contractType
            {
                fundingType = new fundingType
                {
                    fundingTypeCode = "MAIN"
                },
                contractor = new Contractor
                {
                    ukprn = 87654321,
                    legalName = "CONTRACTING ORG"
                },
                contractAllocations = new List<contractAllocationsContractAllocation>
                {
                    new contractAllocationsContractAllocation
                    {
                    }
                }
            };

            DeliveryOrgAppendix1 deliveryOrgAppendix1 = new DeliveryOrgAppendix1(Mock.Of<ITemplateRepository>(),
                Mock.Of<IDocumentConfigurationSource>(), Mock.Of<IFundingTypeFundingPeriodQueryRepository>(),
                Mock.Of<IPaymentManagementPolicyContext>());

            // act, assert
            Assert.IsFalse(deliveryOrgAppendix1.IsDocumentPartRequired(mainstreamContract),
                "Document part should not be required for contract with no non-contracting delivery orgs");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DeliveryOrgAppendix1_ShouldNotBeRequiredIfContractIsMainstreamAndAllocsHaveDeliveryOrgsEqualToContractingOrg()
        {
            // arrange
            var mainstreamContract = new contractType
            {
                fundingType = new fundingType
                {
                    fundingTypeCode = "MAIN"
                },
                contractor = new Contractor
                {
                    ukprn = 87654321,
                    legalName = "CONTRACTING ORG"
                },
                contractAllocations = new List<contractAllocationsContractAllocation>
                {
                    new contractAllocationsContractAllocation
                    {
                        DeliveryOrganisation = "87654321",
                        DeliveryOrganisationDetail = new Contractor
                        {
                            ukprn = 87654321,
                            legalName = "CONTRACTING ORG"
                        }
                    }
                }
            };

            DeliveryOrgAppendix1 deliveryOrgAppendix1 = new DeliveryOrgAppendix1(Mock.Of<ITemplateRepository>(),
                Mock.Of<IDocumentConfigurationSource>(), Mock.Of<IFundingTypeFundingPeriodQueryRepository>(),
                Mock.Of<IPaymentManagementPolicyContext>());

            // act, assert
            Assert.IsFalse(deliveryOrgAppendix1.IsDocumentPartRequired(mainstreamContract),
                "Document part should not be required for contract with no non-contracting delivery orgs");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void DeliveryOrgAppendix1_ShouldGenerateAppendix1ForEachDeliveryOrgWithCorrectValues()
        {
            // arrange
            var documentGenerationCommand = TestResource.FromJson<DocumentGenerationCommand>(
                "SFA.FCT.DocumentsDomain.DocumentGeneration.Tests",
                "Resources.DocGenCommandDeliveryOrgWithContractingOrg.json");

            contractType contract = documentGenerationCommand.CorporateContract;

            using (IWindsorContainer container = GetDocumentGenerationEndpointContainer())
            using (container.BeginScope())
            {
                DeliveryOrgAppendix1 deliveryOrgAppendix1 = new DeliveryOrgAppendix1(
                    container.Resolve<ITemplateRepository>(),
                    new DocumentConfigurationSource(container.Resolve<IFundingStreamPeriodRepository>(), container.Resolve<IFspDeliverableRepository>(),
                        new FundingTypeFundingPeriodRepository(container.Resolve<DocumentsDomainDbContext>())),
                    container.Resolve<IFundingTypeFundingPeriodQueryRepository>(),
                    container.Resolve<IPaymentManagementPolicyContext>());

                // act
                IDictionary<string, DocumentGenerationRequest> docGenRequests =
                    deliveryOrgAppendix1.SupplyDocumentGenerationRequest(
                        documentGenerationCommand.MasterContractNumber,
                        contract,
                        ConfigurationManager.AppSettings["DocumentGeneration.TemplateContainer"]);

                // assert
                Assert.AreEqual(3, docGenRequests.Count, "An incorrect number of doc gen requests were returned");
                Assert.IsTrue(docGenRequests.ContainsKey("2001-NACRO"),
                    "Contracting Org Doc Gen Request was not found");
                Assert.IsTrue(docGenRequests.ContainsKey("2002-10117709 Ltd"),
                    "Delivery org 1 doc gen request was not found");
                Assert.IsTrue(docGenRequests.ContainsKey("2002-10217709 Ltd"),
                    "Delivery org 2 dog gen request was not found");

                var orderedRequests = docGenRequests.OrderBy(r => r.Key).ToList();

                // first request - contracting org
                Assert.AreEqual("2001-NACRO", orderedRequests[0].Key,
                    "Contracting org Doc Gen Request should be first");

                AssertTopLevelMergeFieldsAreCorrect(mergeFields: orderedRequests[0].Value.MergeData.MergeFields,
                    masterContractRef: documentGenerationCommand.MasterContractNumber, 
                    ukprn: "10017709", 
                    orgName: "NACRO", 
                    totalValue: "36.00");

                AssertRepeatingSectionMergeFieldsAreCorrect(table: orderedRequests[0].Value.MergeData.RepeatingSections.First(),
                    singleDelPeriodValue: 1.0m);

                // second request - 10117709
                Assert.AreEqual("2002-10117709 Ltd", orderedRequests[1].Key,
                    "First delivery org Doc Gen Request should be second");

                AssertTopLevelMergeFieldsAreCorrect(mergeFields: orderedRequests[1].Value.MergeData.MergeFields,
                    masterContractRef: documentGenerationCommand.MasterContractNumber, 
                    ukprn: "10117709", 
                    orgName: "10117709 Ltd",
                    totalValue: "72.00");

                AssertRepeatingSectionMergeFieldsAreCorrect(table: orderedRequests[1].Value.MergeData.RepeatingSections.First(),
                    singleDelPeriodValue: 2.0m);

                // third request - 10217709
                Assert.AreEqual("2002-10217709 Ltd", orderedRequests[2].Key,
                    "Second delivery org Doc Gen Request should be last");

                AssertTopLevelMergeFieldsAreCorrect(mergeFields: orderedRequests[2].Value.MergeData.MergeFields,
                    masterContractRef: documentGenerationCommand.MasterContractNumber, 
                    ukprn: "10217709", 
                    orgName: "10217709 Ltd", 
                    totalValue: "108.00");

                AssertRepeatingSectionMergeFieldsAreCorrect(table: orderedRequests[2].Value.MergeData.RepeatingSections.First(),
                    singleDelPeriodValue: 3.0m);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void DeliveryOrgAppendix1_ShouldRenderDeliverablesThatShouldBeDisplayedOnSummaryOfFunding()
        {
            // arrange
            contractType contract = new contractType
            {
                contractor = new Contractor
                {
                    ukprn = 12345678,
                    organisationIdentifier = "ORG0000001",
                    legalName = "Contracting Org"
                },
                contractNumber = "MAIN-1234",
                fundingType = new fundingType
                {
                    fundingTypeCode = "MAIN"
                },
                period = new Period
                {
                    periodType = new periodTypeType
                    {
                        periodTypeCode = periodTypeCodeType.AY
                    },
                    period1 = "1819"
                },
                startDate = new DateTime(2018, 8, 1),
                contractAllocations = new List<contractAllocationsContractAllocation>
                {
                    new contractAllocationsContractAllocation
                    {
                        contractAllocationNumber = "AEC-123",
                    },
                    new contractAllocationsContractAllocation
                    {
                        contractAllocationNumber = "AEC-124",
                        DeliveryOrganisation = "87654321",
                        DeliveryOrganisationDetail = new Contractor()
                        {
                            ukprn = 87654321,
                            organisationIdentifier = "ORG0000002",
                            legalName = "Delivery Org"
                        }
                    }
                }
            };

            contract.contractAllocations.ForEach(a =>
            {
                a.fundingStreamPeriodCode = "AEBC1819";
                a.fundingStream = new fundingStream
                {
                    fundingStreamCode = "AEBC",
                    fundingTypeCode = "MAIN"
                };
                a.contractDeliverables = new List<contractDeliverablesTypeContractDeliverable>
                {
                    new contractDeliverablesTypeContractDeliverable
                    {
                        deliverable = new deliverableType
                        {
                            deliverableCode = 1
                        },
                        plannedValue = 12m
                    },
                    new contractDeliverablesTypeContractDeliverable
                    {
                        deliverable = new deliverableType
                        {
                            deliverableCode = 13
                        },
                        plannedValue = 12m
                    }
                };

                a.contractDeliverables.ForEach(d =>
                    d.contractDeliverablePeriods =
                        Enumerable.Range(1, 12).Select(i => new contractDeliverablePeriodsTypeContractDeliverablePeriod
                        {
                            period = i,
                            plannedValue = 1m,
                            year = i < 8 ? 2019 : 2018
                        }).ToList());
            });

            using (IWindsorContainer container = GetDocumentGenerationEndpointContainer())
            using (container.BeginScope())
            {
                DeliveryOrgAppendix1 deliveryOrgAppendix1 = new DeliveryOrgAppendix1(
                    container.Resolve<ITemplateRepository>(),
                    new DocumentConfigurationSource(container.Resolve<IFundingStreamPeriodRepository>(),
                        container.Resolve<IFspDeliverableRepository>(), new FundingTypeFundingPeriodRepository(container.Resolve<DocumentsDomainDbContext>())),
                    container.Resolve<IFundingTypeFundingPeriodQueryRepository>(),
                    container.Resolve<IPaymentManagementPolicyContext>());

                // act
                IDictionary<string, DocumentGenerationRequest> docGenRequests =
                    deliveryOrgAppendix1.SupplyDocumentGenerationRequest(
                        "ESFA-123",
                        contract,
                        ConfigurationManager.AppSettings["DocumentGeneration.TemplateContainer"]);

                // assert
                Assert.AreEqual(2, docGenRequests.Count, "There was an incorrect count of document gen requests");

                docGenRequests.ToList().ForEach(dgr =>
                {
                    List<MergeFieldType> relevantRowFields = dgr.Value.MergeData.RepeatingSections[0].Rows[1].MergeFields;

                    Assert.AreEqual("^s^tof which Community Learning", relevantRowFields.Single(mf => mf.Name == "AllocationName").Value,
                        "'AllocationName' for deliverable row was incorrect");
                    Assert.AreEqual(string.Empty, relevantRowFields.Single(mf => mf.Name == "AllocationContractRef").Value,
                        "'AllocationContractRef' for deliverable row was incorrect");
                    Assert.AreEqual("8.00", relevantRowFields.Single(mf => mf.Name == "AllocationPeriodOneTotal").Value,
                        "'AllocationPeriodOneTotal' for deliverable row was incorrect");
                    Assert.AreEqual("4.00", relevantRowFields.Single(mf => mf.Name == "AllocationPeriodTwoTotal").Value,
                        "'AllocationPeriodTwoTotal' for deliverable row was incorrect");
                    Assert.AreEqual("12.00", relevantRowFields.Single(mf => mf.Name == "AllocationTotal").Value,
                        "'AllocationTotal' for deliverable row was incorrect");
                });
            }
        }

        private void AssertTopLevelMergeFieldsAreCorrect(List<MergeFieldType> mergeFields, string masterContractRef, string ukprn, string orgName, string totalValue)
        {
            Assert.AreEqual(masterContractRef, mergeFields.Single(m => m.Name == "MasterContractRef").Value);
            Assert.AreEqual(totalValue, mergeFields.Single(m => m.Name == "ContractTotal").Value);
            Assert.AreEqual(ukprn, mergeFields.Single(m => m.Name == "UKPRN").Value);
            Assert.AreEqual(orgName, mergeFields.Single(m => m.Name == "OrgName").Value);
        }

        private void AssertRepeatingSectionMergeFieldsAreCorrect(RepeatingSectionType table, decimal singleDelPeriodValue)
        {
            decimal fyOneValue = singleDelPeriodValue * 8; // 8 months in first financial year within academic year
            decimal fyTwoValue = singleDelPeriodValue * 4; // 4 months in second financial year within academic year
            decimal totalValue = fyOneValue + fyTwoValue; // full 12-month academic year

            Assert.AreEqual(3, table.Rows.Count, "Count of table rows was incorrect");

            // allocation names
            Assert.AreEqual("Apprenticeships Carry-In", table.Rows[0].MergeFields.Single(mf => mf.Name == "AllocationName").Value,
                "First row allocation name is incorrect");
            Assert.AreEqual("16-18 Traineeships", table.Rows[1].MergeFields.Single(mf => mf.Name == "AllocationName").Value,
                "Second row allocation name is incorrect");
            Assert.AreEqual("Adult Education Budget", table.Rows[2].MergeFields.Single(mf => mf.Name == "AllocationName").Value,
                "Third row allocation name is incorrect");

            // allocation contract refs
            Assert.IsTrue(table.Rows[0].MergeFields.Single(mf => mf.Name == "AllocationContractRef").Value.StartsWith("APPS-"),
                "First row allocation reference is incorrect");
            Assert.IsTrue(table.Rows[1].MergeFields.Single(mf => mf.Name == "AllocationContractRef").Value.StartsWith("16TR-"),
                "Second row allocation reference is incorrect");
            Assert.IsTrue(table.Rows[2].MergeFields.Single(mf => mf.Name == "AllocationContractRef").Value.StartsWith("AEC-"),
                "Third row allocation ref is incorrect");
            
            // period one totals
            table.Rows.ForEach(r =>
            {
                string allocName = r.MergeFields.Single(mf => mf.Name == "AllocationName").Value;

                // period one totals
                Assert.AreEqual(fyOneValue.ToString(Constants.DecimalToValueFormat), r.MergeFields.Single(mf => mf.Name == "AllocationPeriodOneTotal").Value,
                    $"Allocation Period 1 Total was incorrect for {allocName}");

                // period two totals
                Assert.AreEqual(fyTwoValue.ToString(Constants.DecimalToValueFormat), r.MergeFields.Single(mf => mf.Name == "AllocationPeriodTwoTotal").Value,
                    $"Allocation period 2 value was incorrect for {allocName}");

                // full year totals
                Assert.AreEqual(totalValue.ToString(Constants.DecimalToValueFormat), r.MergeFields.Single(mf => mf.Name == "AllocationTotal").Value,
                    $"Total allocation value was incorrect for {allocName}");
            });
        }

        private static IWindsorContainer GetDocumentGenerationEndpointContainer()
        {
            return WindsorInstallerForDocumentGenerator.Container;
        }
    }
}