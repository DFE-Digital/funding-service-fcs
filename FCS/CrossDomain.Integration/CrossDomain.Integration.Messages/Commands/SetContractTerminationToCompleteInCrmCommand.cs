namespace SFA.FCT.CrossDomain.Integration.Messages.Commands
{
    public class SetContractTerminationToCompleteInCrmCommand
    {
        public string ContractNumber { get; set; }

        public int VersionNumber { get; set; }

        public int SubVersionNumber { get; set; }

        public CrmServiceResponse RequiredCrmServiceResponse { get; set; }

        public override string ToString()
        {
            return
                $"ContractNumber: {ContractNumber}, VersionNumber: {VersionNumber}, SubVersionNumber: {SubVersionNumber}, RequiredCrmServiceResponse: {RequiredCrmServiceResponse}";
        }

        public enum CrmServiceResponse
        {
            TerminationInitiationSuccessful,
            TerminationInitiationSuccessfulIssueAmend,
            TerminationDetailsUpdateSuccessful,
            ModificationSuccessful,
            ModificationDetailsUpdateSuccessful,
            ModificationCancellationSuccessful
        }
    }
}
