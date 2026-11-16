namespace SFA.FCT.CrossDomain.Integration.Messages.Commands
{
    using Entities.CorporateContract;

    public class DocumentMergeCommand
    {
        public Contract CorporateContract { get; set; }

        public string ContractNumberToBeMerged { get; set; }
    }
}
