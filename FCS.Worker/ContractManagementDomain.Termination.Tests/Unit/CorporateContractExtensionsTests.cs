namespace ContractManagementDomain.Termination.Tests.Unit
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using ContractManagementDomain.Termination.Extensions;
    using FluentAssertions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;

    [TestClass]
    public class CorporateContractExtensionsTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void CorporateContractExtensions_RemoveTerminationInformation_ShouldRemoveTerminationInformation()
        {
            // arrange
            Contract corporateContract = new Contract
            {
                contracts = new List<contractType>
                {
                    new Contract
                    {
                        TerminationDate = DateTime.Now,
                        TerminationReason = "Some reason",
                        contractAllocations = new List<contractAllocationsContractAllocation>
                        {
                            new contractAllocationsContractAllocation
                            {
                                FundingCessationDate = DateTime.Now,
                                StopNewStartsDate = DateTime.Now
                            }
                        }
                    }
                }
            };

            // act
            corporateContract.RemoveTerminationInformation();

            // assert
            Assert.IsFalse(corporateContract.contracts.Any(c => c.TerminationDate != null), "The TerminationDate has not been reset");
            Assert.IsFalse(corporateContract.contracts.Any(c => c.TerminationReason != null), "The TerminationReason has not been reset");
            Assert.IsFalse(corporateContract.contracts.SelectMany(c => c.contractAllocations).Any(a => a.FundingCessationDate != null), "The TerminationDate on the allocation has not been reset");
            Assert.IsFalse(corporateContract.contracts.SelectMany(c => c.contractAllocations).Any(a => a.StopNewStartsDate != null), "The StopNewStartsDate on the allocation has not been reset");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CorporateContractExtensions_SetContractSubStatus_ShouldSetContractSubStatus()
        {
            // arrange
            Contract corporateContract = new Contract
            {
                contracts = new List<contractType>
                {
                    new Contract
                    {
                        contractStatus = new contractStatusType
                        {
                            status = "Approved"
                        }
                    },
                    new Contract

                    {
                        contractStatus = new contractStatusType
                        {
                            status = "Awaiting Documentation"
                        }
                    }
                },
                contractStatus = new contractStatusType
                {
                    status = "Draft"
                }
            };

            // act
            corporateContract.SetChildContractsSubStatus(newStatus: "Under Termination");

            // assert
            Assert.IsTrue(corporateContract.contracts.All(c => c.contractStatus.status == "Under Termination"), "The contract substatus was not updated correctly");
            Assert.IsTrue(corporateContract.contractStatus.status == "Draft", "The master contract substatus was incorrectly updated");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CorporateContractExtensions_SetContractSubStatus_ShouldSetAllNullEndDatesToNotNullAndNotAffectNonNullEndDates()
        {
            DateTime alreadySetDateTime = new DateTime(2018, 1, 1);
            DateTime dateTimeToSet = new DateTime(2017, 2, 1);

            Contract corporateContract = new Contract
            {
                contracts = new List<contractType>
                {
                    new Contract()
                    {
                        endDate = alreadySetDateTime,
                        contractAllocations = new List<contractAllocationsContractAllocation>
                        {
                            new contractAllocationsContractAllocation(),
                            new contractAllocationsContractAllocation()
                        }
                    },
                    new Contract()
                    {
                        contractAllocations = new List<contractAllocationsContractAllocation>()
                        {
                            new contractAllocationsContractAllocation()
                            {
                                endDate = alreadySetDateTime
                            },
                            new contractAllocationsContractAllocation()
                        }
                    }
                }
            };

            corporateContract.SetEndDatesIfEndDatesAreNull(dateTimeToSet);

            Assert.IsTrue(corporateContract.contracts.All(c => c.endDate.HasValue), "Not all contract end dates were set");
            Assert.IsTrue(corporateContract.contracts.SelectMany(c => c.contractAllocations).All(a => a.endDate.HasValue), 
                "Not all contract allocation end dates were set");

            Assert.AreEqual(1, corporateContract.contracts.Count(c => c.endDate == alreadySetDateTime), "incorrect count of unaffected contract end dates");
            Assert.AreEqual(1, corporateContract.contracts.Count(c => c.endDate == dateTimeToSet), "incorrect count of contract end dates that have been set");

            Assert.AreEqual(1, corporateContract.contracts.SelectMany(c => c.contractAllocations).Count(a => a.endDate == alreadySetDateTime),
                "incorrect count of unaffected contract allocation end dates");
            Assert.AreEqual(3, corporateContract.contracts.SelectMany(c => c.contractAllocations).Count(a => a.endDate == dateTimeToSet),
                "incorrect count of contract allocation end dates that have been set");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CorporateContractExtensions_ClearAllocationModificationValues_ShouldClearModificationValuesFromAllocations()
        {
            // arrange
            Contract corporateContract = new Contract   
            {
                contracts = new List<contractType>
                {
                    new Contract
                    {
                        contractAllocations = new List<contractAllocationsContractAllocation>
                        {
                            new contractAllocationsContractAllocation
                            {
                                StopNewStartsDate = DateTime.UtcNow,
                                NewStartsSuspendedReason = "Inadequate Financial Health",
                                InflightStopNewStartsDate = DateTime.UtcNow,
                                InflightNewStartsSuspendedReason = "Inadequate Financial Health"
                            },
                            new contractAllocationsContractAllocation
                            {
                                StopNewStartsDate = DateTime.UtcNow,
                                NewStartsSuspendedReason = "Inadequate Financial Health",
                                InflightStopNewStartsDate = DateTime.UtcNow,
                                InflightNewStartsSuspendedReason = "Inadequate Financial Health"
                            }
                        }
                    },
                    new Contract
                    {
                        contractAllocations = new List<contractAllocationsContractAllocation>
                        {
                            new contractAllocationsContractAllocation
                            {
                                StopNewStartsDate = DateTime.UtcNow,
                                NewStartsSuspendedReason = "Inadequate Financial Health",
                                InflightStopNewStartsDate = DateTime.UtcNow,
                                InflightNewStartsSuspendedReason = "Inadequate Financial Health"
                            },
                            new contractAllocationsContractAllocation
                            {
                                StopNewStartsDate = DateTime.UtcNow,
                                NewStartsSuspendedReason = "Inadequate Financial Health",
                                InflightStopNewStartsDate = DateTime.UtcNow,
                                InflightNewStartsSuspendedReason = "Inadequate Financial Health"
                            }
                        }
                    },
                }
            };

            // act
            corporateContract.ClearAllocationModificationValues();

            // assert
            corporateContract.contracts.ForEach(c => c.contractAllocations.ForEach(ca =>
            {
                ca.StopNewStartsDate.Should().BeNull("Allocation StopNewStartsDate should be cleared");
                ca.NewStartsSuspendedReason.Should().BeNull("Allocation NewStartsSuspendedReason should be cleared");
                ca.InflightStopNewStartsDate.Should().BeNull("Allocation InflightStopNewStartsDate should be cleared");
                ca.InflightNewStartsSuspendedReason.Should().BeNull("Allocation InflightNewStartsSuspendedReason should be cleared");
            }));
        }
    }
}
