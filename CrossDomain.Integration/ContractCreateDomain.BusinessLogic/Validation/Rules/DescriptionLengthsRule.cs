namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules
{
    using System.Collections.Generic;
    using System.Linq;
    using ContractRequestDomain.Common;
    using CrossDomain.Integration.Entities.ContractRequest;

    /// <summary>
    /// This is part of the syntax rule: RSR-004
    /// </summary>
    public class DescriptionLengthsRule // : IRule<contractRequestType>
    {
        public bool Validate(contractRequestType contract)
        {
            List<errorInfoType> localErrors = new List<errorInfoType>();

            const int maxDescriptionLength = 100;

            if (!string.IsNullOrEmpty(contract.contract.description) && contract.contract.description.Length > maxDescriptionLength)
            {
                localErrors.Add(new errorInfoType
                {
                    correlationId = contract.contract.correlationId,
                    level = errorInfoTypeLevel.MasterContract,
                    Value = ErrorMessages.DataLengthInvalidErrorMessage
                });
            }

            foreach (var contracts in contract.contract.contracts)
            {
                if (!string.IsNullOrEmpty(contracts.description) && contracts.description.Length > maxDescriptionLength)
                {
                    localErrors.Add(new errorInfoType
                    {
                        correlationId = contracts.correlationId,
                        level = errorInfoTypeLevel.Contract,
                        Value = ErrorMessages.DataLengthInvalidErrorMessage
                    });
                }

                foreach (var allocation in contracts.contractAllocations)
                {
                    if (!string.IsNullOrEmpty(allocation.description) && allocation.description.Length > maxDescriptionLength)
                    {
                        localErrors.Add(new errorInfoType
                        {
                            correlationId = allocation.correlationId,
                            level = errorInfoTypeLevel.Allocation,
                            Value = ErrorMessages.DataLengthInvalidErrorMessage
                        });
                    }

                    foreach (var deliverable in allocation.contractDeliverables)
                    {
                        if (!string.IsNullOrEmpty(deliverable.deliverableDescription) && deliverable.deliverableDescription.Length > maxDescriptionLength)
                        {
                            localErrors.Add(new errorInfoType
                            {
                                correlationId = deliverable.correlationId,
                                level = errorInfoTypeLevel.Deliverable,
                                Value = ErrorMessages.DataLengthInvalidErrorMessage
                            });
                        }
                    }
                }
            }

            ContractErrorHelper.AddErrorsToContract(contract, localErrors);
            return !localErrors.Any();
        }
    }
}
