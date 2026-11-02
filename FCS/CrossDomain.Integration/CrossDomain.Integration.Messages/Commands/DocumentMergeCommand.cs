namespace SFA.FCT.CrossDomain.Integration.Messages.Commands
{
    using Entities.CorporateContract;

    public class DocumentMergeCommand
    {
        public contract CorporateContract { get; set; }

        public string ContractNumberToBeMerged { get; set; }
    }
}
