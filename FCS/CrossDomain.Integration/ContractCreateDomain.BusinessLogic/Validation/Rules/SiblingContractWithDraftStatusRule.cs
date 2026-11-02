namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules
{
    using System.Collections.Generic;
    using ContractRequestDomain.Common;
    using CrossDomain.Integration.Entities.ContractRequest;

    /// <summary>
    /// This rule is for MBR-005
    /// </summary>
    public class SiblingContractWithDraftStatusRule : IRule<contractRequestType>
    {
        private readonly bool _hasSiblingContractWithDraftStatus;

        public SiblingContractWithDraftStatusRule(bool hasSiblingContractWithDraftStatus)
        {
            _hasSiblingContractWithDraftStatus = hasSiblingContractWithDraftStatus;
        }

        public string ErrorMessage => ErrorMessages.MasterContractAlreadyHasChildContractWithDraftStatusError;

        public errorInfoTypeLevel ErrorLevel => errorInfoTypeLevel.MasterContract;

        public IEnumerable<string> GetFailuresForItem(contractRequestType itemToValidate)
        {
            List<string> errorList = new List<string>();

            if (_hasSiblingContractWithDraftStatus)
            {
                errorList.Add(itemToValidate.contract.correlationId);
            }

            return errorList;
        }
    }
}