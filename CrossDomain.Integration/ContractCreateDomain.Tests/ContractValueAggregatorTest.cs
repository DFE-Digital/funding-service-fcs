namespace ContractCreateDomain.Tests
{
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractCreateDomain.BusinessLogic;
    using ContractRequest = SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
    using CorporateContract = SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;

    [TestClass]
    public class ContractValueAggregatorTest : TestBase
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ShouldAggregateContractAllocationsOntoContract()
        {
            IContractValueAggregator aggregator = Container.Resolve<IContractValueAggregator>();
            var corpContract = CreateExtendedCorpContract();
            aggregator.Aggregate(corpContract);
            Assert.IsTrue(corpContract.contracts[0].contractValue == corpContract.contracts[0].contractAllocations.Sum(ca => ca.maximumContractValue));   
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ShouldAggregatedDeliverablessOntoContractAllocations()
        {
            IContractValueAggregator aggregator = Container.Resolve<IContractValueAggregator>();
            var corpContract = CreateExtendedCorpContract();
            aggregator.Aggregate(corpContract);
            foreach (var contractAllocation in corpContract.contracts[0].contractAllocations)
            {
                decimal summedValue = 0;
                foreach (var deliverable in contractAllocation.contractDeliverables)
                {
                    summedValue += deliverable.contractDeliverablePeriods.Sum(dp => GetDeliverablePeriodValue(dp));
                }

                Assert.IsTrue(summedValue == contractAllocation.maximumContractValue);    
            }
           
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ShouldAggregateContractTypeValuesOntoContractAndAllocations()
        {
            var masterContract = new CorporateContract.contractType
            {
                contracts = new List<CorporateContract.contractType> { CreateSubContractType() }
            };

            new ContractValueAggregator().Aggregate(masterContract);

            Assert.AreEqual(100, masterContract.contracts[0].contractAllocations[0].maximumContractValue);
            Assert.AreEqual(300, masterContract.contracts[0].contractValue);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ShouldUpdateValueVarianceOnContract()
        {
            const int testUkprn = 111;
            const string fundingStreamPeriodCode = "XX";
            const string contractNumber = "10";
            int i = 0;
            // arrange
            IContractValueAggregator aggregator = Container.Resolve<IContractValueAggregator>();
            CorporateContract.ExtendedContractType extendedCorpContract = CreateExtendedCorpContract();
            ContractRequest.contractType contractRequestContract = CreateContractRequestContract();

            extendedCorpContract.contracts[0].contractValue = 10;
            extendedCorpContract.contracts[0].contractNumber = contractNumber;
            // give the contracts matching ukprns
            contractRequestContract.contracts.ForEach(c => c.contractor = new ContractRequest.contractor
            {
                ukprn = testUkprn + i++
                
            });
            contractRequestContract.contracts[0].contractNumber = contractNumber;

            i = 0;
            extendedCorpContract.contracts.ForEach(c => c.contractor = new CorporateContract.contractor
            {
                ukprn = testUkprn + i++
            });

            extendedCorpContract.contracts.ForEach(c => c.contractAllocations.ForEach(ca => ca.maximumContractValue = 2));

            i = 0;
            // give each allocation on the contract request a value and a funding stream periode code
            contractRequestContract.contracts.ForEach(
                c => c.contractAllocations.ForEach(ca =>
                {
                    ca.maximumContractValue = 1;
                    ca.fundingStreamPeriodCode = fundingStreamPeriodCode + i++;
                }));
           
            i = 0;
            extendedCorpContract.contracts.ForEach(
                c => c.contractAllocations.ForEach(ca => ca.fundingStreamPeriodCode = fundingStreamPeriodCode + i++));

            // act
            aggregator.UpdateValueVariance(extendedCorpContract, contractRequestContract);

            // assert
            Assert.IsTrue(extendedCorpContract.contracts[0].ValueVariation == 7);
            Assert.IsTrue(extendedCorpContract.contracts[0].contractAllocations[0].ValueVariation == 1);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ShouldMatchAllocationValueVarianceByAllocationNumberWhenNumbersAreAvailable()
        {
            var extendedContract = new CorporateContract.ExtendedContractType
            {
                contracts = new List<CorporateContract.ExtendedContractType>
                {
                    new CorporateContract.ExtendedContractType
                    {
                        contractNumber = "CONTRACT-1",
                        contractAllocations = new List<CorporateContract.ExtendedContractAllocation>
                        {
                            new CorporateContract.ExtendedContractAllocation
                            {
                                contractAllocationNumber = "ALLOCATION-2",
                                maximumContractValue = 25
                            },
                            new CorporateContract.ExtendedContractAllocation
                            {
                                contractAllocationNumber = "ALLOCATION-1",
                                maximumContractValue = 15
                            }
                        },
                        contractValue = 40
                    }
                }
            };
            var existingContract = new ContractRequest.contractType
            {
                contracts = new List<ContractRequest.contractType>
                {
                    new ContractRequest.contractType
                    {
                        contractNumber = "CONTRACT-1",
                        contractAllocations = new List<ContractRequest.contractAllocation>
                        {
                            new ContractRequest.contractAllocation
                            {
                                contractAllocationNumber = "ALLOCATION-1",
                                maximumContractValue = 10
                            },
                            new ContractRequest.contractAllocation
                            {
                                contractAllocationNumber = "ALLOCATION-2",
                                maximumContractValue = 20
                            }
                        }
                    }
                }
            };

            new ContractValueAggregator().UpdateValueVariance(extendedContract, existingContract);

            Assert.AreEqual(10, extendedContract.contracts[0].ValueVariation);
            Assert.AreEqual(5, extendedContract.contracts[0].contractAllocations[0].ValueVariation);
            Assert.AreEqual(5, extendedContract.contracts[0].contractAllocations[1].ValueVariation);
        }

        private decimal GetDeliverablePeriodValue(CorporateContract.contractDeliverablePeriodsTypeContractDeliverablePeriod deliverablePeriod)
        {
            if (deliverablePeriod.plannedValue != 0)
            {
                return deliverablePeriod.plannedValue;
            }
            else
            {
                return deliverablePeriod.plannedVolume * deliverablePeriod.unitCost;
            }
        }

        private CorporateContract.ExtendedContractType CreateExtendedCorpContract()
        {
            var contract = new CorporateContract.ExtendedContractType();
            contract.contracts = new List<CorporateContract.ExtendedContractType>();
            contract.contracts.Add(CreateExtendedSubContractType());
            return contract;
        }

        private ContractRequest.contractType CreateContractRequestContract()
        {
            ContractRequest.contractType contract = new ContractRequest.contractType();
            contract.contracts = new List<ContractRequest.contractType>();
            contract.contracts.Add(CreateSubContractRequestType());
            return contract;
        }

        private ContractRequest.contractType CreateSubContractRequestType()
        {
            ContractRequest.contractType contract = new ContractRequest.contractType
            {
                contractAllocations = new List<ContractRequest.contractAllocation>()
            };

            contract.contractAllocations.Add(CreateContractRequestAllocation());
            contract.contractAllocations.Add(CreateContractRequestAllocation());
            contract.contractAllocations.Add(CreateContractRequestAllocation());

            return contract;
        }

        private ContractRequest.contractAllocation CreateContractRequestAllocation()
        {
            ContractRequest.contractAllocation allocation = new ContractRequest.contractAllocation
            {
                contractDeliverables = new List<ContractRequest.contractDeliverable>()
            };
            allocation.contractDeliverables.Add(new ContractRequest.contractDeliverable
            {
                plannedValue = 1
            });
            allocation.contractDeliverables.Add(new ContractRequest.contractDeliverable
            {
                plannedValue = 1
            });

            return allocation;
        }

        private CorporateContract.ExtendedContractType CreateExtendedSubContractType()
        {
            CorporateContract.ExtendedContractType contract = new CorporateContract.ExtendedContractType
            {
                contractAllocations = new List<CorporateContract.ExtendedContractAllocation>()
            };

            contract.contractAllocations.Add(new CorporateContract.ExtendedContractAllocation());
            contract.contractAllocations.Add(new CorporateContract.ExtendedContractAllocation());
            contract.contractAllocations.Add(new CorporateContract.ExtendedContractAllocation());

            return contract;
        }

        private CorporateContract.contractType CreateSubContractType()
        {
            CorporateContract.contractType contract = new CorporateContract.contractType
            {
                contractAllocations = new List<CorporateContract.contractAllocationsContractAllocation>()
            };

            contract.contractAllocations.Add(CreateContractAllocation());
            contract.contractAllocations.Add(CreateContractAllocation());
            contract.contractAllocations.Add(CreateContractAllocation());

            return contract;
        }

        private CorporateContract.contractAllocationsContractAllocation CreateContractAllocation()
        {
            CorporateContract.contractAllocationsContractAllocation contractAllocation = new CorporateContract.contractAllocationsContractAllocation();

            contractAllocation.contractDeliverables =
                new List<CorporateContract.contractDeliverablesTypeContractDeliverable>();

            contractAllocation.contractDeliverables.Add(CreateDeliverableWithValue());
            contractAllocation.contractDeliverables.Add(CreateDeliverableWithVolume());
            return contractAllocation;
        }

        private CorporateContract.contractDeliverablesTypeContractDeliverable CreateDeliverableWithValue()
        {
            CorporateContract.contractDeliverablesTypeContractDeliverable deliverable = new CorporateContract.
                contractDeliverablesTypeContractDeliverable
            {
                contractDeliverablePeriods =
                    new List<CorporateContract.contractDeliverablePeriodsTypeContractDeliverablePeriod>()
            };

            deliverable.contractDeliverablePeriods.Add(new CorporateContract.contractDeliverablePeriodsTypeContractDeliverablePeriod
            {
                plannedValue = 100
            });

            return deliverable;
        }

        private CorporateContract.contractDeliverablesTypeContractDeliverable CreateDeliverableWithVolume()
        {
            CorporateContract.contractDeliverablesTypeContractDeliverable deliverable = new CorporateContract.
                contractDeliverablesTypeContractDeliverable
            {
                contractDeliverablePeriods =
                    new List<CorporateContract.contractDeliverablePeriodsTypeContractDeliverablePeriod>()
            };

            deliverable.contractDeliverablePeriods.Add(new CorporateContract.contractDeliverablePeriodsTypeContractDeliverablePeriod
            {
                plannedVolume = 10,
                unitCost = 10
            });

            return deliverable;
        }
    }
}
