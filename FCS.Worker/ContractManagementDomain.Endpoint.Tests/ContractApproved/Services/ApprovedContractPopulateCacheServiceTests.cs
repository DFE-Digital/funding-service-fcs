namespace ContractManagementDomain.Endpoint.Tests.ContractApproved.Services
{
    using System;
    using System.Collections.Generic;
    using System.Data.Entity;
    using System.Linq;
    using System.Threading.Tasks;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Model;
    using Endpoint.ContractApproved.Repositories;
    using Endpoint.ContractApproved.Services;
    using FluentAssertions;
    //  using FluentAssertions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using UnitTests.Common;

    [TestClass]
    public class ApprovedContractPopulateCacheServiceTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void ApprovedContractPopulateCacheService_AddApprovedContract_ShouldNotReplaceAlreadyStoredApprovedContract()
        {
            // Arrange
            const string approvedContractNumber = "APPROVED_CONTRACT_TOREPLACE_1";
            const string approvedContractAllocationPrefix = "APPROVED_ALLOCATION_TOREPLACE_";
            const int versionNumberToBeReplaced = 1;
            const int subVersionNumberToBeReplaced = 1;
            const int versionNumberNew = 2;
            const int subVersionNumberNew = 3;
            const string fundingType = "TFTYPE";
            const periodTypeCodeType periodType = periodTypeCodeType.AY;
            const string period = "1415";
            string fundingPeriod = $"{periodType}{period}";
            const int ukprn = 88888888;
            const string organisationId = "Test-org";
            DateTime contractStartDate = DateTime.Now.AddDays(7).Date;
            DateTime? contractEndDate = DateTime.Now.AddYears(1).Date;

            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                // tear down test records using cascade delete
                context.ApprovedContracts.RemoveWhere(ac => ac.FundingType == fundingType && ac.FundingPeriod == fundingPeriod);
                context.SaveChanges();
            }

            ClearDownFundingTypeFundingPeriod(fundingType, fundingPeriod);
            CreateFundingTypeFundingPeriod(fundingType, fundingPeriod);

            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                context.ApprovedContracts.Add(new ApprovedContract(approvedContractNumber, versionNumberToBeReplaced, subVersionNumberToBeReplaced,
                                                                   fundingType, fundingPeriod, ukprn, organisationId, string.Empty,
                                                                   DateTime.Now.AddDays(1).Date, DateTime.Now.AddDays(2).Date)
                {
                    ApprovedContractAllocations = new List<ApprovedContractAllocation>
                    {
                        new ApprovedContractAllocation {ContractAllocationNumber = approvedContractAllocationPrefix + "1"},
                        new ApprovedContractAllocation {ContractAllocationNumber = approvedContractAllocationPrefix + "2"},
                        new ApprovedContractAllocation {ContractAllocationNumber = approvedContractAllocationPrefix + "3"}
                    }
                });
                context.SaveChanges();
            }

            var corpContract = new Contract
            {
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        contractNumber = approvedContractNumber,
                        contractVersionNumber = versionNumberNew,
                        contractSubVersionNumber = subVersionNumberNew,
                        contractAllocations = new List<contractAllocationsContractAllocation>
                        {
                            new contractAllocationsContractAllocation
                            {
                                contractAllocationNumber = approvedContractAllocationPrefix + "4",
                                DeliveryOrganisationDetail = new Contractor{ legalName = "legal name", ukprn = 4, organisationIdentifier = "OrgId 4" },
                                DeliveryOrganisation = "DelOrg",
                                contractDeliverables = new List<contractDeliverablesTypeContractDeliverable>
                                {
                                    new contractDeliverablesTypeContractDeliverable
                                    {
                                        contractDeliverablePeriods = new List<contractDeliverablePeriodsTypeContractDeliverablePeriod>
                                        {
                                            new contractDeliverablePeriodsTypeContractDeliverablePeriod { period = 1, year = 2018 }
                                        },
                                        deliverable = new deliverableType
                                        {
                                            deliverableCode = 1
                                        }

                                    }
                                }
                            },
                            new contractAllocationsContractAllocation
                            {
                                contractAllocationNumber = approvedContractAllocationPrefix + "5",
                                contractDeliverables = new List<contractDeliverablesTypeContractDeliverable>
                                {
                                    new contractDeliverablesTypeContractDeliverable
                                    {
                                        contractDeliverablePeriods = new List<contractDeliverablePeriodsTypeContractDeliverablePeriod>
                                        {
                                            new contractDeliverablePeriodsTypeContractDeliverablePeriod { period = 1, year = 2018 }
                                        },
                                        deliverable = new deliverableType
                                        {
                                            deliverableCode = 1
                                        }
                                    }
                                }
                            },
                            new contractAllocationsContractAllocation
                            {
                                contractAllocationNumber = approvedContractAllocationPrefix + "6",
                                contractDeliverables = new List<contractDeliverablesTypeContractDeliverable>
                                {
                                    new contractDeliverablesTypeContractDeliverable
                                    {
                                        contractDeliverablePeriods = new List<contractDeliverablePeriodsTypeContractDeliverablePeriod>
                                        {
                                            new contractDeliverablePeriodsTypeContractDeliverablePeriod { period = 1, year = 2018 }
                                        },
                                        deliverable = new deliverableType
                                        {
                                            deliverableCode = 1
                                        }
                                    }
                                }
                            },
                            new contractAllocationsContractAllocation
                            {
                                contractAllocationNumber = approvedContractAllocationPrefix + "7",
                                contractDeliverables = new List<contractDeliverablesTypeContractDeliverable>
                                {
                                    new contractDeliverablesTypeContractDeliverable
                                    {
                                        contractDeliverablePeriods = new List<contractDeliverablePeriodsTypeContractDeliverablePeriod>
                                        {
                                            new contractDeliverablePeriodsTypeContractDeliverablePeriod { period = 1, year = 2018 }
                                        },
                                        deliverable = new deliverableType
                                        {
                                            deliverableCode = 1
                                        }
                                    }
                                }
                            }
                        },
                        startDate = contractStartDate,
                        endDate = contractEndDate,
                        fundingType = new fundingType
                        {
                            fundingTypeCode = fundingType
                        },
                        period = new Period
                        {
                            period1 = period,
                            periodType = new periodTypeType
                            {
                                periodTypeCode = periodType
                            }
                        },
                        contractor = new Contractor{organisationIdentifier = organisationId, ukprn = ukprn },
                    }
                }
            };

            Mock<IApprovedContractRepository> approvedContractRepMock = new Mock<IApprovedContractRepository>();
            approvedContractRepMock.Setup(r => r.Add(It.IsAny<ApprovedContract>(), It.IsAny<ConnectionInfo>()))
                .Callback((ApprovedContract approvedContract, ConnectionInfo connectInfo) =>
                    new ApprovedContractRepository().Add(approvedContract, connectInfo).Wait()).Returns(Task.CompletedTask);

            approvedContractRepMock.Setup(r =>
                    r.GetLegalDeliverableCodesForFsp(It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(new List<int>() { 1 });

            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                IApprovedContractRepository approvedContractRepository = new ApprovedContractRepository();
                IFundingTypeFundingPeriodRepository fundingTypeFundingPeriodRepository = new FundingTypeFundingPeriodRepository();
                IApprovedContractPopulateCacheService approvedContractPopulateCacheService = new ApprovedContractPopulateCacheService(
                    approvedContractRepMock.Object,
                    fundingTypeFundingPeriodRepository);
                ConnectionInfo connectionInfo = new ConnectionInfo(null, context.Database.Connection);

                // Act
                approvedContractPopulateCacheService.UpdateApprovedContractCache(corpContract, string.Empty, connectionInfo).Wait();
            }

            // Assert
            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                var assertedApprovedContract = context.ApprovedContracts
                    .Where(ac => ac.ContractNumber == approvedContractNumber && ac.ContractVersionNumber == versionNumberNew)
                    .Include(ca => ca.ApprovedContractAllocations).Single();

                Assert.AreEqual(versionNumberNew, assertedApprovedContract.ContractVersionNumber,
                    "Incorrect contract version number stored");
                Assert.AreEqual(subVersionNumberNew, assertedApprovedContract.ContractSubVersionNumber,
                    "Incorrect contract subversion number stored");
                Assert.AreEqual(4, assertedApprovedContract.ApprovedContractAllocations.Count,
                    "Expected 4 contract allocation records to be stored");
                Assert.AreEqual(fundingType, assertedApprovedContract.FundingType, "Funding type was not correct");
                Assert.AreEqual(fundingPeriod, assertedApprovedContract.FundingPeriod, "Funding period was not correct");

                Assert.AreEqual(contractStartDate, assertedApprovedContract.StartDate, "Contract start date was not correct");
                Assert.AreEqual(contractEndDate, assertedApprovedContract.EndDate, "Contract end date was not correct");

                // Assert contract org details 
                Assert.AreEqual(organisationId, assertedApprovedContract.OrganisationId, "Incorrect contract organisation id");
                Assert.AreEqual(ukprn, assertedApprovedContract.Ukprn, "Incorrect contract ukprn");

                // Assert allocation with del org details
                var assertedAllocationWithDelOrgDetails = assertedApprovedContract.ApprovedContractAllocations
                    .Single(ca => ca.ContractAllocationNumber == approvedContractAllocationPrefix + "4");

                Assert.IsNotNull(assertedAllocationWithDelOrgDetails, $"'{approvedContractAllocationPrefix + "4"}' Allocation record was expected to be stored");
                Assert.AreEqual(assertedAllocationWithDelOrgDetails.DeliveryOrganisationId, "OrgId 4",
                    $"Allocation '{assertedAllocationWithDelOrgDetails.ContractAllocationNumber}' has incorrect Organisation id");
                Assert.AreEqual(assertedAllocationWithDelOrgDetails.DeliveryOrganisationUkprn, 4,
                    $"Allocation '{assertedAllocationWithDelOrgDetails.ContractAllocationNumber}' has incorrect Ukprn");

                // Assert allocation with no del org details
                var assertedAllocationWithNoDelOrgDetails = assertedApprovedContract.ApprovedContractAllocations
                    .Single(ca => ca.ContractAllocationNumber == approvedContractAllocationPrefix + "5");

                Assert.IsNotNull(assertedAllocationWithNoDelOrgDetails, $"'{approvedContractAllocationPrefix + "5"}' Allocation record was expected to be stored");
                Assert.IsNull(assertedAllocationWithNoDelOrgDetails.DeliveryOrganisationId,
                    $"Allocation '{assertedAllocationWithNoDelOrgDetails.ContractAllocationNumber}' DeliveryOrganisationId should be null");
                Assert.IsNull(assertedAllocationWithNoDelOrgDetails.DeliveryOrganisationUkprn,
                    $"Allocation '{assertedAllocationWithNoDelOrgDetails.ContractAllocationNumber}' Ukprn should be null");

            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ApprovedContractPopulateCacheService_AddApprovedContract_ShouldStoreNewApprovedContract()
        {
            // Arrange
            const string approvedContractNumber = "APPROVED_CONTRACT_TOADDNEW_1";
            const string approvedContractAllocationPrefix = "APPROVED_ALLOCATION_TOADDNEW_";
            const int versionNumberNew = 2;
            const int subVersionNumberNew = 3;
            const string fundingType = "TFTYPE";
            const string period = "1415";
            const periodTypeCodeType periodType = periodTypeCodeType.AY;
            string fundingPeriod = periodType + period;
            const int ukprn = 88888888;
            const string organisationId = "Test-org";
            DateTime? contractStartDate = new DateTime(2018, 8, 1);
            DateTime? contractEndDate = new DateTime(2019, 7, 31);

            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                // tear down test records using cascade delete
                context.ApprovedContracts.RemoveWhere(ac => ac.FundingType == fundingType && ac.FundingPeriod == fundingPeriod);
                context.SaveChanges();
            }

            ClearDownFundingTypeFundingPeriod(fundingType, fundingPeriod);
            CreateFundingTypeFundingPeriod(fundingType, fundingPeriod, true);

            var corpContract = new Contract
            {
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        contractNumber = approvedContractNumber,
                        contractVersionNumber = versionNumberNew,
                        contractSubVersionNumber = subVersionNumberNew,
                        startDate = contractStartDate,
                        endDate = contractEndDate,
                        contractAllocations = new List<contractAllocationsContractAllocation>
                        {
                            new contractAllocationsContractAllocation
                            {
                                contractAllocationNumber = approvedContractAllocationPrefix + "4",
                                fundingStreamPeriodCode = "FSP-1",
                                contractDeliverables = new List<contractDeliverablesTypeContractDeliverable>
                                {
                                    new contractDeliverablesTypeContractDeliverable
                                    {
                                        contractDeliverablePeriods = new List<contractDeliverablePeriodsTypeContractDeliverablePeriod>
                                        {
                                            new contractDeliverablePeriodsTypeContractDeliverablePeriod { period = 12, year = 2018, plannedValue = 100m},
                                            new contractDeliverablePeriodsTypeContractDeliverablePeriod { period = 4, year = 2019, plannedValue = 200m}
                                        },
                                        deliverable = new deliverableType
                                        {
                                            deliverableCode = 1
                                        }
                                    }
                                },
                                startDate = contractStartDate.Value,
                                endDate = contractEndDate
                            },
                            new contractAllocationsContractAllocation
                            {
                                contractAllocationNumber = approvedContractAllocationPrefix + "5",
                                contractDeliverables = new List<contractDeliverablesTypeContractDeliverable>
                                {
                                    new contractDeliverablesTypeContractDeliverable
                                    {
                                        contractDeliverablePeriods = new List<contractDeliverablePeriodsTypeContractDeliverablePeriod>
                                        {
                                            new contractDeliverablePeriodsTypeContractDeliverablePeriod { period = 1, year = 2018 }
                                        },
                                        deliverable = new deliverableType
                                        {
                                            deliverableCode = 1
                                        }
                                    }
                                },
                                startDate = contractStartDate.Value,
                                endDate = contractEndDate
                            },
                            new contractAllocationsContractAllocation
                            {
                                contractAllocationNumber = approvedContractAllocationPrefix + "6",
                                contractDeliverables = new List<contractDeliverablesTypeContractDeliverable>
                                {
                                    new contractDeliverablesTypeContractDeliverable
                                    {
                                        contractDeliverablePeriods = new List<contractDeliverablePeriodsTypeContractDeliverablePeriod>
                                        {
                                            new contractDeliverablePeriodsTypeContractDeliverablePeriod { period = 1, year = 2018 }
                                        },
                                        deliverable = new deliverableType
                                        {
                                            deliverableCode = 1
                                        }
                                    },
                                },
                                startDate = contractStartDate.Value,
                                endDate = contractEndDate
                            },
                            new contractAllocationsContractAllocation
                            {
                                contractAllocationNumber = approvedContractAllocationPrefix + "7",
                                contractDeliverables = new List<contractDeliverablesTypeContractDeliverable>
                                {
                                    new contractDeliverablesTypeContractDeliverable
                                    {
                                        contractDeliverablePeriods = new List<contractDeliverablePeriodsTypeContractDeliverablePeriod>
                                        {
                                            new contractDeliverablePeriodsTypeContractDeliverablePeriod { period = 1, year = 2018 }
                                        },
                                        deliverable = new deliverableType
                                        {
                                            deliverableCode = 1
                                        }
                                    }
                                },
                                startDate = contractStartDate.Value,
                                endDate = contractEndDate
                            }
                        },
                        fundingType = new fundingType
                        {
                            fundingTypeCode = fundingType,
                            fundingTypeName = fundingType + "N"
                        },
                        period = new Period
                        {
                            period1 = period,
                            periodType = new periodTypeType
                            {
                                periodTypeCode = periodType
                            }
                        },
                        contractor = new Contractor{organisationIdentifier = organisationId, ukprn = ukprn },
                    }
                }
            };

            Mock<IApprovedContractRepository> approvedContractRepMock = new Mock<IApprovedContractRepository>();
            approvedContractRepMock.Setup(r => r.Add(It.IsAny<ApprovedContract>(), It.IsAny<ConnectionInfo>()))
                .Callback((ApprovedContract approvedContract, ConnectionInfo connectInfo) =>
                    new ApprovedContractRepository().Add(approvedContract, connectInfo).Wait()).Returns(Task.CompletedTask);

            approvedContractRepMock.Setup(r =>
                    r.GetLegalDeliverableCodesForFsp(It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(new List<int>() { 1 });

            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                IFundingTypeFundingPeriodRepository fundingTypeFundingPeriodQueryRepository = new FundingTypeFundingPeriodRepository();
                IApprovedContractPopulateCacheService approvedContractPopulateCacheService = new ApprovedContractPopulateCacheService(
                    approvedContractRepMock.Object,
                    fundingTypeFundingPeriodQueryRepository);
                ConnectionInfo connectionInfo = new ConnectionInfo(null, context.Database.Connection);
                context.Database.Log = s => System.Diagnostics.Debug.WriteLine(s);
                // Act
                approvedContractPopulateCacheService.UpdateApprovedContractCache(corpContract, string.Empty, connectionInfo).Wait();
            }

            // Assert
            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                var assertedApprovedContract = context.ApprovedContracts
                    .Where(ac => ac.ContractNumber == approvedContractNumber)
                    .Include(ca => ca.ApprovedContractAllocations).Single();

                Assert.AreEqual(versionNumberNew, assertedApprovedContract.ContractVersionNumber,
                    "Incorrect contract version number stored");
                Assert.AreEqual(subVersionNumberNew, assertedApprovedContract.ContractSubVersionNumber,
                    "Incorrect contract subversion number stored");
                Assert.AreEqual(4, assertedApprovedContract.ApprovedContractAllocations.Count,
                    "Expected 4 contract allocation records to be stored");
                Assert.IsTrue(assertedApprovedContract.ApprovedContractAllocations.First().ContractAllocationNumber == approvedContractAllocationPrefix + "4",
                    $"'{approvedContractAllocationPrefix + "4"}' Allocation record was expected to be stored");
                Assert.AreEqual(fundingType, assertedApprovedContract.FundingType, "Funding type was not correct");
                Assert.AreEqual($"{periodType}{period}", assertedApprovedContract.FundingPeriod, "Funding period was not correct");
                Assert.AreEqual(contractStartDate, assertedApprovedContract.StartDate, "Contract start date was incorrect");
                Assert.AreEqual(contractEndDate, assertedApprovedContract.EndDate, "Contract end date was incorrect");

                ApprovedContractAllocation sampleExpectedAllocation = assertedApprovedContract.ApprovedContractAllocations.First();
                Assert.AreEqual(100m, sampleExpectedAllocation.PlannedValueEnvelope1, "Incorrect Allocation PlannedValueEnvelope1 stored");
                Assert.AreEqual(200m, sampleExpectedAllocation.PlannedValueEnvelope2, "Incorrect Allocation PlannedValueEnvelope2 stored");
                Assert.AreEqual(300m, sampleExpectedAllocation.TotalPlannedValue, "Incorrect Allocation TotalPlannedValue stored");
                Assert.AreEqual("FSP-1", sampleExpectedAllocation.FundingStreamPeriodCode, "Incorrect FundingStreamPeriodCode stored");

                var allocation4 = 
                context.ApprovedContractAllocations.AsNoTracking()
                    .Where(a => a.ContractAllocationNumber == approvedContractAllocationPrefix + "4")
                    .Include(a => a.ApprovedContractDeliverables).Single();
                Assert.AreEqual(1, allocation4.ApprovedContractDeliverables.Count, $"The number of deliverables on {approvedContractAllocationPrefix + "4"} is incorrect");
                var deliverable = allocation4.ApprovedContractDeliverables.Single(d => d.DeliverableCode == 1);
                Assert.AreEqual(100m, deliverable.PlannedValueEnvelope1, $"The PlannedValueEnvelope1 on deliverable 1 is incorrect");
                Assert.AreEqual(200m, deliverable.PlannedValueEnvelope2, $"The PlannedValueEnvelope2 on deliverable 1 is incorrect");
                Assert.AreEqual(300m, deliverable.TotalPlannedValue, $"The TotalPlannedValue on deliverable 1 is incorrect");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ApprovedContractPopulateCacheService_AddApprovedContract_ShouldNotStoredApprovedContractWhenNoContractInMessage()
        {
            // Arrange
            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                // tear down test records using cascade delete
                context.ApprovedContracts.RemoveAll();
                context.SaveChanges();
            }

            var corpContract = new Contract();

            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                IApprovedContractRepository approvedContractRepository = new ApprovedContractRepository();
                IFundingTypeFundingPeriodRepository fundingTypeFundingPeriodQueryRepository = new FundingTypeFundingPeriodRepository();
                IApprovedContractPopulateCacheService approvedContractPopulateCacheService = new ApprovedContractPopulateCacheService(
                    approvedContractRepository,
                    fundingTypeFundingPeriodQueryRepository);
                ConnectionInfo connectionInfo = new ConnectionInfo(null, context.Database.Connection);

                // Act
                approvedContractPopulateCacheService.UpdateApprovedContractCache(corpContract, string.Empty, connectionInfo).Wait();
            }

            // Assert
            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                int countApprovedContracts = context.ApprovedContracts.Count();
                Assert.AreEqual(0, countApprovedContracts, "Expected no approved contracts to exist");

                int countApprovedContractAllocations = context.ApprovedContractAllocations.Count();
                Assert.AreEqual(0, countApprovedContractAllocations, "Expected no approved contract allocations to exist");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ApprovedContractPopulateCacheService_AddApprovedContract_ShouldStoredAllApprovedContractsWhenMoreThanOneContractInMessage()
        {
            // Arrange
            const string approvedContractNumberFirst = "APPROVED_CONTRACT_TOADD_FIRST";
            const string approvedContractAllocationPrefixFirst = "APPROVED_ALLOCATION_TOADD_FIRST_";

            const string approvedContractNumberSecond = "APPROVED_CONTRACT_TOADD_SECOND";
            const string approvedContractAllocationPrefixSecond = "APPROVED_ALLOCATION_TOADD_SECOND_";

            const int versionNumberNewFirst = 2;
            const int subVersionNumberNewFirst = 3;

            const int versionNumberNewSecond = 92;
            const int subVersionNumberNewSecond = 93;

            const string fundingType = "TFTYPE";
            const string period = "1415";
            const periodTypeCodeType periodType = periodTypeCodeType.AY;

            const string fundingType2 = "TFOTHER";
            const string period2 = "1213";
            string fundingPeriod = periodType + period;
            string fundingPeriod2 = periodType + period2;

            const int ukprn = 88888888;
            const string organisationId = "Test-org";
            DateTime? contractStartDate = DateTime.Now.AddDays(7).Date;
            DateTime? contractEndDate = DateTime.Now.AddYears(1).Date;

            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                context.ApprovedContracts.RemoveWhere(ac => ac.FundingType == fundingType && ac.FundingPeriod == fundingPeriod);
                context.ApprovedContracts.RemoveWhere(ac => ac.FundingType == fundingType2 && ac.FundingPeriod == fundingPeriod2);
                context.SaveChanges();
            }

            ClearDownFundingTypeFundingPeriod(fundingType, fundingPeriod);
            ClearDownFundingTypeFundingPeriod(fundingType2, fundingPeriod2);
            CreateFundingTypeFundingPeriod(fundingType, fundingPeriod);
            CreateFundingTypeFundingPeriod(fundingType2, fundingPeriod2);

            var corpContract = new Contract
            {
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        contractNumber = approvedContractNumberFirst,
                        contractVersionNumber = versionNumberNewFirst,
                        contractSubVersionNumber = subVersionNumberNewFirst,
                        startDate = contractStartDate,
                        endDate = contractEndDate,
                        contractAllocations = new List<contractAllocationsContractAllocation>
                        {
                            new contractAllocationsContractAllocation
                            {
                                contractAllocationNumber = approvedContractAllocationPrefixFirst + "4",
                                contractDeliverables = new List<contractDeliverablesTypeContractDeliverable>
                                {
                                    new contractDeliverablesTypeContractDeliverable
                                    {
                                        contractDeliverablePeriods = new List<contractDeliverablePeriodsTypeContractDeliverablePeriod>
                                        {
                                            new contractDeliverablePeriodsTypeContractDeliverablePeriod { period = 1, year = 2018 }
                                        },
                                        deliverable = new deliverableType
                                        {
                                            deliverableCode = 1
                                        }
                                    }
                                }
                            },
                            new contractAllocationsContractAllocation
                            {
                                contractAllocationNumber = approvedContractAllocationPrefixFirst + "5",
                                contractDeliverables = new List<contractDeliverablesTypeContractDeliverable>
                                {
                                    new contractDeliverablesTypeContractDeliverable
                                    {
                                        contractDeliverablePeriods = new List<contractDeliverablePeriodsTypeContractDeliverablePeriod>
                                        {
                                            new contractDeliverablePeriodsTypeContractDeliverablePeriod { period = 1, year = 2018 }
                                        },
                                        deliverable = new deliverableType
                                        {
                                            deliverableCode = 1
                                        }
                                    }
                                }
                            },
                            new contractAllocationsContractAllocation
                            {
                                contractAllocationNumber = approvedContractAllocationPrefixFirst + "6",
                                contractDeliverables = new List<contractDeliverablesTypeContractDeliverable>
                                {
                                    new contractDeliverablesTypeContractDeliverable
                                    {
                                        contractDeliverablePeriods = new List<contractDeliverablePeriodsTypeContractDeliverablePeriod>
                                        {
                                            new contractDeliverablePeriodsTypeContractDeliverablePeriod { period = 1, year = 2018 }
                                        },
                                        deliverable = new deliverableType
                                        {
                                            deliverableCode = 1
                                        }
                                    }
                                }
                            },
                            new contractAllocationsContractAllocation
                            {
                                contractAllocationNumber = approvedContractAllocationPrefixFirst + "7",
                                contractDeliverables = new List<contractDeliverablesTypeContractDeliverable>
                                {
                                    new contractDeliverablesTypeContractDeliverable
                                    {
                                        contractDeliverablePeriods = new List<contractDeliverablePeriodsTypeContractDeliverablePeriod>
                                        {
                                            new contractDeliverablePeriodsTypeContractDeliverablePeriod { period = 1, year = 2018 }
                                        },
                                        deliverable = new deliverableType
                                        {
                                            deliverableCode = 1
                                        }
                                    }
                                }
                            }
                        },
                        fundingType = new fundingType
                        {
                            fundingTypeCode = fundingType,
                            fundingTypeName = fundingType + "N"
                        },
                        period = new Period
                        {
                            period1 = period,
                            periodType = new periodTypeType
                            {
                                periodTypeCode = periodType
                            }
                        },
                        contractor = new Contractor{organisationIdentifier = organisationId, ukprn = ukprn },
                    },
                    new contractType
                    {
                        contractNumber = approvedContractNumberSecond,
                        contractVersionNumber = versionNumberNewSecond,
                        contractSubVersionNumber = subVersionNumberNewSecond,
                        startDate = contractStartDate,
                        endDate = contractEndDate,
                        contractAllocations = new List<contractAllocationsContractAllocation>
                        {
                            new contractAllocationsContractAllocation
                            {
                                contractAllocationNumber = approvedContractAllocationPrefixSecond + "94",
                                contractDeliverables = new List<contractDeliverablesTypeContractDeliverable>
                                {
                                    new contractDeliverablesTypeContractDeliverable
                                    {
                                        contractDeliverablePeriods = new List<contractDeliverablePeriodsTypeContractDeliverablePeriod>
                                        {
                                            new contractDeliverablePeriodsTypeContractDeliverablePeriod { period = 1, year = 2018 }
                                        },
                                        deliverable = new deliverableType
                                        {
                                            deliverableCode = 1
                                        }
                                    }
                                }
                            },
                            new contractAllocationsContractAllocation
                            {
                                contractAllocationNumber = approvedContractAllocationPrefixSecond + "95",
                                contractDeliverables = new List<contractDeliverablesTypeContractDeliverable>
                                {
                                    new contractDeliverablesTypeContractDeliverable
                                    {
                                        contractDeliverablePeriods = new List<contractDeliverablePeriodsTypeContractDeliverablePeriod>
                                        {
                                            new contractDeliverablePeriodsTypeContractDeliverablePeriod { period = 1, year = 2018 }
                                        },
                                        deliverable = new deliverableType
                                        {
                                            deliverableCode = 1
                                        }
                                    }
                                }
                            },
                            new contractAllocationsContractAllocation
                            {
                                contractAllocationNumber = approvedContractAllocationPrefixSecond + "96",
                                contractDeliverables = new List<contractDeliverablesTypeContractDeliverable>
                                {
                                    new contractDeliverablesTypeContractDeliverable
                                    {
                                        contractDeliverablePeriods = new List<contractDeliverablePeriodsTypeContractDeliverablePeriod>
                                        {
                                            new contractDeliverablePeriodsTypeContractDeliverablePeriod { period = 1, year = 2018 }
                                        },
                                        deliverable = new deliverableType
                                        {
                                            deliverableCode = 1
                                        }
                                    }
                                }
                            },
                            new contractAllocationsContractAllocation
                            {
                                contractAllocationNumber = approvedContractAllocationPrefixSecond + "97",
                                contractDeliverables = new List<contractDeliverablesTypeContractDeliverable>
                                {
                                    new contractDeliverablesTypeContractDeliverable
                                    {
                                        contractDeliverablePeriods = new List<contractDeliverablePeriodsTypeContractDeliverablePeriod>
                                        {
                                            new contractDeliverablePeriodsTypeContractDeliverablePeriod { period = 1, year = 2018 }
                                        },
                                        deliverable = new deliverableType
                                        {
                                            deliverableCode = 1
                                        }
                                    }
                                }
                            }
                        },
                        fundingType = new fundingType
                        {
                            fundingTypeCode = fundingType2,
                            fundingTypeName = fundingType2 + "N"
                        },
                        period = new Period
                        {
                            period1 = period2,
                            periodType = new periodTypeType
                            {
                                periodTypeCode = periodType
                            }
                        },
                        contractor = new Contractor{organisationIdentifier = organisationId, ukprn = ukprn },
                    },
                }
            };

            Mock<IApprovedContractRepository> approvedContractRepMock = new Mock<IApprovedContractRepository>();
            approvedContractRepMock.Setup(r => r.Add(It.IsAny<ApprovedContract>(), It.IsAny<ConnectionInfo>()))
                .Callback((ApprovedContract approvedContract, ConnectionInfo connectInfo) =>
                    new ApprovedContractRepository().Add(approvedContract, connectInfo).Wait()).Returns(Task.CompletedTask);

            approvedContractRepMock.Setup(r =>
                    r.GetLegalDeliverableCodesForFsp(It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(new List<int>() { 1 });

            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                IFundingTypeFundingPeriodRepository fundingTypeFundingPeriodQueryRepository = new FundingTypeFundingPeriodRepository();
                IApprovedContractPopulateCacheService approvedContractPopulateCacheService = new ApprovedContractPopulateCacheService(
                    approvedContractRepMock.Object,
                    fundingTypeFundingPeriodQueryRepository);
                ConnectionInfo connectionInfo = new ConnectionInfo(null, context.Database.Connection);

                // Act
                approvedContractPopulateCacheService.UpdateApprovedContractCache(corpContract, string.Empty, connectionInfo).Wait();
            }

            // Assert
            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                // First contract in message
                var assertedApprovedContractFirst = context.ApprovedContracts
                    .Where(ac => ac.ContractNumber == approvedContractNumberFirst)
                    .Include(ca => ca.ApprovedContractAllocations).Single();

                Assert.AreEqual(versionNumberNewFirst, assertedApprovedContractFirst.ContractVersionNumber,
                    "Incorrect contract version number stored for 1st contract in message");
                Assert.AreEqual(subVersionNumberNewFirst, assertedApprovedContractFirst.ContractSubVersionNumber,
                    "Incorrect contract subversion number stored for 1st contract in message");
                Assert.AreEqual(4, assertedApprovedContractFirst.ApprovedContractAllocations.Count,
                    "Expected 4 contract allocation records to be stored for 1st contract in message");
                Assert.IsTrue(assertedApprovedContractFirst.ApprovedContractAllocations.First().ContractAllocationNumber == approvedContractAllocationPrefixFirst + "4",
                    $"'{approvedContractAllocationPrefixFirst + "4"}' Allocation record was expected to be stored for 1st contract in message");
                Assert.AreEqual(fundingType, assertedApprovedContractFirst.FundingType, "Funding type was not correct for first contract");
                Assert.AreEqual($"{periodType}{period}", assertedApprovedContractFirst.FundingPeriod, "Funding period was not correct for first contract");

                // Second contract in message
                var assertedApprovedContractSecond = context.ApprovedContracts
                    .Where(ac => ac.ContractNumber == approvedContractNumberSecond)
                    .Include(ca => ca.ApprovedContractAllocations).Single();

                Assert.AreEqual(versionNumberNewSecond, assertedApprovedContractSecond.ContractVersionNumber,
                    "Incorrect contract version number stored for 2nd contract in message");
                Assert.AreEqual(subVersionNumberNewSecond, assertedApprovedContractSecond.ContractSubVersionNumber,
                    "Incorrect contract subversion number stored for 2nd contract in message");
                Assert.AreEqual(4, assertedApprovedContractSecond.ApprovedContractAllocations.Count,
                    "Expected 4 contract allocation records to be stored for 2nd contract in message");
                Assert.IsTrue(assertedApprovedContractSecond.ApprovedContractAllocations.First().ContractAllocationNumber == approvedContractAllocationPrefixSecond + "94",
                    $"'{approvedContractAllocationPrefixSecond + "4"}' Allocation record was expected to be stored for 2nd contract in message");
                Assert.AreEqual(fundingType2, assertedApprovedContractSecond.FundingType, "Funding type was not correct for second contract");
                Assert.AreEqual($"{periodType}{period2}", assertedApprovedContractSecond.FundingPeriod, "Funding period was not correct for second contract");
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ApprovedContractPopulateCacheService_AddApprovedContract_ShouldPopulateFinancialEnvelopesWhenIncludeAllContractsOnSummaryOfFundingIsTrue()
        {
            ApprovedContract addedApprovedContract = null;

            // arrange
            Mock<IApprovedContractRepository> approvedContractRepositoryMock = new Mock<IApprovedContractRepository>();
            approvedContractRepositoryMock
                .Setup(m => m.Add(It.IsAny<ApprovedContract>(), It.IsAny<ConnectionInfo>()))
                .Callback((ApprovedContract ac, ConnectionInfo ci) => { addedApprovedContract = ac; })
                .Returns(Task.CompletedTask);
            approvedContractRepositoryMock
                .Setup(m => m.GetLegalDeliverableCodesForFsp(It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(new List<int> { 1 });

            Mock<IFundingTypeFundingPeriodRepository> fundingTypeFundingPeriodQueryRepositoryMock = new Mock<IFundingTypeFundingPeriodRepository>();
            fundingTypeFundingPeriodQueryRepositoryMock
                .Setup(m => m.Get(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(new FundingTypeFundingPeriod { IncludeAllContractsOnSummaryOfFunding = true });

            ApprovedContractPopulateCacheService approvedContractPopulateCacheService = new ApprovedContractPopulateCacheService(
                approvedContractRepositoryMock.Object,
                fundingTypeFundingPeriodQueryRepositoryMock.Object);

            Contract masterContract = new Contract
            {
                contracts = new List<contractType>
                {
                    new Contract
                    {
                        startDate = DateTime.Now.AddDays(7).Date,
                        endDate = DateTime.Now.AddYears(1).Date,
                        contractAllocations = new List<contractAllocationsContractAllocation>
                        {
                            new contractAllocationsContractAllocation
                            {
                                contractDeliverables = new List<contractDeliverablesTypeContractDeliverable>
                                {
                                    new contractDeliverablesTypeContractDeliverable
                                    {
                                        contractDeliverablePeriods = new List<contractDeliverablePeriodsTypeContractDeliverablePeriod>
                                        {
                                            new contractDeliverablePeriodsTypeContractDeliverablePeriod { period = 8, year = 2018, plannedValue = 100m },
                                            new contractDeliverablePeriodsTypeContractDeliverablePeriod { period = 4, year = 2019, plannedValue = 200m }
                                        },
                                        deliverable = new deliverableType
                                        {
                                            deliverableCode = 1
                                        }
                                    },
                                },
                                endDate = DateTime.Now
                            }
                        }
                    }
                }
            };

            // act
            approvedContractPopulateCacheService.UpdateApprovedContractCache(masterContract, "MAIN-1234", ConnectionInfo.CreateDefault()).Wait();

            // assert
            ApprovedContractAllocation addedAllocation = addedApprovedContract.ApprovedContractAllocations.Single();

            Assert.IsNotNull(addedAllocation.PlannedValueEnvelope1, "Envelope 1 was not set");
            Assert.IsNotNull(addedAllocation.PlannedValueEnvelope2, "Envelope 2 was not set");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ApprovedContractPopulateCacheService_AddApprovedContract_ShouldNotPopulateFinancialEnvelopesWhenIncludeAllContractsOnSummaryOfFundingIsFalse()
        {
            ApprovedContract addedApprovedContract = null;

            // arrange
            Mock<IApprovedContractRepository> approvedContractRepositoryMock = new Mock<IApprovedContractRepository>();
            approvedContractRepositoryMock
                .Setup(m => m.Add(It.IsAny<ApprovedContract>(), It.IsAny<ConnectionInfo>()))
                .Callback((ApprovedContract ac, ConnectionInfo ci) => { addedApprovedContract = ac; })
                .Returns(Task.CompletedTask);
            approvedContractRepositoryMock
                .Setup(m => m.GetLegalDeliverableCodesForFsp(It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(new List<int>{1});

            Mock<IFundingTypeFundingPeriodRepository> fundingTypeFundingPeriodQueryRepositoryMock = new Mock<IFundingTypeFundingPeriodRepository>();
            fundingTypeFundingPeriodQueryRepositoryMock
                .Setup(m => m.Get(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(new FundingTypeFundingPeriod { IncludeAllContractsOnSummaryOfFunding = false });

            ApprovedContractPopulateCacheService approvedContractPopulateCacheService = new ApprovedContractPopulateCacheService(
                approvedContractRepositoryMock.Object,
                fundingTypeFundingPeriodQueryRepositoryMock.Object);

            Contract masterContract = new Contract
            {
                contracts = new List<contractType>
                {
                    new Contract
                    {
                        startDate = DateTime.Now.AddDays(7).Date,
                        endDate = DateTime.Now.AddYears(1).Date,
                        contractAllocations = new List<contractAllocationsContractAllocation>
                        {
                            new contractAllocationsContractAllocation
                            {
                                contractDeliverables = new List<contractDeliverablesTypeContractDeliverable>
                                {
                                    new contractDeliverablesTypeContractDeliverable
                                    {
                                        contractDeliverablePeriods = new List<contractDeliverablePeriodsTypeContractDeliverablePeriod>
                                        {
                                            new contractDeliverablePeriodsTypeContractDeliverablePeriod { period = 8, year = 2018, plannedValue = 100m },
                                            new contractDeliverablePeriodsTypeContractDeliverablePeriod { period = 4, year = 2019, plannedValue = 200m }
                                        },
                                        deliverable = new deliverableType
                                        {
                                            deliverableCode = 1
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            };

            // act
            approvedContractPopulateCacheService.UpdateApprovedContractCache(masterContract, "MAIN-1234", ConnectionInfo.CreateDefault()).Wait();

            // assert
            ApprovedContractAllocation addedAllocation = addedApprovedContract.ApprovedContractAllocations.Single();

            Assert.IsNull(addedAllocation.PlannedValueEnvelope1, "Envelope 1 was set unexpectedly");
            Assert.IsNull(addedAllocation.PlannedValueEnvelope2, "Envelope 2 was set unexpectedly");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ApprovedContractPopulateCacheService_AddApprovedContract_ShouldPopulateFinancialEnvelopesWhenLotsOfPostYearEndPeriods()
        {
            ApprovedContract addedApprovedContract = null;

            // arrange
            const decimal plannedValueEnvelope1 = 100m;
            const decimal plannedValueEnvelope2 = 200m;
            Mock<IApprovedContractRepository> approvedContractRepositoryMock = new Mock<IApprovedContractRepository>();
            approvedContractRepositoryMock
                .Setup(m => m.Add(It.IsAny<ApprovedContract>(), It.IsAny<ConnectionInfo>()))
                .Callback((ApprovedContract ac, ConnectionInfo ci) => { addedApprovedContract = ac; })
                .Returns(Task.CompletedTask);
            approvedContractRepositoryMock
                .Setup(m => m.GetLegalDeliverableCodesForFsp(It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(new List<int> { 1 });

            Mock<IFundingTypeFundingPeriodRepository> fundingTypeFundingPeriodQueryRepositoryMock = new Mock<IFundingTypeFundingPeriodRepository>();
            fundingTypeFundingPeriodQueryRepositoryMock
                .Setup(m => m.Get(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(new FundingTypeFundingPeriod { IncludeAllContractsOnSummaryOfFunding = true });

            ApprovedContractPopulateCacheService approvedContractPopulateCacheService = new ApprovedContractPopulateCacheService(
                approvedContractRepositoryMock.Object,
                fundingTypeFundingPeriodQueryRepositoryMock.Object);

            Contract masterContract = new Contract
            {
                contracts = new List<contractType>
                {
                    new Contract
                    {
                        startDate = DateTime.Now.AddDays(7).Date,
                        endDate = DateTime.Now.AddYears(1).Date,
                        contractAllocations = new List<contractAllocationsContractAllocation>
                        {
                            new contractAllocationsContractAllocation
                            {
                                contractDeliverables = new List<contractDeliverablesTypeContractDeliverable>
                                {
                                    new contractDeliverablesTypeContractDeliverable
                                    {
                                        contractDeliverablePeriods = new List<contractDeliverablePeriodsTypeContractDeliverablePeriod>
                                        {
                                            new contractDeliverablePeriodsTypeContractDeliverablePeriod { period = 8, year = 2018, plannedValue = plannedValueEnvelope1 },
                                            new contractDeliverablePeriodsTypeContractDeliverablePeriod { period = 4, year = 2019, plannedValue = plannedValueEnvelope2},
                                            new contractDeliverablePeriodsTypeContractDeliverablePeriod { period = 8, year = 2020, plannedValue = 0 }
                                        },
                                        deliverable = new deliverableType
                                        {
                                            deliverableCode = 1
                                        }
                                    }
                                },
                                startDate = new DateTime(2018, 8, 1),
                                endDate = new DateTime(2019, 7, 31)
                            }
                        }
                    }
                }
            };

            // act
            approvedContractPopulateCacheService.UpdateApprovedContractCache(masterContract, "MAIN-1234", ConnectionInfo.CreateDefault()).Wait();

            // assert
            ApprovedContractAllocation addedAllocation = addedApprovedContract.ApprovedContractAllocations.Single();

            addedAllocation.PlannedValueEnvelope1.Should().Be(plannedValueEnvelope1);
            addedAllocation.PlannedValueEnvelope2.Should().Be(plannedValueEnvelope2);
        }

        private static void ClearDownFundingTypeFundingPeriod(string fundingType, string fundingPeriod)
        {
            using (ContractManagementDbContext dbContext = new ContractManagementDbContext())
            {
                dbContext.FundingTypeFundingPeriodItems
                    .Where(ftfp => ftfp.FundingTypeCode == fundingType && ftfp.FundingPeriodName == fundingPeriod)
                    .ToList()
                    .ForEach(ftfp => dbContext.FundingTypeFundingPeriodItems.Remove(ftfp));

                dbContext.SaveChanges();
            }
        }

        private static void CreateFundingTypeFundingPeriod(string fundingType, string fundingPeriod, bool includeAllContractsOnSummaryOfFunding = false)
        {
            using (ContractManagementDbContext dbContext = new ContractManagementDbContext())
            {
                dbContext.FundingTypeFundingPeriodItems.Add(new FundingTypeFundingPeriod
                {
                    FundingTypeCode = fundingType,
                    FundingPeriodName = fundingPeriod,
                    IncludeAllContractsOnSummaryOfFunding = includeAllContractsOnSummaryOfFunding
                });

                dbContext.SaveChanges();
            }
        }
    }
}
