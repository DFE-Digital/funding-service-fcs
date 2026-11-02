namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules
{
    using System.Collections.Generic;
    using System.Linq;
    using ContractRequestDomain.Common;
    using CrossDomain.Integration.Entities.ContractRequest;

    /// <summary>
    /// This rule is for MBR-004
    /// </summary>
    public class MandatoryEntitiesRule : IRule<contractRequestType>
    {
        public string ErrorMessage => ErrorMessages.MandatoryEntitiesNotFound;

        public errorInfoTypeLevel ErrorLevel => errorInfoTypeLevel.MasterContract;

        public IEnumerable<string> GetFailuresForItem(contractRequestType itemToValidate)
        {
            List<string> errorList = new List<string>();
            contractType masterContract = itemToValidate.contract;

            if (!HasChildContracts(masterContract) ||
                !HasAllocations(masterContract) ||
                !HasDeliverablesWithPeriods(masterContract))
            {
                errorList.Add(itemToValidate.contract.correlationId);
            }

            return errorList;
        }

        private static bool HasChildContracts(contractType masterContract) 
        {
            return masterContract.contracts.Any();
        }

        private static bool HasAllocations(contractType masterContract)
        {
            return masterContract.contracts.Any(c => c.contractAllocations.Any());
        }

        private static bool HasDeliverablesWithPeriods(contractType masterContract)
        {
            return masterContract.contracts.Any(c => c.contractAllocations.Any(a => a.contractDeliverables.Any(d => d.contractDeliverablePeriods.Any())));
        }
    }
}