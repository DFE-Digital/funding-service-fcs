namespace SFA.FCT.DocumentsDomain.DocumentGeneration.Tests
{
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using ContractManagement.DataStore.Model;
    using ContractManagement.DataStore.Repositories;
    using CrossDomain.Integration.Entities.CorporateContract;
    using CrossDomain.Integration.Messages.Commands;
    using DocumentDefiner.DocumentPartCreators;
    using Integration;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using UnitTests.Common;

    [TestClass]
    public class NcsSchedule4DocumentPartCreatorTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void NcsSchedule4DocumentPartCreator_ShouldRequireDocumentPartWhenFundingTypeCodeIsFY1718()
        {
            // arrange
            NcsSchedule4DocumentPartCreator documentPartCreator = new NcsSchedule4DocumentPartCreator(null, null, null);
            DocumentGenerationCommand documentGenerationCommand = GetNcsFy1718DocumentGenerationCommand();

            // act
            bool isDocumentRequired = documentPartCreator.IsDocumentPartRequired(documentGenerationCommand.CorporateContract);

            // assert
            Assert.AreEqual(true, isDocumentRequired);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void NcsSchedule4DocumentPartCreator_ShouldNotRequireDocumentPartWhenFundingTypeCodeIsNCS1819()
        {
            // arrange
            NcsSchedule4DocumentPartCreator documentPartCreator = new NcsSchedule4DocumentPartCreator(null, null, null);
            DocumentGenerationCommand documentGenerationCommand = GetNcsNcs1819DocumentGenerationCommand();

            // act
            bool isDocumentRequired = documentPartCreator.IsDocumentPartRequired(documentGenerationCommand.CorporateContract);

            // assert
            Assert.AreEqual(false, isDocumentRequired);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void NcsSchedule4DocumentPartCreator_SupplyDocumentGenerationRequest_ShouldReturnExpectedVolumeAndPaymentMergeFieldsForPeriod1718()
        {
            // arrange
            Mock<IFundingTypeFundingPeriodQueryRepository> fundingTypeFundingPeriodQueryRepositoryMock = new Mock<IFundingTypeFundingPeriodQueryRepository>();
            fundingTypeFundingPeriodQueryRepositoryMock.Setup(m => m.Get(It.IsAny<string>(), It.IsAny<string>())).Returns(new FundingTypeFundingPeriod());

            NcsSchedule4DocumentPartCreator documentPartCreator = new NcsSchedule4DocumentPartCreator(
                Mock.Of<ITemplateRepository>(),
                null,
                fundingTypeFundingPeriodQueryRepositoryMock.Object);

            contractType contract = GetNcsContract1718();

            // act
            var documentGenerationRequest = documentPartCreator.SupplyDocumentGenerationRequest("TEST-1234", contract, string.Empty);

            // assert
            Assert.AreEqual("123", documentGenerationRequest["1000"].MergeData.MergeFields.Single(mf => mf.Name == "NCSCDel6Volume").Value, "Incorrect volume for 'NCS-C1718 - NCS in the Community'");
            Assert.AreEqual("456", documentGenerationRequest["1000"].MergeData.MergeFields.Single(mf => mf.Name == "NCSPDel6Volume").Value, "Incorrect volume for 'NCS-P1718 - NCS in Prisons'");

            Assert.AreEqual("111", documentGenerationRequest["1000"].MergeData.MergeFields.Single(mf => mf.Name == "NCSEANov17Value").Value, "Incorrect payment value for 'NCS-EA1718 - Enabling Apprenticeships November 2017'");
            Assert.AreEqual("222", documentGenerationRequest["1000"].MergeData.MergeFields.Single(mf => mf.Name == "NCSEADec17Value").Value, "Incorrect payment value for 'NCS-EA1718 - Enabling Apprenticeships December 2017'");
            Assert.AreEqual("333", documentGenerationRequest["1000"].MergeData.MergeFields.Single(mf => mf.Name == "NCSEAMar18Value").Value, "Incorrect payment value for 'NCS-EA1718 - Enabling Apprenticeships March 2018'");
            Assert.AreEqual("666", documentGenerationRequest["1000"].MergeData.MergeFields.Single(mf => mf.Name == "NCSEATotalValue").Value, "Incorrect payment value for 'NCS-EA1718 - Enabling Apprenticeships Total'");

            Assert.AreEqual("555", documentGenerationRequest["1000"].MergeData.MergeFields.Single(mf => mf.Name == "NCSFWLDec17Value").Value, "Incorrect payment value for 'NCS-FWL1718 - Fuller Working Lives 50+ December 2017'");
            Assert.AreEqual("666", documentGenerationRequest["1000"].MergeData.MergeFields.Single(mf => mf.Name == "NCSFWLMar18Value").Value, "Incorrect payment value for 'NCS-FWL1718 - Fuller Working Lives 50+ March 2018'");
            Assert.AreEqual("1221", documentGenerationRequest["1000"].MergeData.MergeFields.Single(mf => mf.Name == "NCSFWLTotalValue").Value, "Incorrect payment value for 'NCS-FWL1718 - Fuller Working Lives 50+ Total'");

            Assert.AreEqual("422", documentGenerationRequest["1000"].MergeData.MergeFields.Single(mf => mf.Name == "NCSASISTFeb18Value").Value, "Incorrect payment value for 'NCS-ASIST1718 - Apprenticeship Specialist Intervention and Support Team February 2018'");
            Assert.AreEqual("610", documentGenerationRequest["1000"].MergeData.MergeFields.Single(mf => mf.Name == "NCSASISTMar18Value").Value, "Incorrect payment value for 'NCS-ASIST1718 - Apprenticeship Specialist Intervention and Support Team March 2018'");
            Assert.AreEqual("1032", documentGenerationRequest["1000"].MergeData.MergeFields.Single(mf => mf.Name == "NCSASISTTotalValue").Value, "Incorrect payment value for 'NCS-ASIST1718 - Apprenticeship Specialist Intervention and Support Team Total'");

            Assert.AreEqual("108", documentGenerationRequest["1000"].MergeData.MergeFields.Single(mf => mf.Name == "NCSSEEDICFeb18Value").Value, "Incorrect payment value for 'NCS-SEEDIC1718 - Support and Enhance Existing Delivery In-Community Funding February 2018'");
            Assert.AreEqual("147", documentGenerationRequest["1000"].MergeData.MergeFields.Single(mf => mf.Name == "NCSSEEDICMar18Value").Value, "Incorrect payment value for 'NCS-SEEDIC1718 - Support and Enhance Existing Delivery In-Community Funding March 2018'");
            Assert.AreEqual("255", documentGenerationRequest["1000"].MergeData.MergeFields.Single(mf => mf.Name == "NCSSEEDICTotalValue").Value, "Incorrect payment value for 'NCS-SEEDIC1718 - Support and Enhance Existing Delivery In-Community Funding Total'");

            Assert.AreEqual("333", documentGenerationRequest["1000"].MergeData.MergeFields.Single(mf => mf.Name == "NCSIMar18Value").Value, "Incorrect payment value for 'NCS-I1718 - NCS Inspiration Activity March 2018'");
            Assert.AreEqual("444", documentGenerationRequest["1000"].MergeData.MergeFields.Single(mf => mf.Name == "NCSIApr18Value").Value, "Incorrect payment value for 'NCS-I1718 - NCS Inspiration Activity April 2018'");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void NcsSchedule4DocumentPartCreator_SupplyDocumentGenerationRequest_ShouldReturnExpectedVolumeAndPaymentMergeFieldsForPeriod2018()
        {
            // arrange
            Mock<IFundingTypeFundingPeriodQueryRepository> fundingTypeFundingPeriodQueryRepositoryMock = new Mock<IFundingTypeFundingPeriodQueryRepository>();
            fundingTypeFundingPeriodQueryRepositoryMock.Setup(m => m.Get(It.IsAny<string>(), It.IsAny<string>())).Returns(new FundingTypeFundingPeriod());

            NcsSchedule4DocumentPartCreator documentPartCreator = new NcsSchedule4DocumentPartCreator(
                Mock.Of<ITemplateRepository>(),
                null,
                fundingTypeFundingPeriodQueryRepositoryMock.Object);

            contractType contract = GetNcsContract2018();

            // act
            var documentGenerationRequest = documentPartCreator.SupplyDocumentGenerationRequest("TEST-1234", contract, string.Empty);

            // assert
            Assert.AreEqual("This is the contract description", documentGenerationRequest["1000"].MergeData.MergeFields.Single(mf => mf.Name == "ContractDescription").Value, "Incorrect contract description'");
            Assert.AreEqual("TEST", documentGenerationRequest["1000"].MergeData.MergeFields.Single(mf => mf.Name == "ProviderName").Value, "Incorrect provider name'");

            // NCS in the Community  
            Assert.AreEqual("222", documentGenerationRequest["1000"].MergeData.MergeFields.Single(mf => mf.Name == "NCSCValue").Value, "Incorrect payment value for 'NCS-C2018 - NCS in the Community'");
            Assert.AreEqual("555", documentGenerationRequest["1000"].MergeData.MergeFields.Single(mf => mf.Name == "NCSCDel6Volume").Value, "Incorrect volume for 'NCS-C2018 - NCS in the Community'");

            // NCS Inspiration Activity
            Assert.AreEqual("333", documentGenerationRequest["1000"].MergeData.MergeFields.Single(mf => mf.Name == "NCSIMar18Value").Value, "Incorrect payment value for 'NCS-I2018 - NCS Inspiration Activity March 2018'");
            Assert.AreEqual("444", documentGenerationRequest["1000"].MergeData.MergeFields.Single(mf => mf.Name == "NCSIApr18Value").Value, "Incorrect payment value for 'NCS-I2018 - NCS Inspiration Activity April 2018'");
            Assert.AreEqual("999", documentGenerationRequest["1000"].MergeData.MergeFields.Single(mf => mf.Name == "NCSISep18Value").Value, "Incorrect payment value for 'NCS-I2018 - NCS Inspiration Activity September 2018'");
            Assert.AreEqual("1000", documentGenerationRequest["1000"].MergeData.MergeFields.Single(mf => mf.Name == "NCSITotalValue").Value, "Incorrect payment value for 'NCS-I2018 - NCS Inspiration Activity Total'");
        }

        private static DocumentGenerationCommand GetNcsNcs1819DocumentGenerationCommand()
        {
            using (var resource = new TestResource("SFA.FCT.DocumentsDomain.DocumentGeneration.Tests", @"Resources.DocumentGenerationCommandNCS_NCS1819.json"))
            {
                return
                    (DocumentGenerationCommand)
                    new Newtonsoft.Json.JsonSerializer().Deserialize(new StreamReader(resource.Stream), typeof(DocumentGenerationCommand));
            }
        }

        private static DocumentGenerationCommand GetNcsFy1718DocumentGenerationCommand()
        {
            using (var resource = new TestResource("SFA.FCT.DocumentsDomain.DocumentGeneration.Tests", @"Resources.DocumentGenerationCommandNCS_FY1718.json"))
            {
                return
                    (DocumentGenerationCommand)
                        new Newtonsoft.Json.JsonSerializer().Deserialize(new StreamReader(resource.Stream), typeof(DocumentGenerationCommand));
            }
        }

        private static contractType GetNcsContract1718()
        {
            contractType contract = new contractType
            {
                contractor = new contractor
                {
                    legalName = "TEST"
                },
                contractAllocations = new List<contractAllocationsContractAllocation>
                {
                    new contractAllocationsContractAllocation
                    {
                        fundingStreamPeriodCode = "NCS-C1718",
                        contractDeliverables = new List<contractDeliverablesTypeContractDeliverable>
                        {
                            new contractDeliverablesTypeContractDeliverable
                            {
                                deliverable = new deliverableType
                                {
                                    deliverableCode = 6
                                },
                                plannedVolume = 123
                            }
                        }
                    },
                    new contractAllocationsContractAllocation
                    {
                        fundingStreamPeriodCode = "NCS-P1718",
                        contractDeliverables = new List<contractDeliverablesTypeContractDeliverable>
                        {
                            new contractDeliverablesTypeContractDeliverable
                            {
                                deliverable = new deliverableType
                                {
                                    deliverableCode = 6
                                },
                                plannedVolume = 456
                            }
                        }
                    },
                    new contractAllocationsContractAllocation
                    {
                        fundingStreamPeriodCode = "NCS-I1718",
                        maximumContractValue = 1000,
                        contractDeliverables = new List<contractDeliverablesTypeContractDeliverable>
                        {
                            new contractDeliverablesTypeContractDeliverable
                            {
                                deliverable = new deliverableType
                                {
                                    deliverableCode = 1
                                },
                                contractDeliverablePeriods = new List<contractDeliverablePeriodsTypeContractDeliverablePeriod>
                                {
                                    new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                    {
                                        period = 3,
                                        year = 2018,
                                        periodType = new periodTypeType
                                        {
                                            periodTypeCode = periodTypeCodeType.AY
                                        },
                                        plannedValue = 333
                                    },
                                    new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                    {
                                        period = 4,
                                        year = 2018,
                                        periodType = new periodTypeType
                                        {
                                            periodTypeCode = periodTypeCodeType.AY
                                        },
                                        plannedValue = 444
                                    },
                                    new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                    {
                                        period = 9,
                                        year = 2018,
                                        periodType = new periodTypeType
                                        {
                                            periodTypeCode = periodTypeCodeType.AY
                                        },
                                        plannedValue = 999
                                    },
                                }
                            }
                        }
                    },
                    new contractAllocationsContractAllocation
                    {
                        fundingStreamPeriodCode = "NCS-IC1718"
                    },
                    new contractAllocationsContractAllocation
                    {
                        fundingStreamPeriodCode = "NCS-EA1718",
                        maximumContractValue = 666,
                        contractDeliverables = new List<contractDeliverablesTypeContractDeliverable>
                        {
                            new contractDeliverablesTypeContractDeliverable
                            {
                                deliverable = new deliverableType
                                {
                                    deliverableCode = 1
                                },
                                contractDeliverablePeriods = new List<contractDeliverablePeriodsTypeContractDeliverablePeriod>
                                {
                                    new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                    {
                                        period = 11,
                                        year = 2017,
                                        periodType = new periodTypeType
                                        {
                                            periodTypeCode = periodTypeCodeType.AY
                                        },
                                        plannedValue = 111
                                    },
                                    new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                    {
                                        period = 12,
                                        year = 2017,
                                        periodType = new periodTypeType
                                        {
                                            periodTypeCode = periodTypeCodeType.AY
                                        },
                                        plannedValue = 222
                                    },
                                    new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                    {
                                        period = 3,
                                        year = 2018,
                                        periodType = new periodTypeType
                                        {
                                            periodTypeCode = periodTypeCodeType.AY
                                        },
                                        plannedValue = 333
                                    }
                                }
                            }
                        }
                    },
                    new contractAllocationsContractAllocation
                    {
                        fundingStreamPeriodCode = "NCS-FWL1718",
                        maximumContractValue = 1221,
                        contractDeliverables = new List<contractDeliverablesTypeContractDeliverable>
                        {
                            new contractDeliverablesTypeContractDeliverable
                            {
                                deliverable = new deliverableType
                                {
                                    deliverableCode = 1
                                },
                                contractDeliverablePeriods = new List<contractDeliverablePeriodsTypeContractDeliverablePeriod>
                                {
                                    new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                    {
                                        period = 12,
                                        year = 2017,
                                        periodType = new periodTypeType
                                        {
                                            periodTypeCode = periodTypeCodeType.AY
                                        },
                                        plannedValue = 555
                                    },
                                    new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                    {
                                        period = 3,
                                        year = 2018,
                                        periodType = new periodTypeType
                                        {
                                            periodTypeCode = periodTypeCodeType.AY
                                        },
                                        plannedValue = 666
                                    }
                                }
                            }
                        }
                    },
                    new contractAllocationsContractAllocation
                    {
                        fundingStreamPeriodCode = "NCS-ASIST1718",
                        maximumContractValue = 1032,
                        contractDeliverables = new List<contractDeliverablesTypeContractDeliverable>
                        {
                            new contractDeliverablesTypeContractDeliverable
                            {
                                deliverable = new deliverableType
                                {
                                    deliverableCode = 1
                                },
                                contractDeliverablePeriods = new List<contractDeliverablePeriodsTypeContractDeliverablePeriod>
                                {
                                    new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                    {
                                        period = 2,
                                        year = 2018,
                                        periodType = new periodTypeType
                                        {
                                            periodTypeCode = periodTypeCodeType.AY
                                        },
                                        plannedValue = 422
                                    },
                                    new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                    {
                                        period = 3,
                                        year = 2018,
                                        periodType = new periodTypeType
                                        {
                                            periodTypeCode = periodTypeCodeType.AY
                                        },
                                        plannedValue = 610
                                    },
                                }
                            }
                        }
                    },
                    new contractAllocationsContractAllocation
                    {
                        fundingStreamPeriodCode = "NCS-SEEDIC1718",
                        maximumContractValue = 255,
                        contractDeliverables = new List<contractDeliverablesTypeContractDeliverable>
                        {
                            new contractDeliverablesTypeContractDeliverable
                            {
                                deliverable = new deliverableType
                                {
                                    deliverableCode = 1
                                },
                                contractDeliverablePeriods = new List<contractDeliverablePeriodsTypeContractDeliverablePeriod>
                                {
                                    new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                    {
                                        period = 2,
                                        year = 2018,
                                        periodType = new periodTypeType
                                        {
                                            periodTypeCode = periodTypeCodeType.AY
                                        },
                                        plannedValue = 108
                                    },
                                    new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                    {
                                        period = 3,
                                        year = 2018,
                                        periodType = new periodTypeType
                                        {
                                            periodTypeCode = periodTypeCodeType.AY
                                        },
                                        plannedValue = 147
                                    },
                                }
                            }
                        }
                    }
                }
            };

            return contract;
        }

        private static contractType GetNcsContract2018()
        {
            contractType contract = new contractType
            {
                description = "This is the contract description",
                contractor = new contractor
                {
                    legalName = "TEST"
                },
                contractAllocations = new List<contractAllocationsContractAllocation>
                {
                    new contractAllocationsContractAllocation
                    {
                        fundingStreamPeriodCode = "NCS-C2018",
                        maximumContractValue = 222,
                        contractDeliverables = new List<contractDeliverablesTypeContractDeliverable>
                        {
                            new contractDeliverablesTypeContractDeliverable
                            {
                                deliverable = new deliverableType
                                {
                                    deliverableCode = 6
                                },
                                plannedVolume = 555
                            }
                        }
                    },
                    new contractAllocationsContractAllocation
                    {
                        fundingStreamPeriodCode = "NCS-I2018",
                        maximumContractValue = 1000,
                        contractDeliverables = new List<contractDeliverablesTypeContractDeliverable>
                        {
                            new contractDeliverablesTypeContractDeliverable
                            {
                                deliverable = new deliverableType
                                {
                                    deliverableCode = 1
                                },
                                contractDeliverablePeriods = new List<contractDeliverablePeriodsTypeContractDeliverablePeriod>
                                {
                                    new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                    {
                                        period = 3,
                                        year = 2018,
                                        periodType = new periodTypeType
                                        {
                                            periodTypeCode = periodTypeCodeType.AY
                                        },
                                        plannedValue = 333
                                    },
                                    new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                    {
                                        period = 4,
                                        year = 2018,
                                        periodType = new periodTypeType
                                        {
                                            periodTypeCode = periodTypeCodeType.AY
                                        },
                                        plannedValue = 444
                                    },
                                    new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                    {
                                        period = 9,
                                        year = 2018,
                                        periodType = new periodTypeType
                                        {
                                            periodTypeCode = periodTypeCodeType.AY
                                        },
                                        plannedValue = 999
                                    },
                                }
                            }
                        }
                    }
                }
            };

            return contract;
        }
    }
}
