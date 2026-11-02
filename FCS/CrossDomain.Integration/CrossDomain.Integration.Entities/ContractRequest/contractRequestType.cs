namespace SFA.FCT.CrossDomain.Integration.Entities.ContractRequest
{
    using System;
    using System.Collections.Generic;
    using System.Diagnostics.CodeAnalysis;
    using System.Linq;
    using System.Xml.Serialization;

    [Serializable]
    [XmlType(Namespace = "contractrequest")]
    [XmlRoot("contractRequest", Namespace = "contractrequest", IsNullable = false)]
    [SuppressMessage("ReSharper", "InconsistentNaming")]
    public class contractRequestType
    {
        private List<errorInfoType> _errorInfo = null;

        public contractRequestType()
        {
            FundingConfiguration = new List<FundingConfigurationDataType>();
            _errorInfo = new List<errorInfoType>();
            contract = new contractType();
            correlationInfo = new correlationInfoType();
        }

        [XmlElement(Order = 0)]
        public correlationInfoType correlationInfo { get; set; }

        [XmlElement(Order = 1)]
        public contractType contract { get; set; }

        [XmlElement("errorInfo", Order = 2)]
        public List<errorInfoType> errorInfo
        {
            get => _errorInfo ?? (_errorInfo = new List<errorInfoType>());
            set => _errorInfo = value;
        }

        [XmlElement("FundingConfiguration", Order = 3)]
        public List<FundingConfigurationDataType> FundingConfiguration { get; set; }

        public errorInfoTypeLevel? DoesContractContainCorrelationId(Guid correlationId)
        {
            if (Guid.Parse(contract.correlationId) == correlationId)
            {
                return errorInfoTypeLevel.MasterContract;
            }

            if (contract.contracts != null)
            {
                foreach (contractType subContract in contract.contracts)
                {
                    if (Guid.Parse(subContract.correlationId) == correlationId)
                    {
                        return errorInfoTypeLevel.Contract;
                    }

                    if (subContract.contractAllocations != null)
                    {
                        foreach (contractAllocation allocation in subContract.contractAllocations)
                        {
                            if (Guid.Parse(allocation.correlationId) == correlationId)
                            {
                                return errorInfoTypeLevel.Allocation;
                            }

                            if (allocation.contractDeliverables != null)
                            {
                                foreach (contractDeliverable deliverable in allocation.contractDeliverables)
                                {
                                    if (Guid.Parse(deliverable.correlationId) == correlationId)
                                    {
                                        return errorInfoTypeLevel.Deliverable;
                                    }

                                    if (deliverable.contractDeliverablePeriods != null)
                                    {
                                        if (deliverable.contractDeliverablePeriods.Any(p => Guid.Parse(p.correlationId) == correlationId))
                                        {
                                            return errorInfoTypeLevel.DeliverablePeriod;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            return null;
        }

        public IEnumerable<contractType> GetAllContracts()
        {
            return (new[] { contract }).Union(GetSubContracts()); 
        }

        public IEnumerable<contractType> GetSubContracts()
        {
            if (contract.contracts != null)
            {
                return contract.contracts;
            }

            return new contractType[0];
        }

        public IEnumerable<contractAllocation> GetAllocations()
        {
            return GetSubContracts().SelectMany(sc => sc.contractAllocations);
        }

        public IEnumerable<contractDeliverable> GetDeliverables()
        {
            return GetAllocations().SelectMany(a => a.contractDeliverables);
        }

        public IEnumerable<contractDeliverablePeriodType> GetDeliverablePeriods()
        {
            return GetDeliverables().SelectMany(d => d.contractDeliverablePeriods);
        }

        public contractType GetSubContract(string correlationId)
        {
            return GetSubContracts().FirstOrDefault(sc => string.Compare(sc.correlationId, correlationId, StringComparison.InvariantCultureIgnoreCase) == 0);
        }

        public contractAllocation GetAllocation(string correlationId)
        {
            return GetAllocations().FirstOrDefault(a => string.Compare(a.correlationId, correlationId, StringComparison.InvariantCultureIgnoreCase) == 0);
        }

        public contractDeliverablePeriodType GetDeliverablePeriod(string correlationId)
        {
            return GetDeliverablePeriods().FirstOrDefault(dp => string.Compare(dp.correlationId, correlationId, StringComparison.InvariantCultureIgnoreCase) == 0);
        }

        public bool HasUnnumberedAllocations()
        {
            return contract?.contracts != null && contract.contracts.Any(c => c.HasUnnumberedAllocations());
        }

        public bool IsLevyContract()
        {
            return contract.IsLevyContract();
        }

        public string GetFundingPeriod()
        {
            periodType period = contract.contracts.FirstOrDefault()?.period;

            if (period != null)
            {
                return $"{period.periodType1.periodTypeCode}{period.period}";
            }

            throw new InvalidOperationException("There is no contract to get the period from");
        }

        public void AddError(errorInfoType error)
        {
            errorInfo.Add(error);
        }

        public bool IsNewRevisedNewOrUpdateDraft()
        {
            return contract.contracts.First().IsNewRevisedNewOrUpdateDraft();
        }

        public bool IsAmendment()
        {
            return contract.contracts.First().IsAmendment();
        }

        public bool IsNewAmendment()
        {
            return contract.contracts.First().IsNewAmendment();
        }
    }
}
