namespace  SFA.FCT.ContractCreateDomain.Implementation.Persistence.Entities
{
    using Microsoft.Xrm.Sdk;
    using Repositories;

    public abstract class NumberRequest
    {
        public string ContractType { get; set; }

        // Either SFA for master or Main/AGE/EOS/....etc.
        public string FundingType { get; set; }

        public string ContractNumber { get; set; }

        internal Entity ContractNumberEntity { get; set; }

        internal string ContractNumberPrefix { get; set; }

        public abstract void SetContractNumber(EntityCollection referenceData);

        public abstract SequenceType GetSequenceType();

        public abstract string GetPrefixContext();
    }
}