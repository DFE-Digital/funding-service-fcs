using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace Operations.Web.Dtos
{
    public class ConfigReleaseDto
    {
        public int ReleaseId { get; set; }
        public string ReleaseName { get; set; }
        public string Version { get; set; }
        public string Description { get; set; }
        public string CreatedBy { get; set; }
        public string ModifiedBy { get; set; }
        public DateTime? CreatedAt { get; set; }
        public DateTime? ModifiedAt { get; set; }

        //Deployment and Environment info
        public int? DeploymentId { get; set; }
        public string DeploymentStatus { get; set; }
        public string EnvironmentName { get; set; }
    }
}