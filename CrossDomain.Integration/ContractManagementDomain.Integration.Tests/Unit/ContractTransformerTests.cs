namespace SFA.FCT.ContractManagementDomain.Integration.Tests.Unit
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using KellermanSoftware.CompareNetObjects;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using MoreLinq;
    using Newtonsoft.Json;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateSchema.Contract;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;
    using contract = SFA.FCT.CrossDomain.Integration.Entities.CorporateContract.Contract;
    using contractAllocationsContractAllocation = SFA.FCT.CrossDomain.Integration.Entities.CorporateContract.contractAllocationsContractAllocation;
    using contractDeliverablesTypeContractDeliverable = SFA.FCT.CrossDomain.Integration.Entities.CorporateContract.contractDeliverablesTypeContractDeliverable;
    using contractor = SFA.FCT.CrossDomain.Integration.Entities.CorporateContract.Contractor;
    using contractStatusType = SFA.FCT.CrossDomain.Integration.Entities.CorporateContract.contractStatusType;
    using contractType = SFA.FCT.CrossDomain.Integration.Entities.CorporateContract.contractType;
    using CorporateSchema = SFA.FCT.CrossDomain.Integration.Entities.CorporateSchema;
    using period = SFA.FCT.CrossDomain.Integration.Entities.CorporateContract.Period;
    using periodTypeCodeType = SFA.FCT.CrossDomain.Integration.Entities.CorporateContract.periodTypeCodeType;
    using periodTypeNameType = SFA.FCT.CrossDomain.Integration.Entities.CorporateContract.periodTypeNameType;
    using periodTypeType = SFA.FCT.CrossDomain.Integration.Entities.CorporateContract.periodTypeType;

    [TestClass]
    public class ContractTransformerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void TestContractTransformerSuccessfullyTransformsNewDatesAddedForStory7861()
        {
            // Arrange
            var contractApprovalDate = new DateTime(2010, 1, 1);
            var lastModifiedDate = new DateTime(2011, 1, 1);
            var statusLastUpdatedDate = new DateTime(2012, 1, 1);

            contract sourceContract = new contract()
            {
                ContractApprovalDate = contractApprovalDate,
                LastModifiedDate = lastModifiedDate,
                StatusLastUpdatedDate = statusLastUpdatedDate,
                contracts = new List<contractType>()
                {
                    new contractType()
                    {
                        ContractApprovalDate = contractApprovalDate,
                        LastModifiedDate = lastModifiedDate,
                        StatusLastUpdatedDate = statusLastUpdatedDate,
                        contractStatus = new contractStatusType
                        {
                            parentStatus = "Approved",
                            status = "Approved"
                        }
                    }
                },
                contractStatus = new contractStatusType
                {
                    parentStatus = "Approved",
                    status = "Approved"
                }
            };

            // Act

            var corporateContract = new ContractTransformer().TransformToCorporateSchemaContract(sourceContract);

            // Assert
            Assert.AreEqual(contractApprovalDate, corporateContract.ContractApprovalDate);
            Assert.AreEqual(lastModifiedDate, corporateContract.LastModifiedDate);
            Assert.AreEqual(statusLastUpdatedDate, corporateContract.StatusLastUpdatedDate);

            Assert.AreEqual(contractApprovalDate, corporateContract.contracts[0].ContractApprovalDate);
            Assert.AreEqual(lastModifiedDate, corporateContract.contracts[0].LastModifiedDate);
            Assert.AreEqual(statusLastUpdatedDate, corporateContract.contracts[0].StatusLastUpdatedDate);
        }

        /// <summary>
        /// Perform a deep Copy of the object, using Json as a serialisation method.
        /// http://stackoverflow.com/questions/78536/deep-cloning-objects/78551#78551
        /// </summary>
        /// <typeparam name="T">The type of object being copied.</typeparam>
        /// <param name="source">The object instance to copy.</param>
        /// <returns>The copied object.</returns>
        private static T Clone<T>(T source)
        {
            // initialize inner objects individually
            // for example in default constructor some list property initialized with some values,
            // but in 'source' these items are cleaned -
            // without ObjectCreationHandling.Replace default constructor values will be added to result
            var deserializeSettings =
                new JsonSerializerSettings {ObjectCreationHandling = ObjectCreationHandling.Replace};

            return JsonConvert.DeserializeObject<T>(JsonConvert.SerializeObject(source), deserializeSettings);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TestContractTransformerSuccessfullyTransformsEsfContract()
        {
            // Arrange
            var contractApprovalDate = new DateTime(2010, 1, 1);
            var lastModifiedDate = new DateTime(2011, 1, 1);
            var statusLastUpdatedDate = new DateTime(2012, 1, 1);

            const string LEPCode = "LEPCode",
                LEPName = "LEPName",
                tenderSpecificationReference = "tenderSpecificationReference",
                lotReference = "lotReference",
                tenderAwardReference = "tenderAwardRef",
                ActivityDescription = "ActivityDescription",
                InvestmentPriority = "InvestmentPriority",
                AgreementNumber = "AgreementNumber",
                SpecificationTitle = "SpecificationTitle",
                RegionType = "RegionType",
                LearningRatePremium = "12.3",
                description = "description";

            const decimal unitCost = 42m;
            const int plannedVolume = 29;

            contract sourceContract = new contract()
            {
                ContractApprovalDate = contractApprovalDate,
                LastModifiedDate = lastModifiedDate,
                StatusLastUpdatedDate = statusLastUpdatedDate,
                contracts = new List<contractType>()
                {
                    new contractType()
                    {
                        ContractApprovalDate = contractApprovalDate,
                        LastModifiedDate = lastModifiedDate,
                        StatusLastUpdatedDate = statusLastUpdatedDate,

                        contractAllocations = new List<contractAllocationsContractAllocation>
                        {
                            new contractAllocationsContractAllocation
                            {
                                LEPCode = LEPCode,
                                LEPName = LEPName,
                                tenderSpecificationReference = tenderSpecificationReference,
                                lotReference = lotReference,
                                tenderAwardReference = tenderAwardReference,
                                ActivityDescription = ActivityDescription,
                                InvestmentPriority = InvestmentPriority,
                                AgreementNumber = AgreementNumber,
                                SpecificationTitle = SpecificationTitle,
                                RegionType = RegionType,
                                LearningRatePremium = LearningRatePremium,
                                description = description,

                                contractDeliverables = new List<contractDeliverablesTypeContractDeliverable>
                                {
                                    new contractDeliverablesTypeContractDeliverable
                                    {
                                        unitCost = unitCost,
                                        plannedVolume = plannedVolume
                                        //plannedValue = 200m

                                        //deliverableOrganisationRelationships = new List<organisationRelationship>
                                        //{
                                        //    new organisationRelationship
                                        //    {
                                        //        organisationRelationshipType = organisationRelationshipType.FUNDINGORGANISATION,
                                        //        organisationIdentifier = 10000
                                        //    }
                                        //}
                                    }
                                }

                            }
                        },
                        contractStatus = new contractStatusType
                        {
                            parentStatus = "Approved",
                            status = "Approved"
                        }
                    }
                },
                contractStatus = new contractStatusType
                {
                    parentStatus = "Approved",
                    status = "Approved"
                }
            };

            var sourceContractClone = Clone(sourceContract);

            // Act
            var corporateContract = new ContractTransformer().TransformToCorporateSchemaContract(sourceContract);

            // Assert
            Assert.IsNotNull(corporateContract);

            Assert.AreEqual(contractApprovalDate, corporateContract.ContractApprovalDate);
            Assert.AreEqual(lastModifiedDate, corporateContract.LastModifiedDate);
            Assert.AreEqual(statusLastUpdatedDate, corporateContract.StatusLastUpdatedDate);

            Assert.IsNotNull(corporateContract.contracts);
            Assert.AreEqual(1, corporateContract.contracts.Count);

            Assert.AreEqual(contractApprovalDate, corporateContract.contracts[0].ContractApprovalDate);
            Assert.AreEqual(lastModifiedDate, corporateContract.contracts[0].LastModifiedDate);
            Assert.AreEqual(statusLastUpdatedDate, corporateContract.contracts[0].StatusLastUpdatedDate);

            Assert.IsNotNull(corporateContract.contracts[0].contractAllocations);
            Assert.AreEqual(1, corporateContract.contracts[0].contractAllocations.Count);

            Assert.AreEqual(corporateContract.contracts[0].contractAllocations[0].description, description);

            Assert.IsNotNull(corporateContract.contracts[0].contractAllocations[0].ProcurementAttrs);

            Assert.AreEqual(corporateContract.contracts[0].contractAllocations[0].ProcurementAttrs.LEPName, LEPName);
            Assert.AreEqual(corporateContract.contracts[0].contractAllocations[0].ProcurementAttrs.LEPCode, LEPCode);
            Assert.AreEqual(corporateContract.contracts[0].contractAllocations[0].ProcurementAttrs.TenderSpecReference,
                tenderSpecificationReference);
            //Assert.AreEqual(corporateContract.contracts[0].contractAllocations[0].ProcurementAttrs.LotReference, lotReference);
            Assert.AreEqual(corporateContract.contracts[0].contractAllocations[0].ProcurementAttrs.AwardReference,
                tenderAwardReference);
            Assert.AreEqual(corporateContract.contracts[0].contractAllocations[0].ProcurementAttrs.ActivityDescription,
                ActivityDescription);
            Assert.AreEqual(corporateContract.contracts[0].contractAllocations[0].ProcurementAttrs.InvestmentPriority,
                InvestmentPriority);
            Assert.AreEqual(corporateContract.contracts[0].contractAllocations[0].ProcurementAttrs.AgreementNumber,
                AgreementNumber);
            Assert.AreEqual(corporateContract.contracts[0].contractAllocations[0].ProcurementAttrs.TenderSpecTitle,
                SpecificationTitle);
            Assert.AreEqual(corporateContract.contracts[0].contractAllocations[0].ProcurementAttrs.RegionType,
                RegionType);
            Assert.AreEqual(corporateContract.contracts[0].contractAllocations[0].ProcurementAttrs.LearningRatePremium,
                decimal.Parse(LearningRatePremium));

            Assert.IsNotNull(corporateContract.contracts[0].contractAllocations[0].contractDeliverables);
            Assert.AreEqual(1, corporateContract.contracts[0].contractAllocations[0].contractDeliverables.Count);

            Assert.AreEqual(corporateContract.contracts[0].contractAllocations[0].contractDeliverables[0].unitCost,
                unitCost);
            Assert.AreEqual(corporateContract.contracts[0].contractAllocations[0].contractDeliverables[0].plannedVolume,
                plannedVolume);

            // check source contract hasn't been trampled
            var compareResults = new CompareLogic().Compare(sourceContract, sourceContractClone);

            Assert.IsTrue(compareResults.AreEqual,
                $"Naughty transformer has trampled on source contract: {compareResults.DifferencesString}");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractTransformer_ShouldTransformNullLearningRatePremiumToOne()
        {
            // act
            var corporateContract = new ContractTransformer().TransformToCorporateSchemaContract(new contract
            {
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        contractAllocations = new List<contractAllocationsContractAllocation>
                        {
                            new contractAllocationsContractAllocation
                            {
                                LearningRatePremium = null
                            }
                        },
                        contractStatus = new contractStatusType
                        {
                            parentStatus = "Approved",
                            status = "Approved"
                        }
                    }
                },
                contractStatus = new contractStatusType
                {
                    parentStatus = "Approved",
                    status = "Approved"
                }
            });

            // assert
            Assert.AreEqual(1m,
                corporateContract.contracts[0].contractAllocations[0].ProcurementAttrs.LearningRatePremium,
                "Learning Rate Premium was not converted correctly.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractTransformer_ShouldTransformEmptyStringLearningRatePremiumToOne()
        {
            // act
            var corporateContract = new ContractTransformer().TransformToCorporateSchemaContract(new contract
            {
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        contractAllocations = new List<contractAllocationsContractAllocation>
                        {
                            new contractAllocationsContractAllocation
                            {
                                LearningRatePremium = string.Empty
                            }
                        },
                        contractStatus = new contractStatusType
                        {
                            parentStatus = "Approved",
                            status = "Approved"
                        }
                    }
                },
                contractStatus = new contractStatusType
                {
                    parentStatus = "Approved",
                    status = "Approved"
                }
            });

            // assert
            Assert.AreEqual(1m,
                corporateContract.contracts[0].contractAllocations[0].ProcurementAttrs.LearningRatePremium,
                "Learning Rate Premium was not converted correctly.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractTransformer_ShouldTransformWhitespaceLearningRatePremiumToOne()
        {
            // act
            var corporateContract = new ContractTransformer().TransformToCorporateSchemaContract(new contract
            {
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        contractAllocations = new List<contractAllocationsContractAllocation>
                        {
                            new contractAllocationsContractAllocation
                            {
                                LearningRatePremium = " "
                            }
                        },
                        contractStatus = new contractStatusType
                        {
                            parentStatus = "Approved",
                            status = "Approved"
                        }
                    }
                },
                contractStatus = new contractStatusType
                {
                    parentStatus = "Approved",
                    status = "Approved"
                }
            });

            // assert
            Assert.AreEqual(1m,
                corporateContract.contracts[0].contractAllocations[0].ProcurementAttrs.LearningRatePremium,
                "Learning Rate Premium was not converted correctly.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractTransformer_ShouldTransformZeroLearningRatePremiumToZero()
        {
            // act
            var corporateContract = new ContractTransformer().TransformToCorporateSchemaContract(new contract
            {
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        contractAllocations = new List<contractAllocationsContractAllocation>
                        {
                            new contractAllocationsContractAllocation
                            {
                                LearningRatePremium = "0"
                            }
                        },
                        contractStatus = new contractStatusType
                        {
                            parentStatus = "Approved",
                            status = "Approved"
                        }
                    }
                },
                contractStatus = new contractStatusType
                {
                    parentStatus = "Approved",
                    status = "Approved"
                }
            });

            // assert
            Assert.AreEqual(0m,
                corporateContract.contracts[0].contractAllocations[0].ProcurementAttrs.LearningRatePremium,
                "Learning Rate Premium was not converted correctly.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractTransformer_ShouldTransformNonZeroLearningRatePremiumToSameValue()
        {
            // act
            var corporateContract = new ContractTransformer().TransformToCorporateSchemaContract(new contract
            {
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        contractAllocations = new List<contractAllocationsContractAllocation>
                        {
                            new contractAllocationsContractAllocation
                            {
                                LearningRatePremium = "1.2"
                            }
                        },
                        contractStatus = new contractStatusType
                        {
                            parentStatus = "Approved",
                            status = "Approved"
                        }
                    }
                },
                contractStatus = new contractStatusType
                {
                    parentStatus = "Approved",
                    status = "Approved"
                }
            });

            // assert
            Assert.AreEqual(1.2m,
                corporateContract.contracts[0].contractAllocations[0].ProcurementAttrs.LearningRatePremium,
                "Learning Rate Premium was not converted correctly.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractTransformer_ShouldTransformAllPeriodTypeCombinationsFromDtoToCorporateSchema()
        {
            // sanity check the number of values for all enums are the same
            int enumValueCount = Enum.GetValues(typeof(periodTypeCodeType)).Length;
            Assert.AreEqual(enumValueCount, Enum.GetValues(typeof(periodTypeNameType)).Length,
                "Enums length mismatch detected.");
            Assert.AreEqual(enumValueCount, Enum.GetValues(typeof(CorporateSchema.Contract.periodTypeCodeType)).Length,
                "Enums length mismatch detected.");
            Assert.AreEqual(enumValueCount, Enum.GetValues(typeof(CorporateSchema.Contract.periodTypeNameType)).Length,
                "Enums length mismatch detected.");


            // now try transforming each pair of period type code and name from the v8 schema used internally to the v10 rendered on feeds
            Enum.GetValues(typeof(periodTypeCodeType)).Cast<periodTypeCodeType>().ForEach(periodTypeCode =>
            {
                // act
                CorporateSchema.Contract.Contract corporateContract =
                    new ContractTransformer().TransformToCorporateSchemaContract(new contract
                    {
                        contracts = new List<contractType>
                        {
                            new contractType
                            {
                                contractStatus = new contractStatusType
                                {
                                    parentStatus = "Approved",
                                    status = "Approved"
                                },
                                period = new period
                                {
                                    periodType = new periodTypeType
                                    {
                                        periodTypeCode = periodTypeCode,
                                        periodTypeName = (periodTypeNameType) ((int) periodTypeCode)
                                    }
                                }
                            }
                        },
                        contractStatus = new contractStatusType

                        {
                            parentStatus = "Approved",
                            status = "Approved"
                        }
                    });

                // assert
                Assert.AreEqual(periodTypeCode.ToString(),
                    corporateContract.contracts[0].period.periodType.periodTypeCode.ToString(),
                    "periodTypeCode was not transformed correctly.");
                Assert.AreEqual(((periodTypeNameType) ((int) periodTypeCode)).ToString(),
                    corporateContract.contracts[0].period.periodType.periodTypeName.ToString(),
                    "periodTypeName was not transformed correctly.");
            });
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractTransformer_ShouldMapAllocationOrganisationRelationshipsFromDtoToSchema()
        {
            contract contract = new contract
            {
                contractStatus = new contractStatusType
                {
                    status = "Draft"
                },
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        contractStatus = new contractStatusType
                        {
                            status = "Approved"
                        },
                        contractAllocations = new List<contractAllocationsContractAllocation>
                        {
                            new contractAllocationsContractAllocation
                            {
                                contractAllocationNumber = "ABC-123",
                                DeliveryOrganisationDetail =
                                    new contractor
                                    {
                                        legalName = "Delivery Org 1",
                                        organisationIdentifier = "ORG000001",
                                        ukprn = 12345678
                                    },
                                DeliveryOrganisation = "1234568"
                            }
                        }
                    }
                }
            };

            var dtoAllocation = contract.contracts[0].contractAllocations[0];

            // act
            var schemaContract = new ContractTransformer().TransformToCorporateSchemaContract(contract);

            var allocationOrganisationRelationship =
                schemaContract.contracts[0].contractAllocations[0].allocationOrganisationRelationships;

            // assert
            Assert.IsNotNull(allocationOrganisationRelationship,
                "Allocation Organisation Relationships was not mapped");
            Assert.AreEqual(dtoAllocation.contractAllocationNumber,
                allocationOrganisationRelationship.contractAllocationNumber,
                "Allocation number was not correctly mapped");
            Assert.IsNotNull(allocationOrganisationRelationship.Organisation,
                "Delivery organisation was not mapped");
            Assert.AreEqual(dtoAllocation.DeliveryOrganisationDetail.legalName,
                allocationOrganisationRelationship.Organisation.legalName,
                "Delivery organisation legal name was not correctly mapped");
            Assert.AreEqual(dtoAllocation.DeliveryOrganisationDetail.ukprn,
                allocationOrganisationRelationship.Organisation.ukprn,
                "Delivery organisation UKPRN was not correctly mapped");
            Assert.AreEqual(dtoAllocation.DeliveryOrganisationDetail.organisationIdentifier,
                allocationOrganisationRelationship.Organisation.organisationIdentifier,
                "Delivery organisation organisationIdentifier was not correctly mapped");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void
            ContractTransformer_ShouldNotMapAllocationOrganisationRelationshipsFromDtoToSchemaIfThereIsNoDeliveryOrg()
        {
            contract contract = new contract
            {
                contractStatus = new contractStatusType
                {
                    status = "Draft"
                },
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        contractStatus = new contractStatusType
                        {
                            status = "Approved"
                        },
                        contractAllocations = new List<contractAllocationsContractAllocation>
                        {
                            new contractAllocationsContractAllocation
                            {
                                contractAllocationNumber = "ABC-123"
                            }
                        }
                    }
                }
            };

            // act
            var schemaContract = new ContractTransformer().TransformToCorporateSchemaContract(contract);

            // assert
            Assert.IsNull(schemaContract.contracts[0].contractAllocations[0].allocationOrganisationRelationships,
                "Allocation Organisation Relationships should be null if there is no delivery org");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractTransformer_ShouldMapTerminationInfo()
        {
            DateTime terminationDate = DateTime.UtcNow;
            DateTime stopNewStartsDate = terminationDate.AddDays(-1);
            const string terminationReason = "NoticefromAgency";

            contract contract = new contract
            {
                contractStatus = new contractStatusType
                {
                    status = "Draft"
                },
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        contractStatus = new contractStatusType
                        {
                            status = "Approved"
                        },
                        contractAllocations = new List<contractAllocationsContractAllocation>
                        {
                            new contractAllocationsContractAllocation
                            {
                                contractAllocationNumber = "ABC-123",
                                FundingCessationDate = terminationDate,
                                StopNewStartsDate = stopNewStartsDate
                            }
                        },
                        TerminationDate = terminationDate,
                        TerminationReason = terminationReason,
                        contractNumber = "CN 1"
                    }
                }
            };

            // act
            var schemaContract = new ContractTransformer().TransformToCorporateSchemaContract(contract);

            // assert -- contract
            var schemaChildContract = schemaContract.contracts[0];
            Assert.AreEqual(terminationDate.ToString(),
                schemaChildContract.TerminationContractAttrs.terminationDate.ToString(),
                "The contract termination date is not set");
            Assert.AreEqual(terminationReason,
                schemaChildContract.TerminationContractAttrs.ReasonForTermination.ToString(),
                "The contract termination reason is not set");

            // assert -- allocation
            var schemaAllocation = schemaChildContract.contractAllocations.First();
            Assert.AreEqual(terminationDate.ToString(),
                schemaAllocation.allocationTerminationAttrs.fundingCessationDate.ToString(),
                "The allocation termination date is not set");
            Assert.AreEqual(stopNewStartsDate.ToString(),
                schemaAllocation.allocationTerminationAttrs.stopNewStartsFromDate.ToString(),
                "The allocation stopNewStartsDate is not set");
        }


        [TestMethod, TestCategory("UnitTest")]
        public void ContractTransformer_ShouldBeAbleToMapFromCrmReasonToTerminateToCorpSchema()
        {
            var enumNames = Enum.GetNames(typeof(sfa_TerminationReasons));
            var corpSchemaNames = Enum.GetNames(typeof(ReasonForTerminationType));

            Assert.AreEqual(corpSchemaNames.Length, enumNames.Length, "The number of Crm Termination Reasons differ from the number of Corp Schema reasons");
            try
            {
                IReadOnlyCollection<ReasonForTerminationType> mappedNames = enumNames.Select(n => (CorporateSchema.Contract.ReasonForTerminationType) Enum.Parse(
                    typeof(CorporateSchema.Contract.ReasonForTerminationType), n)).ToList();
            }
            catch (Exception)
            {
                Assert.Fail("Enum Parse exception - we have a CRM sfa_TerminationReasons that is not supported in the Corp Schema");
            }
        }
    }
}
