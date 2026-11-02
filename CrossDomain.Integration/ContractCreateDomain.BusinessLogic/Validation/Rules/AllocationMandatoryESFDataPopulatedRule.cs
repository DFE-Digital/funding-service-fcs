namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules
{
    using SFA.FCT.ContractRequestDomain.Common;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
    using System.Collections.Generic;
    using System.Linq;

    /// <summary>
    /// This rule is for CABR-024
    /// </summary>
    public class AllocationMandatoryESFDataPopulatedRule : IRule<contractRequestType>
    {
        public errorInfoTypeLevel ErrorLevel => errorInfoTypeLevel.Allocation;

        public string ErrorMessage => ErrorMessages.AllEsfMandatoryDataMustBePupulated;

        public IEnumerable<string> GetFailuresForItem(contractRequestType itemToValidate)
        {
            return itemToValidate.GetAllocations().Where(a => (ESFFundingStreams.FundingStreams.Contains(a.fundingStreamCode) && 
                (string.IsNullOrWhiteSpace(a.tenderSpecificationReference) ||
                string.IsNullOrWhiteSpace(a.tenderAwardReference) ||
                string.IsNullOrWhiteSpace(a.description) ||
                string.IsNullOrWhiteSpace(a.activityDescription) ||
                string.IsNullOrWhiteSpace(a.investmentPriority) ||
                string.IsNullOrWhiteSpace(a.agreementNumber) ||
                string.IsNullOrWhiteSpace(a.specificationTitle) ||
                string.IsNullOrWhiteSpace(a.regionType))) ||
                (!ESFFundingStreams.FundingStreams.Contains(a.fundingStreamCode) && (
                !string.IsNullOrWhiteSpace(a.tenderSpecificationReference) ||
                !string.IsNullOrWhiteSpace(a.tenderAwardReference) ||
                !string.IsNullOrWhiteSpace(a.activityDescription) ||
                !string.IsNullOrWhiteSpace(a.investmentPriority) ||
                !string.IsNullOrWhiteSpace(a.agreementNumber) ||
                !string.IsNullOrWhiteSpace(a.specificationTitle) ||
                !string.IsNullOrWhiteSpace(a.regionType))))
                .Select(a => a.correlationId);
        }
    }
}
