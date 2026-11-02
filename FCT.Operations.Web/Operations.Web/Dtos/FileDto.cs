using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Operations.Web.Dtos
{
    public class FileDto
    {
        public string Name { get; set; }
        public long? Size { get; set; }
        public DateTimeOffset? UploadDate { get; set; }
    }
}