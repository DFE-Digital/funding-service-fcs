namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using ContractManagement.DataStore.Dtos;
    using ContractRequestDomain.Common;
    using CrossDomain.Integration.Entities.ContractRequest;

    /// <summary>
    /// This rule is for MBR-001 
    /// </summary>
    public class MasterContractNewAmendmentRule : IRule<contractRequestType>
    {
        private readonly Func<FundingTypeFundingPeriodDto, bool> _isNewAmendmentAllowed;
        public MasterContractNewAmendmentRule(Func<FundingTypeFundingPeriodDto, bool> isNewAmendmentAllowed)
        {
            _isNewAmendmentAllowed = isNewAmendmentAllowed;
        }

        public string ErrorMessage => ErrorMessages.MasterContractNewAmendmentCrmIntentError;

        public errorInfoTypeLevel ErrorLevel => errorInfoTypeLevel.MasterContract;

        public IEnumerable<string> GetFailuresForItem(contractRequestType itemToValidate)
        {
            string fundingPeriod = itemToValidate.GetFundingPeriod();

            bool isFundingTypeInfoAllowingNewAmendment = itemToValidate.contract.contracts.Select(c =>
                new FundingTypeFundingPeriodDto(fundingType: c.fundingTypeCode, fundingPeriod: fundingPeriod)).Any(dto => _isNewAmendmentAllowed(dto));

            List<string> errorList = new List<string>();
            if (itemToValidate.contract.CRMIntent == intent.NewAmendment && isFundingTypeInfoAllowingNewAmendment && (string.IsNullOrEmpty(itemToValidate.contract.contractNumber) ||
                 !itemToValidate.contract.IsMasterContractWithMatchingMasterContractNumberPresentInCrm))
            {
                errorList.Add(itemToValidate.contract.correlationId);
            }

            return errorList;
        }
    }
}
