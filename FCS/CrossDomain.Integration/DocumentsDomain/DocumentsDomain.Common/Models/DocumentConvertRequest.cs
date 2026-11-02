namespace SFA.FCT.DocumentsDomain.Common.Models
{
    using System.Collections.Generic;
    using Aspose.Words;

    public class DocumentConvertRequest
    {
        public List<DocumentConvertRequestPart> DocConvertRequests { get; set; }

        public FctFile TargetFile { get; set; }
    }

    public class DocumentConvertRequestPart
    {
        public int SequenceNumber { get; set; }

        public string GroupId { get; set; }

        public bool IsNewPageRequired { get; set; }

        public Document DocPart { get; set; }
    }
}
