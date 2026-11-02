namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules
{
    using System.Collections.Generic;
    using ContractRequestDomain.Common;
    using CrossDomain.Integration.Entities.ContractRequest;

    /// <summary>
    /// MBR-003 - Cannot create a Master Contract as there is already an existing Master Contract for the same period
    /// </summary>
    public class ExistingMasterContractRule : IRule<contractRequestType>
    {
        private readonly bool _multipleOverlappingContractsAllowedForFundingType;

        public ExistingMasterContractRule(bool multipleOverlappingContractsAllowedForFundingType)
        {
            _multipleOverlappingContractsAllowedForFundingType = multipleOverlappingContractsAllowedForFundingType;
        }

        public string ErrorMessage => ErrorMessages.MasterContractAlreadyExists;

        public errorInfoTypeLevel ErrorLevel => errorInfoTypeLevel.MasterContract;

        public IEnumerable<string> GetFailuresForItem(contractRequestType itemToValidate)
        {
            List<string> correlationIds = new List<string>();
            var masterContract = itemToValidate.contract;

            if (masterContract.IsPresentInCrm && !_multipleOverlappingContractsAllowedForFundingType)
            {
                correlationIds.Add(masterContract.correlationId);
            }
          
            return correlationIds;
        }
    }
}
