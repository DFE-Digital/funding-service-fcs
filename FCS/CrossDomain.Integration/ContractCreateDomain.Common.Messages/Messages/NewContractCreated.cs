namespace SFA.FCT.ContractCreateDomain.Common.Messages.Messages
{
    using System;

    public class NewContractCreated
    {
        public Guid CrmMasterContractId { get; set; }

        public string ChildContractNumber { get; set; }

        public int ChildContractVersionNumber { get; set; }

        public int ChildContractSubVersionNumber { get; set; }

        public string CorrelationId { get; set; }

        public override string ToString()
        {
            return
                $"ChildContractNumber: {ChildContractNumber}, " +
                $"ChildContractVersionNumber: {ChildContractVersionNumber}, " +
                $"ChildContractSubVersionNumber: {ChildContractSubVersionNumber}, " +
                $"CrmMasterContractId: {CrmMasterContractId}";
        }
    }
}
