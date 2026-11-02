namespace ContractCreateDomain.Endpoint.NonFinancialAmendment.Dtos
{
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;

    public class ContractInformation
    {
        public string ContractNumber { get; }

        public int VersionNumber { get; }

        public int SubVersionNumber { get; }

        public sfa_contractstatus ContractStatus { get; }

        public ContractInformation(string contractNumber, int versionNumber, int subVersionNumber, sfa_contractstatus contractStatus)
        {
            ContractNumber = contractNumber;
            VersionNumber = versionNumber;
            SubVersionNumber = subVersionNumber;
            ContractStatus = contractStatus;
        }
    }
}