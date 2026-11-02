namespace SFA.FCT.CrossDomain.Integration.Messages.Commands
{
    public class SetDasStagedEventToProcessedCommand
    {
        public long DasEngagamentEventId { get; set; }

        public bool IsContractCreatedInCrm { get; set; }

        public string ContractNumber { get; set; }
    }
}
