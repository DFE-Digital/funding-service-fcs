using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Operations.Web.Dtos;
using Operations.Web.Controllers;
using Microsoft.Xrm.Sdk.Deployment;
using static Operations.Web.Controllers.AppLevyController;

namespace Operations.Web.Services
{
    public interface IAzureTableService
    {
        Task InsertReleaseEntityAsync(ReleaseEntity releaseEntity);
        Task<List<ReleaseEntity>> GetAllEntitiesAsync();
        Task UpdateReleaseEntityAsync(ReleaseEntity releaseEntity);
        Task<ReleaseEntity> GetReleaseEntityAsync(string deployEntity);
    }
}
