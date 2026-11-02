using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Security.Cryptography.X509Certificates;
using System.Threading.Tasks;
using System.Web;
using Operations.Web.ConfigDataStore;
using System.Data.SqlClient;
using System.Data.Entity;
using Microsoft.Azure.Amqp.Framing;

namespace Operations.Web.Repositories
{
    public class DigiRelManagementRepository : IDigiRelManagementRepository
    {
        private static string ConnectionString => ConfigurationManager
            .ConnectionStrings["ConfigDBContext"].ConnectionString;

        public async Task<List<Release>> GetAllAsync()
        {
            using (var connection = new SqlConnection(ConnectionString))
            {
                using (var context = new ConfigDBContext())
                {
                    var releases = await context.Releases
                        .Include(r => r.Release_Deployments.Select(d => d.Environment))
                        .OrderByDescending(r => r.created_at)
                        .Take(50)
                        .ToListAsync();

                    return releases;
                }
            }
        }

        public async Task<Release> GetByIdAsync(int id)
        {
            using (var connection = new SqlConnection(ConnectionString))
            {
                using (var context = new ConfigDBContext())
                {
                    var release = await context.Releases
                        .Include(r => r.Release_Deployments.Select(d => d.Environment))
                        .OrderByDescending(r => r.release_id)
                        .FirstOrDefaultAsync(r => r.release_id == id);

                    /*System.Diagnostics.Debug.WriteLine($"[GetByIdAsync] searching for id: {id}");
                    System.Diagnostics.Debug.WriteLine(release !=null
                        ? $"[GetByIdAsync] Found: {release.releaseName}"
                        : "[GetByIdAsync] No record found.");*/

                    return release;
                }
            }
        }

        public async Task<Release> CreateReleaseAsync(Release release)
        {
            using (var connection = new SqlConnection(ConnectionString))
            {
                using (var context = new ConfigDBContext())
                {
                    context.Releases.Add(release);
                    await context.SaveChangesAsync();
                    return release;
                }
            }
        }

        public async Task UpdateChangesAsync(Release release)
        {
            using (var connection = new SqlConnection(ConnectionString))
            {
                using (var context = new ConfigDBContext())
                {
                    context.Entry(release).State = EntityState.Modified;
                    await context.SaveChangesAsync();
                }
            }
        }

        /*public async Task<List<Release_Deployments>> GetDeploymentsAsync()
        {
            using (var connection = new SqlConnection(ConnectionString))
            {
                using (var context = new ConfigDBContext())
                {
                    return await context.Release_Deployments
                        .Include(d => d.Environment)
                        .ToListAsync();
                }
            }
        }*/

        public async Task<Operations.Web.ConfigDataStore.Environment> GetEnvironmentByNameAsync(string envName)
        {
            using (var connection = new SqlConnection(ConnectionString))
            {
                using (var context = new ConfigDBContext())
                {
                    return await context.Environments
                        .FirstOrDefaultAsync(e => e.Env == envName);
                }
            }
        }

        public async Task<Release_Deployments> GetDeploymentByReleaseIdAndEnvAsync(int releaseId, int envId)
        {
            using (var connection = new SqlConnection(ConnectionString))
            {
                using (var context = new ConfigDBContext())
                {
                    return await context.Release_Deployments
                        .Include(d => d.Environment)
                        .FirstOrDefaultAsync(d => d.release_id == releaseId && d.env_id == envId);
                }
            }
        }

        public async Task AddDeploymentAsync(Release_Deployments release_Deployments)
        {
            using (var connection = new SqlConnection(ConnectionString))
            {
                using (var context = new ConfigDBContext())
                {
                    context.Release_Deployments.Add(release_Deployments);
                    await context.SaveChangesAsync();
                }
            }
        }

        public async Task UpdateDeploymentAsync(Release_Deployments release_Deployments)
        {
            using (var connection = new SqlConnection(ConnectionString))
            {
                using (var context = new ConfigDBContext())
                {
                    context.Entry(release_Deployments).State = EntityState.Modified;
                    await context.SaveChangesAsync();
                }
            }
        }

        public async Task SaveChangesAsync()
        {
            using (var connection = new SqlConnection(ConnectionString))
            {
                using (var context = new ConfigDBContext())
                {
                    await context.SaveChangesAsync();
                }
            }
        }
    }
}