namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules
{
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Entities.ContractRequest;
    using ContractRequestDomain.Common;
    using CrossDomain.Integration.Entities;

    /// <summary>
    /// CABR-004
    /// </summary>
    public class AllocationOnlyOnePerFundingStreamRule : IRule<contractRequestType>
    {
        private readonly bool _isDeliveryOrganisationAllowedToBeSet;

        public AllocationOnlyOnePerFundingStreamRule(bool isDeliveryOrganisationAllowedToBeSet)
        {
            _isDeliveryOrganisationAllowedToBeSet = isDeliveryOrganisationAllowedToBeSet;
        }

        public string ErrorMessage => ErrorMessages.ContractCannotHaveMoreThenOneAllocationPerFundingStream;

        public errorInfoTypeLevel ErrorLevel => errorInfoTypeLevel.Allocation;

        public IEnumerable<string> GetFailuresForItem(contractRequestType itemToValidate)
        {
            if (_isDeliveryOrganisationAllowedToBeSet)
            {
                return itemToValidate
                    .GetAllocations()
                    .GroupBy(al => new { al.DeliveryOrganisation, al.fundingStreamCode } )
                    .Where(g => g.Count() > 1)
                    .SelectMany(g => g)
                    .Select(al => al.correlationId);
            }
            
            return itemToValidate
                .GetAllocations()
                .Where(al => al.fundingStreamCode != "OLASS" &&
                            itemToValidate.contract.fundingTypeCode != FundingTypes.ESF &&
                            itemToValidate.contract.fundingTypeCode != FundingTypes.EOP &&
                            itemToValidate.contract.fundingTypeCode != FundingTypes.EOF)
                .GroupBy(al => al.fundingStreamCode)
                .Where(g => g.Count() > 1)
                .SelectMany(g => g)
                .Select(al => al.correlationId);
        }
    }
}