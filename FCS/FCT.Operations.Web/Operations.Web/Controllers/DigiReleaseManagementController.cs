using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Http;
using Operations.Web.Services;
using Operations.Web.Repositories;
using System.Threading.Tasks;
using Operations.Web.Dtos;
using System.Configuration;

namespace Operations.Web.Controllers
{
    [RoutePrefix("config-dig-release-management")]
    public class DigiReleaseManagementController : ApiController
    {
        private readonly IDigiRelManagementService _service;

        public DigiReleaseManagementController()
        {
            var envName = ConfigurationManager.AppSettings["StorageTableSuffix"];
            var repo = new DigiRelManagementRepository();
            _service = new DigiRelManagementService(repo, envName);
        }

        [HttpGet]
        [Route("")]
        public async Task<IHttpActionResult> GetAll()
        {
            try
            {
                var releases = await _service.GetAllAsync();
                return Json(releases);
            }

            catch (Exception ex)
            {
                return InternalServerError(ex);

            }
        }

        [HttpGet]
        [Route("{id:int}")]
        public async Task<IHttpActionResult> GetById(int id)
        {
            try
            {
                var release = await _service.GetByIdAsync(id);
                return Json(release);
            }

            catch (Exception ex)
            {
                return InternalServerError(ex);

            }
        }

        //need one for creating release, one for editing, one for deploying. remember: check levy deploy and authorisation stuff and currentUser
        [HttpPost]
        [Route("createRelease")]
        public async Task<IHttpActionResult> CreateRelease([FromBody] ConfigReleaseDto configReleaseDto)
        {
            var currentUser = User.Identity.Name;

            await _service.CreateAsync(configReleaseDto, currentUser);
            return Ok();
        }

        [HttpPut]
        [Route("updateRelease/{id:int}")]
        public async Task<IHttpActionResult> UpdateRelease(int id, [FromBody] ConfigReleaseDto configReleaseDto)
        {
            var currentUser = User.Identity.Name;

            var updatedRelease = await _service.UpdateAsync(id, configReleaseDto, currentUser);
            if (!updatedRelease) return NotFound();
            return Ok(new { message = "Release updated successfully" });
        }

        [HttpGet]
        [Route("nextVersion")]
        public async Task<IHttpActionResult> GetNextReleaseVersion()
        {
            var nextVersion = await _service.GetNextReleaseVersionAsync();
            return Ok(nextVersion);
        }

        [HttpPost]
        [Route("deployRelease/{id}")]
        public async Task<IHttpActionResult> DeployRelease(int id)
        {
            try
            {
                var currentUser = User.Identity.Name;
                await _service.DeployAsync(id, currentUser);
                return Ok(new { message = "Deployment successful" });
            }
            catch (Exception ex)
            {
                return InternalServerError(ex);
            }
        }
    }
}