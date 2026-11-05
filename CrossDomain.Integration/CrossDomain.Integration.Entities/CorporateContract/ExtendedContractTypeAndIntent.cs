namespace SFA.FCT.CrossDomain.Integration.Entities.CorporateContract
{
    using System;

    [Serializable]
    [System.Diagnostics.CodeAnalysis.ExcludeFromCodeCoverage]
    public class ExtendedContractTypeAndIntent
    {
        public ExtendedContractTypeAndIntent(ExtendedContractType contract, ContractIntent intent)
        {
            Contract = contract;
            Intent = intent;
        }

        public ExtendedContractType Contract { get; }
        public ContractIntent Intent { get; }
    }
}
