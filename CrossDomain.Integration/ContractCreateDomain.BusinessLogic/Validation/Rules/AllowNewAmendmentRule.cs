namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using ContractManagement.DataStore.Dtos;
    using CrossDomain.Integration.Entities.ContractRequest;

    /// <summary>
    /// MBR-001a - If CRM intent is 'New Amendment', the Funding Type Period must not require new Master Contracts
    /// </summary>
    public class AllowNewAmendmentRule : IRule<contractRequestType>
    {
        private readonly Func<FundingTypeFundingPeriodDto, bool> _isNewAmendmentAllowed;
        public AllowNewAmendmentRule(Func<FundingTypeFundingPeriodDto, bool> isNewAmendmentAllowed)
        {
            _isNewAmendmentAllowed = isNewAmendmentAllowed;
        }

        public string ErrorMessage =>
            "Use of intent 'New Amendment' is not allowed for this Funding Type and Period, as new Master Contracts are required.";

        public errorInfoTypeLevel ErrorLevel => errorInfoTypeLevel.Contract;

        public IEnumerable<string> GetFailuresForItem(contractRequestType masterContract)
        {
            string fundingPeriod = masterContract.GetFundingPeriod();

            return masterContract.contract.contracts.Where(c =>
                    _isNewAmendmentAllowed(new FundingTypeFundingPeriodDto(fundingType: c.fundingTypeCode, fundingPeriod:fundingPeriod)) == false)
                .Select(c => c.correlationId);
        }
    }
}
