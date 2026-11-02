namespace SFA.FCT.ContractCreateDomain.Implementation.Entities
{
    using System;
    using CrossDomain.Integration.Entities.CorporateContract;
    using CrossDomain.Integration.Entities.Xrm;

    public class ContractIdentity
    {
        public ContractIdentity(string contractNumber, int version, int subVersion)
        {
            ContractNumber = contractNumber;
            Version = version;
            SubVersion = subVersion;
        }

        public static implicit operator ContractIdentity(ExtendedContractType masterContract)
        {
            ExtendedContractType childContract = masterContract.ChildContract();

            return new ContractIdentity(childContract.contractNumber, childContract.contractVersionNumber, childContract.contractSubVersionNumber);
        }

        public static implicit operator ContractIdentity(sfa_contract childContract)
        {
            if (childContract.sfa_Version.HasValue && childContract.sfa_SubVersion.HasValue)
            {
                return new ContractIdentity(childContract.sfa_number, childContract.sfa_Version.Value, childContract.sfa_SubVersion.Value);
            }
            
            throw new ArgumentException($"The version and subversion must be set on this contact: {childContract.sfa_number}");
        }

        public string ContractNumber { get; }

        public int Version { get; }

        public int SubVersion { get; }

        public override int GetHashCode()
        {
            return ContractNumber.GetHashCode() ^ Version.GetHashCode() ^ SubVersion.GetHashCode();
        }

        public override bool Equals(object obj)
        {
            if (obj is ContractIdentity other)
            {
                return other.ContractNumber == ContractNumber && other.Version == Version &&
                       other.SubVersion == SubVersion;
            }

            return false;
        }

        public override string ToString()
        {
            return $"ContractNumber: {ContractNumber}, Version: {Version}, SubVersion: {SubVersion}";
        }
    }
}
