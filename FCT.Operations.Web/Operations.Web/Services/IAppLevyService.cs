using Operations.Web.Dtos;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CrossDomainContractInformation = SFA.FCT.CrossDomain.Integration.Entities.ContractInformation;

namespace Operations.Web.Services
{
    public interface IAppLevyService
    {
        Task<List<FileDto>> GetFilesAsync(string container);
        Task InsertReleaseEntityAsync(ReleaseEntity release);
        Task<List<ReleaseEntity>> GetAllEntitiesAsync();
        void CreateAppLevyVariation(List<AppLevyDto> items);
        Task CopyDocumentsAsync(string sourceContainer, string destinationContainer);
        IReadOnlyCollection<CrossDomainContractInformation> GetLatestContractInformationByFundingTypeAndFundingPeriod(string fundingType, string fundingPeriod);


    }
}
