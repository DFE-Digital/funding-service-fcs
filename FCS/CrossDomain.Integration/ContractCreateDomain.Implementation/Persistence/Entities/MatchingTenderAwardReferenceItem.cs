namespace SFA.FCT.ContractCreateDomain.Implementation.Persistence.Entities
{
    public class MatchingTenderAwardReferenceItem
    {
        public MatchingTenderAwardReferenceItem(string contractNumber, string allocationNumber, string tenderAwardReference)
        {
            ContractNumber = contractNumber;
            AllocationNumber = allocationNumber;
            TenderAwardReference = tenderAwardReference;
        }

        public string ContractNumber { get; }

        public string AllocationNumber { get; }

        public string TenderAwardReference { get;}
    }
}
