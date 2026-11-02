namespace CrossDomain.Integration.Entities.Tests.Integration
{
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using System.Reflection;
    using System.Xml;
    using System.Xml.Linq;
    using System.Xml.Schema;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Common.Serializers;
    using SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation.CorporateSchema._3_0;

    [TestClass]
    public class FundingClaimReconciliationSchemaValidationTests
    {
        private const string AssemblyName = "CrossDomain.Integration.Entities.dll";
        private const string EmbeddedResourceName = "SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation.CorporateSchema._3_0.FundingClaimReconciliation.xsd";
        private const string SchemaNamespace = "urn:sfa:schemas:FCReconciliation";
        XmlSchemaSet _schemas;
        private FCReconciliation _fundingClaimReconcilation;

        [TestInitialize]
        public void TestInitialize()
        {
            using (Stream stream = Assembly.LoadFrom(AssemblyName).GetManifestResourceStream(EmbeddedResourceName))
            {
                if (stream == null)
                {
                    Assert.Fail("Could not load FundingClaimReconciliation schema resource.");
                }
                _schemas = new XmlSchemaSet();
                _schemas.Add(SchemaNamespace, new XmlTextReader(stream));
            }

            _fundingClaimReconcilation = CreateFundingClaimReconciliationTestFixture();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingClaimReconcilation_ShouldValidateAgainstCorporateSchemaWhenSerializedToXml()
        {
            List<string> validationErrors = new List<string>();

            // act
            string xml = _fundingClaimReconcilation.SerializeToXml();
            XDocument
                .Parse(xml, LoadOptions.PreserveWhitespace | LoadOptions.SetLineInfo)
                .Validate(_schemas, (sender, e) => validationErrors.Add($"Error: {e.Exception.Message} at line {e.Exception.LineNumber}"));

            // assert
            Assert.IsFalse(validationErrors.Any(), $"Schema validation errors returned: {string.Join("\n", validationErrors)}");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingClaimReconcilation_ShouldHaveCorrectSchemaVersionWhenSerializedToXml()
        {
            // act
            string xml = _fundingClaimReconcilation.SerializeToXml();
            XDocument xDoc = XDocument.Parse(xml, LoadOptions.PreserveWhitespace | LoadOptions.SetLineInfo);

            // assert
            XAttribute schemaVersionAttribute = xDoc.Elements().Single(e => e.Name.LocalName == "FCReconciliation").Attribute("SchemaVersion");
            Assert.AreEqual(3.00m, decimal.Parse(schemaVersionAttribute.Value));
        }

        private static FCReconciliation CreateFundingClaimReconciliationTestFixture()
        {
            return new FCReconciliation
            {
                FCReconciliationAllAttrs = new FCReconciliationAllAttrsCT
                {
                    FCReconciliationPKeyAttrs = new FCReconciliationPKeyAttrsCT
                    {
                        Contractor = new ContractorAllAttrsCT
                        {
                            ContractorPKeyAttrs = new ContractorPKeyAttrsCT
                            {
                                OrganisationIdentifier = "ORG_100123"
                            },
                            ContractorNonPKeyAttrs = new ContractorNonPKeyAttrsCT
                            {
                                UKPRN = 1001234,
                                LegalName = "ABC College"
                            }
                        },
                        Period = new PeriodAllAttrsCT
                        {
                            Period = "1516",
                            PeriodTypePKeyAttrs = new PeriodTypePKeyAttrsCT
                            {
                                PeriodTypeCode = PeriodTypeCodeST.AY
                            },
                            PeriodTypeNonPKeyAttrs = new PeriodTypeNonPKeyAttrsCT
                            {
                                PeriodTypeName = PeriodTypeNameST.ACADEMICYEAR
                            }
                        },
                        ClaimVersionNumber = 1,
                        ClaimType = new ClaimTypeAllAttrsCT
                        {
                            ClaimTypePKeyAttrs = new ClaimTypePKeyAttrsCT
                            {
                                ClaimTypeCode = "YE"
                            },
                            ClaimTypeNonPKeyAttrs = new ClaimTypeNonPKeyAttrsCT
                            {
                                ClaimTypeName = "Year End"
                            }
                        },
                        AllocationGroup = new AllocationGroupAllAttrsCT
                        {
                            AllocationGroupPKeyAttrs = new AllocationGroupPKeyAttrsCT
                            {
                                AllocationGroupCode = "DLSALLBC1516"
                            },
                            AllocationGroupNonPKeyAttrs = new AllocationGroupNonPKeyAttrsCT
                            {
                                AllocationGroupName = "DLS and Advanced Learner Loans Bursary 15/16"
                            }
                        }
                    },
                    FCReconciliationNonPKeyAttrs = new FCReconciliationNonPKeyAttrsCT
                    {
                        Status = ReconciliationStatusST.Published,
                        StatusLastUpdatedDate = new DateTime(2016, 02, 06),
                        AmountAttrs = new AmountAttrsCT
                        {
                            PlannedValue = 10000,
                            ClaimedValue = 6000,
                            ProposedReconciliationValue = -4000,
                            ReconciliationValue = -4000,
                            CappedClaimedValue = 6000
                        },
                        ContractAllocation = new List<ContractAllocationAllAttrsCT>
                        {
                            new ContractAllocationAllAttrsCT
                            {
                                ContractAllocationPKeyAttrs = new ContractAllocationPKeyAttrsCT
                                {
                                    ContractAllocationNumber = "DLS-1234"
                                },
                                ContractAllocationNonPKeyAttrs = new ContractAllocationNonPKeyAttrsCT
                                {
                                    FundingstreamPeriodCode = "DLS1516",
                                    AllocationStartDate = new DateTime(2015, 08, 01),
                                    AllocationEndDate = new DateTime(2016, 07, 31),
                                    AmountAttrs = new AmountAttrsCT
                                    {
                                        PlannedValue = 5000,
                                        ClaimedValue = 4000,
                                        ProposedReconciliationValue = 1000,
                                        ReconciliationValue = 1000,
                                        CappedClaimedValue = 6000
                                    },
                                    ContractDeliverables = new List<ContractDeliverablesAllAttrsCTContractDeliverable>
                                    {
                                        new ContractDeliverablesAllAttrsCTContractDeliverable
                                        {
                                            Deliverable = new DeliverableAllAttrsCT
                                            {
                                                DeliverableCode = 2,
                                                DeliverableName = "19+ Hardship"
                                            },
                                            AmountAttrs = new AmountAttrsCT
                                            {
                                                PlannedValue = 1000,
                                                ClaimedValue = 1000
                                            }
                                        },
                                        new ContractDeliverablesAllAttrsCTContractDeliverable
                                        {
                                            Deliverable = new DeliverableAllAttrsCT
                                            {
                                                DeliverableCode = 3,
                                                DeliverableName = "20+ Childcare"
                                            },
                                            AmountAttrs = new AmountAttrsCT
                                            {
                                                PlannedValue = 1000,
                                                ClaimedValue = 1000
                                            }
                                        },
                                        new ContractDeliverablesAllAttrsCTContractDeliverable
                                        {
                                            Deliverable = new DeliverableAllAttrsCT
                                            {
                                                DeliverableCode = 4,
                                                DeliverableName = "Residential Access Fund"
                                            },
                                            AmountAttrs = new AmountAttrsCT
                                            {
                                                PlannedValue = 1000,
                                                ClaimedValue = 1000
                                            }
                                        },
                                        new ContractDeliverablesAllAttrsCTContractDeliverable
                                        {
                                            Deliverable = new DeliverableAllAttrsCT
                                            {
                                                DeliverableCode = 5,
                                                DeliverableName = "Administrative Expenditure"
                                            },
                                            AmountAttrs = new AmountAttrsCT
                                            {
                                                PlannedValue = 2000,
                                                ClaimedValue = 1000
                                            }
                                        }
                                    }
                                },
                                ContractAllocationDNAttrs = new ContractAllocationDNAttrsCT
                                {
                                    ContractAttrs = new ContractAllAttrsCT
                                    {
                                        ContractNumber = "MAIN-1234",
                                        ContractVersionNumber = 1,
                                        ContractSubVersionNumber = 0,
                                        FundingTypeAllAttrs = new FundingTypeAllAttrsCT
                                        {
                                            FundingPKeyAttrs = new FundingTypePKeyAttrsCT
                                            {
                                                FundingTypeCode = "MAIN"
                                            },
                                            FundingTypeNonPKeyAttrs = new FundingTypeNonPKeyAttrsCT
                                            {
                                                FundingTypeName = "MAINSTREAM"
                                            }
                                        },
                                        ContractApprovalDate = new DateTime(2016, 08, 06)
                                    }
                                }
                            },
                            new ContractAllocationAllAttrsCT
                            {
                                ContractAllocationPKeyAttrs = new ContractAllocationPKeyAttrsCT
                                {
                                    ContractAllocationNumber = "ALLBC-1234",
                                },
                                ContractAllocationNonPKeyAttrs = new ContractAllocationNonPKeyAttrsCT
                                {
                                    FundingstreamPeriodCode = "24+ALLBC1516",
                                    AllocationStartDate = new DateTime(2015, 08, 01),
                                    AllocationEndDate = new DateTime(2016, 07, 31),
                                    AmountAttrs = new AmountAttrsCT
                                    {
                                        PlannedValue = 5000,
                                        ClaimedValue = 4000,
                                        ProposedReconciliationValue = 1000,
                                        ReconciliationValue = 1000
                                    },
                                    ContractDeliverables = new List<ContractDeliverablesAllAttrsCTContractDeliverable>
                                    {
                                        new ContractDeliverablesAllAttrsCTContractDeliverable
                                        {
                                            Deliverable = new DeliverableAllAttrsCT
                                            {
                                                DeliverableCode = 2,
                                                DeliverableName = "24+ Loans - Bursary Funding",
                                            },
                                            AmountAttrs = new AmountAttrsCT
                                            {
                                                PlannedValue = 500,
                                                ClaimedValue = 1000
                                            }
                                        },
                                        new ContractDeliverablesAllAttrsCTContractDeliverable
                                        {
                                            Deliverable = new DeliverableAllAttrsCT
                                            {
                                                DeliverableCode = 3,
                                                DeliverableName = "24+ Loans - Area Costs",
                                            },
                                            AmountAttrs = new AmountAttrsCT
                                            {
                                                PlannedValue = 500,
                                                ClaimedValue = 500
                                            }
                                        },
                                        new ContractDeliverablesAllAttrsCTContractDeliverable
                                        {
                                            Deliverable = new DeliverableAllAttrsCT
                                            {
                                                DeliverableCode = 4,
                                                DeliverableName = "24+ Loans - Excess Claims",
                                            },
                                            AmountAttrs = new AmountAttrsCT
                                            {
                                                PlannedValue = 500,
                                                ClaimedValue = 500
                                            }
                                        },
                                        new ContractDeliverablesAllAttrsCTContractDeliverable
                                        {
                                            Deliverable = new DeliverableAllAttrsCT
                                            {
                                                DeliverableCode = 5,
                                                DeliverableName = "24+ Loans - Hardship",
                                            },
                                            AmountAttrs = new AmountAttrsCT
                                            {
                                                PlannedValue = 500,
                                                ClaimedValue = 500
                                            }
                                        },
                                        new ContractDeliverablesAllAttrsCTContractDeliverable
                                        {
                                            Deliverable = new DeliverableAllAttrsCT
                                            {
                                                DeliverableCode = 6,
                                                DeliverableName = "24+ Loans - Childcare",
                                            },
                                            AmountAttrs = new AmountAttrsCT
                                            {
                                                PlannedValue = 1000,
                                                ClaimedValue = 500
                                            }
                                        },
                                        new ContractDeliverablesAllAttrsCTContractDeliverable
                                        {
                                            Deliverable = new DeliverableAllAttrsCT
                                            {
                                                DeliverableCode = 7,
                                                DeliverableName = "24+ Loans - Residential Access Fund",
                                            },
                                            AmountAttrs = new AmountAttrsCT
                                            {
                                                PlannedValue = 1000,
                                                ClaimedValue = 500
                                            }
                                        },
                                        new ContractDeliverablesAllAttrsCTContractDeliverable
                                        {
                                            Deliverable = new DeliverableAllAttrsCT
                                            {
                                                DeliverableCode = 8,
                                                DeliverableName = "24+ Loans - Administration Expenditure",
                                            },
                                            AmountAttrs = new AmountAttrsCT
                                            {
                                                PlannedValue = 1000,
                                                ClaimedValue = 500
                                            }
                                        }
                                    }
                                },
                                ContractAllocationDNAttrs = new ContractAllocationDNAttrsCT
                                {
                                    ContractAttrs = new ContractAllAttrsCT
                                    {
                                        ContractNumber = "MAIN-1234",
                                        ContractVersionNumber = 1,
                                        ContractSubVersionNumber = 0,
                                        FundingTypeAllAttrs = new FundingTypeAllAttrsCT
                                        {
                                            FundingPKeyAttrs = new FundingTypePKeyAttrsCT
                                            {
                                                FundingTypeCode = "MAIN"
                                            },
                                            FundingTypeNonPKeyAttrs = new FundingTypeNonPKeyAttrsCT
                                            {
                                                FundingTypeName = "MAINSTREAM"
                                            }
                                        },
                                        ContractApprovalDate = new DateTime(2016, 08, 06)
                                    }
                                }
                            }
                        }
                    }
                }
            };
        }
    }
}
