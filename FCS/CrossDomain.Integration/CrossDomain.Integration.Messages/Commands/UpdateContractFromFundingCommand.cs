namespace SFA.FCT.CrossDomain.Integration.Messages.Commands
{
    using System.Collections.Generic;
    using Entities;
    using Entities.CorporateContract;

    public class UpdateContractFromFundingCommand
    {
        public UpdateContractFromFundingCommand(
            CrmContractIdentity crmExistingContractIdentity,
            IEnumerable<ExtendedContractAllocation> allocations,
            string replyFromDocumentationTo, ContractIntent contractIntent, 
            string amendmentType, int latestOverallVersionNumber, bool isAmendment)
        {
            CrmExistingContractIdentity = crmExistingContractIdentity;
            Allocations = allocations;
            ReplyFromDocumentationTo = replyFromDocumentationTo;
            ContractIntent = contractIntent;
            AmendmentType = amendmentType;
            LatestOverallVersionNumber = latestOverallVersionNumber;
            IsAmendment = isAmendment;
        }

        public CrmContractIdentity CrmExistingContractIdentity { get; }
        public IEnumerable<ExtendedContractAllocation> Allocations { get; }
        public int SubVersionToCreate => IsActualAmendment ? 0 : CrmExistingContractIdentity.SubVersion + 1;
        public int VersionToCreate => IsActualAmendment ? LatestOverallVersionNumber + 1 : CrmExistingContractIdentity.Version;
        public string ReplyFromDocumentationTo { get; }
        public ContractIntent ContractIntent { get; }
        public int LatestOverallVersionNumber { get; }

        /// <summary>
        /// This is for DocGen
        /// </summary>
        public bool IsAmendment { get; }
        public string AmendmentType { get; }
        public override string ToString() => $"ContractIntent: {ContractIntent}, CrmContractIdentity: {CrmExistingContractIdentity}, Allocations: {AllocationsText}, SubVersionToCreate: {SubVersionToCreate}, VersionToCreate: {VersionToCreate}, LatestOverallVersionNumber: {LatestOverallVersionNumber}, AmendmentType {AmendmentType}";
        private string AllocationsText => string.Join(",", Allocations ?? new List<ExtendedContractAllocation>());
        private bool IsActualAmendment => ContractIntent == ContractIntent.Amendment;
    }
}
