namespace SFA.FCT.DocumentsDomain.Common.Commands
{
    using System.Collections.Generic;
    using Framework.Logging;
    using Models;

    [LogDetails]
    public class DocumentDeleteCommand
    {
        public DocumentDeleteCommand()
        {
            Files = new List<FctFile>();
        }

        [LogDetail]
        public  IList<FctFile> Files { get; set; }
    }
}
