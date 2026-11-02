namespace ContractManagementDomain.Termination.Xrm.Repositories
{
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;

    public interface ICrmContractRepository
    {
        void OverwriteNullEndDateWithTerminationDate(string contractNumber, int versionNumber, int subVersionNumber);

        void OverwriteNullAllocationEndDatesWithTerminationDates(string contractNumber, int versionNumber, int subVersionNumber);

        void UpdateServiceResponseOnContract(string contractNumber, int version, int subVersion, sfa_serviceresponse serviceresponse);
    }
}