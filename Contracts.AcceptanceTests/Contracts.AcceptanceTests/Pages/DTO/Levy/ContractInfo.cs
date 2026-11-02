namespace SFA.FCT.Contracts.AcceptanceTests.Pages.DTO.Levy
{
    using CrossDomain.Integration.Entities.Xrm;

    public class ContractInfo
    {
        public ContractInfo(sfa_contract contract, string subStatus)
        {
            Contract = contract;
            SubStatus = subStatus;
        }
        public sfa_contract Contract { get; }

        public string SubStatus { get; }
    }
}
