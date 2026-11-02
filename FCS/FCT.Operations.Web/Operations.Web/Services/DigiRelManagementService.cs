using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Operations.Web.Dtos;
using Operations.Web.Repositories;
using System.Threading.Tasks;
using Operations.Web.ConfigDataStore;
using LanguageExt.ClassInstances;
using System.Configuration;
using System.Data.Entity;
using System.Data.SqlClient;
using Microsoft.Azure.Amqp.Framing;

namespace Operations.Web.Services
{
    public class DigiRelManagementService : IDigiRelManagementService
    {
        private readonly IDigiRelManagementRepository _repo;
        private readonly string _currentEnv;

        public DigiRelManagementService(IDigiRelManagementRepository repo, string envName)
        {
            _repo = repo;
            _currentEnv = envName ?? ConfigurationManager.AppSettings["StorageTableSuffix"];
        }

        public async Task<IEnumerable<ConfigReleaseDto>> GetAllAsync()
        {
            var releases = await _repo.GetAllAsync();
            var result = releases.Select(r =>
            {
                var latestDeployment = r.Release_Deployments?
                .FirstOrDefault(d => d.Environment.Env == _currentEnv);

                return new ConfigReleaseDto
                {
                    ReleaseId = r.release_id,
                    ReleaseName = r.releaseName,
                    Version = r.version,
                    Description = r.description,
                    CreatedBy = r.created_by,
                    ModifiedBy = r.modified_by,
                    CreatedAt = r.created_at,
                    ModifiedAt = r.modified_at,
                    DeploymentId = latestDeployment?.deployment_id,
                    DeploymentStatus = latestDeployment?.deployment_status ?? "Pending",
                    EnvironmentName = _currentEnv
                };
            }).ToList();

            return result;
        }

        public async Task<ConfigReleaseDto> GetByIdAsync(int id)
        {
            var release = await _repo.GetByIdAsync(id);
            if (release == null) return null;

            var latestDeployment = release.Release_Deployments?
                .FirstOrDefault(d => d.Environment.Env == _currentEnv);

            return new ConfigReleaseDto
            {
                ReleaseId = release.release_id,
                ReleaseName = release.releaseName,
                Version = release.version,
                Description = release.description,
                CreatedBy = release.created_by,
                ModifiedBy = release.modified_by,
                CreatedAt = release.created_at,
                ModifiedAt = release.modified_at,
                DeploymentId = latestDeployment?.deployment_id,
                DeploymentStatus = latestDeployment?.deployment_status ?? "Pending",
                EnvironmentName = _currentEnv
            };
        }

        public async Task CreateAsync(ConfigReleaseDto configReleaseDto, string currentUser)
        {
            var release = new Release
            {
                releaseName = configReleaseDto.ReleaseName,
                description = configReleaseDto.Description,
                created_by = currentUser,
                created_at = DateTime.Now
            };

            var created = await _repo.CreateReleaseAsync(release);
            created.version = $"V{created.release_id:D3}";

            await _repo.UpdateChangesAsync(created);

            var environment = await _repo.GetEnvironmentByNameAsync(_currentEnv);

            //initial pending deployment
            var deployment = new Release_Deployments
            {
                release_id = release.release_id,
                env_id = environment.Id,
                deployment_status = "Pending",
                created_by = currentUser,
                created_at = DateTime.UtcNow

            };

            await _repo.AddDeploymentAsync(deployment);
        }

        public async Task<bool> UpdateAsync(int id, ConfigReleaseDto configReleaseDto, string currentUser)
        {
            var release = await _repo.GetByIdAsync(id);
            if (release == null) return false;

            release.releaseName = configReleaseDto.ReleaseName;
            release.description = configReleaseDto.Description;
            release.modified_by = currentUser;
            release.modified_at = DateTime.Now;

            await _repo.UpdateChangesAsync(release);
            return true;
        }

        public async Task<string> GetNextReleaseVersionAsync()
        {
            var getAll = await _repo.GetAllAsync();
            var nextId = getAll.Any() ? getAll.Max(r => r.release_id) +1 : 1;
            return $"V{nextId:D3}";
        }

        public async Task DeployAsync(int releaseId, string currentUser)
        {
            var environment = await _repo.GetEnvironmentByNameAsync(_currentEnv);
            var currentDeployment = await _repo.GetDeploymentByReleaseIdAndEnvAsync(releaseId, environment.Id);
            if (currentDeployment == null)
            {
                await _repo.AddDeploymentAsync( new Release_Deployments
                {
                    release_id = releaseId,
                    env_id = environment.Id,
                    deployment_status = "Deployed",
                    created_by = currentUser,
                    created_at = DateTime.UtcNow
                });
            }
            else
            {
                if (currentDeployment.deployment_status == "Pending")
                {
                    currentDeployment.deployment_status = "Deployed";
                    currentDeployment.modified_by = currentUser;
                    currentDeployment.modified_at = DateTime.UtcNow;
                    await _repo.UpdateDeploymentAsync(currentDeployment);
                }
                else if(currentDeployment.deployment_status == "Deployed")
                {
                    currentDeployment.deployment_status = "Redeployed";
                    currentDeployment.modified_by = currentUser;
                    currentDeployment.modified_at = DateTime.UtcNow;
                    await _repo.UpdateDeploymentAsync(currentDeployment);
                }

                currentDeployment.modified_by = currentUser;
                currentDeployment.modified_at = DateTime.UtcNow;
                await _repo.UpdateDeploymentAsync(currentDeployment);
            }
        }
    }
}