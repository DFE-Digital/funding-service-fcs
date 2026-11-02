namespace Datafix.Tests.Services
{
    using System.Collections.Generic;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;

    public static class CrmToContractInformationStatusTransformer
    {
        public static ContractStatus TransformContractStatus(sfa_contractstatus crmContractstatus)
        {
            Dictionary<sfa_contractstatus, ContractStatus> statuses = new Dictionary<sfa_contractstatus, ContractStatus>
            {
                {sfa_contractstatus.Approved, ContractStatus.Approved},
                {sfa_contractstatus.Closed, ContractStatus.Closed},
                {sfa_contractstatus.Draft, ContractStatus.Draft}
            };

            return statuses.ContainsKey(crmContractstatus) ? statuses[crmContractstatus] : ContractStatus.Other;
        }

        public static ContractSubStatus TransformContractSubStatus(string crmSubstatus)
        {
            Dictionary<string, ContractSubStatus> statuses = new Dictionary<string, ContractSubStatus>
            {
                {"Approved", ContractSubStatus.Approved},
                {"Awaiting Closure Approval", ContractSubStatus.AwaitingClosureApproval},
                {"Closed", ContractSubStatus.Closed},
                {"Closure in Progress", ContractSubStatus.ClosureinProgress},
                {"Closure Initiation in Progress", ContractSubStatus.ClosureInitiationinProgress},
                {"Published to Provider", ContractSubStatus.PublishedtoProvider},
                {"Awaiting Termination Initiation Approval", ContractSubStatus.AwaitingTerminationInitiationApproval},
                { "Under Termination", ContractSubStatus.UnderTermination }
            };

            return statuses.ContainsKey(crmSubstatus) ? statuses[crmSubstatus] : ContractSubStatus.Other;
        }
    }
}