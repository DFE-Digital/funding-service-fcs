namespace SFA.FCT.ContractManagementService.Common.Commands
{
    public class AmendContractNonFinancialAmendmentCommand
    {
        public string ContractNumber { get; set; } 

        public int VersionNumber { get; set; }

        public int SubVersionNumber { get; set; }

        public AmendmentType AmendmentType { get; set; }

        public bool IsNonFinancialAmendment { get; set; }

        public override string ToString()
        {
            return $"ContractNumber: {ContractNumber}, VersionNumber: {VersionNumber}, SubVersionNumber: {SubVersionNumber}, AmendmentType: {AmendmentType}";
        }
    }
}