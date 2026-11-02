namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules.Deliverable
{
    using System.Collections.Generic;
    using System.Linq;
    using ContractManagement.DataStore.Model;
    using ContractRequestDomain.Common;
    using CrossDomain.Integration.Entities.ContractRequest;

    /// <summary>
    /// Rule DBR-015
    /// </summary>
    public class DeliverableAllowProfileRule : IRule<contractRequestType>
    {
        private readonly IReadOnlyCollection<FundingStreamPeriodLegalDeliverable> _profileFspLegalDeliverables;

        public DeliverableAllowProfileRule(IReadOnlyCollection<FundingStreamPeriodLegalDeliverable> profileFspLegalDeliverables)
        {
            _profileFspLegalDeliverables = profileFspLegalDeliverables;
        }

        public string ErrorMessage
        {
            get { return ErrorMessages.DeliverableAllowProfileErrorMessage; }
        }

        public errorInfoTypeLevel ErrorLevel
        {
            get { return errorInfoTypeLevel.Deliverable; }
        }

        public IEnumerable<string> GetFailuresForItem(contractRequestType itemToValidate)
        {
            return itemToValidate.GetAllocations()
                .SelectMany(a => a.contractDeliverables.Select(d => new
                {
                    FspCode = a.fundingStreamPeriodCode,
                    DelCode = d.deliverable.deliverableCode,
                    CorrelationId = d.correlationId
                }))
                .Where(fspDeliverable => !_profileFspLegalDeliverables.Any(fspd =>
                    fspd.FundingStreamPeriodCode == fspDeliverable.FspCode
                    && fspd.DeliverableCode == fspDeliverable.DelCode))
                .Select(fspDeliverable => fspDeliverable.CorrelationId)
                .ToList();
        }
    }
}