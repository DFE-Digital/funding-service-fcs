namespace PaymentManagement.Calculation.Tests.Extensions
{
    using System.Collections.Generic;
    using System.Linq;
    using Calculation.Extensions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using PaymentManagement.Calculation.Dtos;
    using SFA.FCT.CrossDomain.Integration.Entities.DeliveryAllocation;

    [TestClass]
    public class AllocationTypeExtensionsTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void AllocationTypeExtensions_ShouldTansform()
        {
            // arrange
            allocationType allocationType = new allocationType()
            {
                contractReference = new contractReferenceType
                {
                    contractNumber = "MAIN-1234",
                    contractVersionNumber = 2
                },
                contractorReference = new organisationReferenceType
                {
                    organisationIdentifier = "ORG123",
                    alternativeOrganisationIdentifiers = new List<alternativeOrganisationIdentifierType>
                    {
                        new alternativeOrganisationIdentifierType
                        {
                            OrganisationIdentifier = "ukprn1",
                            OrganisationIdentifierName = alternativeOrganisationIdentifierTypeOrganisationIdentifierName.UKPROVIDERREFERENCENUMBER
                        }
                    }
                },
                fundingStreamPeriod = new allocationTypeFundingStreamPeriod
                {
                    fundingStreamPeriodCode = "FSP1"
                },
                contractAllocationNumber = "AN1",
                contractDeliverables = new List<contractDeliverableType>
                {
                    new contractDeliverableType
                    {
                        deliverable = new deliverableType
                        {
                            deliverableCode = 1
                        },
                        contractDeliverablePeriods = new List<contractDeliverablePeriodsTypeContractDeliverablePeriod>
                        {
                            new contractDeliverablePeriodsTypeContractDeliverablePeriod
                            {
                                period = new periodType
                                {
                                    periodValue = "202003"
                                },
                                plannedValue = 100,
                                plannedVolume = 101
                            }
                        }
                    },
                    new contractDeliverableType
                    {
                        deliverable = new deliverableType
                        {
                            deliverableCode = 2
                        },
                        contractDeliverablePeriods = new List<contractDeliverablePeriodsTypeContractDeliverablePeriod>
                        {
                            new contractDeliverablePeriodsTypeContractDeliverablePeriod
                            {
                                period = new periodType
                                {
                                    periodValue = "202003"
                                },
                                plannedValue = 200,
                                plannedVolume = 201
                            }
                        }
                    }
                }
            };

            var fspDeliverableInfos = new List<FspDeliverableInfo>
            {
                new FspDeliverableInfo(1, true, 4, 11),
                new FspDeliverableInfo(2, false, 5, 22)
            };

            var cappingGroups = new List<CappingGroup>
            {
                new CappingGroup(9000, true, false),
                new CappingGroup(9001, false, true),
                new CappingGroup(9002, false, false)
            };

            // act
            var input = allocationType.ToCalculationAllocationInput(fspDeliverableInfos, cappingGroups);

            // assert
            Assert.AreEqual(allocationType.contractReference.contractNumber, input.ContractNumber, "The contract number is not right");
            Assert.AreEqual(allocationType.contractReference.contractVersionNumber, input.VersionNumber, "The VersionNumber is not right");
            Assert.AreEqual(allocationType.contractorReference.alternativeOrganisationIdentifiers[0].OrganisationIdentifier, input.Ukprn, "The Ukprn is not right");
            Assert.AreEqual(allocationType.contractorReference.organisationIdentifier, input.OrgId, "The OrgId is not right");
            Assert.AreEqual(allocationType.fundingStreamPeriod.fundingStreamPeriodCode, input.FundingStreamPeriodCode, "The FundingStreamPeriodCode is not right");
            Assert.AreEqual(allocationType.contractAllocationNumber, input.AllocationNumber, "The AllocationNumber is not right");

            Assert.AreEqual(2, input.Deliverables.Count, "The number of deliverables is incorrect");

            int numDeliverablePeriods = input.Deliverables.Single(d => d.DeliverableCode == 2).DeliverablePeriods.Count;
            Assert.AreEqual(1, numDeliverablePeriods, "The numDeliverablePeriods is not right for deliverable 2");

            var plannedValue = input.Deliverables.Single(d => d.DeliverableCode == 2).DeliverablePeriods.First().PlannedValue;
            Assert.AreEqual(200, plannedValue, "The plannedValue is not right for deliverable 2 and first period");

            fspDeliverableInfos.ForEach(fdi =>
            {
                var deliverable = input.Deliverables.Single(d => d.DeliverableCode == fdi.DeliverableCode);

                Assert.AreEqual(fdi.AllowProfile, deliverable.AllowProfile, 
                    $"The AllowProfile is not correct for deliverableCode {fdi.DeliverableCode}");
                Assert.AreEqual(fdi.CappingApportionmentPriorityOrder, deliverable.CappingApportionmentPriorityOrder, 
                    $"The CappingApportionmentPriorityOrder is not correct for deliverableCode {fdi.DeliverableCode}");
                Assert.AreEqual(fdi.FundingStreamPeriodCappingGroupId, deliverable.FundingStreamPeriodCappingGroupId,
                    $"The FundingStreamPeriodCappingGroupId is not correct for deliverableCode {fdi.DeliverableCode}");
            });

            cappingGroups.ForEach(cg =>
            {
                var resultCappingGroup = input.CappingGroups.Single(resultCg => resultCg.FundingStreamPeriodCappingGroupId == cg.FundingStreamPeriodCappingGroupId);
                Assert.AreEqual(cg.AllowUnderDeliveryToBeReUsed, resultCappingGroup.AllowUnderDeliveryToBeReUsed,
                    $"The AllowUnderDeliveryToBeReUsed is not correct for FundingStreamPeriodCappingGroupId {cg.FundingStreamPeriodCappingGroupId}");
                Assert.AreEqual(cg.AllowOverDeliveryToBeOffset, resultCappingGroup.AllowOverDeliveryToBeOffset,
                    $"The AllowOverDeliveryToBeOffset is not correct for FundingStreamPeriodCappingGroupId {cg.AllowOverDeliveryToBeOffset}");
            });
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationTypeExtensions_ShouldTansformWhenTheirAreHierarchicalDeliverables()
        {
            // arrange
            allocationType allocationType = new allocationType()
            {
                contractReference = new contractReferenceType
                {
                    contractNumber = "MAIN-1234",
                    contractVersionNumber = 2
                },
                contractorReference = new organisationReferenceType
                {
                    organisationIdentifier = "ORG123",
                    alternativeOrganisationIdentifiers = new List<alternativeOrganisationIdentifierType>
                    {
                        new alternativeOrganisationIdentifierType
                        {
                            OrganisationIdentifier = "ukprn1",
                            OrganisationIdentifierName = alternativeOrganisationIdentifierTypeOrganisationIdentifierName.UKPROVIDERREFERENCENUMBER
                        }
                    }
                },
                fundingStreamPeriod = new allocationTypeFundingStreamPeriod
                {
                    fundingStreamPeriodCode = "FSP1"
                },
                contractAllocationNumber = "AN1",
                contractDeliverables = new List<contractDeliverableType>
                {
                    new contractDeliverableType
                    {
                        deliverable = new deliverableType
                        {
                            deliverableCode = 1
                        },
                        contractDeliverablePeriods = new List<contractDeliverablePeriodsTypeContractDeliverablePeriod>
                        {
                            new contractDeliverablePeriodsTypeContractDeliverablePeriod
                            {
                                period = new periodType
                                {
                                    periodValue = "202003"
                                },
                                plannedValue = 100,
                                plannedVolume = 101
                            }
                        },
                        contractDeliverables = new List<contractDeliverableType>
                        {
                            new contractDeliverableType
                            {
                                deliverable = new deliverableType
                                {
                                    deliverableCode = 3
                                },
                                contractDeliverablePeriods = new List<contractDeliverablePeriodsTypeContractDeliverablePeriod>
                                {
                                    new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                    {
                                        period = new periodType
                                        {
                                            periodValue = "202003"
                                        },
                                        plannedValue = 300,
                                        plannedVolume = 301
                                    }
                                }
                            }
                        }
                    },
                    new contractDeliverableType
                    {
                        deliverable = new deliverableType
                        {
                            deliverableCode = 2
                        },
                        contractDeliverablePeriods = new List<contractDeliverablePeriodsTypeContractDeliverablePeriod>
                        {
                            new contractDeliverablePeriodsTypeContractDeliverablePeriod
                            {
                                period = new periodType
                                {
                                    periodValue = "202003"
                                },
                                plannedValue = 200,
                                plannedVolume = 201
                            }
                        }
                    }
                }
            };

            var fspDeliverableInfos = new List<FspDeliverableInfo>
            {
                new FspDeliverableInfo(1, true, null, -1),
                new FspDeliverableInfo(2, false, 88, -1),
                new FspDeliverableInfo(3, false, 99, -1)
            };

            // act
            var input = allocationType.ToCalculationAllocationInput(fspDeliverableInfos, new List<CappingGroup>());

            // assert
            Assert.AreEqual(allocationType.contractReference.contractNumber, input.ContractNumber, "The contract number is not right");
            Assert.AreEqual(allocationType.contractReference.contractVersionNumber, input.VersionNumber, "The VersionNumber is not right");
            Assert.AreEqual(allocationType.contractorReference.alternativeOrganisationIdentifiers[0].OrganisationIdentifier, input.Ukprn, "The Ukprn is not right");
            Assert.AreEqual(allocationType.contractorReference.organisationIdentifier, input.OrgId, "The OrgId is not right");
            Assert.AreEqual(allocationType.fundingStreamPeriod.fundingStreamPeriodCode, input.FundingStreamPeriodCode, "The FundingStreamPeriodCode is not right");
            Assert.AreEqual(allocationType.contractAllocationNumber, input.AllocationNumber, "The AllocationNumber is not right");

            Assert.AreEqual(3, input.Deliverables.Count, "The number of deliverables is incorrect");
            int numDeliverablePeriods = input.Deliverables.Single(d => d.DeliverableCode == 2).DeliverablePeriods.Count;
            Assert.AreEqual(1, numDeliverablePeriods, "The numDeliverablePeriods is not right for deliverable 2");
            var plannedValue = input.Deliverables.Single(d => d.DeliverableCode == 3).DeliverablePeriods.First()
                .PlannedValue;
            Assert.AreEqual(300, plannedValue, "The plannedValue is not right for deliverable 3 and first period");

            fspDeliverableInfos.ForEach(fdi =>
            {
                var deliverable = input.Deliverables.Single(d => d.DeliverableCode == fdi.DeliverableCode);

                Assert.AreEqual(fdi.AllowProfile, deliverable.AllowProfile,
                    $"The AllowProfile is not correct for deliverableCode {fdi.DeliverableCode}");
                Assert.AreEqual(fdi.CappingApportionmentPriorityOrder, deliverable.CappingApportionmentPriorityOrder,
                    $"The CappingApportionmentPriorityOrder is not correct for deliverableCode {fdi.DeliverableCode}");
            });
        }
    }
}
