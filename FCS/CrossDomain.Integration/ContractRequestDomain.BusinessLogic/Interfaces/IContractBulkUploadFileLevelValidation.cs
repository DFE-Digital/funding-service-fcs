namespace SFA.FCT.ContractRequestDomain.BusinessLogic.Interfaces
{
    using System.Collections.Generic;
    using CrossDomain.Integration.Entities.Data;
    using CrossDomain.Integration.Entities.ExcelUpload;

    public interface IContractBulkUploadFileLevelValidation
    {
        List<errorInfo> Errors { get; }

        bool ValidateFile(dataLoadResults file, ConnectionInfo connectionInfo);

        bool FSR_004_ValidateFileStructure(dataLoadResults file);
    }
}
