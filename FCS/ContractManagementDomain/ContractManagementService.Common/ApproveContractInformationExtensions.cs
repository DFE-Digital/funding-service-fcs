namespace SFA.FCT.ContractManagementService.Common
{
    public static class ApproveContractInformationExtensions
    {
        public static bool IsValid(this ContractInformation contractInformation)
        {
            return !string.IsNullOrEmpty(contractInformation?.ContractNumber) &&
                   !string.IsNullOrEmpty(contractInformation.MasterContractNumber) &&
                   contractInformation.ContractVersionNumber != null && 
                   contractInformation.ContractVersionNumber != 0;
        }
    }
}