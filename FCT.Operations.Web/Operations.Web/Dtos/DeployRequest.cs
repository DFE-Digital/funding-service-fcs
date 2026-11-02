using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Operations.Web.Dtos
{
    public class DeployRequest
    {
        public string Environment { get; set; }
        public string Rowkey { get; set; }
        public string FileUrl { get; set; }
    }
}