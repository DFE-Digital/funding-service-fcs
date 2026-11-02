namespace SFA.FCT.DocumentsDomain.DocumentGeneration.Tests
{
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentDefiner;
    using SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentDefiner.DocumentConfiguration;
    using SFA.FCT.DocumentsDomain.Integration;
    using Common.Models;
    using DocumentDefiner.DocumentPartCreators;
    using Framework.Logging;
    using PaymentManagementDomain.PolicyCache.DataStore;
    using UnitTests.Common;

    [TestClass]
    public class DocumentPartCreatorTests : DocumentPartCreator
    {
        public DocumentPartCreatorTests() : base (null, DocumentConfigurationSourceTests.GetDocumentConfigurationSourceWithMockRepositories())
        {
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void TestGetNameOfTemplateActiveOnDateForSimpleCase()
        {
            Mock<IAzureStorageWrapper> azureMock = new Mock<IAzureStorageWrapper>();
            azureMock
                .Setup(m => m.GetContainerContents(It.IsAny<string>()))
                .Returns(new string[]
                {
                    "A2_OLASS1516_2015-08-01.docx"
                });

            DocumentPartCreatorTestChild child = new DocumentPartCreatorTestChild(new TemplateRepository(azureMock.Object), DocumentConfigurationSourceTests.GetDocumentConfigurationSourceWithMockRepositories());

            string templateName = child.TestGetNameOfTemplateActiveOnDate("document-io-unittest", "A2_OLASS1516", new DateTime(2015, 08, 01));

            Assert.AreEqual("A2_OLASS1516_2015-08-01.docx", templateName);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        [ExpectedException(typeof (FileNotFoundException))]
        public void TestGetNameOfTemplateActiveOnDateWhenFileNotFound()
        {
            Mock<IAzureStorageWrapper> azureMock = new Mock<IAzureStorageWrapper>();
            azureMock
                .Setup(m => m.GetContainerContents(It.IsAny<string>()))
                .Returns(new string[]
                {
                    "A2_OLASS1516_2015-08-01.docx"
                });

            DocumentPartCreatorTestChild child = new DocumentPartCreatorTestChild(new TemplateRepository(azureMock.Object), DocumentConfigurationSourceTests.GetDocumentConfigurationSourceWithMockRepositories());
            string templateName = child.TestGetNameOfTemplateActiveOnDate("document-io-unittest", "A2_OLASS1516", new DateTime(2015, 07, 01));
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void TestGetNameOfTemplateActiveOnDateForMultipleTemplates()
        {
            Mock<IAzureStorageWrapper> azureMock = new Mock<IAzureStorageWrapper>();
            azureMock.Setup(m => m.GetContainerContents(It.IsAny<string>()))
                .Returns(new string[]
                {
                    "A2_OLASS1516_2015-08-01.docx",
                    "A2_OLASS1516_2015-09-01.docx",
                    "A2_OLASS1516_2015-10-01.docx"
                });

            DocumentPartCreatorTestChild child = new DocumentPartCreatorTestChild(new TemplateRepository(azureMock.Object), DocumentConfigurationSourceTests.GetDocumentConfigurationSourceWithMockRepositories());
            string templateName = child.TestGetNameOfTemplateActiveOnDate("document-io-unittest", "A2_OLASS1516", new DateTime(2015, 09, 01));

            Assert.AreEqual("A2_OLASS1516_2015-09-01.docx", templateName);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void TestGetNameOfTemplateActiveOnDateForComplexCase()
        {

            Mock<IAzureStorageWrapper> azureMock = new Mock<IAzureStorageWrapper>();
            azureMock
                .Setup(m => m.GetContainerContents(It.IsAny<string>()))
                .Returns(new string[]
                {
                    "A1_24+_1516_2015-08-01.docx",
                    "A1_24+_1516_2015-09-01.docx",
                    "A1_24+_1516_2015-10-01.docx",
                    "A1_24+_1516_2015-11-01.docx",
                    "A1_AGE_1516_2015-08-01.docx",
                    "A1_ESF_1420_2015-08-01.docx",
                    "A1_MAIN_1516_2015-08-01.docx",
                    "A2_24+ALLB1516_2015-08-01.docx",
                    "A2_24+ALLB1516_2016-01-01.docx",
                    "A2_24+ALLB1516_2016-02-01.docx",
                    "A2_24+ALLB1516_2016-06-15.docx",
                    "A2_AGE1516_2015-08-01.docx",
                    "A2_ASC1516_2015-08-01.docx",
                    "A2_CL1516_2015-08-01.docx",
                    "A2_DLS1516_2015-08-01.docx",
                    "A2_OLASS1516_2015-08-01.docx",
                    "A2H_24+_2015-08-01.docx",
                    "A2H_AGE_2015-08-01.docx",
                    "A2H_ESF_2015-08-01.docx",
                    "A2H_MAIN_2015-08-01.docx"
                })
                .Verifiable();

            DocumentPartCreatorTestChild child = new DocumentPartCreatorTestChild(new TemplateRepository(azureMock.Object), DocumentConfigurationSourceTests.GetDocumentConfigurationSourceWithMockRepositories());

            Assert.AreEqual("A2_24+ALLB1516_2015-08-01.docx", child.TestGetNameOfTemplateActiveOnDate("document-io-unittest", "A2_24+ALLB1516", new DateTime(2015, 12, 30)));
            Assert.AreEqual("A2_24+ALLB1516_2016-02-01.docx", child.TestGetNameOfTemplateActiveOnDate("document-io-unittest", "A2_24+ALLB1516", new DateTime(2016, 02, 15)));
            Assert.AreEqual("A2_24+ALLB1516_2016-06-15.docx", child.TestGetNameOfTemplateActiveOnDate("document-io-unittest", "A2_24+ALLB1516", new DateTime(2016, 07, 31)));
        }

        [TestMethod, TestCategory("UnitTest")]
        [ExpectedException(typeof (ApplicationException))]
        public void TestWithPeriodWithInvalidStartYearInPeriodValue()
        {
            contractAllocationsContractAllocation allocation = new contractAllocationsContractAllocation()
            {
                period = new period()
                {
                    period1 = "SS16"
                }
            };

            GetMonthsInPeriod(allocation);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TestGetStartYearFromPeriod()
        {
            Assert.AreEqual(2016, GetStartYearFromPeriod(new period() {period1 = "1617"}));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TestGetEndYearFromPeriod()
        {
            Assert.AreEqual(2017, GetEndYearFromPeriod(new period() {period1 = "1617"}));
        }

        [TestMethod, TestCategory("UnitTest")]
        [ExpectedException(typeof (ApplicationException))]
        public void TestGetEndYearFromPeriodWithBadlyFormedPeriod()
        {
            period p = new period()
            {
                period1 = "yyyy"
            };

            GetEndYearFromPeriod(p);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TestGetStartMonthFromPeriodForAY()
        {
            period p = new period()
            {
                periodType = new periodTypeType()
                {
                    periodTypeCode = periodTypeCodeType.AY
                },
                period1 = "1516"
            };

            Assert.AreEqual(8, GetStartMonthFromPeriod(p));
        }
                
        [TestMethod, TestCategory("UnitTest")]
        public void TestGetStartMonthFromPeriodForFY()
        {
            period p = new period()
            {
                periodType = new periodTypeType()
                {
                    periodTypeCode = periodTypeCodeType.FY
                },
                period1 = "1516"
            };

            Assert.AreEqual(4, GetStartMonthFromPeriod(p));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TestGetEndMonthFromPeriodForAY()
        {
            period p = new period()
            {
                periodType = new periodTypeType()
                {
                    periodTypeCode = periodTypeCodeType.AY
                },
                period1 = "1516"
            };

            Assert.AreEqual(7, GetEndMonthFromPeriod(p));
        }
               
        [TestMethod, TestCategory("UnitTest")]
        public void TestGetEndMonthFromPeriodForFY()
        {
            period p = new period()
            {
                periodType = new periodTypeType()
                {
                    periodTypeCode = periodTypeCodeType.FY
                },
                period1 = "1516"
            };

            Assert.AreEqual(3, GetEndMonthFromPeriod(p));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TestGetMonthsInPeriodForESF1420()
        {
            string[] months = new DocumentPartCreatorTestChild(null, null).TestGetMonthsInPeriod(CreateAllocation("", periodTypeCodeType.ESF, "1420", new DateTime(2014,4,1), new DateTime(2020, 08,01)));
            Assert.AreEqual(7*12, months.Length);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TestGetMonthsInPeriodForESF1420WithShortContract()
        {
            string[] months = new DocumentPartCreatorTestChild(null, null).TestGetMonthsInPeriod(CreateAllocation("", periodTypeCodeType.ESF, "1420", new DateTime(2014, 4, 1), new DateTime(2014, 08, 01)));
            Assert.AreEqual(months.Length, 1 * 12);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TestGetMonthsInPeriodForESF1420WithThreeYearContract()
        {
            string[] months = new DocumentPartCreatorTestChild(null, null).TestGetMonthsInPeriod(CreateAllocation("", periodTypeCodeType.ESF, "1420", new DateTime(2016, 4, 1), new DateTime(2018, 08, 01)));
            Assert.AreEqual(months.Length, 3 * 12);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TestGetMonthsInPeriodForAY1516()
        {
            period p = new period()
            {
                period1 = "1516",
                periodType = new periodTypeType()
                {
                    periodTypeCode = periodTypeCodeType.AY
                }
            };

            string[] months = new DocumentPartCreatorTestChild(null, null).TestGetMonthsInPeriod(CreateAllocation("", periodTypeCodeType.AY, "1516", new DateTime(2015, 8, 1), new DateTime(2016, 07, 01)));
            Assert.AreEqual(months.Length, 12);
            Assert.AreEqual("Aug 2015", months[0]);
            Assert.AreEqual("Jul 2016", months[11]);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TestGetMonthsInPeriodForSB()
        {
            period p = new period()
            {
                period1 = "2022",
                periodType = new periodTypeType()
                {
                    periodTypeCode = periodTypeCodeType.SB
                }
            };

            string[] months = new DocumentPartCreatorTestChild(null, null).TestGetMonthsInPeriod(CreateAllocation("", periodTypeCodeType.SB, "2022", new DateTime(2021, 8, 1), new DateTime(2022, 07, 01)));
            Assert.AreEqual(months.Length, 12);
            Assert.AreEqual("Aug 2021", months[0]);
            Assert.AreEqual("Jul 2022", months[11]);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TestGetMonthsInPeriodForFY1819()
        {
            period p = new period()
            {
                period1 = "1819",
                periodType = new periodTypeType()
                {
                    periodTypeCode = periodTypeCodeType.FY
                }
            };

            string[] months = new DocumentPartCreatorTestChild(null, null).TestGetMonthsInPeriod(CreateAllocation("", periodTypeCodeType.FY, "1819", new DateTime(2018, 4, 1), new DateTime(2019, 03, 01)));
            Assert.AreEqual(months.Length, 12);
            Assert.AreEqual("Apr 2018", months[0]);
            Assert.AreEqual("Mar 2019", months[11]);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TestGetDocumentHeaderFields()
        {
            List<MergeFieldType> fields = GetDocumentHeaderFieldsForFundingStream("OLASS");
            Assert.AreEqual(16, fields.Count);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TestGetDocumentHeaderFieldsDocumentName()
        {
            Assert.AreEqual("Document Title String", GetDocumentHeaderFieldsForFundingStream("OLASS").First(mf => mf.Name == "DocumentTitle").Value);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TestGetDocumentHeaderFieldsHeaderTextForOLASS()
        {
            Assert.AreEqual("", GetDocumentHeaderFieldsForFundingStream("OLASS").First(mf => mf.Name == "HeaderText").Value);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TestGetDocumentHeaderFieldsHeaderTextForAGE()
        {
            Assert.IsTrue(GetDocumentHeaderFieldsForFundingStream("AGE").First(mf => mf.Name == "HeaderText").Value.Length > 0);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TestGetDocumentHeaderFieldsLotReferenceForESFandNotEmpty()
        {
            Assert.IsTrue(GetDocumentHeaderFieldsForFundingStream("ESF", "LotReference").First(mf => mf.Name == "LOT").Value == "LotReference");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TestGetDocumentHeaderFieldsLotReferenceForESFandIsEmpty()
        {
            Assert.IsTrue(GetDocumentHeaderFieldsForFundingStream("ESF", null).First(mf => mf.Name == "LOT").Value == "N/A");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DocumentPartCreator_GetDocumentHeaderFields_ShouldReturnWithCorrectMergedFields()
        {
            // arrange
            const string allocationDeliveryOrgLegalName = "Delivery Organisation";
            const int allocationDeliveryOrgUkprn = 12345678;
            const string masterContractNumber = "MASTER-1";
            const string childContractNumber = "Child-1";
            const int childContractVersion = 1;
            DateTime allocationStartDate = new DateTime(2015, 08, 01);
            DateTime allocationEndDate = new DateTime(2016, 07, 31);
            const string allocationContractRef = "Alloc-ContractRef";
            const string specificationTitle = "Specification-Title";
            const string lep = "Allocation-Lep";
            const string tenderSpecificationRef = "Tender-SpecificationRef";
            const string lot = "Lot";
            const string agreementNumber = "Alloc agreementNumber";
            const string deliveryOrgName = "DeliveryOrgName";
            const string allocationDesc = "Allocation description";
            const string allocationDeliveryOrgUpin = "8765";

            contract master = new contract
            {
                fundingType = new fundingType { fundingTypeCode = "ESF" },
                contractNumber = masterContractNumber,
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        contractAllocations = new List<contractAllocationsContractAllocation>
                        {
                            new contractAllocationsContractAllocation
                            {
                                contractAllocationNumber = allocationContractRef,
                                startDate = allocationStartDate,
                                endDate = allocationEndDate,
                                description = allocationDesc,
                                AgreementNumber = agreementNumber,
                                SpecificationTitle = specificationTitle,
                                tenderSpecificationReference = tenderSpecificationRef,
                                LEPName = lep,
                                lotReference = lot,
                                fundingStreamPeriodCode = "FspCode",
                                DeliveryOrganisationDetail =
                                    new contractor
                                    {
                                        legalName = allocationDeliveryOrgLegalName,
                                        ukprn = allocationDeliveryOrgUkprn,
                                        Upin = allocationDeliveryOrgUpin
                                    },
                                DeliveryOrganisation = deliveryOrgName,
                                fundingStream = new fundingStream
                                {
                                    fundingStreamCode = "Test Funding stream"
                                },
                                period = new period
                                {
                                    periodType = new periodTypeType {periodTypeCode = periodTypeCodeType.ESF},
                                    period1 = "1420"
                                },
                                contractDeliverables = new List<contractDeliverablesTypeContractDeliverable>
                                {
                                    new contractDeliverablesTypeContractDeliverable
                                    {
                                        deliverableDescription = "deliverable desc",
                                        deliverable = new deliverableType
                                        {
                                            deliverableCode = 1
                                        },
                                        contractDeliverablePeriods =
                                            new List<contractDeliverablePeriodsTypeContractDeliverablePeriod>
                                            {
                                                new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                                {
                                                    period = 8,
                                                    year = 2015,
                                                    periodType = new periodTypeType
                                                    {
                                                        periodTypeCode = periodTypeCodeType.AY
                                                    },
                                                    plannedValue = 1234
                                                },
                                                new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                                {
                                                    period = 9,
                                                    year = 2015,
                                                    periodType = new periodTypeType
                                                    {
                                                        periodTypeCode = periodTypeCodeType.AY
                                                    },
                                                    plannedValue = 4321
                                                }
                                            }
                                    }
                                }
                            }
                        },
                        startDate = new DateTime(2015, 08, 01),
                        contractNumber = childContractNumber,
                        contractVersionNumber = childContractVersion,
                        contractor = null
                    }
                },
                contractor = new contractor
                {
                    ukprn = 12345678,
                    legalName = "Provider Name",
                    Upin = "1234"
                }
            };
            var allocation = master.contracts.First().contractAllocations.First();

            // act
            List<MergeFieldType> documentHeaderFields = GetDocumentHeaderFields(masterContractNumber,
                master.contracts.First(), allocation);

            // assert
            var mergedFieldsWithNameAsKey = documentHeaderFields.ToDictionary(v => v.Name, e => e.Value);
            Assert.AreEqual(masterContractNumber, mergedFieldsWithNameAsKey["MasterContractRef"]);
            Assert.AreEqual($"{childContractNumber} v{childContractVersion}", mergedFieldsWithNameAsKey["ContractRef"]);
            Assert.AreEqual(allocationStartDate.ToString("yyyy-MM-dd"), mergedFieldsWithNameAsKey["AllocationStartDate"]);
            Assert.AreEqual(allocationEndDate.ToString("yyyy-MM-dd"), mergedFieldsWithNameAsKey["AllocationEndDate"]);
            Assert.AreEqual(allocationContractRef, mergedFieldsWithNameAsKey["AllocationContractRef"]);
            Assert.AreEqual(specificationTitle, mergedFieldsWithNameAsKey["SpecificationTitle"]);
            Assert.AreEqual(lep, mergedFieldsWithNameAsKey["LEP"]);
            Assert.AreEqual(tenderSpecificationRef, mergedFieldsWithNameAsKey["TenderSpecificationRef"]);
            Assert.AreEqual(lot, mergedFieldsWithNameAsKey["LOT"]);
            Assert.AreEqual(agreementNumber, mergedFieldsWithNameAsKey["Agreement"]);
            Assert.AreEqual(null, mergedFieldsWithNameAsKey["DeliveryOrgName"]);
            Assert.AreEqual(allocationDeliveryOrgLegalName, mergedFieldsWithNameAsKey["OrgName"]);
            Assert.AreEqual(allocationDeliveryOrgUkprn.ToString(), mergedFieldsWithNameAsKey["UKPRN"]);
            Assert.AreEqual(allocationDeliveryOrgUpin, mergedFieldsWithNameAsKey["UPIN"]);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void DocumentPartCreator_ShouldOnlyGetNcsSchedule6ToReturnTrueForNcs1920()
        {
            // arrange
            IWindsorContainer container = new WindsorContainer().Install(new SFA.FCT.DocumentsDomain.DocumentGeneration.IoC.WindsorInstallerForDocumentGenerator(new LoggerFactory()));
            container.Register(Component.For<IPaymentManagementPolicyContext>().Instance(Mock.Of<IPaymentManagementPolicyContext>()).LifestyleScoped().IsDefault());
            container.Register(Component.For<IDocumentConfigurationSource>()
                .Instance(Mock.Of<IDocumentConfigurationSource>()).IsDefault());

            container.BeginScope();

            DocumentPartFinder documentPartFinder = new DocumentPartFinder();
            contractType contractType = GetNcs1920ContractTypeFromFile();

            var documentPartCreators = documentPartFinder.GetDocumentPartCreators(contractType);
            

            // act
            var ncs1920DocumentPartCreators = documentPartCreators.Where(dpc => dpc.IsDocumentPartRequired(contractType)).ToList();

            // assert
            Assert.AreEqual(1, ncs1920DocumentPartCreators.Count, "The number of document parts returned is not correct");
            Assert.AreEqual(typeof(NcsSchedule6DocumentPartCreator), ncs1920DocumentPartCreators.First().GetType(), "The type of document part is not correct");
        }

        private contractType GetNcs1920ContractTypeFromFile()
        {
            return TestResource.FromJson<contractType>("SFA.FCT.DocumentsDomain.DocumentGeneration.Tests",
                "Resources.Ncs1920_ContractTypes.json");
        }

        #region Test Helpers       
        private List<MergeFieldType> GetDocumentHeaderFieldsForFundingStream(string fundingStreamCode, string lotReference = null)
        {
            contractAllocationsContractAllocation allocation = new contractAllocationsContractAllocation()
            {
                fundingStream = new fundingStream()
                {
                    fundingStreamCode = fundingStreamCode
                },
                startDate = new DateTime(2015, 08, 01),
                endDate = new DateTime(2016, 07, 31),
                contractAllocationNumber = fundingStreamCode + "-4321",
                DeliveryOrganisationDetail = new contractor()
                {
                    legalName = "DeliveryOrg Legal Name",
                    ukprn = 12345678
                }
            };

            contract masterContract = new contract()
            {
                contractNumber = "SFA-1234",
                contractVersionNumber = 5,
                contractor = new contractor()
                {
                    legalName = "ContractorName",
                    ukprn = 87654321
                }
            };

            contractType contract = new contractType()
            {
                contractNumber = "CON-4321",
                contractVersionNumber = 6,
                contractAllocations = new List<contractAllocationsContractAllocation> {allocation}
            };

            

            if (fundingStreamCode == "ESF")
                allocation.lotReference = lotReference;
            else
                allocation.lotReference = null;

            Mock<IDocumentConfigurationSource> configMock = new Mock<IDocumentConfigurationSource>();
            configMock
                .Setup(m => m.GetFundingAgreementTitleFromAllocation(It.IsAny<contractAllocationsContractAllocation>()))
                .Returns("Document Title String")
                .Verifiable();

            List<MergeFieldType> mergeFields = new DocumentPartCreatorTestChild(null, configMock.Object).TestGetDocumentHeaderFields(masterContract.contractNumber, contract, allocation);

            return mergeFields;
        }

        DocumentPartCreatorTestChild GetTestChildWithMockConfigSource()
        {
            Mock<IDocumentConfigurationSource> configMock = new Mock<IDocumentConfigurationSource>();
            configMock
                .Setup(m => m.GetDeliverableConfigurationForFundingAgreement(It.IsAny<contractAllocationsContractAllocation>(), It.IsAny<int>()))
                .Returns<contractAllocationsContractAllocation, int>((a, d) => 
                {
                    switch (d)
                    {
                        case 10:
                            // test instance with allowCustomDescription true
                            return new DeliverableConfiguration(d, true, false, 2, true, "Can be custom description here", new[] {10});

                        case 99:
                            return new DeliverableConfiguration(d, true, true, d, false, "Deliverable 1 Name", new[] {1, 3, 4});

                        default:
                            return new DeliverableConfiguration(d, true, true, d, false, "Fixed Deliverable Name", new[] {d});
                    }
                })
                .Verifiable();

            return new DocumentPartCreatorTestChild(null, configMock.Object);
        }

        Dictionary<int, Dictionary<string, decimal>> GetPeriodDictionary()
        {
            return new Dictionary<int, Dictionary<string, decimal>>()
            {
                {
                    1, new Dictionary<string, decimal>
                    {
                        {"1", 1000},
                        {"2", 2000},
                        {"3", 3000},
                        {"4", 4000}
                    }
                },
                {
                    2, new Dictionary<string, decimal>
                    {
                        {"1", 5000},
                        {"2", 6000},
                        {"3", 7000},
                        {"4", 8000}
                    }
                },
                {
                    3, new Dictionary<string, decimal>
                    {
                        {"1", 5000},
                        {"4", 8000}
                    }
                },
                {
                    10, new Dictionary<string, decimal>
                    {
                        { "Aug 2015", 1234.56m }
                    }
                }
            };
        }

        contractAllocationsContractAllocation CreateAllocation(string fundingStreamCode, periodTypeCodeType codeType, string period, DateTime startDate, DateTime endDate)
        {
            return new contractAllocationsContractAllocation()
            {
                contractDeliverables = new List<contractDeliverablesTypeContractDeliverable>
                {
                    new contractDeliverablesTypeContractDeliverable
                    {
                        contractDeliverablePeriods = CreateDeliverablePeriods(startDate, endDate)
                    }
                },
                period = new period()
                {
                    periodType = new periodTypeType()
                    {
                        periodTypeCode = codeType
                    },
                    period1 = period
                },
                fundingStream = new fundingStream()
                {
                    fundingStreamCode = fundingStreamCode
                },
                startDate = startDate,
                endDate = endDate
            };
        }

        private List<contractDeliverablePeriodsTypeContractDeliverablePeriod> CreateDeliverablePeriods(DateTime startDate, DateTime endDate)
        {
            List<contractDeliverablePeriodsTypeContractDeliverablePeriod> periods = new List<contractDeliverablePeriodsTypeContractDeliverablePeriod>();

            // NOTE: Looping through inclusive months only, ignore days (so 20/12/15 to 02/01/16 should produce two periods)
            for (var date = new DateTime(startDate.Year, startDate.Month, 1); date <= endDate; date = date.AddMonths(1))
            {
                // Build the list of periods
                contractDeliverablePeriodsTypeContractDeliverablePeriod period = new contractDeliverablePeriodsTypeContractDeliverablePeriod()
                {
                    aggregate = false,
                    year = date.Year,
                    period = date.Month,
                    periodType = new periodTypeType()
                    {
                        periodTypeCode = periodTypeCodeType.CM,
                        periodTypeName = periodTypeNameType.CALENDARMONTH
                    }
                };

                periods.Add(period);
            }

            return periods;
        }

        #endregion

        #region DocumentPartCreator methods
        public override bool IsDocumentPartRequired(contractType contract)
        {
            throw new NotImplementedException();
        }

        public override bool IsHeaderDocumentRequired
        {
            get { throw new NotImplementedException(); }
        }

        public override string RequiredHeaderDocumentName
        {
            get { throw new NotImplementedException(); }
        }

        public override IDictionary<string, DocumentGenerationRequest> SupplyDocumentGenerationRequest(string masterContractNumber, contractType contract, string templateContainer)
        {
            throw new NotImplementedException();
        }
        #endregion
    }
}
