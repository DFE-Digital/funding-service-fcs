namespace SFA.FCT.ContractManagementService.Common.Repositories
{
    using System;
    using System.Collections.Generic;
    using SFA.FCT.ContractManagementDomain.Integration.Dtos;
    using SFA.FCT.ContractManagementService.Common.Dtos;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;

    public interface ICrmContractRepository
    {
        void UpdateStartDate(Guid contractId, DateTime startDateTime);

        FundingTypeFundingPeriodKeyDto GetFundingTypeFundingPeriodKeyDtoForLatestContract(string contractNumber, int versionNumber);

        bool HasContractBeenApproved(string contractNumber);

        ContractEndDateInfo GetContractEndDateInfoByContractNumberVersionAndSubVersion(string contractNumber, int version, int subVersion);

        void UpdateServiceResponseOnContract(string contractNumber, int version, int subVersion,
            sfa_serviceresponse serviceresponse);

        bool IsContractLatestVersion(string contractNumber, int version, int subVersion);

        bool IsContractClosed(string contractNumber);

        Guid GetContractId(string contractNumber, int version, int subVersion);

        void UpdateContract(sfa_contract contract);

        IReadOnlyCollection<Guid> GetAllocationIdsForContract(string contractNumber, int version, int subVersion);

        string GetMasterContractNumber(string contractNumber, int version, int subversion);

        ContractStatusInfo GetContractStatusIfContractIsLatest(string contractNumber, int version, int subVersion);
    }
}