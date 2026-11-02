using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using Operations.Web.Dtos;

namespace Operations.Web.Services
{
    public interface IDigiRelManagementService
    {
        Task<IEnumerable<ConfigReleaseDto>> GetAllAsync();
        Task<ConfigReleaseDto> GetByIdAsync(int id);
        Task CreateAsync(ConfigReleaseDto configReleaseDto, string currentUser);
        Task<bool> UpdateAsync(int id, ConfigReleaseDto configReleaseDto, string currentUser);
        Task<string> GetNextReleaseVersionAsync();
        Task DeployAsync(int releaseId, string currentUser);
    }
}