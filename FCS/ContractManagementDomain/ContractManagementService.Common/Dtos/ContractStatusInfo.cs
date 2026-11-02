namespace SFA.FCT.ContractManagementDomain.Integration.Dtos
{
    using CrossDomain.Integration.Entities;

    public class ContractStatusInfo
    {
        public ContractStatusInfo(ContractStatus contractStatus, ContractSubStatus contractSubStatus)
        {
            ContractStatus = contractStatus;
            ContractSubStatus = contractSubStatus;
        }

        public ContractStatus ContractStatus { get; }

        public ContractSubStatus ContractSubStatus { get; }
    }
}
