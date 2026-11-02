using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using Operations.Web.ConfigDataStore;

namespace Operations.Web.Repositories
{
    public interface IDigiRelManagementRepository
    {
        Task<List<Release>> GetAllAsync();
        Task<Release> GetByIdAsync(int id);
        Task<Release> CreateReleaseAsync(Release release);
        Task UpdateChangesAsync(Release release);
        //Task<Operations.Web.ConfigDataStore.Environment> GetEnvironmentAsync(string envName);
        //Task<List<Release_Deployments>> GetAllByEnvIdAsync(int envId);
        //Task<List<Release_Deployments>> GetDeploymentsAsync();
        //Task AddOrUpdateDeploymentAsync(int releaseId, string envName, string status, string currentUser);
        Task<Release_Deployments> GetDeploymentByReleaseIdAndEnvAsync(int releaseId, int envId);
        Task AddDeploymentAsync(Release_Deployments release_Deployments);
        Task UpdateDeploymentAsync(Release_Deployments release_Deployments);
        Task SaveChangesAsync();
        Task<Operations.Web.ConfigDataStore.Environment> GetEnvironmentByNameAsync(string envName);
    }
}