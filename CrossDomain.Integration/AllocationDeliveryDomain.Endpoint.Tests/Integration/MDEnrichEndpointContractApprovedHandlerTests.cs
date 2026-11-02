namespace AllocationDeliveryDomain.Endpoint.Tests.Integration
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data.SqlClient;
    using System.IO;
    using System.Linq;
    using System.Xml;
    using System.Xml.Linq;
    using System.Xml.Schema;
    using Helpers;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus;
    using NServiceBus.Testing;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository;
    using SFA.FCT.AllocationDeliveryDomain.MDEnrich.BusinessLogic;
    using SFA.FCT.AllocationDeliveryDomain.MDEnrich.Endpoint;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Framework.Logging.Interfaces;
    using CorporateContract = SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using DeliveryAllocation = SFA.FCT.CrossDomain.Integration.Entities.DeliveryAllocation;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
    using SFA.FCT.AllocationDeliveryDomain.MDEnrich.Infrastructure;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    [TestClass]
    public class MDEnrichEndpointContractApprovedHandlerTests : MDEnrichEndpointIntegrationTestBase
    {
        private const string DeliveryAllocationSchemaNamespace = "urn:sfa:schemas:contract";
        private const string DeliveryAllocationSchemaResourceName = "SFA.FCT.CrossDomain.Integration.Entities.DeliveryAllocation.delivery_allocation.xsd";

        [TestMethod, TestCategory("IntegrationTest")]
        public void CallingMDEnrichEndpointContractApprovedHandlerPublishesTransformedEnrichedAllocations()
        {
            // arrange
            var sessionConnectionFactoryMock = new Mock<ISessionConnectionFactory>();
            sessionConnectionFactoryMock
                .Setup(m => m.GetConnection(It.IsAny<IMessageHandlerContext>()))
                .Returns(ConnectionInfo.CreateFrom(new SqlConnection(ConfigurationManager.ConnectionStrings["AllocationDeliveryDbContext"].ConnectionString)));

            var handler = new ContractApprovedHandler
            {
                Logger = Mock.Of<ILogger>(),
                Transformer = Container.Resolve<IContractAllocationTransformer>(),
                Store = Container.Resolve<IMonitoringDeliverableStore>(),
                Enrichment = Container.Resolve<IMonitoringDeliverableEnrichment>(),
                SessionConnectionFactory = sessionConnectionFactoryMock.Object
            };

            var context = new TestableMessageHandlerContext
            {
                MessageHeaders = {[Headers.CorrelationId] = Guid.NewGuid().ToString()}
            };

            // act
            handler.Handle(new ContractApprovedEvent
            {
                CorporateContract = GetCorporateContract()
            }, context).Wait();

            // assert
            var publishedEvents = context.PublishedMessages
                .Select(pm => pm.Message)
                .OfType<AllocationDeliveryCommencedEvent>()
                .ToList();

            Assert.AreEqual(1, publishedEvents.Count);

            var expectedDeliveryAllocation = GetExpectedDeliveryAllocation();
            var publishedDeliveryAllocation = publishedEvents.Single().Allocation;

            AssertExtensions.PropertyValuesAreEqual(expectedDeliveryAllocation, publishedDeliveryAllocation);

            ValidateDeliveryAllocationAgainstSchema(publishedDeliveryAllocation);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CallingMDEnrichdpointContractApprovedHandler_ShouldStoreEnrichedDeliverablePeriodsInDatabase()
        {
            // arrange
            var organisationId = "ORG1122334";

            var corporateContract = GetCorporateContract();
            corporateContract.contracts[0].contractor.organisationIdentifier = organisationId;

            var sessionConnectionFactoryMock = new Mock<ISessionConnectionFactory>();
            sessionConnectionFactoryMock
                .Setup(m => m.GetConnection(It.IsAny<IMessageHandlerContext>()))
                .Returns(ConnectionInfo.CreateFrom(new SqlConnection(ConfigurationManager.ConnectionStrings["AllocationDeliveryDbContext"].ConnectionString)));

            var handler = new ContractApprovedHandler
            {
                Logger = Mock.Of<ILogger>(),
                Transformer = Container.Resolve<IContractAllocationTransformer>(),
                Store = Container.Resolve<IMonitoringDeliverableStore>(),
                Enrichment = Container.Resolve<IMonitoringDeliverableEnrichment>(),
                SessionConnectionFactory = sessionConnectionFactoryMock.Object
            };

            var context = new TestableMessageHandlerContext
            {
                MessageHeaders = { [Headers.CorrelationId] = Guid.NewGuid().ToString() }
            };

            // act
            handler.Handle(new ContractApprovedEvent
            {
                CorporateContract = corporateContract
            }, context).Wait();

            // assert
            using (var dbContext = new MonitoringDeliverablesDbContext())
            {
                var insertedRecords = dbContext.AllocationDeliverablePeriods.Count(x => x.OrganisationId == organisationId);

                Assert.IsTrue(insertedRecords == 72, "The correct number of DeliverablePeriods was was not inserted");
            }
        }

        private static void ValidateDeliveryAllocationAgainstSchema(DeliveryAllocation.allocationType allocation)
        {
            XmlSchemaSet schemas = new XmlSchemaSet();
            Stream xsdStream = typeof(CorporateContract.contract).Assembly.GetManifestResourceStream(DeliveryAllocationSchemaResourceName);

            Assert.IsNotNull(xsdStream, "DeliveryAllocation schema not found as resource stream");

            schemas.Add(DeliveryAllocationSchemaNamespace, new XmlTextReader(xsdStream));

            System.Xml.Serialization.XmlSerializer serializer = new System.Xml.Serialization.XmlSerializer(typeof(DeliveryAllocation.allocationType));
            XDocument responseXml;
            using (MemoryStream xmlStream = new MemoryStream())
            {
                serializer.Serialize(xmlStream, allocation);
                xmlStream.Position = 0;
                responseXml = XDocument.Load(xmlStream, LoadOptions.PreserveWhitespace | LoadOptions.SetLineInfo);
            }

            responseXml.Validate(
                schemas,
                (o, e) =>
                {
                    Assert.Fail(e.Message);
                });
        }

        private static CorporateContract.contract GetCorporateContract()
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
                            organisationIdentifier = "ORG1234567",
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
                                    periodType = new CorporateContract.periodTypeType() { periodTypeCode = CorporateContract.periodTypeCodeType.AY },
                                    period1 = "1516",
                                    startDate = new DateTime(2015, 08, 01),
                                    endDate = new DateTime(2016, 07, 31)
                                },
                                fundingStreamPeriodCode = "16-18APPS1516",
                                contractDeliverables = new List<CorporateContract.contractDeliverablesTypeContractDeliverable>
                                {
                                    new CorporateContract.contractDeliverablesTypeContractDeliverable
                                    {
                                        deliverable = new CorporateContract.deliverableType
                                        {
                                            deliverableCode = 2,
                                            deliverableName = "DELIVERABLE-002"
                                        },
                                        deliverableDescription = "Deliverable Description",
                                        plannedValue = 48765,
                                        contractDeliverablePeriods = new List<CorporateContract.contractDeliverablePeriodsTypeContractDeliverablePeriod>
                                        {
                                            new CorporateContract.contractDeliverablePeriodsTypeContractDeliverablePeriod
                                            {
                                                period = 8,
                                                year = 2015,
                                                periodType = new CorporateContract.periodTypeType { periodTypeCode = CorporateContract.periodTypeCodeType.CM },
                                                plannedValue = 1234,
                                            },
                                            new CorporateContract.contractDeliverablePeriodsTypeContractDeliverablePeriod
                                            {
                                                period = 9,
                                                year = 2015,
                                                periodType = new CorporateContract.periodTypeType { periodTypeCode = CorporateContract.periodTypeCodeType.CM },
                                                plannedValue = 4321
                                            },
                                            new CorporateContract.contractDeliverablePeriodsTypeContractDeliverablePeriod
                                            {
                                                period = 10,
                                                year = 2015,
                                                periodType = new CorporateContract.periodTypeType { periodTypeCode = CorporateContract.periodTypeCodeType.CM },
                                                plannedValue = 4321
                                            },
                                            new CorporateContract.contractDeliverablePeriodsTypeContractDeliverablePeriod
                                            {
                                                period = 11,
                                                year = 2015,
                                                periodType = new CorporateContract.periodTypeType { periodTypeCode = CorporateContract.periodTypeCodeType.CM },
                                                plannedValue = 4321
                                            },
                                            new CorporateContract.contractDeliverablePeriodsTypeContractDeliverablePeriod
                                            {
                                                period = 12,
                                                year = 2015,
                                                periodType = new CorporateContract.periodTypeType { periodTypeCode = CorporateContract.periodTypeCodeType.CM },
                                                plannedValue = 4321
                                            },
                                            new CorporateContract.contractDeliverablePeriodsTypeContractDeliverablePeriod
                                            {
                                                period = 1,
                                                year = 2016,
                                                periodType = new CorporateContract.periodTypeType { periodTypeCode = CorporateContract.periodTypeCodeType.CM },
                                                plannedValue = 4321
                                            },
                                            new CorporateContract.contractDeliverablePeriodsTypeContractDeliverablePeriod
                                            {
                                                period = 2,
                                                year = 2016,
                                                periodType = new CorporateContract.periodTypeType { periodTypeCode = CorporateContract.periodTypeCodeType.CM },
                                                plannedValue = 4321
                                            },
                                            new CorporateContract.contractDeliverablePeriodsTypeContractDeliverablePeriod
                                            {
                                                period = 3,
                                                year = 2016,
                                                periodType = new CorporateContract.periodTypeType { periodTypeCode = CorporateContract.periodTypeCodeType.CM },
                                                plannedValue = 4321
                                            },
                                            new CorporateContract.contractDeliverablePeriodsTypeContractDeliverablePeriod
                                            {
                                                period = 4,
                                                year = 2016,
                                                periodType = new CorporateContract.periodTypeType { periodTypeCode = CorporateContract.periodTypeCodeType.CM },
                                                plannedValue = 4321
                                            },
                                            new CorporateContract.contractDeliverablePeriodsTypeContractDeliverablePeriod
                                            {
                                                period = 5,
                                                year = 2016,
                                                periodType = new CorporateContract.periodTypeType { periodTypeCode = CorporateContract.periodTypeCodeType.CM },
                                                plannedValue = 4321
                                            },
                                            new CorporateContract.contractDeliverablePeriodsTypeContractDeliverablePeriod
                                            {
                                                period = 6,
                                                year = 2016,
                                                periodType = new CorporateContract.periodTypeType { periodTypeCode = CorporateContract.periodTypeCodeType.CM },
                                                plannedValue = 4321
                                            },
                                            new CorporateContract.contractDeliverablePeriodsTypeContractDeliverablePeriod
                                            {
                                                period = 7,
                                                year = 2016,
                                                periodType = new CorporateContract.periodTypeType { periodTypeCode = CorporateContract.periodTypeCodeType.CM },
                                                plannedValue = 4321
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            };
        }

        private static DeliveryAllocation.allocationType GetExpectedDeliveryAllocation()
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
                    organisationIdentifier = "ORG1234567",
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
                            deliverableCode = 2,
                            deliverableName = "DELIVERABLE-002",
                            isLegal = true,
                            isMonitoring = false
                        },
                        deliverableDescription = "Deliverable Description",
                        plannedValue = 48765,
                        plannedVolume = 0,
                        contractDeliverables = new List<DeliveryAllocation.contractDeliverableType>
                        {
                            new DeliveryAllocation.contractDeliverableType
                            {
                                deliverable = new DeliveryAllocation.deliverableType
                                {
                                    deliverableCode = 6,
                                    deliverableName = "16-18 Apprenticeships Programme Funding",
                                    isMonitoring = true,
                                    DisplayOrder =3

                                },
                                contractDeliverablePeriods = GetExpectedDeliverablePeriods(true)
                            },
                            new DeliveryAllocation.contractDeliverableType
                            {
                                deliverable = new DeliveryAllocation.deliverableType
                                {
                                    deliverableCode = 7,
                                    deliverableName = "16-18 Apprenticeships Learning Support",
                                    isMonitoring = true,
                                    DisplayOrder = 4
                                },
                                contractDeliverablePeriods = GetExpectedDeliverablePeriods(true)
                            },
                            new DeliveryAllocation.contractDeliverableType
                            {
                                deliverable = new DeliveryAllocation.deliverableType
                                {
                                    deliverableCode = 8,
                                    deliverableName = "16-18 Apprenticeships Learner Support",
                                    isMonitoring = true,
                                    DisplayOrder = 5
                                },
                                contractDeliverablePeriods = GetExpectedDeliverablePeriods(true)
                            },
                            new DeliveryAllocation.contractDeliverableType
                            {
                                deliverable = new DeliveryAllocation.deliverableType
                                {
                                    deliverableCode = 9,
                                    deliverableName = "16-18 Trailblazer Apprenticeships Programme Funding",
                                    isMonitoring = true,
                                    DisplayOrder = 6
                                },
                                contractDeliverablePeriods = GetExpectedDeliverablePeriods(true)
                            },
                            new DeliveryAllocation.contractDeliverableType
                            {
                                deliverable = new DeliveryAllocation.deliverableType
                                {
                                    deliverableCode = 10,
                                    deliverableName = "16-18 Trailblazer Apprenticeships Learning Support",
                                    isMonitoring = true,
                                    DisplayOrder = 7
                                },
                                contractDeliverablePeriods = GetExpectedDeliverablePeriods(true)
                            }
                        },
                        contractDeliverablePeriods = GetExpectedDeliverablePeriods()
                    }
                }
            };
        }

        private static List<DeliveryAllocation.contractDeliverablePeriodsTypeContractDeliverablePeriod> GetExpectedDeliverablePeriods(bool zeroAllPlannedValues = false)
        {
            return new List<DeliveryAllocation.contractDeliverablePeriodsTypeContractDeliverablePeriod>
            {
                new DeliveryAllocation.contractDeliverablePeriodsTypeContractDeliverablePeriod
                {
                    plannedValue = zeroAllPlannedValues ? 0 : 1234,
                    plannedVolume = 0,
                    period = new DeliveryAllocation.periodType
                    {
                        periodType1 = new DeliveryAllocation.periodTypeType { periodTypeCode = DeliveryAllocation.periodTypeCodeType.CM },
                        periodValue = GetPeriodValue(2015, 8)
                    }
                },
                new DeliveryAllocation.contractDeliverablePeriodsTypeContractDeliverablePeriod
                {
                    plannedValue = zeroAllPlannedValues ? 0 : 4321,
                    plannedVolume = 0,
                    period = new DeliveryAllocation.periodType
                    {
                        periodType1 = new DeliveryAllocation.periodTypeType { periodTypeCode = DeliveryAllocation.periodTypeCodeType.CM },
                        periodValue = GetPeriodValue(2015, 9)
                    }
                },
                new DeliveryAllocation.contractDeliverablePeriodsTypeContractDeliverablePeriod
                {
                    plannedValue = zeroAllPlannedValues ? 0 : 4321,
                    plannedVolume = 0,
                    period = new DeliveryAllocation.periodType
                    {
                        periodType1 = new DeliveryAllocation.periodTypeType { periodTypeCode = DeliveryAllocation.periodTypeCodeType.CM },
                        periodValue = GetPeriodValue(2015, 10)
                    }
                },
                new DeliveryAllocation.contractDeliverablePeriodsTypeContractDeliverablePeriod
                {
                    plannedValue = zeroAllPlannedValues ? 0 : 4321,
                    plannedVolume = 0,
                    period = new DeliveryAllocation.periodType
                    {
                        periodType1 = new DeliveryAllocation.periodTypeType { periodTypeCode = DeliveryAllocation.periodTypeCodeType.CM },
                        periodValue = GetPeriodValue(2015, 11)
                    }
                },
                new DeliveryAllocation.contractDeliverablePeriodsTypeContractDeliverablePeriod
                {
                    plannedValue = zeroAllPlannedValues ? 0 : 4321,
                    plannedVolume = 0,
                    period = new DeliveryAllocation.periodType
                    {
                        periodType1 = new DeliveryAllocation.periodTypeType { periodTypeCode = DeliveryAllocation.periodTypeCodeType.CM },
                        periodValue = GetPeriodValue(2015, 12)
                    }
                },
                new DeliveryAllocation.contractDeliverablePeriodsTypeContractDeliverablePeriod
                {
                    plannedValue = zeroAllPlannedValues ? 0 : 4321,
                    plannedVolume = 0,
                    period = new DeliveryAllocation.periodType
                    {
                        periodType1 = new DeliveryAllocation.periodTypeType { periodTypeCode = DeliveryAllocation.periodTypeCodeType.CM },
                        periodValue = GetPeriodValue(2016, 1)
                    }
                },
                new DeliveryAllocation.contractDeliverablePeriodsTypeContractDeliverablePeriod
                {
                    plannedValue = zeroAllPlannedValues ? 0 : 4321,
                    plannedVolume = 0,
                    period = new DeliveryAllocation.periodType
                    {
                        periodType1 = new DeliveryAllocation.periodTypeType { periodTypeCode = DeliveryAllocation.periodTypeCodeType.CM },
                        periodValue = GetPeriodValue(2016, 2)
                    }
                },
                new DeliveryAllocation.contractDeliverablePeriodsTypeContractDeliverablePeriod
                {
                    plannedValue = zeroAllPlannedValues ? 0 : 4321,
                    plannedVolume = 0,
                    period = new DeliveryAllocation.periodType
                    {
                        periodType1 = new DeliveryAllocation.periodTypeType { periodTypeCode = DeliveryAllocation.periodTypeCodeType.CM },
                        periodValue = GetPeriodValue(2016, 3)
                    }
                },
                new DeliveryAllocation.contractDeliverablePeriodsTypeContractDeliverablePeriod
                {
                    plannedValue = zeroAllPlannedValues ? 0 : 4321,
                    plannedVolume = 0,
                    period = new DeliveryAllocation.periodType
                    {
                        periodType1 = new DeliveryAllocation.periodTypeType { periodTypeCode = DeliveryAllocation.periodTypeCodeType.CM },
                        periodValue = GetPeriodValue(2016, 4)
                    }
                },
                new DeliveryAllocation.contractDeliverablePeriodsTypeContractDeliverablePeriod
                {
                    plannedValue = zeroAllPlannedValues ? 0 : 4321,
                    plannedVolume = 0,
                    period = new DeliveryAllocation.periodType
                    {
                        periodType1 = new DeliveryAllocation.periodTypeType { periodTypeCode = DeliveryAllocation.periodTypeCodeType.CM },
                        periodValue = GetPeriodValue(2016, 5)
                    }
                },
                new DeliveryAllocation.contractDeliverablePeriodsTypeContractDeliverablePeriod
                {
                    plannedValue = zeroAllPlannedValues ? 0 : 4321,
                    plannedVolume = 0,
                    period = new DeliveryAllocation.periodType
                    {
                        periodType1 = new DeliveryAllocation.periodTypeType { periodTypeCode = DeliveryAllocation.periodTypeCodeType.CM },
                        periodValue = GetPeriodValue(2016, 6)
                    }
                },
                new DeliveryAllocation.contractDeliverablePeriodsTypeContractDeliverablePeriod
                {
                    plannedValue = zeroAllPlannedValues ? 0 : 4321,
                    plannedVolume = 0,
                    period = new DeliveryAllocation.periodType
                    {
                        periodType1 = new DeliveryAllocation.periodTypeType { periodTypeCode = DeliveryAllocation.periodTypeCodeType.CM },
                        periodValue = GetPeriodValue(2016, 7)
                    }
                }
            };
        }

        private static string GetPeriodValue(int year, int period)
        {
            return string.Format("{0:0000}{1:00}", year, period);
        }
    }
}
