namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules
{
    using System.Collections.Generic;
    using ContractRequestDomain.Common;
    using CrossDomain.Integration.Entities.ContractRequest;
    using CrossDomain.Integration.Entities;

    /// <summary>
    /// CABR-012
    /// </summary>
    public class StartAndEndDatesMandatoryRule : IRule<contractRequestType>
    {
        private readonly List<string> _fundingTypes = new List<string> { FundingTypes.ESF, FundingTypes.EOP, FundingTypes.EOF };

        public string ErrorMessage => ErrorMessages.AllocationStartAndEndDatesNotSupplied;

        public errorInfoTypeLevel ErrorLevel => errorInfoTypeLevel.Allocation;

        // Any Allocation dates for ESF, EOP and EOF Cannot be null and will have failed prior to this. 
        // Therefore we simply set the null dates to the contracts dates. 
        public IEnumerable<string> GetFailuresForItem(contractRequestType itemToValidate)
        {
            List<string> correlationIds = new List<string>();

            foreach (var contract in itemToValidate.contract.contracts)
            {
                foreach (var allocation in contract.contractAllocations)
                {
                    if (allocation.startDate == null)
                    {
                        if (_fundingTypes.Contains(itemToValidate.contract.fundingTypeCode))
                        {
                            correlationIds.Add(allocation.correlationId);
                        }
                        else
                        {
                            allocation.startDate = contract.startDate;
                        }
                    }

                    if (allocation.endDate == null)
                    {
                        if (_fundingTypes.Contains(itemToValidate.contract.fundingTypeCode))
                        {
                            correlationIds.Add(allocation.correlationId);
                        }
                        else
                        {
                            allocation.endDate = contract.endDate;
                        }
                    }
                }
            }

            return correlationIds;
        }
    }
}