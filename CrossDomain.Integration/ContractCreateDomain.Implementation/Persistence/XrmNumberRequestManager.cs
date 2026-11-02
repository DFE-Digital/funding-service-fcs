namespace SFA.FCT.ContractCreateDomain.Implementation.Persistence
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Entities;
    using CrossDomain.Integration.Entities.ContractRequest;
    using CrossDomain.Integration.Entities.Data;
    using Repositories;
    using SFA.FCT.ContractCreateDomain.Implementation.Extensions;

    public class XrmNumberRequestManager : INumberRequestManager
    {
        private readonly INumberPrefixRepository _numberPrefixRepository;
        private readonly ISequenceRepository _sequenceRepository;

        public XrmNumberRequestManager(
            INumberPrefixRepository numberPrefixRepository,
            ISequenceRepository sequenceRepository)
        {
            _numberPrefixRepository = numberPrefixRepository;
            _sequenceRepository = sequenceRepository;
        }

        public contractRequestType GetContractNumbers(contractRequestType numberRequest, ConnectionInfo connectionInfo)
        {
            List<NumberRequest> numberRequestsList = GetNumberRequests(numberRequest);

            numberRequestsList = GetContractNumbers(numberRequestsList, connectionInfo);

            PopulateContractNumbers(numberRequest, numberRequestsList);

            return numberRequest;
        }

        public void PopulateContractAllocationNumbers(contractRequestType contractRequest, ConnectionInfo connectionInfo)
        {
            List<NumberRequest> numberRequestsList = GetNumberRequestsForAllocations(contractRequest);

            numberRequestsList = GetContractNumbers(numberRequestsList, connectionInfo);

            contractRequest.contract.contracts.ForEach((contract) =>
            {
                PopulateAllocationNumbers(contract, numberRequestsList);
            });
        }

        public List<NumberRequest> GetContractNumbers(List<NumberRequest> list, ConnectionInfo connectionInfo)
        {
            foreach (NumberRequest numberRequest in list)
            {
                CrmSetContractNumber(numberRequest, connectionInfo);
            }

            return list;
        }

        public List<NumberRequest> GetNumberRequests(contractRequestType requestData)
        {
            // Add Master Contract to list. 
            List<NumberRequest> numberRequestsList = new List<NumberRequest>();

            if (requestData.contract.contractNumber.IsNullOrEmpty())
            {
                numberRequestsList.Add(new MasterContractNumberRequest(requestData.contract.hierarchyType.ToString(), requestData.contract.fundingTypeCode));
            }

            // Populate the numberRequestList with values for each Contract and its allocations.
            foreach (contractType contract in requestData.contract.contracts)
            {
                if (contract.contractNumber.IsNullOrEmpty())
                {
                    numberRequestsList.Add(new ContractNumberRequest(contract.hierarchyType.ToString(), contract.fundingTypeCode));
                }

                // Add allocations details.
                if (contract.contractAllocations != null)
                {
                    foreach (contractAllocation allocation in contract.contractAllocations.Where(a => a.contractAllocationNumber.IsNullOrEmpty()))
                    {
                        periodType period;
                        if (allocation.period != null)
                        {
                            period = allocation.period;
                        }
                        else
                        {
                            period = contract.period;
                        }

                        numberRequestsList.Add(new AllocationNumberRequest(
                            allocation.hierarchyType.ToString(),
                            contract.fundingTypeCode,
                            allocation.fundingStreamCode,
                            period.period,
                            period.periodType1.periodTypeCode,
                            allocation.fundingStreamPeriodCode));
                    }
                }
            }

            return numberRequestsList;
        }

        public List<NumberRequest> GetNumberRequestsForAllocations(contractRequestType requestData)
        {
            // Add Master Contract to list. 
            List<NumberRequest> numberRequestsList = new List<NumberRequest>();

            // Populate the numberRequestList with values for each Contract and its allocations.
            foreach (contractType contract in requestData.contract.contracts)
            {
                // Add allocations details.
                if (contract.contractAllocations != null)
                {
                    foreach (contractAllocation allocation in contract.contractAllocations.Where(a => a.contractAllocationNumber.IsNullOrEmpty()))
                    {
                        periodType period;
                        if (allocation.period != null)
                        {
                            period = allocation.period;
                        }
                        else
                        {
                            period = contract.period;
                        }

                        numberRequestsList.Add(new AllocationNumberRequest(
                            allocation.hierarchyType.ToString(),
                            contract.fundingTypeCode,
                            allocation.fundingStreamCode,
                            period.period,
                            period.periodType1.periodTypeCode,
                            allocation.fundingStreamPeriodCode));
                    }
                }
            }

            return numberRequestsList;
        }

        public void PopulateContractNumbers(contractRequestType contracts, List<NumberRequest> contractNumbers)
        {
            // Populate Master Contract Number.
            if (contracts.contract.contractNumber.IsNullOrEmpty())
            {
                int masterIndex = contractNumbers.FindIndex(c => c.ContractType == contracts.contract.hierarchyType.ToString());
                contracts.contract.contractNumber = contractNumbers[masterIndex].ContractNumber;
                contractNumbers.RemoveAt(masterIndex);
            }

            // Populate Contract numbers and allocations.
            foreach (contractType contract in contracts.contract.contracts)
            {
                if (contract.contractNumber.IsNullOrEmpty())
                {
                    int index = contractNumbers.FindIndex(c => c.ContractType == contract.hierarchyType.ToString() && c.FundingType == contract.fundingTypeCode);
                    contract.contractNumber = contractNumbers[index].ContractNumber;
                    contractNumbers.RemoveAt(index);
                }

                if (contract.contractAllocations != null)
                {
                    // Repeat for each Allocation.
                    PopulateAllocationNumbers(contract, contractNumbers);
                }
            }
        }

        private static void PopulateAllocationNumbers(contractType contract, List<NumberRequest> contractNumbers)
        {
            foreach (contractAllocation allocation in contract.contractAllocations.Where(a => a.contractAllocationNumber.IsNullOrEmpty()))
            {
                var contractNumber = contractNumbers.OfType<AllocationNumberRequest>()
                    .FirstOrDefault(a => a.ContractType == allocation.hierarchyType.ToString() && a.FundingStreamCode == allocation.fundingStreamCode);

                if (contractNumber != null)
                {
                    allocation.contractAllocationNumber = contractNumber.ContractNumber;
                    contractNumbers.Remove(contractNumber);
                }
            }
        }

        private void CrmSetContractNumber(NumberRequest numberRequest, ConnectionInfo connectionInfo)
        {
            SequenceType sequenceType = numberRequest.GetSequenceType();
            string prefixContext = numberRequest.GetPrefixContext();

            string prefix = null;
            int nextNumber = 0;

            // please forgive me
            switch (sequenceType)
            {
                case SequenceType.Master:
                    prefix = _numberPrefixRepository.GetMasterContractPrefix(prefixContext);
                    nextNumber = _sequenceRepository.GetNextNumber(sequenceType, prefix, connectionInfo).Result;
                    break;

                case SequenceType.Contract:
                    prefix = _numberPrefixRepository.GetContractPrefix(prefixContext);
                    nextNumber = _sequenceRepository.GetNextNumber(sequenceType, prefixContext, connectionInfo).Result;
                    break;

                case SequenceType.Allocation:
                    prefix = _numberPrefixRepository.GetAllocationPrefix(prefixContext);
                    nextNumber = _sequenceRepository.GetNextNumber(sequenceType, ((AllocationNumberRequest)numberRequest).FundingStreamCode, connectionInfo).Result;
                    break;

                case SequenceType.NotSet:
                    throw new InvalidOperationException("SequenceType not set");
            }

            numberRequest.ContractNumber = $"{prefix}-{nextNumber}";
        }
    }
}