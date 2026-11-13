namespace SFA.FCT.CrossDomain.Integration.Entities.CorporateContract
{
    using System;

    public class ContractSummary
    {
        public string ContractNumber { get; set; }

        public int? ContractVersionNumber { get; set; }

        public string MasterContractNumber { get; set; }

        public Func<CorporateSchema.Contract.Contract> GetFullCorpContract { get; set; }
    }
}