namespace SFA.FCT.ContractCreateDomain.Common.Messages.Events
{
    public class ContractCreatedInCrmEvent
    {
        public string ContractNumber { get; set; }

        public int ContractVersionNumber { get; set; }

        public int ContractSubVersionNumber { get; set; }

        public string AmendmentType { get; set; }
        public int? TotalAllocationCount { get; set; }

        public override string ToString()
        {
            return $"ContractNumber: {ContractNumber}, ContractVersionNumber: {ContractVersionNumber}, ContractSubVersionNumber: {ContractSubVersionNumber}, AmendmentType: {AmendmentType}, TotalAllocationCount:{TotalAllocationCount}";
        }
    }
}
