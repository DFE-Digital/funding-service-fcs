namespace ADMonitoringDomain.Endpoint.Tests.Unit
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using BusinessLogic;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Model;
    using ContractManagement.DataStore.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.CrossDomain.Integration.Common.SchemaValidator;
    using SFA.FCT.CrossDomain.Integration.Common.Serializers;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Entities.DeliveryAllocation;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Interfaces;
    using UnitTests.Common;
    using XmlSerializer = System.Xml.Serialization.XmlSerializer;

    [TestClass]
    public class AllocationDeliveryPerformanceMapperTests
    {
        private const string AllocationNumber = "ALL-123";
        private const string ContractNumber = "CON-321";
        private const int VersionNumber = 200;
        private const int SubVersionNumber = 5;
        private const string FundingStreamPeriodCode = "24+ALLBC1516";
        private const string UopCode = "4";
        private const string AllocationPeriodTypeCode = "AY";
        private const string OrganisationId = "ORG1234567";
        private const string AlternativeOrganisationId = "777111";
        private const string AOrgIdName = "UKPROVIDERREFERENCENUMBER";
        private const int DeliverableCode = 7;
        private const string AssemblyName = "CrossDomain.Integration.Entities.dll";
        private const string EmbeddedResourceName = "SFA.FCT.CrossDomain.Integration.Entities.AllocationDeliveryPerformance.allocation-delivery-performance-schema.xsd";
        private const string SchemaNamespace = "urn:sfa:schemas:allocation-delivery-performance";

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationDeliveryPerformanceMapper_Map_ShouldCorrectlyMapAllocationDeliveryCommencedEventToAllocationDeliveryPerformance()
        {
            // arrange
            const string allocationNumber = "XX";
            const string orgId = "ORG1234567";
            const int ukprn = 444;
            Mock<IApprovedContractRepository> approvedContractRepositoryMock = new Mock<IApprovedContractRepository>();
            ApprovedContract approvedContract = 
                new ApprovedContract("", 0, 0, "", "", int.Parse(AlternativeOrganisationId), 
                    orgId, string.Empty, DateTime.Now.AddDays(7).Date, DateTime.Now.AddYears(1).Date)
            {
                ApprovedContractAllocations = new List<ApprovedContractAllocation>
                {
                    new ApprovedContractAllocation
                    {
                        ContractAllocationNumber = allocationNumber,
                        DeliveryOrganisationId = orgId,
                        DeliveryOrganisationUkprn = ukprn
                    }
                }
            };
            approvedContractRepositoryMock.Setup(r => r.GetContractForAllocationNumber(It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(approvedContract);
            AllocationDeliveryPerformanceMapper mapper = new AllocationDeliveryPerformanceMapper(approvedContractRepositoryMock.Object)
            {
                SchemaValidator = new SchemaValidator()
            };

            AllocationDeliveryCommencedEvent allocDeliveryCommencedEvent = CreateAllocationDeliveryCommencedEvent(allocationNumber);

            // act
            AllocationDeliveryPerformance result = mapper.Map(allocDeliveryCommencedEvent, ConnectionInfo.CreateDefault());

            // assert
            Assert.AreEqual(allocationNumber, result.contractAllocationNumber, "Allocation number was not mapped.");
            Assert.AreEqual(UopCode, result.UoPCode, "UoP code was not mapped.");
            Assert.AreEqual(AllocationPeriodTypeCode, result.AllocationPeriodTypeCode.ToString(), "Allocation period type code was not mapped.");
            //// Contract
            Assert.AreEqual(ContractNumber, result.Contract.contractNumber, "Contract number was not mapped.");
            Assert.AreEqual(VersionNumber, result.Contract.contractVersionNumber, "Contract version number was not mapped.");
            Assert.AreEqual(0, result.Contract.contractSubVersionNumber, "Contract sub version number was not set to zero.");
            //// Funding Stream Period
            Assert.AreEqual(FundingStreamPeriodCode, result.FundingStreamPeriod.FundingStreamPeriodCode, "FSP code was not mapped.");
            //// Contractor
            Assert.AreEqual(orgId, result.Contractor.organisationIdentifier, "Org id was not mapped.");
            Assert.AreEqual(AlternativeOrganisationId, result.Contractor.alternativeOrganisationIdentifiers.AlternativeOrganisationIdentifier.OrganisationIdentifier, "Alternative org id was not mapped.");
            Assert.AreEqual(AOrgIdName, result.Contractor.alternativeOrganisationIdentifiers.AlternativeOrganisationIdentifier.OrganisationIdentifierName.ToString(), "Alternative org id name was not mapped.");
            //// Deliverables
            Assert.AreEqual(DeliverableCode, result.ContractDeliverables.Single().DeliverableCode, "Deliverable code was not mapped.");
            Assert.IsTrue(result.ContractDeliverables.Single().isLegal, "Deliverable is legal flag was not mapped.");
            Assert.IsTrue(result.ContractDeliverables.Single().isMonitoring, "Deliverable is monitoring flag was not mapped.");
            Assert.IsTrue(result.ContractDeliverables.Single().ContractDeliverablePeriods.Count == 1, "Contract deliverable periods were not mapped");
            Assert.IsTrue(result.ContractDeliverables.Single().ContractDeliverablePeriods.Single().PlannedValue == 10, "Contract deliverable period 1 planned value not mapped");
            Assert.IsTrue(result.ContractDeliverables.Single().ContractDeliverablePeriods.Single().Period == "201608", "Contract deliverable period period value not mapped");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationDeliveryPerformance_ShouldSerializeToValidXml()
        {
            // arrange
            AllocationDeliveryPerformance adp = GetAllocationDeliveryPerformance();
            adp.allocationOrganisationRelationships = new allocationOrganisationRelationshipsTYPE
            {
                contractAllocationNumber = adp.contractAllocationNumber,
                Organisation = new organisationReferenceTYPE
                {
                    organisationIdentifier = "ORG0000001",
                    alternativeOrganisationIdentifiers = new organisationReferenceTYPEAlternativeOrganisationIdentifiers
                    {
                        AlternativeOrganisationIdentifier = new alternativeOrganisationIdentifierTYPE
                        {
                            OrganisationIdentifier = "12345678",
                            OrganisationIdentifierName = alternativeOrganisationIdentifierTYPEOrganisationIdentifierName.UKPROVIDERREFERENCENUMBER
                        }
                    }
                },
                RelationshipType = organisationRelationshipTYPE.DELIVERYORGANISATION
            };
            SchemaValidator validator = new SchemaValidator();

            // act
            string xml = adp.SerializeToXml();

            // assert
            SchemaValidatorResultset result = validator.ValidateAgainstSchema(AssemblyName, EmbeddedResourceName, SchemaNamespace,xml);
            Assert.AreEqual("", string.Join(",", result.ValidationErrors));
        }
        [TestMethod, TestCategory("UnitTest")]
        public void AllocationDeliveryPerformance_ShouldSerializeAllocOrgRelationshipsFor1619Funding1718()
        {
            // arrange
            AllocationDeliveryPerformance adp1 = GetAllocationDeliveryPerformance();
            AllocationDeliveryPerformance adp2 = GetAllocationDeliveryPerformance();
            AllocationDeliveryPerformance adp3 = GetAllocationDeliveryPerformance();

            var allocationOrg = new allocationOrganisationRelationshipsTYPE
            {
                contractAllocationNumber = adp1.contractAllocationNumber,
                Organisation = new organisationReferenceTYPE
                {
                    organisationIdentifier = "ORG0000001",
                    alternativeOrganisationIdentifiers = new organisationReferenceTYPEAlternativeOrganisationIdentifiers
                    {
                        AlternativeOrganisationIdentifier = new alternativeOrganisationIdentifierTYPE
                        {
                            OrganisationIdentifier = "12345678",
                            OrganisationIdentifierName = alternativeOrganisationIdentifierTYPEOrganisationIdentifierName.UKPROVIDERREFERENCENUMBER
                        }
                    }
                },
                RelationshipType = organisationRelationshipTYPE.DELIVERYORGANISATION
            };

            adp1.allocationOrganisationRelationships = allocationOrg;
            adp2.allocationOrganisationRelationships = allocationOrg;
            adp3.allocationOrganisationRelationships = allocationOrg;

            adp1.FundingStreamPeriod = new AllocationDeliveryPerformanceFundingStreamPeriod { FundingStreamPeriodCode = "1619LR1718" };
            adp2.FundingStreamPeriod = new AllocationDeliveryPerformanceFundingStreamPeriod { FundingStreamPeriodCode = "NMF1718" };
            adp3.FundingStreamPeriod = new AllocationDeliveryPerformanceFundingStreamPeriod { FundingStreamPeriodCode = "SSF1718" };


            // act
            string xml1 = adp1.SerializeToXml();
            string xml2 = adp2.SerializeToXml();
            string xml3 = adp3.SerializeToXml();

            // assert
            Assert.IsTrue(xml1.Contains("<allocationOrganisationRelationships>"), "Allocation organisation relationships should have been serialized for 1619LR1718 alloc");
            Assert.IsTrue(xml2.Contains("<allocationOrganisationRelationships>"), "Allocation organisation relationships should have been serialized for NMF1718 alloc");
            Assert.IsTrue(xml3.Contains("<allocationOrganisationRelationships>"), "Allocation organisation relationships should have been serialized for SSF1718 alloc");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationDeliveryPerformance_ShouldSerializeAllocOrgRelationshipsForMainstream1819()
        {
            // arrange
            AllocationDeliveryPerformance allocationDeliveryPerformance = GetAllocationDeliveryPerformance();

            allocationDeliveryPerformance.FundingStreamPeriod = new AllocationDeliveryPerformanceFundingStreamPeriod { FundingStreamPeriodCode = "APPS1819" };
            allocationDeliveryPerformance.allocationOrganisationRelationships = new allocationOrganisationRelationshipsTYPE
            {
                contractAllocationNumber = allocationDeliveryPerformance.contractAllocationNumber,
                Organisation = new organisationReferenceTYPE
                {
                    organisationIdentifier = "ORG0000001",
                    alternativeOrganisationIdentifiers = new organisationReferenceTYPEAlternativeOrganisationIdentifiers
                    {
                        AlternativeOrganisationIdentifier = new alternativeOrganisationIdentifierTYPE
                        {
                            OrganisationIdentifier = "12345678",
                            OrganisationIdentifierName = alternativeOrganisationIdentifierTYPEOrganisationIdentifierName.UKPROVIDERREFERENCENUMBER
                        }
                    }
                },
                RelationshipType = organisationRelationshipTYPE.DELIVERYORGANISATION
            };
            
            // act
            string xml = allocationDeliveryPerformance.SerializeToXml();
            

            // assert
            Assert.IsTrue(xml.Contains("<allocationOrganisationRelationships>"), "Allocation organisation relationships should have been serialized for Mainstream");
            Assert.IsTrue(xml.Contains("<RelationshipType>DELIVERY ORGANISATION</RelationshipType>"), "Allocation organisation relationships should have been serialized for Mainstream");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationDeliveryPerformanceMapper_ShouldMapDeliveryOrgInfoWhenPresent()
        {
            // arrange
            const string allocationNumber = "XX";
            const string orgId = "ORG1234567";
            const int ukprn = 444;
            ApprovedContract approvedContract =
                new ApprovedContract("", 0, 0, "", "", int.Parse(AlternativeOrganisationId),
                    orgId, string.Empty, DateTime.Now.AddDays(7).Date, DateTime.Now.AddYears(1).Date)
            {
                ApprovedContractAllocations = new List<ApprovedContractAllocation>
                {
                    new ApprovedContractAllocation
                    {
                        ContractAllocationNumber = allocationNumber,
                        DeliveryOrganisationId = orgId,
                        DeliveryOrganisationUkprn = ukprn
                    }
                }
            };

            Mock<IApprovedContractRepository> approvedContractRepositoryMock = new Mock<IApprovedContractRepository>();
            approvedContractRepositoryMock.Setup(r => r.GetContractForAllocationNumber(It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(approvedContract);
            AllocationDeliveryPerformanceMapper mapper = new AllocationDeliveryPerformanceMapper(approvedContractRepositoryMock.Object)
            {
                SchemaValidator = new SchemaValidator()
            };

            AllocationDeliveryCommencedEvent allocDeliveryCommencedEvent = CreateAllocationDeliveryCommencedEvent(allocationNumber);

            // act
            AllocationDeliveryPerformance result = mapper.Map(allocDeliveryCommencedEvent, ConnectionInfo.CreateDefault());

            // assert
            Assert.AreEqual(allocationNumber,
                result.allocationOrganisationRelationships.contractAllocationNumber,
                "The allocation number on the org relationship is incorrect");
            Assert.AreEqual(orgId,
                result.allocationOrganisationRelationships.Organisation.organisationIdentifier,
                "The organisationIdentifier on the org relationship is incorrect");
            Assert.AreEqual(ukprn.ToString(),
                result.allocationOrganisationRelationships.Organisation.alternativeOrganisationIdentifiers.AlternativeOrganisationIdentifier.OrganisationIdentifier,
                "The ukprn on the org relationship is incorrect");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationDeliveryPerformanceMapper_ShouldMapToEmptyDeliveryOrgInfoWhenNotPresent()
        {
            // arrange
            const string allocationNumber = "XX";
            const string orgId = null;
            int? ukprn = null;
            ApprovedContract approvedContract = 
                new ApprovedContract("", 0, 0, "", "", int.Parse(AlternativeOrganisationId), 
                                     "ORG1244777", string.Empty, DateTime.Now.AddDays(7).Date, DateTime.Now.AddYears(1).Date)
            {
                ApprovedContractAllocations = new List<ApprovedContractAllocation>
                {
                    new ApprovedContractAllocation
                    {
                        ContractAllocationNumber = allocationNumber,
                        DeliveryOrganisationId = orgId,
                        DeliveryOrganisationUkprn = ukprn
                    }
                }
            };

            Mock<IApprovedContractRepository> approvedContractRepositoryMock = new Mock<IApprovedContractRepository>();
            approvedContractRepositoryMock.Setup(r => r.GetContractForAllocationNumber(It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(approvedContract);
            AllocationDeliveryPerformanceMapper mapper = new AllocationDeliveryPerformanceMapper(approvedContractRepositoryMock.Object)
            {
                SchemaValidator = new SchemaValidator()
            };

            AllocationDeliveryCommencedEvent allocDeliveryCommencedEvent = CreateAllocationDeliveryCommencedEvent(allocationNumber);

            // act
            AllocationDeliveryPerformance result = mapper.Map(allocDeliveryCommencedEvent, ConnectionInfo.CreateDefault());

            // assert
            Assert.AreEqual(null,
                result.allocationOrganisationRelationships.contractAllocationNumber,
                "The allocation number on the org relationship is incorrect");
            Assert.AreEqual(orgId,
                result.allocationOrganisationRelationships.Organisation.organisationIdentifier,
                "The organisationIdentifier on the org relationship is incorrect");
            Assert.AreEqual(null,
                result.allocationOrganisationRelationships.Organisation.alternativeOrganisationIdentifiers.AlternativeOrganisationIdentifier.OrganisationIdentifier,
                "The ukprn on the org relationship is incorrect");
        }

        private static AllocationDeliveryPerformance GetAllocationDeliveryPerformance()
        {
            using (TestResource resource = new TestResource("ADMonitoringDomain.Endpoint.Tests", @"Resources.AllocationDeliveryPerformance.xml"))
            {
                XmlSerializer serializer = new XmlSerializer(typeof(AllocationDeliveryPerformance));

                return (AllocationDeliveryPerformance)serializer.Deserialize(resource.Stream);
            }
        }

        private static AllocationDeliveryCommencedEvent CreateAllocationDeliveryCommencedEvent(string allocationNumber = AllocationNumber)
        {
            return new AllocationDeliveryCommencedEvent
            {
                Allocation = new allocationType
                {
                    contractAllocationNumber = allocationNumber,
                    contractReference = new contractReferenceType
                    {
                        contractNumber = ContractNumber,
                        contractVersionNumber = VersionNumber,
                        contractSubVersionNumber = SubVersionNumber
                    },
                    fundingStreamPeriod = new allocationTypeFundingStreamPeriod
                    {
                        fundingStreamPeriodCode = FundingStreamPeriodCode,
                        period = new periodType
                        {
                            periodType1 = new periodTypeType
                            {
                                periodTypeCode = (periodTypeCodeType) Enum.Parse(typeof (periodTypeCodeType), AllocationPeriodTypeCode)
                            }
                        }
                    },
                    uopCode = UopCode,
                    contractorReference = new organisationReferenceType
                    {
                        organisationIdentifier = OrganisationId,
                        alternativeOrganisationIdentifiers = new List<alternativeOrganisationIdentifierType>
                        {
                            new alternativeOrganisationIdentifierType
                            {
                                OrganisationIdentifier = AlternativeOrganisationId,
                                OrganisationIdentifierName = (alternativeOrganisationIdentifierTypeOrganisationIdentifierName) Enum.Parse(typeof (alternativeOrganisationIdentifierTypeOrganisationIdentifierName), AOrgIdName)
                            }
                        }
                    },
                    contractDeliverables = new List<contractDeliverableType>
                    {
                        new contractDeliverableType
                        {
                            deliverable = new deliverableType
                            {
                                deliverableCode = DeliverableCode,
                                isLegal = true,
                                isMonitoring = true
                            },
                            //plannedValue = DelPlannedVal,
                            //plannedVolume = DelPlannedVol,
                            contractDeliverablePeriods = new List<contractDeliverablePeriodsTypeContractDeliverablePeriod>
                            {
                                new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                {
                                    period = new periodType
                                    {
                                        periodValue = "201608",
                                        periodType1 = new periodTypeType
                                        {
                                            periodTypeCode = periodTypeCodeType.AY,
                                            periodTypeName = periodTypeNameType.ACADEMICYEAR
                                        }
                                    },
                                    plannedValue = 10m,
                                }
                            }
                        }
                    }
                }
            };
        }
      }
}
