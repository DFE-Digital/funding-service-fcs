namespace ContractCreateDomain.Tests
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Moq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using CorporateContract = SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using SFA.FCT.ContractCreateDomain.BusinessLogic;
    using SFA.FCT.ContractCreateDomain.Implementation.Services;

    [TestClass]
    public class ContractDeliverableEnricherTests
    {
        private Mock<IFundingStreamConfigService> _fscServiceMock = null;

        [TestMethod, TestCategory("UnitTest")]
        public void TestEnrichContractDeliverablesSuccess()
        {
            // Arrange
            var masterContract = new CorporateContract.ExtendedContractType
            {
                contracts = new List<CorporateContract.ExtendedContractType>()
            };
            var contract = new CorporateContract.ExtendedContractType()
            {

                startDate = new DateTime(2014, 7, 1),
                endDate = new DateTime(2015, 6, 1),
                contractAllocations = new List<CorporateContract.ExtendedContractAllocation>()
            };

            var allocation = new CorporateContract.ExtendedContractAllocation()
            {
                startDate = new DateTime(2014, 7, 1),
                endDate = new DateTime(2015, 6, 1),
                fundingStream = new CorporateContract.fundingStream()
                {
                    fundingStreamCode = "16-18 APPS",
                    fundingStreamName = "16-18 Apprenticeships",
                    fundingStreamShortCode = "APS"
                },
                period = new CorporateContract.period(),
                fundingStreamPeriodCode = "16-18APPS1516"
            };
            
            var deliverablB = new CorporateContract.contractDeliverablesTypeContractDeliverable()
            {
                deliverable = new CorporateContract.deliverableType()
                {
                    deliverableCode = 4,
                    deliverableName = "THIS SHOULD NOT BE KEPT"
                }
            };
            // Changed for Nullable start and end date
            for (DateTime periodDate = contract.startDate.GetValueOrDefault(); periodDate <= contract.endDate; periodDate = periodDate.AddMonths(1))
            {
                deliverablB.contractDeliverablePeriods.Add(new CorporateContract.contractDeliverablePeriodsTypeContractDeliverablePeriod()
                {
                    period = periodDate.Month,
                    year = periodDate.Year,
                    plannedValue = 20,
                    plannedVolume = 10
                });
            }
            allocation.contractDeliverables.Add(deliverablB);

            var deliverableC = new CorporateContract.contractDeliverablesTypeContractDeliverable();
            deliverableC.deliverable = new CorporateContract.deliverableType() { deliverableCode = 5 };
            for (DateTime periodDate = contract.startDate.GetValueOrDefault(); periodDate <= contract.endDate; periodDate = periodDate.AddMonths(1))
            {
                deliverableC.contractDeliverablePeriods.Add(new CorporateContract.contractDeliverablePeriodsTypeContractDeliverablePeriod()
                {
                    period = periodDate.Month,
                    year = periodDate.Year,
                    plannedValue = 30,
                    plannedVolume = 20
                });
            }
            allocation.contractDeliverables.Add(deliverableC);

            contract.contractAllocations.Add(allocation);
            masterContract.contracts.Add(contract);

            var deliverableStructure = GetFSC1618APPS();

            // Mock out the FundingStreamConfigService
            _fscServiceMock = new Mock<IFundingStreamConfigService>();
            _fscServiceMock.Setup(m => m.GetFullDeliverableStructure(It.IsAny<string>())).Returns(deliverableStructure);

            // Act
            ContractDeliverableEnricher enricher = new ContractDeliverableEnricher(_fscServiceMock.Object);
            enricher.Enrich(masterContract);

            //Flattening the deliverable hierarchy so that tests continue to work
            masterContract.contracts.First().contractAllocations.ForEach(a =>
            {
                a.contractDeliverables = a.FlattenDeliverables(a.contractDeliverables);
            });

            // Assert
            Assert.IsTrue(masterContract.contracts.Count > 0);
            var contractA = masterContract.contracts[0];

            Assert.IsTrue(contractA.contractAllocations.Count > 0);
            var allocationA = contractA.contractAllocations[0];
            var s = "";
            foreach (var d in allocationA.contractDeliverables)
            {
                s += "del code " + d.deliverable.deliverableCode + "\n";
            }

            Assert.IsTrue(allocationA.contractDeliverables.Count == 5, "Number of deliverables incorrect, expected 5 got " + allocationA.contractDeliverables.Count + " " + s);

            var deliverableCode4 = allocationA.contractDeliverables.First(d => d.deliverable.deliverableCode == 4);
            Assert.IsTrue(deliverableCode4.plannedValue == 240, "Total value for deliverable code 4 incorrect");
            Assert.IsTrue(deliverableCode4.plannedVolume == 120, "Total volume for deliverable code 4 incorrect");
            Assert.IsTrue(deliverableCode4.contractDeliverablePeriods.Any(dp => dp.aggregate != true), "Deliverable Periods should not be aggregates");
            Assert.IsTrue(deliverableCode4.deliverable.deliverableName != "THIS SHOULD NOT BE KEPT", "Deliverable Name has not been updated");

            var deliverableCode5 = allocationA.contractDeliverables.First(d => d.deliverable.deliverableCode == 5);
            Assert.IsTrue(deliverableCode5.plannedValue == 360, "Total value for deliverable code 5 incorrect");
            Assert.IsTrue(deliverableCode5.plannedVolume == 240, "Total volume for deliverable code 5 incorrect");
            Assert.IsTrue(deliverableCode5.contractDeliverablePeriods.Any(dp => dp.aggregate != true), "Deliverable Periods should not be aggregates");

            var deliverableCode3 = allocationA.contractDeliverables.First(d => d.deliverable.deliverableCode == 3);
            Assert.IsTrue(deliverableCode3.plannedValue == 600, "Total value for deliverable code 3 incorrect");
            Assert.IsTrue(deliverableCode3.plannedVolume == 0, "Total value for deliverable code 3 incorrect");
            Assert.IsTrue(deliverableCode3.contractDeliverablePeriods.Count == 12, "Incorrect number of periods");
            Assert.IsTrue(deliverableCode3.contractDeliverablePeriods[0].period == 7, "Start period month incorrect");
            Assert.IsTrue(deliverableCode3.contractDeliverablePeriods[0].year == 2014, "Start period year incorrect");
            Assert.IsTrue(deliverableCode3.contractDeliverablePeriods.Any(dp => dp.aggregate != false), "Deliverable Periods should be aggregates");

            var deliverableCode2 = allocationA.contractDeliverables.First(d => d.deliverable.deliverableCode == 2);

            Assert.IsTrue(deliverableCode2.plannedValue == 0, "Total value for deliverable code 2 incorrect");
            Assert.IsTrue(deliverableCode2.plannedVolume == 0, "Total volume for deliverable code 2 incorrect");
            Assert.IsTrue(deliverableCode2.contractDeliverablePeriods.Count == 12, "Incorrect number of periods");
            Assert.IsTrue(deliverableCode2.contractDeliverablePeriods[0].period == 7, "Start period month incorrect");
            Assert.IsTrue(deliverableCode2.contractDeliverablePeriods[0].year == 2014, "Start period year incorrect");
            Assert.IsTrue(deliverableCode2.contractDeliverablePeriods.Any(dp => dp.aggregate != true), "Deliverable Periods should be aggregates");

            var deliverableCode1 = allocationA.contractDeliverables.First(d => d.deliverable.deliverableCode == 1);

            Assert.IsTrue(deliverableCode1.plannedValue == 600, "Total value for deliverable code 1 incorrect");
            Assert.IsTrue(deliverableCode1.plannedVolume == 0, "Total volume for deliverable code 1 incorrect");
            Assert.IsTrue(deliverableCode1.contractDeliverablePeriods.Count == 12, "Incorrect number of periods");
            Assert.IsTrue(deliverableCode1.contractDeliverablePeriods[0].period == 7, "Start period month incorrect");
            Assert.IsTrue(deliverableCode1.contractDeliverablePeriods[0].year == 2014, "Start period year incorrect");
            Assert.IsTrue(deliverableCode1.contractDeliverablePeriods.Any(dp => dp.aggregate != false), "Deliverable Periods should be aggregates");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TestEnrichNoAllocationDatesSuccess()
        {
            // Arrange
            var masterContract = new CorporateContract.ExtendedContractType
            {
                contracts = new List<CorporateContract.ExtendedContractType>()
                
            };
            var contract = new CorporateContract.ExtendedContractType
            {
                contractAllocations = new List<CorporateContract.ExtendedContractAllocation>()
            };

            contract.startDate = new DateTime(2014, 7, 1);
            contract.endDate = new DateTime(2015, 6, 1);

            var allocation = new CorporateContract.ExtendedContractAllocation();
            allocation.startDate = DateTime.MinValue;
            allocation.endDate = DateTime.MinValue;
            allocation.fundingStreamPeriodCode = "16-18APPS1516";
            allocation.period = new CorporateContract.period();

            CorporateContract.contractDeliverablesTypeContractDeliverable deliverableC = new CorporateContract.contractDeliverablesTypeContractDeliverable();
            deliverableC.deliverable = new CorporateContract.deliverableType() { deliverableCode = 1 };
            // Changed for Nullable start and end date
            for (DateTime periodDate = contract.startDate.GetValueOrDefault(); periodDate <= contract.endDate; periodDate = periodDate.AddMonths(1))
            {
                deliverableC.contractDeliverablePeriods.Add(new CorporateContract.contractDeliverablePeriodsTypeContractDeliverablePeriod()
                {
                    period = periodDate.Month,
                    year = periodDate.Year,
                    plannedValue = 10
                });
            }
            allocation.contractDeliverables.Add(deliverableC);
            contract.contractAllocations.Add(allocation);
            masterContract.contracts.Add(contract);

            var deliverableStructure = GetFSC1618APPS();

            // Mock out the FundingStreamConfigService
            _fscServiceMock = new Mock<IFundingStreamConfigService>();
            _fscServiceMock.Setup(m => m.GetFullDeliverableStructure(It.IsAny<string>())).Returns(deliverableStructure);

            // Act
            ContractDeliverableEnricher enricher = new ContractDeliverableEnricher(_fscServiceMock.Object);
            enricher.Enrich(masterContract);

            //Flattening the deliverable hierarchy so that tests continue to work
            masterContract.contracts.First().contractAllocations.ForEach(a =>
            {
                a.contractDeliverables = a.FlattenDeliverables(a.contractDeliverables);
            });

            // Assert
            Assert.IsTrue(masterContract.contracts.Count > 0);
            Assert.IsTrue(masterContract.contracts[0].contractAllocations.Count > 0);
            Assert.IsTrue(masterContract.contracts[0].contractAllocations[0].contractDeliverables.Count == 5, "Number of deliverables incorrect");
            Assert.IsTrue(masterContract.contracts[0].contractAllocations[0].contractDeliverables[1].contractDeliverablePeriods.Count == 12, "Incorrect number of periods");
            Assert.IsTrue(masterContract.contracts[0].contractAllocations[0].contractDeliverables[1].contractDeliverablePeriods[0].period == 7, "Start period month incorrect");
            Assert.IsTrue(masterContract.contracts[0].contractAllocations[0].contractDeliverables[1].contractDeliverablePeriods[0].year == 2014, "Start period year incorrect");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractDeliverableEnricher_ShouldEnrichForVolumeDeliverable()
        {
            // Arrange
            var masterContract = new CorporateContract.ExtendedContractType
            {
                contracts = new List<CorporateContract.ExtendedContractType>()

            };
            var contract = new CorporateContract.ExtendedContractType
            {
                contractAllocations = new List<CorporateContract.ExtendedContractAllocation>()
            };

            contract.startDate = new DateTime(2014, 7, 1);
            contract.endDate = new DateTime(2015, 6, 1);

            var allocation = new CorporateContract.ExtendedContractAllocation();
            allocation.startDate = DateTime.MinValue;
            allocation.endDate = DateTime.MinValue;
            allocation.period = new CorporateContract.period();
            allocation.fundingStreamPeriodCode = "16-18APPS1516";

            CorporateContract.contractDeliverablesTypeContractDeliverable deliverableC = new CorporateContract.contractDeliverablesTypeContractDeliverable();
            deliverableC.deliverable = new CorporateContract.deliverableType() { deliverableCode = 2 };
            // Changed for Nullable start and end date
            for (DateTime periodDate = contract.startDate.GetValueOrDefault(); periodDate <= contract.endDate; periodDate = periodDate.AddMonths(1))
            {
                deliverableC.contractDeliverablePeriods.Add(new CorporateContract.contractDeliverablePeriodsTypeContractDeliverablePeriod()
                {
                    period = periodDate.Month,
                    year = periodDate.Year,
                    plannedValue = 0,
                    plannedVolume = 10,
                    unitCost = 2
                });
            }
            allocation.contractDeliverables.Add(deliverableC);
            contract.contractAllocations.Add(allocation);
            masterContract.contracts.Add(contract);

            var deliverableStructure = GetFSC1618APPS();

            // Mock out the FundingStreamConfigService
            _fscServiceMock = new Mock<IFundingStreamConfigService>();
            _fscServiceMock.Setup(m => m.GetFullDeliverableStructure(It.IsAny<string>())).Returns(deliverableStructure);

            // Act
            ContractDeliverableEnricher enricher = new ContractDeliverableEnricher(_fscServiceMock.Object);
            enricher.Enrich(masterContract);

            //Flattening the deliverable hierarchy so that tests continue to work
            masterContract.contracts.First().contractAllocations.ForEach(a =>
            {
                a.contractDeliverables = a.FlattenDeliverables(a.contractDeliverables);
            });

            // Assert
            Assert.IsTrue(masterContract.contracts.Count > 0);
            Assert.IsTrue(masterContract.contracts[0].contractAllocations.Count > 0);
            Assert.IsTrue(masterContract.contracts[0].contractAllocations[0].contractDeliverables[1].contractDeliverablePeriods[0].plannedValue == 20, "The planned value has not been calculated");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractDeliverableEnricher_Enrich_ShouldSetPeriodNameCorrectly()
        {
            // Arrange
            var masterContract = new CorporateContract.ExtendedContractType
            {
                contracts = new List<CorporateContract.ExtendedContractType>()
            }; 
            var startDate = new DateTime(2014, 7, 1);
            var endDate = new DateTime(2015, 6, 1);

            var contract = new CorporateContract.ExtendedContractType
            {
                startDate = startDate,
                endDate = endDate,
                contractAllocations = new List<CorporateContract.ExtendedContractAllocation>
                {
                    new CorporateContract.ExtendedContractAllocation
                    {
                        startDate = DateTime.MinValue,
                        endDate = DateTime.MinValue,
                        fundingStreamPeriodCode = "16-18APPS1516",
                        contractDeliverables = new List<CorporateContract.contractDeliverablesTypeContractDeliverable>
                        {
                            new CorporateContract.contractDeliverablesTypeContractDeliverable
                            {
                                deliverable = new CorporateContract.deliverableType()
                                {
                                    deliverableCode = 1
                                },
                                contractDeliverablePeriods = Enumerable.Range(0, (endDate.Year - startDate.Year) * 12 + (endDate.Month - startDate.Month + 1))
                                    .Select(m => new CorporateContract.contractDeliverablePeriodsTypeContractDeliverablePeriod
                                    {
                                        period = startDate.AddMonths(m).Month,
                                        year = startDate.AddMonths(m).Year,
                                        plannedValue = 10

                                    }).ToList()
                            }
                        }
                    },
                }
            };

            masterContract.contracts.Add(contract);

            var deliverableStructure = GetFSC1618APPS();

            // Mock out the FundingStreamConfigService
            _fscServiceMock = new Mock<IFundingStreamConfigService>();
            _fscServiceMock.Setup(m => m.GetFullDeliverableStructure(It.IsAny<string>())).Returns(deliverableStructure);

            // Act
            ContractDeliverableEnricher enricher = new ContractDeliverableEnricher(_fscServiceMock.Object);
            enricher.Enrich(masterContract);

            //Flattening the deliverable hierarchy so that tests continue to work
            masterContract.contracts.First().contractAllocations.ForEach(a =>
            {
                a.contractDeliverables = a.FlattenDeliverables(a.contractDeliverables);
            });

            // Assert
            Assert.IsTrue(masterContract.contracts.Count > 0);
            Assert.IsTrue(masterContract.contracts[0].contractAllocations.Count > 0);
            Assert.AreEqual(5, masterContract.contracts[0].contractAllocations[0].contractDeliverables.Count,
                "Number of deliverables incorrect");

            var firstContractFirstAllocationFirstDeliverablePeriods =
                masterContract.contracts[0].contractAllocations[0].contractDeliverables[1].contractDeliverablePeriods;
            Assert.AreEqual(12, firstContractFirstAllocationFirstDeliverablePeriods.Count, "Incorrect number of periods");
            Assert.AreEqual(7, firstContractFirstAllocationFirstDeliverablePeriods[0].period,
                "Start period month incorrect");
            Assert.AreEqual(2014, firstContractFirstAllocationFirstDeliverablePeriods[0].year,
                "Start period year incorrect");
            Assert.AreEqual(firstContractFirstAllocationFirstDeliverablePeriods[0].periodName, "Jul-14", "Period name set incorrectly");

        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractDeliverableEnricher_Enrich_ShouldNotDuplicateAggregateDeliverables()
        {
            // Arrange
            var masterContract = new CorporateContract.ExtendedContractType
            {
                contracts = new List<CorporateContract.ExtendedContractType>()
            }; 
            var startDate = new DateTime(2014, 7, 1);
            var endDate = new DateTime(2015, 6, 1);

            var contract = new CorporateContract.ExtendedContractType
            {
                startDate = startDate,
                endDate = endDate,
                contractAllocations = new List<CorporateContract.ExtendedContractAllocation>
                {
                    new CorporateContract.ExtendedContractAllocation
                    {
                        startDate = DateTime.MinValue,
                        endDate = DateTime.MinValue,
                        fundingStreamPeriodCode = "16-18APPS1516",
                        contractDeliverables = new List<CorporateContract.contractDeliverablesTypeContractDeliverable>
                        {
                            new CorporateContract.contractDeliverablesTypeContractDeliverable
                            {
                                deliverable = new CorporateContract.deliverableType()
                                {
                                    deliverableCode = 1
                                },
                                contractDeliverablePeriods = Enumerable.Range(0, (endDate.Year - startDate.Year) * 12 + (endDate.Month - startDate.Month + 1))
                                    .Select(m =>
                                        new CorporateContract.
                                            contractDeliverablePeriodsTypeContractDeliverablePeriod
                                        {
                                            period = startDate.AddMonths(m).Month,
                                            year = startDate.AddMonths(m).Year,
                                            plannedValue = 10

                                        }).ToList(),
                                plannedValue = 120

                            },
                            new CorporateContract.contractDeliverablesTypeContractDeliverable
                            {
                                deliverable = new CorporateContract.deliverableType()
                                {
                                    deliverableCode = 2
                                },
                                contractDeliverablePeriods = Enumerable.Range(0, (endDate.Year - startDate.Year) * 12 + (endDate.Month - startDate.Month + 1))
                                    .Select(
                                        m =>
                                            new CorporateContract.
                                                contractDeliverablePeriodsTypeContractDeliverablePeriod
                                            {
                                                period = startDate.AddMonths(m).Month,
                                                year = startDate.AddMonths(m).Year,
                                                plannedValue = 10

                                            }).ToList(),
                                plannedValue = 120

                            },
                            new CorporateContract.contractDeliverablesTypeContractDeliverable
                            {
                                deliverable = new CorporateContract.deliverableType()
                                {
                                    deliverableCode = 3
                                },
                                contractDeliverablePeriods =
                                    Enumerable.Range(0,
                                        (endDate.Year - startDate.Year) * 12 + (endDate.Month - startDate.Month + 1))
                                        .Select(
                                            m =>
                                                new CorporateContract.
                                                    contractDeliverablePeriodsTypeContractDeliverablePeriod
                                                {
                                                    period = startDate.AddMonths(m).Month,
                                                    year = startDate.AddMonths(m).Year,
                                                    plannedValue = 10

                                                }).ToList(),
                                plannedValue = 120

                            },
                            new CorporateContract.contractDeliverablesTypeContractDeliverable
                            {
                                deliverable = new CorporateContract.deliverableType()
                                {
                                    deliverableCode = 4
                                },
                                contractDeliverablePeriods =
                                    Enumerable.Range(0,
                                        (endDate.Year - startDate.Year) * 12 + (endDate.Month - startDate.Month + 1))
                                        .Select(
                                            m =>
                                                new CorporateContract.
                                                    contractDeliverablePeriodsTypeContractDeliverablePeriod
                                                {
                                                    period = startDate.AddMonths(m).Month,
                                                    year = startDate.AddMonths(m).Year,
                                                    plannedValue = 10

                                                }).ToList(),
                                plannedValue = 120

                            },
                            new CorporateContract.contractDeliverablesTypeContractDeliverable
                            {
                                deliverable = new CorporateContract.deliverableType()
                                {
                                    deliverableCode = 5
                                },
                                contractDeliverablePeriods =
                                    Enumerable.Range(0,
                                        (endDate.Year - startDate.Year) * 12 + (endDate.Month - startDate.Month + 1))
                                        .Select(
                                            m =>
                                                new CorporateContract.
                                                    contractDeliverablePeriodsTypeContractDeliverablePeriod
                                                {
                                                    period = startDate.AddMonths(m).Month,
                                                    year = startDate.AddMonths(m).Year,
                                                    plannedValue = 10

                                                }).ToList(),
                                plannedValue = 120
                            }
                        }
                    }
                }
            };

            masterContract.contracts.Add(contract);

            var deliverableStructure = GetFSC1618APPS();

            // Mock out the FundingStreamConfigService
            _fscServiceMock = new Mock<IFundingStreamConfigService>();
            _fscServiceMock.Setup(m => m.GetFullDeliverableStructure(It.IsAny<string>())).Returns(deliverableStructure);

            // Act
            ContractDeliverableEnricher enricher = new ContractDeliverableEnricher(_fscServiceMock.Object);
            enricher.Enrich(masterContract);

            //Flattening the deliverable hierarchy so that tests continue to work
            masterContract.contracts.First().contractAllocations.ForEach(a =>
            {
                a.contractDeliverables = a.FlattenDeliverables(a.contractDeliverables);
            });
            // Assert
            Assert.IsTrue(masterContract.contracts.Count > 0);
            Assert.IsTrue(masterContract.contracts[0].contractAllocations.Count > 0);
            Assert.AreEqual(5, masterContract.contracts[0].contractAllocations[0].contractDeliverables.Count,
                "Number of deliverables incorrect");

            var firstContractFirstAllocation = masterContract.contracts[0].contractAllocations[0];
            Assert.AreEqual(360, firstContractFirstAllocation.contractDeliverables[0].plannedValue, "Planned Value on Deliverable 1 Incorrect");
            Assert.IsTrue(
                firstContractFirstAllocation.contractDeliverables[0].contractDeliverablePeriods.TrueForAll(
                    p => p.plannedValue == 30), "Deliverable Periods for Deliverable 1 Incorrect");
            Assert.AreEqual(240, firstContractFirstAllocation.contractDeliverables[2].plannedValue, "Planned Value on Deliverable 2 Incorrect");
            Assert.IsTrue(
                firstContractFirstAllocation.contractDeliverables[2].contractDeliverablePeriods.TrueForAll(
                    p => p.plannedValue == 20), "Deliverable Periods for Deliverable 3 Incorrect");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractDeliverableEnricher_Enrich_ShouldRemoveMonitoringDeliverables()
        {
            // Arrange
            var masterContract = ContractTestExtendedContractType(10);

            var deliverableStructure = GetFSC1618APPS();

            // Mock out the FundingStreamConfigService
            _fscServiceMock = new Mock<IFundingStreamConfigService>();
            _fscServiceMock.Setup(m => m.GetFullDeliverableStructure(It.IsAny<string>())).Returns(deliverableStructure);

            // Act
            ContractDeliverableEnricher enricher = new ContractDeliverableEnricher(_fscServiceMock.Object);
            enricher.Enrich(masterContract);

            //Flattening the deliverable hierarchy so that tests continue to work
            masterContract.contracts.First().contractAllocations.ForEach(a =>
            {
                a.contractDeliverables = a.FlattenDeliverables(a.contractDeliverables);
            });
            // Assert
            Assert.IsTrue(masterContract.contracts.Count > 0);
            Assert.IsTrue(masterContract.contracts[0].contractAllocations.Count > 0);
            Assert.AreEqual(5, masterContract.contracts[0].contractAllocations[0].contractDeliverables.Count,  "Number of deliverables incorrect");

            var firstContractFirstAllocation = masterContract.contracts[0].contractAllocations[0];
            Assert.AreEqual(360, firstContractFirstAllocation.contractDeliverables[0].plannedValue, "Planned Value on Deliverable 1 Incorrect");
            Assert.IsTrue(
                firstContractFirstAllocation.contractDeliverables[0].contractDeliverablePeriods.TrueForAll(
                    p => p.plannedValue == 30), "Deliverable Periods for Deliverable 1 Incorrect");
            Assert.AreEqual(240, firstContractFirstAllocation.contractDeliverables[2].plannedValue, "Planned Value on Deliverable 2 Incorrect");
            Assert.IsTrue(
                firstContractFirstAllocation.contractDeliverables[2].contractDeliverablePeriods.TrueForAll(
                    p => p.plannedValue == 20), "Deliverable Periods for Deliverable 3 Incorrect");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractDeliverableEnricher_Enrich_ShouldSetDisplayOrderCorrectly()
        {
            // Arrange
            var masterContract = new CorporateContract.ExtendedContractType
            {
                contracts = new List<CorporateContract.ExtendedContractType>()
            }; 
            var startDate = new DateTime(2014, 7, 1);
            var endDate = new DateTime(2015, 6, 1);

            var contract = new CorporateContract.ExtendedContractType
            {
                startDate = startDate,
                endDate = endDate,
                contractAllocations = new List<CorporateContract.ExtendedContractAllocation>
                {
                    new CorporateContract.ExtendedContractAllocation
                    {
                        startDate = DateTime.MinValue,
                        endDate = DateTime.MinValue,
                        fundingStreamPeriodCode = "16-18APPS1516",
                        contractDeliverables = new List<CorporateContract.contractDeliverablesTypeContractDeliverable>
                        {
                            new CorporateContract.contractDeliverablesTypeContractDeliverable
                            {
                                deliverable = new CorporateContract.deliverableType()
                                {
                                    deliverableCode = 1
                                },
                                contractDeliverablePeriods = Enumerable.Range(0,
                                    (endDate.Year - startDate.Year) * 12 + (endDate.Month - startDate.Month + 1))
                                    .Select(
                                        m =>
                                            new CorporateContract.
                                                contractDeliverablePeriodsTypeContractDeliverablePeriod
                                            {
                                                period = startDate.AddMonths(m).Month,
                                                year = startDate.AddMonths(m).Year,
                                                plannedValue = 10

                                            }).ToList()
                            }
                        }
                    },
                }
            };

            masterContract.contracts.Add(contract);

            var deliverableStructure = GetFSC1618APPS();

            // Mock out the FundingStreamConfigService
            _fscServiceMock = new Mock<IFundingStreamConfigService>();
            _fscServiceMock.Setup(m => m.GetFullDeliverableStructure(It.IsAny<string>())).Returns(deliverableStructure);

            // Act
            ContractDeliverableEnricher enricher = new ContractDeliverableEnricher(_fscServiceMock.Object);
            enricher.Enrich(masterContract);

            //Flattening the deliverable hierarchy so that tests continue to work
            masterContract.contracts.First().contractAllocations.ForEach(a =>
            {
                a.contractDeliverables = a.FlattenDeliverables(a.contractDeliverables);
            });

            // Assert
            Assert.IsTrue(masterContract.contracts.Count > 0);
            Assert.IsTrue(masterContract.contracts[0].contractAllocations.Count > 0);
            Assert.AreEqual(5, masterContract.contracts[0].contractAllocations[0].contractDeliverables.Count,
                "Number of deliverables incorrect");

            var firstContractFirstAllocationFirstDeliverablePeriods =
                masterContract.contracts[0].contractAllocations[0].contractDeliverables[1].contractDeliverablePeriods;
            Assert.AreEqual(12, firstContractFirstAllocationFirstDeliverablePeriods.Count, "Incorrect number of periods");
            Assert.AreEqual(7, firstContractFirstAllocationFirstDeliverablePeriods[0].period,
                "Start period month incorrect");
            Assert.AreEqual(2014, firstContractFirstAllocationFirstDeliverablePeriods[0].year,
                "Start period year incorrect");
            Assert.AreEqual(firstContractFirstAllocationFirstDeliverablePeriods[0].displayOrder, 201407, "Period name set incorrectly");

        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractDeliverableEnricher_GetDisplayOrder_ShouldReturnValidInt()
        {
            // Arrange
            var startDate = new DateTime(2014, 7, 1);

            // Act
            var displayOrder = ContractDeliverableEnricher.GetDisplayOrder(startDate);

            // Assert
            Assert.IsInstanceOfType(displayOrder, typeof(int), "GetDisplayOrder does not return correct type");
            Assert.AreEqual(201407, displayOrder, "GetDisplayOrder does not return correct value");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractDeliverableEnricher_GetPeriodName_ShouldReturnValidInt()
        {
            // Arrange
            var startDate = new DateTime(2014, 7, 1);

            // Act
            var periodName = ContractDeliverableEnricher.GetPeriodName(startDate);

            // Assert
            Assert.IsInstanceOfType(periodName, typeof(string), "GetPeriodName does not return correct type");
            Assert.AreEqual("Jul-14", periodName, "GetPeriodName does not return correct value");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ShouldFilterProfileDeliverableStructure()
        {
            var deliverableStructure = GetFSC1618APPS();

            for (int i = 6; i < 11; i++)
            {
                deliverableStructure.DeliverableStructureList.Add(new DeliverableConfigurationType()
                {
                    DeliverableCode = i,
                    DeliverableName = "Monitoring Deliverable",
                    ParentDetails = new DeliverableConfigurationTypeParentDetails()
                    {
                        ParentDeliverableCode = 2,
                        ParentRelationship = DeliverableParentRelationshipType.Aggregate
                    },
                    Settings = new List<DeliverableSettingsType>()
                    {
                        new DeliverableSettingsType { SettingCode = "mandatory", SettingValue = "Mandatory" },
                        new DeliverableSettingsType { SettingCode = "allowprofile", SettingValue = "No" }
                    }
                });
            }

            var filteredData = FundingStreamConfigServiceHelper.FilterProfileDeliverableStructure(deliverableStructure);

            Assert.IsTrue(filteredData.DeliverableStructureList.Count == 5, "Expected number of deliverables does not equal 5, actually {0}", filteredData.DeliverableStructureList.Count);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractDeliverableEnricher_Enrich_ShouldEnrichContract_WithNullEndDate_WithOnePeriodForEachMandatoryDeliverable()
        {
            // Arrange

            var masterContract = CreateLevyContract();
            
            var deliverableStructure = GetFSCLEVY();

            // Mock out the FundingStreamConfigService
            _fscServiceMock = new Mock<IFundingStreamConfigService>();
            _fscServiceMock.Setup(m => m.GetFullDeliverableStructure(It.IsAny<string>())).Returns(deliverableStructure);

            // Act
            ContractDeliverableEnricher enricher = new ContractDeliverableEnricher(_fscServiceMock.Object);
            enricher.Enrich(masterContract);

            //Flattening the deliverable hierarchy so that tests continue to work
            masterContract.contracts.First().contractAllocations.ForEach(a =>
            {
                a.contractDeliverables = a.FlattenDeliverables(a.contractDeliverables);
            });

            // Assert
            Assert.IsTrue(masterContract.contracts.Count > 0);
            var contract = masterContract.contracts[0];

            Assert.IsTrue(contract.contractAllocations.Count > 0);
            var allocation = contract.contractAllocations[0];

            var s = allocation.contractDeliverables.Aggregate("", (current, d) => current + ("del code " + d.deliverable.deliverableCode + "\n"));

            Assert.IsTrue(allocation.contractDeliverables.Count == 1, "Number of deliverables incorrect, expected 1 got " + allocation.contractDeliverables.Count + " " + s);

            var deliverableCode1 = allocation.contractDeliverables.First(d => d.deliverable.deliverableCode == 1);

            Assert.IsTrue(deliverableCode1.plannedValue == 20, "Total value for deliverable code 1 incorrect");
            Assert.IsTrue(deliverableCode1.contractDeliverablePeriods.Count == 1, "Incorrect number of periods");
            Assert.IsTrue(deliverableCode1.contractDeliverablePeriods[0].period == 7, "Start period month incorrect");
            Assert.IsTrue(deliverableCode1.contractDeliverablePeriods[0].year == 2017, "Start period year incorrect");
            Assert.IsFalse(deliverableCode1.contractDeliverablePeriods.Any(dp => dp.aggregate), "Deliverable Periods should be aggregates");
        }

        private FSCDeliverableStructureDefinitionResponse GetFSCLEVY()
        {
            return new FSCDeliverableStructureDefinitionResponse
            {
                DeliverableStructureList = new List<DeliverableConfigurationType>
                {
                    new DeliverableConfigurationType
                    {
                        DeliverableCode = 1,
                        DeliverableName = "Placeholder legal deliverable",
                        Settings = new List<DeliverableSettingsType>
                        {
                            new DeliverableSettingsType {SettingCode = "mandatory", SettingValue = "Mandatory"},
                            new DeliverableSettingsType {SettingCode = "allowprofile", SettingValue = "Yes"},
                            new DeliverableSettingsType {SettingCode = "displayorder", SettingValue = "1"}
                        }
                    },
                    new DeliverableConfigurationType
                    {
                        DeliverableCode = 2,
                        DeliverableName = "Placeholder monitoring deliverable",
                        ParentDetails = new DeliverableConfigurationTypeParentDetails
                        {
                            ParentDeliverableCode = 1,
                            ParentRelationship = DeliverableParentRelationshipType.Aggregate
                        },
                        Settings = new List<DeliverableSettingsType>
                        {
                            new DeliverableSettingsType {SettingCode = "mandatory", SettingValue = "Mandatory"},
                            new DeliverableSettingsType {SettingCode = "allowprofile", SettingValue = "No"},
                            new DeliverableSettingsType {SettingCode = "displayorder", SettingValue = "2"}
                        }
                    }
                }
            };
        }

        private CorporateContract.ExtendedContractType CreateLevyContract()
        {
            DateTime startDate = new DateTime(2017, 7, 1);
            DateTime? endDate = null;

            var masterContract = new CorporateContract.ExtendedContractType
            {
                contracts = new List<CorporateContract.ExtendedContractType>
                {
                    new CorporateContract.ExtendedContractType
                    {
                        startDate = startDate,
                        endDate = endDate,
                        contractAllocations = new List<CorporateContract.ExtendedContractAllocation>
                        {
                            new CorporateContract.ExtendedContractAllocation()
                            {
                                startDate = startDate,
                                endDate = endDate,
                                fundingStream = new CorporateContract.fundingStream()
                                {
                                    fundingStreamCode = "LEVY",
                                    fundingStreamName = "Apprenticeship Levy",
                                    fundingStreamShortCode = "LEVY"
                                },
                                fundingStreamPeriodCode = "LEVY1799",
                                contractDeliverables = new List<CorporateContract.contractDeliverablesTypeContractDeliverable>
                                {
                                    new CorporateContract.contractDeliverablesTypeContractDeliverable()
                                    {
                                        deliverable = new CorporateContract.deliverableType()
                                        {
                                            deliverableCode = 1,
                                            deliverableName = "THIS SHOULD NOT BE KEPT"
                                        },
                                        DisplayOrder = 1,
                                        contractDeliverablePeriods = CreateDeliverablePeriods(startDate, endDate)
                                    },
                                    new CorporateContract.contractDeliverablesTypeContractDeliverable
                                    {
                                        deliverable = new CorporateContract.deliverableType {deliverableCode = 2},
                                        DisplayOrder = 2,
                                        contractDeliverablePeriods = CreateDeliverablePeriods(startDate, endDate)
                                    }
                                }
                            }
                        }
                    }
                }
            };
            

            return masterContract;
        }

        private List<CorporateContract.contractDeliverablePeriodsTypeContractDeliverablePeriod> CreateDeliverablePeriods(DateTime? startDate, DateTime? endDate)
        {
            var contractDeliverablePeriods = new List<CorporateContract.contractDeliverablePeriodsTypeContractDeliverablePeriod>();

            if (endDate == null)
            {
                contractDeliverablePeriods.Add(new CorporateContract.contractDeliverablePeriodsTypeContractDeliverablePeriod()
                {
                    period = startDate.GetValueOrDefault().Month,
                    year = startDate.GetValueOrDefault().Year,
                    plannedValue = 20
                });
            }
            else
            {
                // Changed for Nullable start and end date
                for (DateTime periodDate = startDate.GetValueOrDefault(); periodDate <= endDate; periodDate = periodDate.AddMonths(1))
                {
                    contractDeliverablePeriods.Add(new CorporateContract.contractDeliverablePeriodsTypeContractDeliverablePeriod()
                    {
                        period = periodDate.Month,
                        year = periodDate.Year,
                        plannedValue = 20
                    });
                }
            }

            return contractDeliverablePeriods;
        }

        private FSCDeliverableStructureDefinitionResponse GetFSC1618APPS()
        {
            FSCDeliverableStructureDefinitionResponse deliverableStructure = new FSCDeliverableStructureDefinitionResponse()
            {
                DeliverableStructureList = new List<DeliverableConfigurationType>()
                {
                    new DeliverableConfigurationType()
                    {
                        DeliverableCode = 1,
                        DeliverableName = "Total 16-18 Funding",
                        Settings = new List<DeliverableSettingsType>
                        {
                            new DeliverableSettingsType { SettingCode = "mandatory", SettingValue = "Mandatory" },
                            new DeliverableSettingsType { SettingCode = "allowprofile", SettingValue = "No" },
                            new DeliverableSettingsType { SettingCode = "displayorder", SettingValue = "1" },

                        }
                    },
                    new DeliverableConfigurationType
                    {
                        DeliverableCode = 2,
                        DeliverableName = "16-18 Apprenticeships Total Funding",
                        ParentDetails = new DeliverableConfigurationTypeParentDetails()
                        {
                            ParentDeliverableCode = 1,
                            ParentRelationship = DeliverableParentRelationshipType.Aggregate
                        },
                        Settings = new List<DeliverableSettingsType>
                        {
                            new DeliverableSettingsType { SettingCode = "mandatory", SettingValue = "Mandatory" },
                            new DeliverableSettingsType { SettingCode = "allowprofile", SettingValue = "Yes" },
                            new DeliverableSettingsType { SettingCode = "displayorder", SettingValue = "2" },
                        }
                    },
                    new DeliverableConfigurationType()
                    {
                        DeliverableCode = 3,
                        DeliverableName = "16-18 Traineeships Total Funding",
                        ParentDetails = new DeliverableConfigurationTypeParentDetails()
                        {
                            ParentDeliverableCode = 1,
                            ParentRelationship = DeliverableParentRelationshipType.Aggregate
                        },
                        Settings = new List<DeliverableSettingsType>
                        {
                            new DeliverableSettingsType { SettingCode = "mandatory", SettingValue = "Mandatory" },
                            new DeliverableSettingsType { SettingCode = "allowprofile", SettingValue = "No" },
                            new DeliverableSettingsType { SettingCode = "displayorder", SettingValue = "3" },
                        }
                    },
                    new DeliverableConfigurationType
                    {
                        DeliverableCode = 4,
                        DeliverableName = "16-18 Traineeships Programme Funding",
                        ParentDetails = new DeliverableConfigurationTypeParentDetails
                        {
                            ParentDeliverableCode = 3,
                            ParentRelationship = DeliverableParentRelationshipType.Aggregate
                        },
                        Settings = new List<DeliverableSettingsType>
                        {
                            new DeliverableSettingsType { SettingCode = "mandatory", SettingValue = "Mandatory" },
                            new DeliverableSettingsType { SettingCode = "allowprofile", SettingValue = "Yes" },
                            new DeliverableSettingsType { SettingCode = "displayorder", SettingValue = "4" },
                        }
                    },
                    new DeliverableConfigurationType
                    {
                        DeliverableCode = 5,
                        DeliverableName = "16-18 Traineeships Bursary Funding",
                        ParentDetails = new DeliverableConfigurationTypeParentDetails
                        {
                            ParentDeliverableCode = 3,
                            ParentRelationship = DeliverableParentRelationshipType.Aggregate
                        },
                        Settings = new List<DeliverableSettingsType>
                        {
                            new DeliverableSettingsType { SettingCode = "mandatory", SettingValue = "Mandatory" },
                            new DeliverableSettingsType { SettingCode = "allowprofile", SettingValue = "Yes" },
                            new DeliverableSettingsType { SettingCode = "displayorder", SettingValue = "5" },
                        }
                    },
                }
            };

            return deliverableStructure;
        }

        public CorporateContract.ExtendedContractType ContractTestExtendedContractType(int numberOfDeliverables)
        {
            // Arrange
            var masterContract = new CorporateContract.ExtendedContractType
            {
                contracts = new List<CorporateContract.ExtendedContractType>()
            };
            var startDate = new DateTime(2014, 7, 1);
            var endDate = new DateTime(2015, 6, 1);

            var contract = new CorporateContract.ExtendedContractType
            {
                startDate = startDate,
                endDate = endDate,
                contractAllocations = new List<CorporateContract.ExtendedContractAllocation>
                {
                    new CorporateContract.ExtendedContractAllocation
                    {
                        startDate = DateTime.MinValue,
                        endDate = DateTime.MinValue,
                        fundingStreamPeriodCode = "16-18APPS1516",
                        contractDeliverables = new List<CorporateContract.contractDeliverablesTypeContractDeliverable>()
                    }
                }
            };

            masterContract.contracts.Add(contract);

            for (int i = 1; i <= numberOfDeliverables; i++)
            {
                contract.contractAllocations[0].contractDeliverables.Add(

                    new CorporateContract.contractDeliverablesTypeContractDeliverable
                    {
                        deliverable = new CorporateContract.deliverableType()
                        {
                            deliverableCode = i
                        },
                        contractDeliverablePeriods = Enumerable.Range(0, (endDate.Year - startDate.Year) * 12 + (endDate.Month - startDate.Month + 1))
                            .Select(m =>
                                new CorporateContract.
                                    contractDeliverablePeriodsTypeContractDeliverablePeriod
                                {
                                    period = startDate.AddMonths(m).Month,
                                    year = startDate.AddMonths(m).Year,
                                    plannedValue = 10

                                }).ToList(),
                        plannedValue = 120

                    });
            }


            return masterContract;
        }
    }
}