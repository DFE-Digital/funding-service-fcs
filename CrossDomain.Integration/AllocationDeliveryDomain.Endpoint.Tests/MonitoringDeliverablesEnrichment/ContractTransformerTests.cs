namespace AllocationDeliveryDomain.Endpoint.Tests.MonitoringDeliverablesEnrichment
{
    using System;
    using System.Collections.Generic;
    using Helpers;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.AllocationDeliveryDomain.MDEnrich.BusinessLogic;
    using SFA.FCT.Framework.Logging.Interfaces;
    using contractDeliverablePeriodsTypeContractDeliverablePeriod = SFA.FCT.CrossDomain.Integration.Entities.CorporateContract.contractDeliverablePeriodsTypeContractDeliverablePeriod;
    using CorporateContract = SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using deliverableType = SFA.FCT.CrossDomain.Integration.Entities.CorporateContract.deliverableType;
    using DeliveryAllocation = SFA.FCT.CrossDomain.Integration.Entities.DeliveryAllocation;
    using periodTypeCodeType = SFA.FCT.CrossDomain.Integration.Entities.CorporateContract.periodTypeCodeType;
    using periodTypeType = SFA.FCT.CrossDomain.Integration.Entities.CorporateContract.periodTypeType;

    [TestClass]
    public class ContractTransformerTests
    {
        private ContractAllocationTransformer _transformer;
        private Mock<ILogger> _mockLogger;

        [TestInitialize]
        public void TestInitialize()
        {
            _mockLogger = new Mock<ILogger>();

            _transformer = new ContractAllocationTransformer();
            _transformer.Logger = _mockLogger.Object;
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractAllocationTransformer_Transform_ShouldTransformContractOrganisation()
        {
            // Arrange
            CorporateContract.contract mastercontract = GetRichContract();
            CorporateContract.contractAllocationsContractAllocation allocation = mastercontract.contracts[0].contractAllocations[0];

            string expectedOrganisationIdentifier = mastercontract.contracts[0].contractor.organisationIdentifier;
            string expectedUkprn = mastercontract.contracts[0].contractor.ukprn.ToString();

            // Act
            var transformedAllocation = _transformer.Transform(mastercontract.contracts[0], allocation, "1");

            // Assert
            string resultOrganisationIdentifier = transformedAllocation.contractorReference.organisationIdentifier;
            string resultUkprn = transformedAllocation.contractorReference.alternativeOrganisationIdentifiers[0].OrganisationIdentifier;

            Assert.AreEqual(expectedOrganisationIdentifier, resultOrganisationIdentifier, "Contract OrganisationIdentifier was not transformed");
            Assert.AreEqual(expectedUkprn, resultUkprn, "Contract Ukprn was not transformed");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractAllocationTransformer_Transform_ShouldTransformAllocationOrganisation()
        {
            // Arrange
            CorporateContract.contract mastercontract = GetRichContract();
            CorporateContract.contractAllocationsContractAllocation allocation = mastercontract.contracts[0].contractAllocations[0];

            const string expectedOrganisationIdentifier = "AllocOrganisationIdentifier";
            const int expectedUkprn = 4444;

            var contractor = new CorporateContract.contractor
            {
                organisationIdentifier = expectedOrganisationIdentifier,
                ukprn = expectedUkprn,
                legalName = "Allocation Provider Name"
            };

            allocation.DeliveryOrganisation = "AllocationDeliveryOrg";
            allocation.DeliveryOrganisationDetail = contractor;

            // Act
            var transformedAllocation = _transformer.Transform(mastercontract.contracts[0], allocation, "1");

            // Assert
            string resultOrganisationIdentifier = transformedAllocation.contractorReference.organisationIdentifier;
            string resultUkprn = transformedAllocation.contractorReference.alternativeOrganisationIdentifiers[0].OrganisationIdentifier;

            Assert.AreEqual(expectedOrganisationIdentifier, resultOrganisationIdentifier, "Allocation OrganisationIdentifier was not transformed");
            Assert.AreEqual(expectedUkprn.ToString(), resultUkprn, "Allocation Ukprn was not transformed");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractAllocationTransformerTest()
        {
            // Arrange
            var mastercontract = GetRichContract();
            var testAllocation = GetRichContractAllocation();

            var allocation = mastercontract.contracts[0].contractAllocations[0];

            // Act
            var transformedAllocation = _transformer.Transform(mastercontract.contracts[0], allocation, "1");

            // Assert
            Assert.AreEqual(testAllocation.contractAllocationNumber, transformedAllocation.contractAllocationNumber);
            Assert.AreEqual(testAllocation.startDate, transformedAllocation.startDate);
            Assert.AreEqual(testAllocation.endDate, transformedAllocation.endDate);
            Assert.AreEqual(testAllocation.contractReference.contractNumber, transformedAllocation.contractReference.contractNumber);
            Assert.AreEqual(testAllocation.contractReference.contractVersionNumber, transformedAllocation.contractReference.contractVersionNumber);
            Assert.AreEqual(testAllocation.contractReference.contractSubVersionNumber, transformedAllocation.contractReference.contractSubVersionNumber);
            Assert.AreEqual(testAllocation.contractDeliverables.Count, transformedAllocation.contractDeliverables.Count);

            for (int i = 0; i < testAllocation.contractDeliverables.Count; i++)
            {
                var td = testAllocation.contractDeliverables[i];
                var ta = transformedAllocation.contractDeliverables[i];
                Assert.AreEqual(td.deliverable.deliverableCode, ta.deliverable.deliverableCode);
                for (int p = 0; p < td.contractDeliverablePeriods.Count; p++)
                {
                    Assert.AreEqual(td.contractDeliverablePeriods[p].period.periodType1.periodTypeCode, ta.contractDeliverablePeriods[p].period.periodType1.periodTypeCode);
                    Assert.AreEqual(td.contractDeliverablePeriods[p].period.periodType1.periodTypeName, ta.contractDeliverablePeriods[p].period.periodType1.periodTypeName);
                    Assert.AreEqual(td.contractDeliverablePeriods[p].period.periodValue, ta.contractDeliverablePeriods[p].period.periodValue);
                }
            }

            Assert.AreEqual(testAllocation.contractDeliverables[0].contractDeliverables.Count, transformedAllocation.contractDeliverables[0].contractDeliverables.Count, "Different number of hierarchical delierables");


            AssertExtensions.PropertyValuesAreEqual(transformedAllocation, testAllocation);
        }

        private CorporateContract.contract GetRichContract()
        {
            return new CorporateContract.contract
            {
                fundingType = new CorporateContract.fundingType { fundingTypeCode = "MAIN" },
                contractNumber = "MASTER-001",
                contracts = new List<CorporateContract.contractType>
                {
                    new CorporateContract.contractType
                    {
                        startDate = new DateTime(2015, 08, 01),
                        contractNumber = "CONTRACT-001",
                        contractVersionNumber = 1,
                        contractValue = 48765,
                        contractor = new CorporateContract.contractor
                        {
                            organisationIdentifier = "ORG12345678",
                            ukprn = 12345678,
                            legalName = "Provider Name"
                        },
                        contractAllocations = new List<CorporateContract.contractAllocationsContractAllocation>
                        {
                            new CorporateContract.contractAllocationsContractAllocation
                            {
                                contractAllocationNumber = "ALLOCATION-001",
                                startDate = new DateTime(2015, 10, 01),
                                endDate = new DateTime(2016, 07, 31),
                                description = "Allocation One",
                                AgreementNumber = "",
                                SpecificationTitle = "",
                                tenderSpecificationReference = "",
                                LEPName = "",
                                lotReference = "",
                                fundingStream = new CorporateContract.fundingStream
                                {
                                    fundingStreamCode = "16-18 APPS"
                                },
                                period = new CorporateContract.period
                                {
                                    periodType = new periodTypeType { periodTypeCode = periodTypeCodeType.AY },
                                    period1 = "1516",
                                    startDate = new DateTime(2015, 08, 01),
                                    endDate = new DateTime(2016, 07, 31)
                                },
                                fundingStreamPeriodCode = "16-18APPS1516",
                                contractDeliverables = new List<CorporateContract.contractDeliverablesTypeContractDeliverable>
                                {
                                    new CorporateContract.contractDeliverablesTypeContractDeliverable
                                    {
                                        deliverable = new deliverableType
                                        {
                                            deliverableCode = 1,
                                            deliverableName = "the first deliverable"
                                        },
                                        deliverableDescription = "Use This One",
                                        plannedValue = 48765,
                                        contractDeliverablePeriods = new List<contractDeliverablePeriodsTypeContractDeliverablePeriod>
                                        {
                                            new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                            {
                                                period = 8,
                                                year = 2015,
                                                periodType = new periodTypeType { periodTypeCode = periodTypeCodeType.CM },
                                                plannedValue = 1234,
                                            },
                                            new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                            {
                                                period = 9,
                                                year = 2015,
                                                periodType = new periodTypeType { periodTypeCode = periodTypeCodeType.CM },
                                                plannedValue = 4321
                                            },
                                            new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                            {
                                                period = 10,
                                                year = 2015,
                                                periodType = new periodTypeType { periodTypeCode = periodTypeCodeType.CM },
                                                plannedValue = 4321
                                            },
                                            new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                            {
                                                period = 11,
                                                year = 2015,
                                                periodType = new periodTypeType { periodTypeCode = periodTypeCodeType.CM },
                                                plannedValue = 4321
                                            },
                                            new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                            {
                                                period = 12,
                                                year = 2015,
                                                periodType = new periodTypeType { periodTypeCode = periodTypeCodeType.CM },
                                                plannedValue = 4321
                                            },
                                            new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                            {
                                                period = 1,
                                                year = 2016,
                                                periodType = new periodTypeType { periodTypeCode = periodTypeCodeType.CM },
                                                plannedValue = 4321
                                            },
                                            new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                            {
                                                period = 2,
                                                year = 2016,
                                                periodType = new periodTypeType { periodTypeCode = periodTypeCodeType.CM },
                                                plannedValue = 4321
                                            },
                                            new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                            {
                                                period = 3,
                                                year = 2016,
                                                periodType = new periodTypeType { periodTypeCode = periodTypeCodeType.CM },
                                                plannedValue = 4321
                                            },
                                            new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                            {
                                                period = 4,
                                                year = 2016,
                                                periodType = new periodTypeType { periodTypeCode = periodTypeCodeType.CM },
                                                plannedValue = 4321
                                            },
                                            new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                            {
                                                period = 5,
                                                year = 2016,
                                                periodType = new periodTypeType { periodTypeCode = periodTypeCodeType.CM },
                                                plannedValue = 4321
                                            },
                                            new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                            {
                                                period = 6,
                                                year = 2016,
                                                periodType = new periodTypeType { periodTypeCode = periodTypeCodeType.CM },
                                                plannedValue = 4321
                                            },
                                            new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                            {
                                                period = 7,
                                                year = 2016,
                                                periodType = new periodTypeType { periodTypeCode = periodTypeCodeType.CM },
                                                plannedValue = 4321
                                            },
                                        },
                                        contractDeliverables = new List<CorporateContract.contractDeliverablesTypeContractDeliverable>
                                        {
                                            new CorporateContract.contractDeliverablesTypeContractDeliverable
                                            {
                                                deliverable = new deliverableType
                                                {
                                                    deliverableCode = 2,
                                                    deliverableName = "the second deliverable"
                                                },
                                                deliverableDescription = "Use This One",
                                                plannedValue = 48765,
                                                contractDeliverablePeriods = new List<contractDeliverablePeriodsTypeContractDeliverablePeriod>
                                                {
                                                    new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                                    {
                                                        period = 8,
                                                        year = 2015,
                                                        periodType = new periodTypeType { periodTypeCode = periodTypeCodeType.CM },
                                                        plannedValue = 1234,
                                                    },
                                                    new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                                    {
                                                        period = 9,
                                                        year = 2015,
                                                        periodType = new periodTypeType { periodTypeCode = periodTypeCodeType.CM },
                                                        plannedValue = 4321
                                                    },
                                                    new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                                    {
                                                        period = 10,
                                                        year = 2015,
                                                        periodType = new periodTypeType { periodTypeCode = periodTypeCodeType.CM },
                                                        plannedValue = 4321
                                                    },
                                                    new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                                    {
                                                        period = 11,
                                                        year = 2015,
                                                        periodType = new periodTypeType { periodTypeCode = periodTypeCodeType.CM },
                                                        plannedValue = 4321
                                                    },
                                                    new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                                    {
                                                        period = 12,
                                                        year = 2015,
                                                        periodType = new periodTypeType { periodTypeCode = periodTypeCodeType.CM },
                                                        plannedValue = 4321
                                                    },
                                                    new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                                    {
                                                        period = 1,
                                                        year = 2016,
                                                        periodType = new periodTypeType { periodTypeCode = periodTypeCodeType.CM },
                                                        plannedValue = 4321
                                                    },
                                                    new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                                    {
                                                        period = 2,
                                                        year = 2016,
                                                        periodType = new periodTypeType { periodTypeCode = periodTypeCodeType.CM },
                                                        plannedValue = 4321
                                                    },
                                                    new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                                    {
                                                        period = 3,
                                                        year = 2016,
                                                        periodType = new periodTypeType { periodTypeCode = periodTypeCodeType.CM },
                                                        plannedValue = 4321
                                                    },
                                                    new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                                    {
                                                        period = 4,
                                                        year = 2016,
                                                        periodType = new periodTypeType { periodTypeCode = periodTypeCodeType.CM },
                                                        plannedValue = 4321
                                                    },
                                                    new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                                    {
                                                        period = 5,
                                                        year = 2016,
                                                        periodType = new periodTypeType { periodTypeCode = periodTypeCodeType.CM },
                                                        plannedValue = 4321
                                                    },
                                                    new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                                    {
                                                        period = 6,
                                                        year = 2016,
                                                        periodType = new periodTypeType { periodTypeCode = periodTypeCodeType.CM },
                                                        plannedValue = 4321
                                                    },
                                                    new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                                    {
                                                        period = 7,
                                                        year = 2016,
                                                        periodType = new periodTypeType { periodTypeCode = periodTypeCodeType.CM },
                                                        plannedValue = 4321
                                                    },
                                                },
                                                contractDeliverables = new List<CorporateContract.contractDeliverablesTypeContractDeliverable>
                                                {
                                                    new CorporateContract.contractDeliverablesTypeContractDeliverable
                                                    {
                                                        deliverable = new deliverableType
                                                        {
                                                            deliverableCode = 3,
                                                            deliverableName = "the third deliverable"
                                                        },
                                                        deliverableDescription = "Use This One",
                                                        plannedValue = 48765,
                                                        contractDeliverablePeriods = new List<contractDeliverablePeriodsTypeContractDeliverablePeriod>
                                                        {
                                                            new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                                            {
                                                                period = 8,
                                                                year = 2015,
                                                                periodType = new periodTypeType { periodTypeCode = periodTypeCodeType.CM },
                                                                plannedValue = 1234,
                                                            },
                                                            new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                                            {
                                                                period = 9,
                                                                year = 2015,
                                                                periodType = new periodTypeType { periodTypeCode = periodTypeCodeType.CM },
                                                                plannedValue = 4321
                                                            },
                                                            new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                                            {
                                                                period = 10,
                                                                year = 2015,
                                                                periodType = new periodTypeType { periodTypeCode = periodTypeCodeType.CM },
                                                                plannedValue = 4321
                                                            },
                                                            new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                                            {
                                                                period = 11,
                                                                year = 2015,
                                                                periodType = new periodTypeType { periodTypeCode = periodTypeCodeType.CM },
                                                                plannedValue = 4321
                                                            },
                                                            new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                                            {
                                                                period = 12,
                                                                year = 2015,
                                                                periodType = new periodTypeType { periodTypeCode = periodTypeCodeType.CM },
                                                                plannedValue = 4321
                                                            },
                                                            new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                                            {
                                                                period = 1,
                                                                year = 2016,
                                                                periodType = new periodTypeType { periodTypeCode = periodTypeCodeType.CM },
                                                                plannedValue = 4321
                                                            },
                                                            new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                                            {
                                                                period = 2,
                                                                year = 2016,
                                                                periodType = new periodTypeType { periodTypeCode = periodTypeCodeType.CM },
                                                                plannedValue = 4321
                                                            },
                                                            new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                                            {
                                                                period = 3,
                                                                year = 2016,
                                                                periodType = new periodTypeType { periodTypeCode = periodTypeCodeType.CM },
                                                                plannedValue = 4321
                                                            },
                                                            new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                                            {
                                                                period = 4,
                                                                year = 2016,
                                                                periodType = new periodTypeType { periodTypeCode = periodTypeCodeType.CM },
                                                                plannedValue = 4321
                                                            },
                                                            new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                                            {
                                                                period = 5,
                                                                year = 2016,
                                                                periodType = new periodTypeType { periodTypeCode = periodTypeCodeType.CM },
                                                                plannedValue = 4321
                                                            },
                                                            new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                                            {
                                                                period = 6,
                                                                year = 2016,
                                                                periodType = new periodTypeType { periodTypeCode = periodTypeCodeType.CM },
                                                                plannedValue = 4321
                                                            },
                                                            new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                                            {
                                                                period = 7,
                                                                year = 2016,
                                                                periodType = new periodTypeType { periodTypeCode = periodTypeCodeType.CM },
                                                                plannedValue = 4321
                                                            },
                                                        }
                                                    },
                                                }
                                            },
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            };
        }

        private DeliveryAllocation.allocationType GetRichContractAllocation()
        {
            return new DeliveryAllocation.allocationType
            {
                contractAllocationNumber = "ALLOCATION-001",
                contractReference = new DeliveryAllocation.contractReferenceType
                {
                    contractNumber = "CONTRACT-001",
                    contractVersionNumber = 1,
                    contractSubVersionNumber = 0
                },
                startDate = new DateTime(2015, 10, 01),
                endDate = new DateTime(2016, 07, 31),
                description = "Allocation One",
                maximumContractValue = 48765,
                contractorReference = new DeliveryAllocation.organisationReferenceType
                {
                    organisationIdentifier = "ORG12345678",
                    alternativeOrganisationIdentifiers = new List<DeliveryAllocation.alternativeOrganisationIdentifierType>()
                    {
                        new DeliveryAllocation.alternativeOrganisationIdentifierType()
                        {
                            OrganisationIdentifier = "12345678",
                            OrganisationIdentifierName = DeliveryAllocation.alternativeOrganisationIdentifierTypeOrganisationIdentifierName.UKPROVIDERREFERENCENUMBER,
                        }
                    }
                },
                fundingStreamPeriod = new DeliveryAllocation.allocationTypeFundingStreamPeriod
                {
                    endDate = new DateTime(2016, 07, 31),
                    fundingStreamPeriodCode = "16-18APPS1516",
                    period = new DeliveryAllocation.periodType
                    {
                        periodType1 = new DeliveryAllocation.periodTypeType { periodTypeCode = DeliveryAllocation.periodTypeCodeType.AY },
                        periodValue = "1516"
                    },
                    startDate = new DateTime(2015, 08, 01),
                },
                contractDeliverables = new List<DeliveryAllocation.contractDeliverableType>
                {
                    new DeliveryAllocation.contractDeliverableType
                    {
                        deliverable = new DeliveryAllocation.deliverableType
                        {
                            deliverableCode = 1,
                            deliverableName = "the first deliverable",
                            isLegal = true,
                            isMonitoring = false //// THIS  NEEDS determining
                        },
                        deliverableDescription = "Use This One",
                        plannedValue = 48765,
                        plannedVolume = 0,
                        contractDeliverablePeriods = new List<DeliveryAllocation.contractDeliverablePeriodsTypeContractDeliverablePeriod>
                        {
                            new DeliveryAllocation.contractDeliverablePeriodsTypeContractDeliverablePeriod
                            {
                                plannedValue = 1234,
                                plannedVolume = 0,
                                period = new DeliveryAllocation.periodType
                                {
                                    periodType1 = new DeliveryAllocation.periodTypeType { periodTypeCode = DeliveryAllocation.periodTypeCodeType.CM },
                                    periodValue = GetPeriodValue(2015, 8)
                                }
                            },
                            new DeliveryAllocation.contractDeliverablePeriodsTypeContractDeliverablePeriod
                            {
                                plannedValue = 4321,
                                plannedVolume = 0,
                                period = new DeliveryAllocation.periodType
                                {
                                    periodType1 = new DeliveryAllocation.periodTypeType { periodTypeCode = DeliveryAllocation.periodTypeCodeType.CM },
                                    periodValue = GetPeriodValue(2015, 9)
                                }
                            },
                            new DeliveryAllocation.contractDeliverablePeriodsTypeContractDeliverablePeriod
                            {
                                plannedValue = 4321,
                                plannedVolume = 0,
                                period = new DeliveryAllocation.periodType
                                {
                                    periodType1 = new DeliveryAllocation.periodTypeType { periodTypeCode = DeliveryAllocation.periodTypeCodeType.CM },
                                    periodValue = GetPeriodValue(2015, 10)
                                }
                            },
                            new DeliveryAllocation.contractDeliverablePeriodsTypeContractDeliverablePeriod
                            {
                                plannedValue = 4321,
                                plannedVolume = 0,
                                period = new DeliveryAllocation.periodType
                                {
                                    periodType1 = new DeliveryAllocation.periodTypeType { periodTypeCode = DeliveryAllocation.periodTypeCodeType.CM },
                                    periodValue = GetPeriodValue(2015, 11)
                                }
                            },
                            new DeliveryAllocation.contractDeliverablePeriodsTypeContractDeliverablePeriod
                            {
                                plannedValue = 4321,
                                plannedVolume = 0,
                                period = new DeliveryAllocation.periodType
                                {
                                    periodType1 = new DeliveryAllocation.periodTypeType { periodTypeCode = DeliveryAllocation.periodTypeCodeType.CM },
                                    periodValue = GetPeriodValue(2015, 12)
                                }
                            },
                            new DeliveryAllocation.contractDeliverablePeriodsTypeContractDeliverablePeriod
                            {
                                plannedValue = 4321,
                                plannedVolume = 0,
                                period = new DeliveryAllocation.periodType
                                {
                                    periodType1 = new DeliveryAllocation.periodTypeType { periodTypeCode = DeliveryAllocation.periodTypeCodeType.CM },
                                    periodValue = GetPeriodValue(2016, 1)
                                }
                            },
                            new DeliveryAllocation.contractDeliverablePeriodsTypeContractDeliverablePeriod
                            {
                                plannedValue = 4321,
                                plannedVolume = 0,
                                period = new DeliveryAllocation.periodType
                                {
                                    periodType1 = new DeliveryAllocation.periodTypeType { periodTypeCode = DeliveryAllocation.periodTypeCodeType.CM },
                                    periodValue = GetPeriodValue(2016, 2)
                                }
                            },
                            new DeliveryAllocation.contractDeliverablePeriodsTypeContractDeliverablePeriod
                            {
                                plannedValue = 4321,
                                plannedVolume = 0,
                                period = new DeliveryAllocation.periodType
                                {
                                    periodType1 = new DeliveryAllocation.periodTypeType { periodTypeCode = DeliveryAllocation.periodTypeCodeType.CM },
                                    periodValue = GetPeriodValue(2016, 3)
                                }
                            },
                            new DeliveryAllocation.contractDeliverablePeriodsTypeContractDeliverablePeriod
                            {
                                plannedValue = 4321,
                                plannedVolume = 0,
                                period = new DeliveryAllocation.periodType
                                {
                                    periodType1 = new DeliveryAllocation.periodTypeType { periodTypeCode = DeliveryAllocation.periodTypeCodeType.CM },
                                    periodValue = GetPeriodValue(2016, 4)
                                }
                            },
                            new DeliveryAllocation.contractDeliverablePeriodsTypeContractDeliverablePeriod
                            {
                                plannedValue = 4321,
                                plannedVolume = 0,
                                period = new DeliveryAllocation.periodType
                                {
                                    periodType1 = new DeliveryAllocation.periodTypeType { periodTypeCode = DeliveryAllocation.periodTypeCodeType.CM },
                                    periodValue = GetPeriodValue(2016, 5)
                                }
                            },
                            new DeliveryAllocation.contractDeliverablePeriodsTypeContractDeliverablePeriod
                            {
                                plannedValue = 4321,
                                plannedVolume = 0,
                                period = new DeliveryAllocation.periodType
                                {
                                    periodType1 = new DeliveryAllocation.periodTypeType { periodTypeCode = DeliveryAllocation.periodTypeCodeType.CM },
                                    periodValue = GetPeriodValue(2016, 6)
                                }
                            },
                            new DeliveryAllocation.contractDeliverablePeriodsTypeContractDeliverablePeriod
                            {
                                plannedValue = 4321,
                                plannedVolume = 0,
                                period = new DeliveryAllocation.periodType
                                {
                                    periodType1 = new DeliveryAllocation.periodTypeType { periodTypeCode = DeliveryAllocation.periodTypeCodeType.CM },
                                    periodValue = GetPeriodValue(2016, 7)
                                }
                            },
                        },
                        contractDeliverables = new List<DeliveryAllocation.contractDeliverableType>
                        {
                            new DeliveryAllocation.contractDeliverableType
                            {
                                deliverable = new DeliveryAllocation.deliverableType
                                {
                                    deliverableCode = 2,
                                    deliverableName = "the second deliverable",
                                    isLegal = true,
                                    isMonitoring = false //// THIS  NEEDS determining
                                },
                                deliverableDescription = "Use This One",
                                plannedValue = 48765,
                                plannedVolume = 0,
                                contractDeliverablePeriods = new List<DeliveryAllocation.contractDeliverablePeriodsTypeContractDeliverablePeriod>
                                {
                                    new DeliveryAllocation.contractDeliverablePeriodsTypeContractDeliverablePeriod
                                    {
                                        plannedValue = 1234,
                                        plannedVolume = 0,
                                        period = new DeliveryAllocation.periodType
                                        {
                                            periodType1 = new DeliveryAllocation.periodTypeType { periodTypeCode = DeliveryAllocation.periodTypeCodeType.CM },
                                            periodValue = GetPeriodValue(2015, 8)
                                        }
                                    },
                                    new DeliveryAllocation.contractDeliverablePeriodsTypeContractDeliverablePeriod
                                    {
                                        plannedValue = 4321,
                                        plannedVolume = 0,
                                        period = new DeliveryAllocation.periodType
                                        {
                                            periodType1 = new DeliveryAllocation.periodTypeType { periodTypeCode = DeliveryAllocation.periodTypeCodeType.CM },
                                            periodValue = GetPeriodValue(2015, 9)
                                        }
                                    },
                                    new DeliveryAllocation.contractDeliverablePeriodsTypeContractDeliverablePeriod
                                    {
                                        plannedValue = 4321,
                                        plannedVolume = 0,
                                        period = new DeliveryAllocation.periodType
                                        {
                                            periodType1 = new DeliveryAllocation.periodTypeType { periodTypeCode = DeliveryAllocation.periodTypeCodeType.CM },
                                            periodValue = GetPeriodValue(2015, 10)
                                        }
                                    },
                                    new DeliveryAllocation.contractDeliverablePeriodsTypeContractDeliverablePeriod
                                    {
                                        plannedValue = 4321,
                                        plannedVolume = 0,
                                        period = new DeliveryAllocation.periodType
                                        {
                                            periodType1 = new DeliveryAllocation.periodTypeType { periodTypeCode = DeliveryAllocation.periodTypeCodeType.CM },
                                            periodValue = GetPeriodValue(2015, 11)
                                        }
                                    },
                                    new DeliveryAllocation.contractDeliverablePeriodsTypeContractDeliverablePeriod
                                    {
                                        plannedValue = 4321,
                                        plannedVolume = 0,
                                        period = new DeliveryAllocation.periodType
                                        {
                                            periodType1 = new DeliveryAllocation.periodTypeType { periodTypeCode = DeliveryAllocation.periodTypeCodeType.CM },
                                            periodValue = GetPeriodValue(2015, 12)
                                        }
                                    },
                                    new DeliveryAllocation.contractDeliverablePeriodsTypeContractDeliverablePeriod
                                    {
                                        plannedValue = 4321,
                                        plannedVolume = 0,
                                        period = new DeliveryAllocation.periodType
                                        {
                                            periodType1 = new DeliveryAllocation.periodTypeType { periodTypeCode = DeliveryAllocation.periodTypeCodeType.CM },
                                            periodValue = GetPeriodValue(2016, 1)
                                        }
                                    },
                                    new DeliveryAllocation.contractDeliverablePeriodsTypeContractDeliverablePeriod
                                    {
                                        plannedValue = 4321,
                                        plannedVolume = 0,
                                        period = new DeliveryAllocation.periodType
                                        {
                                            periodType1 = new DeliveryAllocation.periodTypeType { periodTypeCode = DeliveryAllocation.periodTypeCodeType.CM },
                                            periodValue = GetPeriodValue(2016, 2)
                                        }
                                    },
                                    new DeliveryAllocation.contractDeliverablePeriodsTypeContractDeliverablePeriod
                                    {
                                        plannedValue = 4321,
                                        plannedVolume = 0,
                                        period = new DeliveryAllocation.periodType
                                        {
                                            periodType1 = new DeliveryAllocation.periodTypeType { periodTypeCode = DeliveryAllocation.periodTypeCodeType.CM },
                                            periodValue = GetPeriodValue(2016, 3)
                                        }
                                    },
                                    new DeliveryAllocation.contractDeliverablePeriodsTypeContractDeliverablePeriod
                                    {
                                        plannedValue = 4321,
                                        plannedVolume = 0,
                                        period = new DeliveryAllocation.periodType
                                        {
                                            periodType1 = new DeliveryAllocation.periodTypeType { periodTypeCode = DeliveryAllocation.periodTypeCodeType.CM },
                                            periodValue = GetPeriodValue(2016, 4)
                                        }
                                    },
                                    new DeliveryAllocation.contractDeliverablePeriodsTypeContractDeliverablePeriod
                                    {
                                        plannedValue = 4321,
                                        plannedVolume = 0,
                                        period = new DeliveryAllocation.periodType
                                        {
                                            periodType1 = new DeliveryAllocation.periodTypeType { periodTypeCode = DeliveryAllocation.periodTypeCodeType.CM },
                                            periodValue = GetPeriodValue(2016, 5)
                                        }
                                    },
                                    new DeliveryAllocation.contractDeliverablePeriodsTypeContractDeliverablePeriod
                                    {
                                        plannedValue = 4321,
                                        plannedVolume = 0,
                                        period = new DeliveryAllocation.periodType
                                        {
                                            periodType1 = new DeliveryAllocation.periodTypeType { periodTypeCode = DeliveryAllocation.periodTypeCodeType.CM },
                                            periodValue = GetPeriodValue(2016, 6)
                                        }
                                    },
                                    new DeliveryAllocation.contractDeliverablePeriodsTypeContractDeliverablePeriod
                                    {
                                        plannedValue = 4321,
                                        plannedVolume = 0,
                                        period = new DeliveryAllocation.periodType
                                        {
                                            periodType1 = new DeliveryAllocation.periodTypeType { periodTypeCode = DeliveryAllocation.periodTypeCodeType.CM },
                                            periodValue = GetPeriodValue(2016, 7)
                                        }
                                    }
                                },
                                contractDeliverables = new List<DeliveryAllocation.contractDeliverableType>
                                {
                                    new DeliveryAllocation.contractDeliverableType
                                    {
                                        deliverable = new DeliveryAllocation.deliverableType
                                        {
                                            deliverableCode = 3,
                                            deliverableName = "the third deliverable",
                                            isLegal = true,
                                            isMonitoring = false //// THIS  NEEDS determining
                                        },
                                        deliverableDescription = "Use This One",
                                        plannedValue = 48765,
                                        plannedVolume = 0,
                                        contractDeliverablePeriods = new List<DeliveryAllocation.contractDeliverablePeriodsTypeContractDeliverablePeriod>
                                        {
                                            new DeliveryAllocation.contractDeliverablePeriodsTypeContractDeliverablePeriod
                                            {
                                                plannedValue = 1234,
                                                plannedVolume = 0,
                                                period = new DeliveryAllocation.periodType
                                                {
                                                    periodType1 = new DeliveryAllocation.periodTypeType { periodTypeCode = DeliveryAllocation.periodTypeCodeType.CM },
                                                    periodValue = GetPeriodValue(2015, 8)
                                                }
                                            },
                                            new DeliveryAllocation.contractDeliverablePeriodsTypeContractDeliverablePeriod
                                            {
                                                plannedValue = 4321,
                                                plannedVolume = 0,
                                                period = new DeliveryAllocation.periodType
                                                {
                                                    periodType1 = new DeliveryAllocation.periodTypeType { periodTypeCode = DeliveryAllocation.periodTypeCodeType.CM },
                                                    periodValue = GetPeriodValue(2015, 9)
                                                }
                                            },
                                            new DeliveryAllocation.contractDeliverablePeriodsTypeContractDeliverablePeriod
                                            {
                                                plannedValue = 4321,
                                                plannedVolume = 0,
                                                period = new DeliveryAllocation.periodType
                                                {
                                                    periodType1 = new DeliveryAllocation.periodTypeType { periodTypeCode = DeliveryAllocation.periodTypeCodeType.CM },
                                                    periodValue = GetPeriodValue(2015, 10)
                                                }
                                            },
                                            new DeliveryAllocation.contractDeliverablePeriodsTypeContractDeliverablePeriod
                                            {
                                                plannedValue = 4321,
                                                plannedVolume = 0,
                                                period = new DeliveryAllocation.periodType
                                                {
                                                    periodType1 = new DeliveryAllocation.periodTypeType { periodTypeCode = DeliveryAllocation.periodTypeCodeType.CM },
                                                    periodValue = GetPeriodValue(2015, 11)
                                                }
                                            },
                                            new DeliveryAllocation.contractDeliverablePeriodsTypeContractDeliverablePeriod
                                            {
                                                plannedValue = 4321,
                                                plannedVolume = 0,
                                                period = new DeliveryAllocation.periodType
                                                {
                                                    periodType1 = new DeliveryAllocation.periodTypeType { periodTypeCode = DeliveryAllocation.periodTypeCodeType.CM },
                                                    periodValue = GetPeriodValue(2015, 12)
                                                }
                                            },
                                            new DeliveryAllocation.contractDeliverablePeriodsTypeContractDeliverablePeriod
                                            {
                                                plannedValue = 4321,
                                                plannedVolume = 0,
                                                period = new DeliveryAllocation.periodType
                                                {
                                                    periodType1 = new DeliveryAllocation.periodTypeType { periodTypeCode = DeliveryAllocation.periodTypeCodeType.CM },
                                                    periodValue = GetPeriodValue(2016, 1)
                                                }
                                            },
                                            new DeliveryAllocation.contractDeliverablePeriodsTypeContractDeliverablePeriod
                                            {
                                                plannedValue = 4321,
                                                plannedVolume = 0,
                                                period = new DeliveryAllocation.periodType
                                                {
                                                    periodType1 = new DeliveryAllocation.periodTypeType { periodTypeCode = DeliveryAllocation.periodTypeCodeType.CM },
                                                    periodValue = GetPeriodValue(2016, 2)
                                                }
                                            },
                                            new DeliveryAllocation.contractDeliverablePeriodsTypeContractDeliverablePeriod
                                            {
                                                plannedValue = 4321,
                                                plannedVolume = 0,
                                                period = new DeliveryAllocation.periodType
                                                {
                                                    periodType1 = new DeliveryAllocation.periodTypeType { periodTypeCode = DeliveryAllocation.periodTypeCodeType.CM },
                                                    periodValue = GetPeriodValue(2016, 3)
                                                }
                                            },
                                            new DeliveryAllocation.contractDeliverablePeriodsTypeContractDeliverablePeriod
                                            {
                                                plannedValue = 4321,
                                                plannedVolume = 0,
                                                period = new DeliveryAllocation.periodType
                                                {
                                                    periodType1 = new DeliveryAllocation.periodTypeType { periodTypeCode = DeliveryAllocation.periodTypeCodeType.CM },
                                                    periodValue = GetPeriodValue(2016, 4)
                                                }
                                            },
                                            new DeliveryAllocation.contractDeliverablePeriodsTypeContractDeliverablePeriod
                                            {
                                                plannedValue = 4321,
                                                plannedVolume = 0,
                                                period = new DeliveryAllocation.periodType
                                                {
                                                    periodType1 = new DeliveryAllocation.periodTypeType { periodTypeCode = DeliveryAllocation.periodTypeCodeType.CM },
                                                    periodValue = GetPeriodValue(2016, 5)
                                                }
                                            },
                                            new DeliveryAllocation.contractDeliverablePeriodsTypeContractDeliverablePeriod
                                            {
                                                plannedValue = 4321,
                                                plannedVolume = 0,
                                                period = new DeliveryAllocation.periodType
                                                {
                                                    periodType1 = new DeliveryAllocation.periodTypeType { periodTypeCode = DeliveryAllocation.periodTypeCodeType.CM },
                                                    periodValue = GetPeriodValue(2016, 6)
                                                }
                                            },
                                            new DeliveryAllocation.contractDeliverablePeriodsTypeContractDeliverablePeriod
                                            {
                                                plannedValue = 4321,
                                                plannedVolume = 0,
                                                period = new DeliveryAllocation.periodType
                                                {
                                                    periodType1 = new DeliveryAllocation.periodTypeType { periodTypeCode = DeliveryAllocation.periodTypeCodeType.CM },
                                                    periodValue = GetPeriodValue(2016, 7)
                                                }
                                            },

                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            };
        }

        private string GetPeriodValue(int year, int period)
        {
            return string.Format("{0:0000}{1:00}", year, period);
        }
    }
}