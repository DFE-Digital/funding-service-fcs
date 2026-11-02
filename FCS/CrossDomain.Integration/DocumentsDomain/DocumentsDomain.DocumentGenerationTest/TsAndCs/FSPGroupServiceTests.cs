namespace SFA.FCT.DocumentsDomain.DocumentGeneration.Tests.TsAndCs
{
    using System;
    using System.Collections.Generic;
    using CrossDomain.Integration.Entities.CorporateContract;
    using DataStore.Models;
    using DataStore.Repositories;
    using DocumentDefiner.DocumentPartCreators.TsAndCs;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;

    [TestClass]
    public class FSPGroupServiceTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void FSPGroupService_GetFspGroupsNewToTheContract_ShouldReturnAnEmptyList_WhenThereAreNotGroupsWithAllAddedAllocations()
        {
            // arrange
            contractType contract = new contractType
            {
                contractAllocations = new List<contractAllocationsContractAllocation>
                {
                    new contractAllocationsContractAllocation
                    {
                        fundingStreamPeriodCode = "FSP1",
                        HasBeenAdded = true
                    },
                    new contractAllocationsContractAllocation
                    {
                        fundingStreamPeriodCode = "FSP1",
                        HasBeenAdded = false
                    }
                }
            };
            Mock<IFundingStreamPeriodRepository> fundingStreamPeriodRepositoryMock = new Mock<IFundingStreamPeriodRepository>();
            fundingStreamPeriodRepositoryMock.Setup(r => r.GetFspsWithGroups(It.IsAny<IEnumerable<string>>())).Returns(
                new List<FundingStreamPeriod>
                {
                    new FundingStreamPeriod(
                        "FSP1",
                        string.Empty,
                        1,
                        false,
                        false,
                        string.Empty,
                        string.Empty,
                        "FSPG1",
                        string.Empty
                    )
                    {
                        FspGroup = new FSPGroup("FSPG1", string.Empty, 1)
                    }
                });

            // act
            IReadOnlyCollection<FSPGroup> fspGroups =
                FSPGroupService.GetFspGroupsNewToTheContract(contract, fundingStreamPeriodRepositoryMock.Object);

            // assert
            Assert.AreEqual(0, fspGroups.Count);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FSPGroupService_GetFspGroupsNewToTheContract_ShouldReturnPopulatedList_WhenThereIsAGroupsWithAllAddedAllocations()
        {
            // arrange
            contractType contract = new contractType
            {
                contractAllocations = new List<contractAllocationsContractAllocation>
                {
                    new contractAllocationsContractAllocation
                    {
                        fundingStreamPeriodCode = "FSP1",
                        HasBeenAdded = true
                    },
                    new contractAllocationsContractAllocation
                    {
                        fundingStreamPeriodCode = "FSP1",
                        HasBeenAdded = true
                    },
                    new contractAllocationsContractAllocation
                    {
                        fundingStreamPeriodCode = "FSP2",
                        HasBeenAdded = true
                    },
                    new contractAllocationsContractAllocation
                    {
                        fundingStreamPeriodCode = "FSP2",
                        HasBeenAdded = false
                    }
                }
            };
            Mock<IFundingStreamPeriodRepository> fundingStreamPeriodRepositoryMock = new Mock<IFundingStreamPeriodRepository>();
            fundingStreamPeriodRepositoryMock.Setup(r => r.GetFspsWithGroups(It.IsAny<IEnumerable<string>>())).Returns(
                new List<FundingStreamPeriod>
                {
                    new FundingStreamPeriod(
                        "FSP1",
                        string.Empty,
                        1,
                        false,
                        false,
                        string.Empty,
                        string.Empty,
                        "FSPG1",
                        String.Empty
                    )
                    {
                        FspGroup = new FSPGroup("FSPG1", string.Empty, 1)
                    },
                    new FundingStreamPeriod(
                        "FSP2",
                        string.Empty,
                        1,
                        false,
                        false,
                        string.Empty,
                        string.Empty,
                        "FSPG2",
                        String.Empty
                    )
                    {
                        FspGroup = new FSPGroup("FSPG2", string.Empty, 1)
                    }
                });

            // act
            IReadOnlyCollection<FSPGroup> fspGroups =
                FSPGroupService.GetFspGroupsNewToTheContract(contract, fundingStreamPeriodRepositoryMock.Object);

            // assert
            Assert.AreEqual(1, fspGroups.Count);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FSPGroupService_GetFspGroupsNewToTheContract_ShouldReturnPopulatedList_WhenThereIs2GroupsWithAllAddedAllocations()
        {
            contractType contract = new contractType
            {
                contractAllocations = new List<contractAllocationsContractAllocation>
                {
                    new contractAllocationsContractAllocation
                    {
                        fundingStreamPeriodCode = "FSP1",
                        HasBeenAdded = true
                    },
                    new contractAllocationsContractAllocation
                    {
                        fundingStreamPeriodCode = "FSP1",
                        HasBeenAdded = true
                    },
                    new contractAllocationsContractAllocation
                    {
                        fundingStreamPeriodCode = "FSP2",
                        HasBeenAdded = true
                    },
                    new contractAllocationsContractAllocation
                    {
                        fundingStreamPeriodCode = "FSP2",
                        HasBeenAdded = true
                    }
                }
            };
            Mock<IFundingStreamPeriodRepository> fundingStreamPeriodRepositoryMock = new Mock<IFundingStreamPeriodRepository>();
            fundingStreamPeriodRepositoryMock.Setup(r => r.GetFspsWithGroups(It.IsAny<IEnumerable<string>>())).Returns(
                new List<FundingStreamPeriod>
                {
                    new FundingStreamPeriod(
                        "FSP1",
                        string.Empty,
                        1,
                        false,
                        false,
                        string.Empty,
                        string.Empty,
                        "FSPG1",
                        String.Empty
                    )
                    {
                        FspGroup = new FSPGroup("FSPG1", string.Empty, 1)
                    },
                    new FundingStreamPeriod(
                        "FSP2",
                        string.Empty,
                        1,
                        false,
                        false,
                        string.Empty,
                        string.Empty,
                        "FSPG2",
                        String.Empty
                    )
                    {
                        FspGroup = new FSPGroup("FSPG2", string.Empty, 1)
                    }
                });

            // act
            IReadOnlyCollection<FSPGroup> fspGroups =
                FSPGroupService.GetFspGroupsNewToTheContract(contract, fundingStreamPeriodRepositoryMock.Object);

            // assert
            Assert.AreEqual(2, fspGroups.Count);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FSPGroupService_GetFspGroupsNewToTheContract_ShouldReturnOneFspGroupPopulatedList_WhenAllFspsHaveTheSameGroup()
        {
            contractType contract = new contractType
            {
                contractAllocations = new List<contractAllocationsContractAllocation>
                {
                    new contractAllocationsContractAllocation
                    {
                        fundingStreamPeriodCode = "FSP1",
                        HasBeenAdded = true
                    },
                    new contractAllocationsContractAllocation
                    {
                        fundingStreamPeriodCode = "FSP1",
                        HasBeenAdded = true
                    },
                    new contractAllocationsContractAllocation
                    {
                        fundingStreamPeriodCode = "FSP2",
                        HasBeenAdded = true
                    },
                    new contractAllocationsContractAllocation
                    {
                        fundingStreamPeriodCode = "FSP2",
                        HasBeenAdded = true
                    }
                }
            };
            Mock<IFundingStreamPeriodRepository> fundingStreamPeriodRepositoryMock = new Mock<IFundingStreamPeriodRepository>();
            fundingStreamPeriodRepositoryMock.Setup(r => r.GetFspsWithGroups(It.IsAny<IEnumerable<string>>())).Returns(
                new List<FundingStreamPeriod>
                {
                    new FundingStreamPeriod(
                        "FSP1",
                        string.Empty,
                        1,
                        false,
                        false,
                        string.Empty,
                        string.Empty,
                        "FSPG1",
                        ""
                    )
                    {
                        FspGroup = new FSPGroup("FSPG1", string.Empty, 1)
                    },
                    new FundingStreamPeriod(
                        "FSP2",
                        string.Empty,
                        1,
                        false,
                        false,
                        string.Empty,
                        string.Empty,
                        "FSPG1",
                        ""
                    )
                    {
                        FspGroup = new FSPGroup("FSPG1", string.Empty, 1)
                    }
                });

            // act
            IReadOnlyCollection<FSPGroup> fspGroups =
                FSPGroupService.GetFspGroupsNewToTheContract(contract, fundingStreamPeriodRepositoryMock.Object);

            // assert
            Assert.AreEqual(1, fspGroups.Count, "The number of FSP Groups is incorrect");
        }
    }
}
