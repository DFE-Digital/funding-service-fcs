namespace SFA.FCT.DocumentsDomain.Common.Commands
{
    using CrossDomain.Integration.Entities.Documents;
    using CrossDomain.Integration.Entities.CorporateContract;

    public class UpdateDocumentMergeStatusCommand
    {
        public Contract CorporateContract;
        public MergeStatus MergeStatus { get; set; }
    }
}
