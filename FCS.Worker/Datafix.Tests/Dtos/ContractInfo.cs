namespace Datafix.Tests.Dtos
{
    using System;
    using ContractManagement.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;

    public class ContractInfo
    {
        public ContractInfo(string contractNumber, int version, int subVersion, DateTime createdDate, int? amendmentTypeCrmEnum)
        {
            ContractNumber = contractNumber;
            Version = version;
            SubVersion = subVersion;
            CreatedDate = createdDate;
            AmendmentTypeCrmEnum = amendmentTypeCrmEnum;
            AmendmentType = ToCreatedContractAmendmentType(amendmentTypeCrmEnum);
        }

        public string ContractNumber { get; }

        public int Version { get; }

        public int SubVersion { get; }

        public DateTime CreatedDate { get; }

        public int? AmendmentTypeCrmEnum { get; }

        public AmendmentType? AmendmentType { get; }

        public override bool Equals(object obj)
        {
            if (obj is ContractInfo other)
            {
                return ContractNumber == other.ContractNumber && Version == other.Version && SubVersion == other.SubVersion;
            }

            return false;
        }

        public override int GetHashCode()
        {
            return ContractNumber.GetHashCode() ^ Version.GetHashCode() ^ SubVersion.GetHashCode();
        }

        private static AmendmentType? ToCreatedContractAmendmentType(int? amendmentTypeCrmEnum)
        {
            AmendmentType? createdContractAmendmentType = null;
            if (amendmentTypeCrmEnum.HasValue)
            {
                createdContractAmendmentType = (sfa_amendmenttype)amendmentTypeCrmEnum.Value == sfa_amendmenttype.Notification
                    ? ContractManagement.DataStore.Model.AmendmentType.Notification
                    : ContractManagement.DataStore.Model.AmendmentType.Variation;
            }

            return createdContractAmendmentType;
        }
    }
}
