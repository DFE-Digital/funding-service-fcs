namespace SFA.FCT.Contracts.AcceptanceTests.Pages.DTO.Levy
{
    public class ContractWorkflow
    {
        public ContractWorkflow(string action, string previousContractOwner, string newContractOwner)
        {
            Action = action;
            PreviousContractOwner = previousContractOwner;
            NewContractOwner = newContractOwner;
        }

        public string Action { get; }      

        public string PreviousContractOwner { get; }

        public string NewContractOwner { get; }
    }
}
