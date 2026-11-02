namespace SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentMerger
{
    using System.Linq;
    using Common.Models;
    using Framework.Logging.NullObjects;
    using Integration;
    using Framework.Logging.Interfaces;

    public class DocumentMerger : IDocumentMerger
    {
        private readonly IAsposeWrapper _asposeWrapper;

        public DocumentMerger(IAsposeWrapper asposeWrapper)
        {
            _asposeWrapper = asposeWrapper;
            Logger = new LoggerNullObject();
        }

        public ILogger Logger { get; set; }

        public byte[] MergeDocuments(DocumentConvertRequest convertRequest)
        {
            var orderedList = (from t in convertRequest.DocConvertRequests
                select t).OrderBy(c => c.SequenceNumber).ToList();
           
            return _asposeWrapper.ConvertToPdf(orderedList);
        }
    }
}