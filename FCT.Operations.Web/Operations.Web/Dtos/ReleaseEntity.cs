using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Microsoft.WindowsAzure.Storage.Table;
using Newtonsoft.Json;


namespace Operations.Web.Dtos
{
    public class ReleaseEntity : TableEntity
    {
        public ReleaseEntity(string partitionKey, string rowKey)
        {
            PartitionKey = partitionKey;
            RowKey = rowKey;
        }


        public ReleaseEntity() { }

        public string ReleaseId { get; set; }
        public string ReleaseName { get; set; }
        public string Description { get; set; }
        public string FileUrl { get; set; }
        public string VersionNumber { get; set; }
        public string Environment { get; set; }

        // Flattened environment statuses
        public string OATStatus { get; set; }
        public string PRODStatus { get; set; }
        public string DMOStatus { get; set; }
        public string DATStatus { get; set; }
        public string DOATStatus { get; set; }
        public string ATStatus { get; set; }
        public string DCIStatus { get; set; }
        public string CIStatus { get; set; }
        public string MOStatus { get; set; }

        // Helper method to get environment statuses as a dictionary
        public Dictionary<string, string> GetEnvironmentStatuses()
        {
            return new Dictionary<string, string>
         {
         { "OAT", OATStatus },
         { "PROD", PRODStatus },
         { "DMO", DMOStatus },
         { "DAT", DATStatus },
         { "DOAT", DOATStatus },
         { "AT", ATStatus },
         { "DCI", DCIStatus },
         { "CI", CIStatus },
         { "MO", MOStatus }
         };
                }

        // Helper method to set environment statuses from a dictionary
        public void SetEnvironmentStatuses(Dictionary<string, string> statuses)
        {
            OATStatus = statuses.ContainsKey("OAT") ? statuses["OAT"] : "Not Started";
            PRODStatus = statuses.ContainsKey("PROD") ? statuses["PROD"] : "Not Started";
            DMOStatus = statuses.ContainsKey("DMO") ? statuses["DMO"] : "Not Started";
            DATStatus = statuses.ContainsKey("DAT") ? statuses["DAT"] : "Not Started";
            DOATStatus = statuses.ContainsKey("DOAT") ? statuses["DOAT"] : "Not Started";
            ATStatus = statuses.ContainsKey("AT") ? statuses["AT"] : "Not Started";
            DCIStatus = statuses.ContainsKey("DCI") ? statuses["DCI"] : "Not Started";
            CIStatus = statuses.ContainsKey("CI") ? statuses["CI"] : "Not Started";
            MOStatus = statuses.ContainsKey("MO") ? statuses["MO"] : "Not Started";
        }
    }
}
