namespace SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Dtos
{
    using System.Collections.Generic;
    using System.Linq;
    using Entities;
    using Extensions;
    using LanguageExt;

    public class CrmContractInfo
    {
        public CrmContractInfo(
            string number,
            int version,
            int subVersion,
            int contractingUkprn,
            string crmEntityId,
            string masterContractNumber,
            string amendmentType,
            IReadOnlyCollection<CrmAllocationInfo> crmAllocationInfos,
            int latestOverallVersionNumber)
        {
            Number = number;
            Version = version;
            SubVersion = subVersion;
            CrmEntityId = crmEntityId;
            CrmAllocationInfos = crmAllocationInfos;
            AmendmentType = amendmentType;
            LatestOverallVersionNumber = latestOverallVersionNumber;
            ContractingUkprn = contractingUkprn;
            MasterContractNumber = masterContractNumber;
        }

        public string Number { get; }
        public int Version { get; }
        public int SubVersion { get; }
        public string CrmEntityId { get; }
        public int ContractingUkprn { get; }
        public string MasterContractNumber { get; }
        public int LatestOverallVersionNumber { get; }

        public string AmendmentType { get; }

        public IReadOnlyCollection<CrmAllocationInfo> CrmAllocationInfos { get; }

        public CrmContractIdentity ToCrmContractIdentity()
        {
            return new CrmContractIdentity(Number, Version, SubVersion, CrmEntityId);
        }

        public Option<int> GetExistingAllocationNumber(string fundingStreamCode, int deliveryUkprn)
        {
            var matchingAllocationInfo = CrmAllocationInfos.FirstOrDefault(a =>
                a.FundingStreamCode == fundingStreamCode &&
                (a.DeliveryOrgUkprn ?? ContractingUkprn.ToString()) == deliveryUkprn.ToString());
                                         
            int ExtractNumber(string allocRef) => int.Parse(allocRef.Split('-')[1]);

            if (matchingAllocationInfo != null)
            {
                return ExtractNumber(matchingAllocationInfo.AllocationNumber);
            }

            return Option<int>.None;
        }

        public override string ToString()
        {
            return $"Number: {Number}, Version: {Version}, SubVersion: {SubVersion}, CrmEntityId: {CrmEntityId}, Master: {MasterContractNumber}, AmendmentType: {AmendmentType}" +
                   $"CrmAllocationInfos: {string.Join(",", CrmAllocationInfos.GetValueOrEmpty())}";
        }
    }
}