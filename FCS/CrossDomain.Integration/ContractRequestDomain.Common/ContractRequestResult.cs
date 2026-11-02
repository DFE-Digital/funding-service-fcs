namespace SFA.FCT.ContractRequestDomain.Common
{
    using System;
    using System.Linq;
    using System.Collections.Generic;
    using CrossDomain.Integration.Entities.ContractRequest;

    [Serializable]
    public class ContractRequestResult
    {
        public ContractRequestResult(contractRequestType contractRequestType)
        {
            CorrelationId = contractRequestType.correlationInfo.correlationId;

            if (contractRequestType.errorInfo != null && contractRequestType.errorInfo.Count > 0)
            {
                Errors = contractRequestType.errorInfo;
            }
            else
            {
                ContractNumbers = new Dictionary<string, string>();

                ContractNumbers.Add(
                    contractRequestType.correlationInfo.correlationId,
                    contractRequestType.contract.contractNumber);

                contractRequestType
                    .GetSubContracts()
                    .ToList()
                    .ForEach(c => ContractNumbers.Add(c.correlationId, c.contractNumber));

                contractRequestType
                    .GetAllocations().Where(ca => !string.IsNullOrEmpty(ca.correlationId))
                    .ToList()
                    .ForEach(a => ContractNumbers.Add(a.correlationId, a.contractAllocationNumber));
            }
        }
    
        public string CorrelationId { get; set; }

        public List<errorInfoType> Errors { get; set; }

        public Dictionary<string, string> ContractNumbers { get; set; }
    }
}